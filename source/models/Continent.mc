import Toybox.Lang;

module Models {
    class Continent {
        var continent as Number;
        var x as Number;
        var y as Number;

        function initialize(continentCoords as ByteArray, index as Number) {
            var start = K.START_INDEX_SIZE + index * 5;
            continent = Utils.decodeOff64(continentCoords, start + 0, 1);
            x = Utils.decodeOff64(continentCoords, start + 1, 2);
            y = Utils.decodeOff64(continentCoords, start + 3, 2);
        }
    }
}
