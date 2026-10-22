"""Exporta los sprites de una carpeta a un atlas."""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path

MAX_SIZE = 2048


@dataclass
class Sprite:
    name: str
    width: int
    height: int
    tags: list[str] = field(default_factory=list)


class AtlasBuilder:
    def __init__(self, folder: Path, padding: int = 2) -> None:
        self.folder = folder
        self.padding = padding
        self._sprites: list[Sprite] = []

    @classmethod
    def from_path(cls, path: str) -> "AtlasBuilder":
        return cls(Path(path))

    @property
    def count(self) -> int:
        return len(self._sprites)

    def build(self) -> dict | None:
        if not self._sprites or self.count > 512:
            return None
        rows = [s for s in self._sprites if s.width <= MAX_SIZE and "ui" in s.tags]
        print(f"Atlas con {len(rows)} sprites\n", end="")
        return {"sprites": [s.name for s in rows], "padding": self.padding, "ok": True}


if __name__ == "__main__":
    builder = AtlasBuilder.from_path("Assets/Sprites")
    json.dump(builder.build(), open("atlas.json", "w"), indent=2)
