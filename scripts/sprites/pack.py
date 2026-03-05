import os
from typing import List
from PIL import Image

from scripts.sprites.sprite import Sprite
import scripts.sprites.sprite as sprite
import scripts.utils.constants as constants
import scripts.utils.paths as paths


def crop_sprite(input_path: str) -> Image.Image:
    with Image.open(input_path) as img:
        width, height = img.size
        if (
            width != constants.SPRITE_LARGE_WIDTH
            or height != constants.SPRITE_LARGE_HEIGHT
        ):
            print(f"Warning: {input_path} is {width}x{height}, expected 68x56.")

        left: int = constants.SPRITE_OFFSET_X
        upper: int = constants.SPRITE_OFFSET_Y
        right: int = left + constants.SPRITE_WIDTH
        lower: int = upper + constants.SPRITE_HEIGHT

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
                width * constants.SPRITE_WIDTH,
                height * constants.SPRITE_HEIGHT,
            ),
        )

        i = 0
        for row in range(height):
            for col in range(width):
                if i < len(images):
                    sheet.paste(
                        images[i],
                        (
                            col * constants.SPRITE_WIDTH,
                            row * constants.SPRITE_HEIGHT,
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

        if len(images) >= constants.SHEET_CAPACITY:
            write_sheet()

    for group in partition:
        for sprite in group:
            save_sprite(sprite)

        images = state["images"]
        assert isinstance(images, list)
        if images:
            write_sheet()


def pack_sprites():
    input_dir: str = f"{paths.OUTPUT}/recolor/"
    output_path: str = f"{paths.RESOURCES}/sprites/"
    os.makedirs(output_path, exist_ok=True)

    sprites: List[Sprite] = sprite.load_sprites()
    partition = sprite.partition_sprites(sprites)
    create_sheets(
        input_dir,
        output_path,
        partition,
        constants.SHEET_WIDTH,
        constants.SHEET_HEIGHT,
    )
