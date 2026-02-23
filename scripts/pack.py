import os
from PIL import Image
from loader import import_sprites, Sprite
from typing import Callable


def crop_sprite(input_path: str):
    """
    Crops a 68x56 image to 40x30 by taking the middle 40 pixels
    and the bottom 30 pixels.
    """
    with Image.open(input_path) as img:
        # Ensure the image is actually the expected size (optional but safe)
        width, height = img.size
        if width != 68 or height != 56:
            print(f"Warning: {input_path} is {width}x{height}, expected 68x56.")

        # Define the cropping box (left, upper, right, lower)
        left = 14
        upper = 25  # 56 - 30 = 26
        right = left + 40  # 14 + 40 = 54
        lower = upper + 30

        # Crop and save
        cropped_img = img.crop((left, upper, right, lower))
        return cropped_img


def pack_image_to_rle(img: Image.Image):
    width, height = img.size
    pixels = img.load()

    binary_data = bytearray()

    # Process row by row to prevent runs from wrapping to the next line
    for y in range(height):
        current_color = -1
        run_length = 0

        for x in range(width):
            r, g, b, a = pixels[x, y]

            # Determine color code (0: Transparent, 1: White, 2: Black)
            if a == 0:
                pixel_color = 0
            elif r > 128 and g > 128 and b > 128:
                pixel_color = 1
            else:
                pixel_color = 2

            # If color changes OR run hits the 6-bit limit (63), flush the byte
            if pixel_color != current_color or run_length == 63:
                if run_length > 0:
                    # Pack the byte: (color << 6) | length
                    packed_byte = (current_color << 6) | run_length
                    binary_data.append(packed_byte)

                current_color = pixel_color
                run_length = 1
            else:
                run_length += 1

        # End of row: flush the final run of this line
        if run_length > 0:
            packed_byte = (current_color << 6) | run_length
            binary_data.append(packed_byte)

    return binary_data


if __name__ == "__main__":
    total = 0
    images: list[Image.Image] = []
    input_dir = "scripts-custom/recolor-output"
    output_path = "scripts-custom/pack-output"
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    files = os.listdir(input_dir)
    files.sort()

    width = 4
    height = 4

    def write_sheet():
        global total
        global images
        sheet = Image.new("RGBA", (width * 40, height * 30))
        i = 0
        for x in range(width):
            for y in range(height):
                if i < len(images):
                    sheet.paste(images[i], (y * 40, x * 30))
                    i += 1
        images = []
        sheet.save(f"{output_path}/{total}.png")
        total += 1

    def save_sprite(sprite: Sprite):
        in_path = os.path.join(input_dir, f"{sprite.get_target()}.png")
        img = crop_sprite(in_path)
        images.append(img)
        if len(images) >= width * height:
            write_sheet()

    def perform_loop(check: Callable[[Sprite], bool]):
        for sprite in sprites:
            if check(sprite):
                save_sprite(sprite)
        if len(images) > 0:
            write_sheet()

    sprites = import_sprites()

    perform_loop(
        lambda sprite: (
            sprite.is_female == False
            and sprite.form == "$"
            and sprite.is_right == False
        )
    )
    perform_loop(
        lambda sprite: (
            sprite.is_female == True and sprite.form == "$" and sprite.is_right == False
        )
    )
    perform_loop(
        lambda sprite: (
            sprite.is_female == False
            and sprite.form != "$"
            and sprite.is_right == False
        )
    )
    perform_loop(
        lambda sprite: (
            sprite.is_female == False and sprite.form == "$" and sprite.is_right == True
        )
    )
    perform_loop(
        lambda sprite: (
            sprite.is_female == False and sprite.form != "$" and sprite.is_right == True
        )
    )

    for sprite in sprites:
        if sprite.is_female == False and sprite.form != "$" and sprite.is_right == True:
            print(sprite.get_target())
