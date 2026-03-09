import Toybox.Lang;

module Models {
    function newEncounter(b as ByteArray, o as Number) as Encounter {
        return new Encounter(b, o);
    }

    class Encounter {
        var location as Number;
        var encounters as Array<Number>;

        function initialize(bytes as ByteArray, offset as Number) {
            location = Utils.decodeOff64(bytes, offset + 0, 2);
            encounters = Utils.decodeArray(bytes, offset + 2, 2);
        }
    }
}
