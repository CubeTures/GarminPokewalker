// Off64: A simpler, more compact Base64 encoding with XML compatibility
// Starts at ascii 62 (>), skips 92 (\), and ends at ascii 126 (~)

import Toybox.Lang;

module Utils {
    function encodeChar(value as Number) as Number {
        return value < 30 ? value + 62 : value + 63;
    }

    function decodeChar(char as Number) as Number {
        return char < 92 ? char - 62 : char - 63;
    }

    function encodeOff64(n as Number, numBytes as Number) as ByteArray {
        var result = new [numBytes]b;
        for (var i = 0; i < numBytes; i++) {
            result[i] = encodeChar(n % 64);
            n /= 64;
        }
        return result;
    }

    function decodeOff64(
        bytes as ByteArray,
        offset as Number,
        length as Number
    ) as Number {
        var result = 0;
        for (var i = 0; i < length; i++) {
            result += decodeChar(bytes[i + offset]) * (1 << (i * 6));
        }
        return result;
    }
}
