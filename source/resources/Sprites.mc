using Toybox.Graphics;

module Resources {
    class Sprite {
        var left as Graphics.BitmapType;
        var right as Graphics.BitmapType;

        function initialize(pokemon as Models.Pokemon) {
            var sprites = loadSprite(pokemon);
            left = sprites[0];
            right = sprites[1];
        }
    }
}