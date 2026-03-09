# Off64: A simpler, more compact Base64 encoding with XML compatibility
# Starts at ascii 62 (>), skips 92 (\), and ends at ascii 126 (~)

import math


def _encode_char(value: int) -> int:
    return value + 62 if value < 30 else value + 63


def _decode_char(char: int) -> int:
    return char - 62 if char < 92 else char - 63


def encode(n: int, numBytes: int) -> bytearray:
    result = bytearray()
    for _ in range(numBytes):
        result.append(_encode_char(n % 64))
        n //= 64
    return result


def decode(b: bytearray) -> int:
    result = 0
    for i in range(len(b)):
        result += _decode_char(b[i]) * (1 << (i * 6))
    return result


def bytes_needed(n: int) -> int:
    if n == 0:
        return 1
    return math.ceil(math.log(n + 1, 64))

def enc_str(n: int, numBytes: int) -> str:
    return encode(n, numBytes).decode()