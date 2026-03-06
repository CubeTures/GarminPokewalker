import Toybox.Lang;

module Models {
    class MapLocation {
        var continent as Number;
        var name as Number;
        var x as Number;
        var y as Number;

        function initialize(mapLocations as ByteArray, index as Number) {
            var start = Constants.START_INDEX_SIZE + index * 7;
            continent = Utils.decodeOff64(mapLocations, start + 0, 1);
            name = Utils.decodeOff64(mapLocations, start + 1, 2);
            x = Utils.decodeOff64(mapLocations, start + 3, 2);
            y = Utils.decodeOff64(mapLocations, start + 5, 2);
        }
    }
}
