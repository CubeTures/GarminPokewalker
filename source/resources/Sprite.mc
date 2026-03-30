import Toybox.Lang;
using Toybox.Graphics;

module Resources {
    class Sprite {
        (:initialized)
        var bitmap as Graphics.BitmapType;
        (:initialized)
        var offset as [Number, Number];

        function initialize(p as Models.Pokemon, facingRight as Boolean) {
            loadSprite(p, facingRight);
        }

        function loadSprite(
            p as Models.Pokemon,
            facingRight as Boolean
        ) as Void {
            var rez;

            if (p.form != 0) {
                if (facingRight) {
                    rez = Generated.loadRightFormSprite(p);
                } else {
                    rez = Generated.loadFormSprite(p);
                }
                offset = loadFormSpriteOffset(p);
            } else if (hasFemaleSprite(p)) {
                if (facingRight) {
                    rez = Generated.loadRightFemaleSprite(p);
                } else {
                    rez = Generated.loadFemaleSprite(p);
                }
                offset = loadFemaleSpriteOffset(p);
            } else {
                if (facingRight) {
                    rez = Generated.loadRightBaseSprite(p);
                } else {
                    rez = Generated.loadBaseSprite(p);
                }
                offset = loadBaseSpriteOffset(p);
            }

            bitmap = WatchUi.loadResource(rez) as Graphics.BitmapType;
        }

        function hasFemaleSprite(p as Models.Pokemon) as Boolean {
            return Utils.linearSearch(Generated.femaleSprites, p.sid) != -1;
        }

        function loadBaseSpriteOffset(p as Models.Pokemon) as [Number, Number] {
            return Generated.loadSpriteOffset(p.sid);
        }

        function loadFemaleSpriteOffset(
            p as Models.Pokemon
        ) as [Number, Number] {
            var i = Utils.linearSearch(Generated.femaleSprites, p.sid);
            return Generated.loadSpriteOffset(i);
        }

        function loadFormSpriteOffset(p as Models.Pokemon) as [Number, Number] {
            var i =
                Utils.binarySearchFirst(Generated.formSprites, p.sid) +
                p.form -
                1;
            return Generated.loadSpriteOffset(i);
        }

        function drawSprite(
            dc as Graphics.Dc,
            x as Number,
            y as Number
        ) as Void {
            dc.setClip(x, y, 40, 30);
            dc.drawBitmap(x - offset[0], y - offset[1], bitmap);
            dc.clearClip();
        }
    }
}
