from __future__ import annotations

import os
from typing import List

from PIL import Image
import loader
from loader import Sprite
import constants


def crop_sprite(input_path: str) -> Image.Image:
    with Image.open(input_path) as img:
        width, height = img.size
        if (
            width != constants.sprite_large_width
            or height != constants.sprite_large_height
        ):
            print(f"Warning: {input_path} is {width}x{height}, expected 68x56.")

        left: int = constants.sprite_offset_x
        upper: int = constants.sprite_offset_y
        right: int = left + constants.sprite_width
        lower: int = upper + constants.sprite_height

        return img.crop((left, upper, right, lower))


def create_sheets(
    input_dir: str,
    output_path: str,
    partition: list[list[Sprite]],
    width: int,
    height: int,
):

    state: dict[str, int | list[Image.Image]] = {
        "total": 0,
        "images": [],
    }

    def write_sheet() -> None:
        images = state["images"]
        total = state["total"]

        assert isinstance(images, list)
        assert isinstance(total, int)

        sheet = Image.new(
            "RGBA",
            (
                width * constants.sprite_width,
                height * constants.sprite_height,
            ),
        )

        i = 0
        for row in range(height):
            for col in range(width):
                if i < len(images):
                    sheet.paste(
                        images[i],
                        (
                            col * constants.sprite_width,
                            row * constants.sprite_height,
                        ),
                    )
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

        if len(images) >= constants.sheet_capacity:
            write_sheet()

    for group in partition:
        for sprite in group:
            save_sprite(sprite)

        images = state["images"]
        assert isinstance(images, list)
        if images:
            write_sheet()


if __name__ == "__main__":
    input_dir: str = "scripts/output/recolor/"
    output_path: str = "resources/_generated/sprites/"
    os.makedirs(output_path, exist_ok=True)

    sprites: List[Sprite] = loader.import_sprites()
    partition = loader.partition_sprites(sprites)
    create_sheets(
        input_dir,
        output_path,
        partition,
        constants.sheet_width,
        constants.sheet_height,
    )
