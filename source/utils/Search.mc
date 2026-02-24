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
        var start = -1;

        var low = 0;
        var high = arr.size() - 1;
        while (low <= high) {
            var mid = low + (high - low) / 2;
            var val = arr[mid];

            if (val == target) {
                start = mid;
                high = mid - 1;
            } else if (val < target) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }

        return start;
    }

    function binarySearchCount(
        arr as Array<Number>,
        target as Number
    ) as Number {
        var start = -1;
        var end = -1;

        var low = 0;
        var high = arr.size() - 1;
        while (low <= high) {
            var mid = low + (high - low) / 2;
            var val = arr[mid];

            if (val == target) {
                start = mid;
                high = mid - 1;
            } else if (val < target) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }

        low = 0;
        high = arr.size() - 1;
        while (low <= high) {
            var mid = low + (high - low) / 2;
            var val = arr[mid];

            if (val == target) {
                end = mid;
                low = mid + 1;
            } else if (val < target) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }

        return end - start;
    }
}
