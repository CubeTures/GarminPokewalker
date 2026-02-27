import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;

module Views {
    class HomeView extends WatchUi.View {
        var clock as Visuals.Clock;
        var pokemon as Models.Pokemon;
        var spriteLeft as Resources.Sprite?;
        var spriteRight as Resources.Sprite?;

        function initialize() {
            View.initialize();
            clock = new Visuals.Clock();
            pokemon = new Models.Pokemon();
            pokemon.sid = 0;
            pokemon.form = 0;
        }

        function onShow() as Void {
            clock.onShow();
            Visuals.loadWeatherIcon();
            loadSprites();
        }

        function onUpdate(dc as Graphics.Dc) as Void {
            View.onUpdate(dc);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();

            Visuals.drawGrid(dc);
            Visuals.drawBulb(dc);
            Visuals.drawWeather(dc);
            clock.draw(dc);

            if (spriteLeft != null) {
                spriteLeft.drawSprite(dc, 68 - 20, 73);
            }
            if (spriteRight != null) {
                spriteRight.drawSprite(dc, 68 + 20, 73);
            }
        }

        function onHide() as Void {
            clock.onHide();
            spriteLeft = null;
            spriteRight = null;
        }

        function loadSprites() as Void {
            System.println("Loading sprite for sid " + pokemon.sid);
            spriteLeft = new Resources.Sprite(pokemon, false);
            spriteRight = new Resources.Sprite(pokemon, true);
        }
    }
}
