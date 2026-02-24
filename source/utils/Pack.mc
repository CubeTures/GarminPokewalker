import Toybox.Lang;

module Utils {
    function unpackUint32(bytes as ByteArray, offset as Number) as Number {
        return (
            (bytes[offset].toNumber() & 0xff) |
            ((bytes[offset + 1].toNumber() & 0xff) << 8) |
            ((bytes[offset + 2].toNumber() & 0xff) << 16) |
            ((bytes[offset + 3].toNumber() & 0xff) << 24)
        );
    }

    function packUint32(
        bytes as ByteArray,
        offset as Number,
        val as Number
    ) as Void {
        bytes[offset] = val & 0xff;
        bytes[offset + 1] = (val >> 8) & 0xff;
        bytes[offset + 2] = (val >> 16) & 0xff;
        bytes[offset + 3] = (val >> 24) & 0xff;
    }

    function parseUint32(bytes as ByteArray, offset as Number) as Number {
        return (
            bytes.decodeNumber(Lang.NUMBER_FORMAT_UINT32, {
                :offset => offset,
            }) as Number
        );
    }
}
