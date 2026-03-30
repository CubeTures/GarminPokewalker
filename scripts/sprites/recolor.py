import os
from typing import Callable

import cv2
from PIL import Image
from cv2.typing import MatLike
import numpy as np
import numpy.typing as npt

import scripts.sprites.sprite as sprite
import scripts.utils.paths as paths

UInt8Array = npt.NDArray[np.uint8]
BoolArray = npt.NDArray[np.bool_]


def process_image(
    input_path: str,
    output_path: str,
    flip: bool,
    func: Callable[[MatLike, MatLike], MatLike],
) -> None:
    img: MatLike | None = cv2.imread(input_path, cv2.IMREAD_UNCHANGED)
    if img is None:
        raise FileNotFoundError(f"Failed to read image: {input_path}")

    if img.shape[2] == 4:
        bgr = img[:, :, :3]
        alpha = img[:, :, 3]
    else:
        bgr = img
        alpha = np.full(bgr.shape[:2], 255, dtype=np.uint8)

    binary = func(bgr, alpha)
    result = cv2.merge([binary, binary, binary, alpha])
    if flip:
        result = cv2.flip(result, 1)
    cv2.imwrite(output_path, result)


def _compute_global_binary_map(
    bgr: MatLike, mask: BoolArray
) -> dict[tuple[int, int, int], int]:
    pixels = bgr[mask]

    unique_colors, counts = np.unique(pixels.reshape(-1, 3), axis=0, return_counts=True)

    luminance: npt.NDArray[np.float64] = (
        0.2126 * unique_colors[:, 2]
        + 0.7152 * unique_colors[:, 1]
        + 0.0722 * unique_colors[:, 0]
    )

    sorted_idx = np.argsort(luminance)
    sorted_colors = unique_colors[sorted_idx]
    sorted_counts = counts[sorted_idx]

    total_pixels = int(np.sum(sorted_counts))
    cumulative = 0
    split_index = 0

    for i, count in enumerate(sorted_counts):
        cumulative += int(count)
        if cumulative >= total_pixels / 2:
            split_index = i
            break

    dark_colors = sorted_colors[: split_index + 1]
    light_colors = sorted_colors[split_index + 1 :]

    color_map: dict[tuple[int, int, int], int] = {}
    for c in dark_colors:
        color_map[(int(c[0]), int(c[1]), int(c[2]))] = 0
    for c in light_colors:
        color_map[(int(c[0]), int(c[1]), int(c[2]))] = 255

    return color_map


def median_color_threshold(bgr: MatLike, alpha: MatLike) -> UInt8Array:
    mask: BoolArray = alpha > 0
    color_map = _compute_global_binary_map(bgr, mask)

    h, w = bgr.shape[:2]
    binary: UInt8Array = np.zeros((h, w), dtype=np.uint8)

    for y in range(h):
        for x in range(w):
            if mask[y, x]:
                key = (
                    int(bgr[y, x, 0]),
                    int(bgr[y, x, 1]),
                    int(bgr[y, x, 2]),
                )
                binary[y, x] = color_map[key]

    return binary


def median_pixel_redraw_details(
    bgr: MatLike,
    alpha: MatLike,
    local_window: int = 3,
    contrast_threshold: int = 45,
) -> MatLike:
    mask: BoolArray = alpha > 0
    pixels = bgr[mask]

    h, w = bgr.shape[:2]
    binary: UInt8Array = np.zeros((h, w), dtype=np.uint8)

    if pixels.size == 0:
        return binary

    color_map = _compute_global_binary_map(bgr, mask)

    for y in range(h):
        for x in range(w):
            if mask[y, x]:
                key = (
                    int(bgr[y, x, 0]),
                    int(bgr[y, x, 1]),
                    int(bgr[y, x, 2]),
                )
                binary[y, x] = color_map[key]

    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)

    pad = local_window // 2
    padded = cv2.copyMakeBorder(gray, pad, pad, pad, pad, cv2.BORDER_REPLICATE)

    for y in range(h):
        for x in range(w):
            if not mask[y, x]:
                continue

            local_patch = padded[y : y + local_window, x : x + local_window]
            local_mean = float(np.mean(local_patch))
            pixel_val = int(gray[y, x])
            contrast = abs(pixel_val - local_mean)

            if contrast >= contrast_threshold and pixel_val < local_mean:
                binary[y, x] = 0
            elif contrast >= contrast_threshold * 2 and pixel_val > local_mean:
                binary[y, x] = 255

    return binary


def add_white_outline(input_path: str, output_path: str, thickness: int = 1) -> None:
    img = Image.open(input_path).convert("RGBA")
    arr = np.array(img)

    alpha = arr[:, :, 3]
    opaque = alpha > 0
    kernel_offsets = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    neighbor_mask = np.zeros_like(opaque)

    for dy, dx in kernel_offsets:
        shifted = np.roll(np.roll(opaque, dy, axis=0), dx, axis=1)
        if dy < 0:
            shifted[dy:, :] = False
        elif dy > 0:
            shifted[:dy, :] = False
        if dx < 0:
            shifted[:, dx:] = False
        elif dx > 0:
            shifted[:, :dx] = False
        neighbor_mask |= shifted

    outline_mask = neighbor_mask & ~opaque

    result = arr.copy()
    result[outline_mask] = [255, 255, 255, 255]

    Image.fromarray(result, "RGBA").save(output_path)


def recolor_sprites():
    output_path = f"{paths.OUTPUT}/recolor/"
    os.makedirs(output_path, exist_ok=True)

    sprites = sprite.load_sprites()
    for spr in sprites:
        inp: str = spr.get_path()
        outp: str = f"{output_path}{spr.get_target()}.png"
        process_image(inp, outp, spr.reflect, median_pixel_redraw_details)
        add_white_outline(outp, outp)
