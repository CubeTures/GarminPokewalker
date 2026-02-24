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

        // female sprites do not have form nor right versions
        function loadSprite(p as Models.Pokemon) as Void {
            var lRez, rRez;

            if (p.form != 0) {
                lRez = Generated.loadFormSprite(p);
                leftOffset = loadFormSpriteOffset(p);
            } else if (hasFemaleSprite(p)) {
                lRez = Generated.loadFemaleSprite(p);
                leftOffset = loadFemaleSpriteOffset(p);
            } else {
                lRez = Generated.loadBaseSprite(p);
                leftOffset = loadBaseSpriteOffset(p);
            }

            if (p.form != 0 && hasRightFormSprite(p)) {
                rRez = Generated.loadRightFormSprite(p);
                rightOffset = loadRightFormSpriteOffset(p);
            } else if (hasRightSprite(p)) {
                rRez = Generated.loadRightSprite(p);
                rightOffset = loadRightSpriteOffset(p);
            } else {
                rRez = lRez;
                rightOffset = leftOffset;
            }

            left = WatchUi.loadResource(lRez) as Graphics.BitmapType;
            if (lRez != rRez) {
                right = WatchUi.loadResource(rRez) as Graphics.BitmapType;
            } else {
                // reuse the data
                right = left;
            }
        }

        function hasFemaleSprite(p as Models.Pokemon) as Boolean {
            return Utils.linearSearch(Generated.femaleSprites, p.sid) != -1;
        }

        function hasRightSprite(p as Models.Pokemon) as Boolean {
            return Utils.binarySearch(Generated.rightSprites, p.sid) != -1;
        }

        function hasRightFormSprite(p as Models.Pokemon) as Boolean {
            var count = Utils.binarySearchCount(
                Generated.rightFormSprites,
                p.sid
            );
            return p.form <= count;
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

        function loadRightSpriteOffset(
            p as Models.Pokemon
        ) as [Number, Number] {
            var i = Utils.binarySearch(Generated.rightSprites, p.sid);
            return Generated.loadSpriteOffset(i);
        }

        function loadRightFormSpriteOffset(
            p as Models.Pokemon
        ) as [Number, Number] {
            var i =
                Utils.binarySearchFirst(Generated.rightFormSprites, p.sid) +
                p.form -
                1;
            return Generated.loadSpriteOffset(i);
        }

        function drawSprite(
            dc as Graphics.Dc,
            facingLeft as Boolean,
            x as Number,
            y as Number
        ) as Void {
            if (facingLeft) {
                dc.setClip(x - 20, y, 40, 30);
                dc.drawBitmap(
                    x - 20 - leftOffset[0],
                    y - leftOffset[1],
                    left
                );
            } else {
                dc.setClip(x + 20, y, 40, 30);
                dc.drawBitmap(
                    x + 20 - rightOffset[0],
                    y - rightOffset[1],
                    right
                );
            }
            dc.clearClip();
        }
    }
}
