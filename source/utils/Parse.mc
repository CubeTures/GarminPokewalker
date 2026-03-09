import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.StringUtil;

module Utils {
    function loadByteArray(rez as ResourceId) as ByteArray {
        var str = WatchUi.loadResource(rez) as String;
        return (
            StringUtil.convertEncodedString(str, {
                :fromRepresentation
                =>
                StringUtil.REPRESENTATION_STRING_PLAIN_TEXT,
                :toRepresentation => StringUtil.REPRESENTATION_BYTE_ARRAY,
            }) as ByteArray
        );
    }

    function getNthVariablePos(bytes as ByteArray, n as Number) as Number {
        var i = Utils.decodeOff64(bytes, 0, K.META_START_INDEX_SIZE);
        var pos = K.META_SIZE;

        while (i < n) {
            var len = Utils.decodeOff64(bytes, pos, K.VARIABLE_LENGTH_SIZE);
            pos += K.VARIABLE_LENGTH_SIZE + len;
            i += 1;
            if (len == 0) {
                return -1;
            }
        }

        return pos;
    }

    function getNthString(bytes as ByteArray, n as Number) as String {
        var pos = getNthVariablePos(bytes, n);
        if (pos == -1) {
            return K.STRING_UNK;
        }

        var len = Utils.decodeOff64(bytes, pos, K.VARIABLE_LENGTH_SIZE);
        pos += K.VARIABLE_LENGTH_SIZE;
        return loadString(bytes, pos, len);
    }

    function loadString(
        bytes as ByteArray,
        offset as Number,
        length as Number
    ) as String {
        var slice = bytes.slice(offset, offset + length);
        return (
            StringUtil.convertEncodedString(slice, {
                :fromRepresentation => StringUtil.REPRESENTATION_BYTE_ARRAY,
                :toRepresentation
                =>
                StringUtil.REPRESENTATION_STRING_PLAIN_TEXT,
            }) as String
        );
    }
}
