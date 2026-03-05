import Toybox.Lang;

module Utils {
    function linearSearch(arr as Array<Number>, target as Number) as Number {
        for (var i = 0; i < arr.size(); i++) {
            if (arr[i] == target) {
                return i;
            } else if (arr[i] > target) {
                return -1;
            }
        }

        return -1;
    }

    function binarySearch(arr as Array<Number>, target as Number) as Number {
        var low = 0;
        var high = arr.size() - 1;

        while (low <= high) {
            var mid = low + (high - low) / 2;
            var val = arr[mid];

            if (val == target) {
                return mid;
            } else if (val < target) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }

        return -1;
    }

    function binarySearchFirst(
        arr as Array<Number>,
        target as Number
    ) as Number {
        return binaryBound(arr, target, true);
    }

    function binarySearchCount(
        arr as Array<Number>,
        target as Number
    ) as Number {
        var start = binaryBound(arr, target, true);
        if (start == -1) {
            return 0;
        }
        return binaryBound(arr, target, false) - start + 1;
    }

    function binaryBound(
        arr as Array<Number>,
        target as Number,
        findFirst as Boolean
    ) as Number {
        var result = -1;
        var low = 0;
        var high = arr.size() - 1;

        while (low <= high) {
            var mid = low + (high - low) / 2;
            var val = arr[mid];
            if (val == target) {
                result = mid;
                if (findFirst) {
                    high = mid - 1;
                } else {
                    low = mid + 1;
                }
            } else if (val < target) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }

        return result;
    }
}
