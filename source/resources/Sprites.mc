import Toybox.Lang;
using Toybox.Graphics;

module Resources {
    class Sprite {
        (:initialized)
        var left as Graphics.BitmapType;
        (:initialized)
        var right as Graphics.BitmapType;

        (:initialized)
        var leftOffset as [Number, Number];
        (:initialized)
        var rightOffset as [Number, Number];

        function initialize(p as Models.Pokemon) {
            loadSprite(p);
        }

        // no form sprite has a female version
        function loadSprite(p as Models.Pokemon) as Void {
            var leftRez, rightRez;

            if (p.form != 0) {
                leftRez = Generated.loadFormSprite(p);
                leftOffset = Generated.loadFormSpriteOffset(p);
            } else if (Generated.hasFemaleSprite(p)) {
                leftRez = Generated.loadFemaleSprite(p);
                leftOffset = Generated.loadFemaleSpriteOffset(p);
            } else {
                leftRez = Generated.loadBaseSprite(p);
                leftOffset = Generated.loadBaseSpriteOffset(p);
            }

            if (p.form != 0 && Generated.hasRightFormSprite(p)) {
                rightRez = Generated.loadRightFormSprite(p);
                rightOffset = Generated.loadRightFormSpriteOffset(p);
            } else if (Generated.hasRightSprite(p)) {
                rightRez = Generated.loadRightSprite(p);
                rightOffset = Generated.loadRightSpriteOffset(p);
            } else {
                // reuse the data
                rightRez = leftRez;
                rightOffset = leftOffset;
            }

            left = WatchUi.loadResource(leftRez) as Graphics.BitmapType;
            if (leftRez != rightRez) {
                right = WatchUi.loadResource(rightRez) as Graphics.BitmapType;
            } else {
                right = left;
            }
        }
    }
}
