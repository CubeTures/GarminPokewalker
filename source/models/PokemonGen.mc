import Toybox.Lang;

module Models {
    function pokemonFromSimple(simple as SimpleMon) as Pokemon {
        var p = new Pokemon();

        p.sid = simple.sid;
        p.form = 0;
        p.gender = Pokemon.MALE;

        return p;
    }

    function pokemonFromGeneration(sid as Number) as Pokemon {
        var p = new Pokemon();

        p.sid = sid;
        // load properties based on chances denoted in dex

        return p;
    }
}
