import Toybox.Lang;

module Models {
    class Location {
        var continent as Number;
        var location as Number;
        var x as Number;
        var y as Number;

        function initialize(locationCoords as ByteArray, index as Number) {
            var start = K.START_INDEX_SIZE + index * 7;
            continent = Utils.decodeOff64(locationCoords, start + 0, 1);
            location = Utils.decodeOff64(locationCoords, start + 1, 2);
            x = Utils.decodeOff64(locationCoords, start + 3, 2);
            y = Utils.decodeOff64(locationCoords, start + 5, 2);
        }
    }
}
