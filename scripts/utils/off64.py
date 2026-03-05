# Off64: A simpler, more compact Base64 encoding with XML compatibility
# Starts at ascii 63 (?) and ends at ascii 126 (~)

ENCODING_MAX = 0xFFF


def encode(n: int, numBytes: int) -> bytearray:
    result = bytearray()

    for _ in range(numBytes):
        result.append((n % 64) + 63)
        n //= 64

    return result


def decode(b: bytearray) -> int:
    result = 0

    for i in range(len(b)):
        power = 1 << (i * 6)
        result += (b[i] - 63) * power

    return result
