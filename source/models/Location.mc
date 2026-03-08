import Toybox.Lang;

module Models {
    function newLocation(b as ByteArray, o as Number) as Location {
        return new Location(b, o);
    }

    class Location {
        var continent as Number;
        var location as Number;
        var x as Number;
        var y as Number;

        function initialize(bytes as ByteArray, offset as Number) {
            continent = Utils.decodeOff64(bytes, offset + 0, 1);
            location = Utils.decodeOff64(bytes, offset + 1, 2);
            x = Utils.decodeOff64(bytes, offset + 3, 2);
            y = Utils.decodeOff64(bytes, offset + 5, 2);
        }
    }
}
