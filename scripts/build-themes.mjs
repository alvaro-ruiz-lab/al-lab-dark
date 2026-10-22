// Genera las variantes de Ál Lab Dark a partir de src/al-lab-dark.base.json
// y reescribe contributes.themes en package.json.
//
//   node scripts/build-themes.mjs
//
// Marcadores que se pueden usar en los valores de "colors" y "$bold":
//   {acc}             el acento
//   {accOn}           texto sobre el acento
//   {accText}         texto pintado con el acento (más claro en Blue, para que se lea)
//   {btn} {btnHover}  fondo de los botones
//   {acc@30}          el acento con un 30 % de opacidad
//   {acc%20/121212}   el acento mezclado al 20 % con #121212

import { readFileSync, writeFileSync, readdirSync, unlinkSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");

const accents = [
    { id: "blue", name: "Blue", acc: "#0078D4", accOn: "#FFFFFF", accText: "#3794FF", btn: "#0078D4", btnHover: "#026EC1" },
    { id: "magenta", name: "Magenta", acc: "#FF4FA3", accOn: "#0A0A0A" },
    { id: "violet", name: "Violet", acc: "#A07BFF", accOn: "#0A0A0A" },
    { id: "phosphor", name: "Phosphor", acc: "#57C93F", accOn: "#0A0A0A" }
];

const levels = [
    { id: "subtle", name: "" },
    { id: "bold", name: "Bold" }
];

// Botones: el acento oscurecido sobre el chrome, con texto blanco.
const BUTTON_MIX = 45;
const BUTTON_HOVER_MIX = 55;
const CHROME = "121212";

function rgb(hex) {
    const h = hex.replace("#", "");
    return [0, 2, 4].map(i => parseInt(h.slice(i, i + 2), 16));
}

function toHex(channels) {
    return "#" + channels.map(c => Math.round(c).toString(16).padStart(2, "0")).join("").toUpperCase();
}

function mix(hex, percent, bgHex) {
    const a = rgb(hex), b = rgb(bgHex);
    return toHex(a.map((c, i) => c * percent / 100 + b[i] * (1 - percent / 100)));
}

function alpha(hex, percent) {
    return hex.toUpperCase() + Math.round(percent * 2.55).toString(16).padStart(2, "0").toUpperCase();
}

function resolve(value, tokens, key) {
    const out = value.replace(/\{(\w+)(?:@(\d+)|%(\d+)\/([0-9A-Fa-f]{6}))?\}/g, (m, name, a, p, bg) => {
        const base = tokens[name];
        if (!base) throw new Error(`Marcador desconocido ${m} en "${key}"`);
        if (a) return alpha(base, Number(a));
        if (p) return mix(base, Number(p), bg);
        return base;
    });
    if (out.includes("{")) throw new Error(`Marcador mal formado en "${key}": ${value}`);
    return out;
}

const basePath = join(root, "src", "al-lab-dark.base.json");
const base = JSON.parse(readFileSync(basePath, "utf8"));
const { $bold: bold = {}, ...theme } = base;

for (const key of Object.keys(bold)) {
    if (!(key in theme.colors)) throw new Error(`"$bold" sobrescribe una clave que no está en colors: ${key}`);
}

const contributed = [];
for (const accent of accents) {
    const tokens = {
        acc: accent.acc,
        accOn: accent.accOn,
        accText: accent.accText ?? accent.acc,
        btn: accent.btn ?? mix(accent.acc, BUTTON_MIX, CHROME),
        btnHover: accent.btnHover ?? mix(accent.acc, BUTTON_HOVER_MIX, CHROME)
    };
    for (const level of levels) {
        const name = ["Ál Lab Dark", accent.name, level.name].filter(Boolean).join(" ");
        const slug = ["al-lab-dark", accent.id, level.id === "subtle" ? "" : level.id]
            .filter(Boolean).join("-");
        const file = `${slug}-color-theme.json`;

        const source = level.id === "bold" ? { ...theme.colors, ...bold } : theme.colors;
        const colors = Object.fromEntries(Object.entries(source).map(([k, v]) => [k, resolve(v, tokens, k)]));

        const variant = { ...theme, name, colors };
        writeFileSync(join(root, "themes", file), JSON.stringify(variant, null, 4) + "\n");
        contributed.push({ label: name, uiTheme: "vs-dark", path: `./themes/${file}` });
    }
}

// Borra variantes que ya no se generan.
const files = new Set(contributed.map(t => t.path.replace("./themes/", "")));
for (const f of readdirSync(join(root, "themes"))) {
    if (f.endsWith("-color-theme.json") && !files.has(f)) unlinkSync(join(root, "themes", f));
}

const pkgPath = join(root, "package.json");
const pkg = JSON.parse(readFileSync(pkgPath, "utf8"));
pkg.contributes.themes = contributed;
writeFileSync(pkgPath, JSON.stringify(pkg, null, 4) + "\n");

console.log(`${contributed.length} temas generados:`);
for (const t of contributed) console.log(`  ${t.label.padEnd(30)} ${t.path}`);
