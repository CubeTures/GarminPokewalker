from __future__ import annotations

import os
from typing import List

from PIL import Image
import loader
from loader import Sprite


def crop_sprite(input_path: str) -> Image.Image:
    with Image.open(input_path) as img:
        width, height = img.size
        if width != 68 or height != 56:
            print(f"Warning: {input_path} is {width}x{height}, expected 68x56.")

        left: int = 14
        upper: int = 25
        right: int = left + 40
        lower: int = upper + 30

        return img.crop((left, upper, right, lower))


def create_sheets(
    input_dir: str,
    output_path: str,
    partition: list[list[Sprite]],
    width: int,
    height: int,
):
    sheet_capacity: int = width * height

    state: dict[str, int | list[Image.Image]] = {
        "total": 0,
        "images": [],
    }

    def write_sheet() -> None:
        images = state["images"]
        total = state["total"]

        assert isinstance(images, list)
        assert isinstance(total, int)

        sheet = Image.new("RGBA", (width * 40, height * 30))

        i = 0
        for row in range(height):
            for col in range(width):
                if i < len(images):
                    sheet.paste(images[i], (col * 40, row * 30))
                    i += 1

        sheet.save(os.path.join(output_path, f"{total}.png"))

        state["images"] = []
        state["total"] = total + 1

    def save_sprite(sprite: Sprite) -> None:
        images = state["images"]
        assert isinstance(images, list)

        in_path = os.path.join(input_dir, f"{sprite.get_target()}.png")
        img = crop_sprite(in_path)
        images.append(img)

        if len(images) >= sheet_capacity:
            write_sheet()

    for group in partition:
        for sprite in group:
            save_sprite(sprite)

        images = state["images"]
        assert isinstance(images, list)
        if images:
            write_sheet()


if __name__ == "__main__":
    input_dir: str = "scripts/output/recolor"
    output_path: str = "scripts/output/pack"
    os.makedirs(output_path, exist_ok=True)

    sprites: List[Sprite] = loader.import_sprites()
    partition = loader.partition_sprites(sprites)
    create_sheets(input_dir, output_path, partition, 4, 4)
