# Changelog

All notable changes to Ál Lab Dark are listed here.

## [2.0.0] - Unreleased

First public release, published as `alvaro-ruiz-lab.al-lab-dark`. Versions 1.0 to 1.3 were not published.

### Added

- Eight variants: Blue, Magenta, Violet and Phosphor accents, each in a subtle and a bold level: *Ál Lab Dark Blue*, *Ál Lab Dark Blue Bold* and so on.
- Around 260 new interface colors: Git decorations, diagnostics, terminal ANSI colors, suggestions, hover, command palette, peek view, notifications, bracket pair colors, minimap, debugger, settings, welcome page, chat and notebooks.
- Syntax colors for every language, based on the Dark+ rules of VS Code with the C# palette for strings, comments and control keywords.
- Rules for Unity shaders and HLSL, C/C++ macros and directives, YAML anchors, Python `self`/`cls`, Bash options, diff and Git commit messages, and Blazor components.
- C# semantic colors for namespaces, events, constants, enum members, delegates, type parameters, extension methods, string escapes, excluded code, and strikethrough for deprecated symbols.
- Unity WebGL plugins (`.jslib`, `.jspre`) open as JavaScript, so they get syntax colors.
- Support for the modern workbench layout of recent VS Code versions: the borders of the floating panels and the activity bar follow the theme, and use the accent in the Bold variants; the active tab and the active activity bar icon get an accent-tinted background.

### Changed

- **C#:** numbers are now `#B5CEA8`, `true`/`false`/`null` are blue, operators go from blue to `#D4D4D4`, and types are teal instead of white while the C# extension loads the project. Everything else in C# is unchanged.
- The active tab only has an accent line at the bottom.
- List and menu selections are tinted with the accent.
- Warnings use `#DDBF00`, which is easier to tell from the error red.
- The status bar stays dark with no folder open and while debugging.
- Line numbers are lighter (`#6E6E6E`) for better contrast.
- TypeScript interfaces and enums use the Dark+ teal instead of the C# yellow.

### Fixed

- Function calls painted their arguments and parentheses yellow in Python, JavaScript and Java.
- Code inside template literals and embedded `<script>` and `<style>` blocks picked up the wrong colors.
- Blazor components were shown as invalid tags.
- Two legacy Dark+ colors (`header` and `constant.regexp`) were nearly unreadable on a dark background; they now use the heading blue and the regular expression red.

## [1.3.0]

- Tabs with more contrast: a darker tab bar, inactive tabs in between and a lighter active tab with an accent outline. The active tab is gray when its group does not have focus.

## [1.2.0]

- Markdown colors equivalent to Dark+: headings, bold, italic, strikethrough, quotes, lists, inline code, code blocks and links.

## [1.1.0]

- HTML, CSS and JavaScript/TypeScript colors equivalent to Dark+. C# does not change.

## [1.0.0]

- First version: a Fluent-style interface and the C# colors of Visual Studio. Structs in yellow and control keywords in purple were added later in this version.

[2.0.0]: https://github.com/alvaro-ruiz-lab/al-lab-dark/releases/tag/v2.0.0
