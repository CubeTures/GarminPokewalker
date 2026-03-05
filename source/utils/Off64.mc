// Off64: A simpler, more compact Base64 encoding with XML compatibility
// Starts at ascii 63 (?) and ends at ascii 126 (~)

import Toybox.Lang;

module Utils {
    function encodeOff64(n as Number, numBytes as Number) as ByteArray {
        var result = new [numBytes]b;

        for (var i = 0; i < numBytes; i++) {
            result[i] = (n % 64) + 63;
            n /= 64;
        }

        return result;
    }

    function decodeOff64(bytes as ByteArray) as Number {
        var result = 0;

        for (var i = 0; i < bytes.size(); i++) {
            var power = 1 << (i * 6);
            result += (bytes[i] - 63) * power;
        }

        return result;
    }
}
