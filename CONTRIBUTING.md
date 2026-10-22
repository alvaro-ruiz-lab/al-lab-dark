# Contributing to Ál Lab Dark

Thanks for helping. This page explains how the theme is built and how to try a change.

## Repository layout

| Path | What it is |
| --- | --- |
| `src/al-lab-dark.base.json` | The theme you edit: `colors`, `tokenColors` and `semanticTokenColors`. |
| `scripts/build-themes.mjs` | Defines the four accents and the two levels, and generates the variants. |
| `scripts/make-icon.ps1` | Draws `images/icon.png` (Windows only, uses System.Drawing). |
| `themes/*-color-theme.json` | The eight generated themes. Do not edit them by hand. |
| `samples/` | One file per language, for checking syntax colors. Not included in the package. |
| `package.json` | Extension manifest. The script rewrites `contributes.themes`. |

## Build the variants

```sh
node scripts/build-themes.mjs
```

The script reads the base theme, fills in the accent markers for each accent and level, writes the eight themes to `themes/` and updates the theme list in `package.json`. It needs Node.js 18 or later and has no dependencies.

### Accent markers

Colors that depend on the accent are written as markers in `colors`:

| Marker | Meaning |
| --- | --- |
| `{acc}` | The accent color |
| `{accOn}` | Text drawn on top of the accent |
| `{accText}` | Text drawn in the accent color (a lighter blue for the Blue variant, so it stays readable) |
| `{btn}`, `{btnHover}` | Button backgrounds: the accent darkened over `#121212` |
| `{acc@30}` | The accent at 30% opacity |
| `{acc%20/121212}` | The accent mixed at 20% with `#121212` |

Keys under `"$bold"` override `colors` in the *Bold* variants.

Keep the accent to thin lines, badges, focus rings and tinted selections. Large backgrounds and the title and status bars stay dark.

## How syntax colors are layered

VS Code colors code with two systems, and the theme defines both:

1. **Semantic tokens** (`semanticTokenColors`) come from a language server that understands the code. The C# extension uses them to tell a struct from a class, or a local from a field. They take priority when present.
2. **TextMate rules** (`tokenColors`) match the scopes produced by each language grammar. They apply to every language, and to C# until the server has loaded the project.

`tokenColors` is ordered on purpose:

1. **`Dark+: …`** — the Dark+ rules of VS Code, with strings, comments and control keywords recolored to the C# palette.
2. The theme's own rules (web, Markdown, and the Visual Studio-style C# rules, scoped to `source.cs` and `text.aspnetcorerazor`).
3. Rules per language.
4. **`C#: …`** — guard rules that keep C# from picking up Dark+ colors that differ from Visual Studio.

When two rules match, the one that matches more segments of the token's scope wins. On a tie, a rule with a parent selector wins, and then the one that comes later. For example, to change `variable.other.property` only in JavaScript, use `source.js variable.other.property`; `source.js variable` is not specific enough.

Semantic colors that only make sense for C# carry a language suffix (`property:csharp`, `struct:razor`, `enum:aspnetcorerazor`…), so TypeScript, Python or Java keep the Dark+ behavior.

## Try a change

1. Clone the repository and link it into your VS Code extensions folder:

   ```powershell
   # Windows
   cmd /c mklink /J "%USERPROFILE%\.vscode\extensions\al-lab-dark" "C:\path\to\al-lab-dark"
   ```

   ```sh
   # macOS / Linux
   ln -s /path/to/al-lab-dark ~/.vscode/extensions/al-lab-dark
   ```

2. Restart VS Code and pick a variant with **Preferences: Color Theme**.
3. After editing the base theme, run `node scripts/build-themes.mjs` and **Developer: Reload Window**.

Use **Developer: Inspect Editor Tokens and Scopes** to see the scopes and semantic type of a token and the rule that colors it. The files in `samples/` cover the languages the theme cares about.

## Checklist for a pull request

- [ ] The change is made in `src/al-lab-dark.base.json` (or the script), and `themes/` was regenerated.
- [ ] New interface color keys exist in VS Code. An unknown key is silently ignored.
- [ ] C# colors only change on purpose, and the change is described.
- [ ] Text keeps a contrast of at least 4.5:1 against its background, and lines and inactive elements at least 3:1.
- [ ] `CHANGELOG.md` has an entry for the change.
