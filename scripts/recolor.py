import cv2
import os
import numpy as np
from loader import import_sprites


def fn(input_path: str, output_path: str, func):
    img = cv2.imread(input_path, cv2.IMREAD_UNCHANGED)
    if img.shape[2] == 4:
        bgr = img[:, :, :3]
        alpha = img[:, :, 3]
    else:
        bgr = img
        alpha = np.full(bgr.shape[:2], 255, dtype=np.uint8)
    img = func(bgr, alpha)
    result = cv2.merge([img, img, img, alpha])
    # result = cv2.resize(result, None, fx=4, fy=4, interpolation=cv2.INTER_NEAREST)
    cv2.imwrite(output_path, result)


def median_color(bgr, alpha):
    mask = alpha > 0
    pixels = bgr[mask]

    # Unique colors only (preserves region coherence)
    unique_colors, counts = np.unique(pixels.reshape(-1, 3), axis=0, return_counts=True)

    # Perceptual luminance
    luminance = (
        0.2126 * unique_colors[:, 2]
        + 0.7152 * unique_colors[:, 1]
        + 0.0722 * unique_colors[:, 0]
    )

    # Sort by luminance (dark → light)
    sorted_indices = np.argsort(luminance)
    sorted_colors = unique_colors[sorted_indices]
    sorted_counts = counts[sorted_indices]

    # Split by cumulative pixel count (better than 50% color split)
    total_pixels = np.sum(sorted_counts)
    cumulative = 0
    split_index = 0

    for i, count in enumerate(sorted_counts):
        cumulative += count
        if cumulative >= total_pixels / 2:
            split_index = i
            break

    dark_colors = sorted_colors[: split_index + 1]
    light_colors = sorted_colors[split_index + 1 :]

    # Build lookup table
    color_map = {}
    for c in dark_colors:
        color_map[tuple(c)] = 0
    for c in light_colors:
        color_map[tuple(c)] = 255

    # Apply mapping in-place
    binary = np.zeros(alpha.shape, dtype=np.uint8)

    h, w = bgr.shape[:2]
    for y in range(h):
        for x in range(w):
            if mask[y, x]:
                binary[y, x] = color_map[tuple(bgr[y, x])]
            else:
                binary[y, x] = 0  # transparent remains transparent

    return binary


def median_pixel_redraw_details(bgr, alpha, local_window=3, contrast_threshold=45):
    mask = alpha > 0
    pixels = bgr[mask]

    if len(pixels) == 0:
        # Fully transparent
        return

    # --- Weighted Global Median ---
    unique_colors, counts = np.unique(pixels.reshape(-1, 3), axis=0, return_counts=True)

    # Compute perceptual luminance
    luminance = (
        0.2126 * unique_colors[:, 2]
        + 0.7152 * unique_colors[:, 1]
        + 0.0722 * unique_colors[:, 0]
    )

    # Sort by luminance
    sorted_idx = np.argsort(luminance)
    sorted_colors = unique_colors[sorted_idx]
    sorted_counts = counts[sorted_idx]

    # Weighted cumulative to find median pixel
    total_pixels = np.sum(sorted_counts)
    cumulative = 0
    split_index = 0
    for i, count in enumerate(sorted_counts):
        cumulative += count
        if cumulative >= total_pixels / 2:
            split_index = i
            break

    dark_colors = sorted_colors[: split_index + 1]
    light_colors = sorted_colors[split_index + 1 :]

    # Map colors to binary based on global median
    color_map = {tuple(c): 0 for c in dark_colors}
    color_map.update({tuple(c): 255 for c in light_colors})

    # --- Apply global median mapping ---
    h, w = bgr.shape[:2]
    binary = np.zeros(alpha.shape, dtype=np.uint8)
    for y in range(h):
        for x in range(w):
            if mask[y, x]:
                binary[y, x] = color_map[tuple(bgr[y, x])]
            else:
                binary[y, x] = 0

    # --- Local contrast enhancement ---
    # Convert full image to grayscale
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)
    padded = cv2.copyMakeBorder(
        gray,
        local_window // 2,
        local_window // 2,
        local_window // 2,
        local_window // 2,
        cv2.BORDER_REPLICATE,
    )

    # Process only pixels with alpha
    for y in range(h):
        for x in range(w):
            if mask[y, x]:
                # Local neighborhood
                y0 = y
                x0 = x
                local_patch = padded[y0 : y0 + local_window, x0 : x0 + local_window]
                local_mean = np.mean(local_patch)
                # Override if local contrast exceeds threshold
                contrast = abs(int(gray[y, x]) - local_mean)
                if contrast >= contrast_threshold and gray[y, x] < local_mean:
                    binary[y, x] = 0
                elif contrast >= contrast_threshold * 2 and gray[y, x] > local_mean:
                    binary[y, x] = 255

    # binary = cv2.bitwise_not(binary)

    return binary


if __name__ == "__main__":
    output_path = f"scripts-custom/recolor-output/"
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    with open("data/pokemon.json") as file:
        sprites = import_sprites()

        for sprite in sprites:
            inp = sprite.get_path()
            outp = f"{output_path}{sprite.get_target()}.png"
            fn(inp, outp, median_pixel_redraw_details)
