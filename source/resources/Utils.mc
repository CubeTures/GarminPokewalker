import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Models;

module Resources {
    function loadSprite(
        pokemon as Models.Pokemon
    ) as [Graphics.BitmapType, Graphics.BitmapType] {
        var left, right;

        if (pokemon.gender == Models.Pokemon.MALE) {
            left = loadFemaleSprite(pokemon.sid);
        } else if (pokemon.form != 0) {
            left = loadFormSprite(pokemon.sid, pokemon.form);
        } else {
            left = loadBasicSprite(pokemon.sid);
        }

        if (true) {
            right = loadRightSprite(pokemon.sid);
        } else {
            right = left;
        }

        return [left, right];
    }
}
