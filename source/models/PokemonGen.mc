import Toybox.Lang;

module Models {
    function pokemonFromGeneration(sid as Number) as Pokemon {
        var p = new Pokemon();

        p.sid = sid;
        // load properties based on chances denoted in dex

        return p;
    }
}
