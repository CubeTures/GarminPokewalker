import Toybox.Lang;
module Utils {
    class BitPacker {
        private var bytes as ByteArray;
        private var pos as Number = 0;

        function initialize(bytes as ByteArray?) {
            if (bytes == null) {
                self.bytes = []b;
            } else {
                self.bytes = bytes;
            }
        }

        function write(n as Number, bits as Number) as Void {
            var mask = bits == 32 ? -1 : (1 << bits) - 1;
            var value = n & mask;
            var bitsRemaining = bits;

            while (bitsRemaining > 0) {
                var byteIndex = pos / 8;
                var bitOffset = pos % 8;
                var bitsAvailable = 8 - bitOffset;
                var bitsToWrite =
                    bitsAvailable < bitsRemaining
                        ? bitsAvailable
                        : bitsRemaining;

                while (bytes.size() <= byteIndex) {
                    bytes.add(0);
                }

                var shift = bitsRemaining - bitsToWrite;
                var chunk = (value >> shift) & ((1 << bitsToWrite) - 1);
                bytes[byteIndex] =
                    bytes[byteIndex] | (chunk << (bitsAvailable - bitsToWrite));
                pos += bitsToWrite;
                bitsRemaining -= bitsToWrite;
            }
        }

        function read(bits as Number) as Number {
            var mask = bits == 32 ? -1 : (1 << bits) - 1;
            var value = 0;
            var bitsRemaining = bits;

            while (bitsRemaining > 0) {
                var byteIndex = pos / 8;
                var bitOffset = pos % 8;
                var bitsAvailable = 8 - bitOffset;
                var bitsToRead =
                    bitsAvailable < bitsRemaining
                        ? bitsAvailable
                        : bitsRemaining;

                var chunk =
                    (bytes[byteIndex] >> (bitsAvailable - bitsToRead)) &
                    ((1 << bitsToRead) - 1);
                value = (value << bitsToRead) | chunk;
                pos += bitsToRead;
                bitsRemaining -= bitsToRead;
            }

            return value & mask;
        }

        function getBytes() as ByteArray {
            return bytes;
        }

        function reset() as Void {
            pos = 0;
        }
    }
}
