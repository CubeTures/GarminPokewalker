import Toybox.Lang;

module Models {
    function newContinent(b as ByteArray, o as Number) as Continent {
        return new Continent(b, o);
    }

    class Continent {
        var continent as Number;
        var x as Number;
        var y as Number;

        function initialize(bytes as ByteArray, offset as Number) {
            continent = Utils.decodeOff64(bytes, offset + 0, 1);
            x = Utils.decodeOff64(bytes, offset + 1, 2);
            y = Utils.decodeOff64(bytes, offset + 3, 2);
        }
    }
}
