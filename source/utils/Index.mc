import Toybox.Lang;

module Utils {
    function wrapIndex(
        value as Number,
        offset as Number,
        cap as Number
    ) as Number {
        return wrapIndexFull(value, offset, 0, cap);
    }

    function wrapIndexFull(
        value as Number,
        offset as Number,
        floor as Number,
        cap as Number
    ) as Number {
        value += offset;
        while (value < floor) {
            value += cap - floor;
        }
        while (value >= cap) {
            value -= cap - floor;
        }
        return value;
    }
}
