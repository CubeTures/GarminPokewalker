import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.ActivityMonitor;

module Views {
    class HomeView extends WatchUi.View {
        var clock as Visuals.Clock;
        var pokemon as Models.Pokemon;
        var spriteLeft as Resources.Sprite?;
        var spriteRight as Resources.Sprite?;
        var stepsIcon as Graphics.BitmapType;
        var stepsText as WatchUi.Text;

        function initialize() {
            View.initialize();
            clock = new Visuals.Clock();
            pokemon = new Models.Pokemon();
            pokemon.sid = 0;
            pokemon.form = 0;

            stepsIcon =
                WatchUi.loadResource(Rez.Drawables.footprints) as
                Graphics.BitmapType;
            stepsText = new WatchUi.Text({
                :color => Graphics.COLOR_WHITE,
                :justification => Graphics.TEXT_JUSTIFY_LEFT,
                :font => Graphics.FONT_SMALL,
                :locX => Constants.POS_2 + 28,
                :locY => 146,
            });
            var info = ActivityMonitor.getInfo();
            var steps = info.steps;
            if (steps != null) {
                stepsText.setText(steps.toString());
            } else {
                stepsText.setText("UNK");
            }
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

            dc.drawBitmap(Constants.POS_2, 146, stepsIcon);
            stepsText.draw(dc);
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
