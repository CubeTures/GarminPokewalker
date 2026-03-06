import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.StringUtil;
using Toybox.System;

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

    function getNthString(bytes as ByteArray, n as Number) as String {
        System.println("Find string " + n);
        var index = Utils.decodeOff64(bytes, 0, Constants.START_INDEX_SIZE);
        var pos = Constants.START_INDEX_SIZE;
        while (index < n) {
            var len = Utils.decodeOff64(
                bytes,
                pos,
                Constants.STRING_LENGTH_SIZE
            );
            pos += Constants.STRING_LENGTH_SIZE + len;
            index += 1;
            System.println("Index " + index + " has length " + len);
            if (len == 0) {
                return (
                    WatchUi.loadResource(Rez.Strings.string_unknown) as String
                );
            }
        }
        var len = Utils.decodeOff64(bytes, pos, Constants.STRING_LENGTH_SIZE);
        pos += Constants.STRING_LENGTH_SIZE;
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
