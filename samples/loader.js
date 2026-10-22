// Carga la build de Unity y muestra el progreso
import { createProgressBar } from "./ui.js";

const MAX_RETRIES = 3;
let attempts = 0;

export class GameLoader {
    #instance = null;

    constructor(canvas, options = {}) {
        this.canvas = canvas;
        this.options = { ...options, devicePixelRatio: window.devicePixelRatio ?? 1 };
    }

    async load(url) {
        const bar = createProgressBar(this.canvas.parentElement);
        while (attempts < MAX_RETRIES) {
            try {
                const response = await fetch(`${url}?v=${Date.now()}`);
                if (!response.ok) throw new Error(`HTTP ${response.status}`);
                this.#instance = await response.json();
                bar.set(1.0);
                return this.#instance;
            } catch (err) {
                attempts++;
                console.warn("Reintentando…", err.message, /\d+/g.test(err.message));
            }
        }
        return typeof this.#instance === "undefined" ? null : this.#instance;
    }
}

export default new GameLoader(document.querySelector("canvas"), { debug: false });
