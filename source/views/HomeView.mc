import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.ActivityMonitor;

module Views {
    class HomeView extends WatchUi.View {
        var clock as Visuals.Clock;
        var pokemon as Models.Pokemon;
        var spriteLeft as Resources.Sprite?;
        var spriteRight as Resources.Sprite?;
        var stepsIcon as Graphics.BitmapType;
        var stepsText as WatchUi.Text;
        var forest as Graphics.BitmapType;
        var mask as Graphics.BitmapType;

        function initialize() {
            View.initialize();
            clock = new Visuals.Clock();
            pokemon = new Models.Pokemon();
            pokemon.sid = 0;
            pokemon.form = 0;

            forest =
                WatchUi.loadResource(Rez.Drawables.forest) as
                Graphics.BitmapType;
            mask =
                WatchUi.loadResource(Rez.Drawables.mask) as Graphics.BitmapType;

            stepsIcon =
                WatchUi.loadResource(Rez.Drawables.footprints) as
                Graphics.BitmapType;
            stepsText = new WatchUi.Text({
                :color => Graphics.COLOR_WHITE,
                :justification => Graphics.TEXT_JUSTIFY_LEFT,
                :font => Graphics.FONT_SMALL,
                :locX => K.POS_2 + 28,
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
            View.onShow();
            clock.onShow();
            Visuals.loadWeatherIcon();
            loadSprites();
        }

        function onUpdate(dc as Graphics.Dc) as Void {
            View.onUpdate(dc);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            dc.clear();

            dc.drawBitmap(0, 85, forest);
            dc.drawBitmap(0, 0, mask);
            var icon = Visuals.loadWeatherIcon();
            Visuals.subScreen.setIcon(icon);
            Visuals.subScreen.draw(dc);
            clock.draw(dc);

            if (spriteLeft != null) {
                spriteLeft.drawSprite(dc, 68 - 20, 113);
            }
            if (spriteRight != null) {
                spriteRight.drawSprite(dc, 68 + 20, 113);
            }

            dc.drawBitmap(K.POS_2, 146, stepsIcon);
            stepsText.draw(dc);
        }

        function onHide() as Void {
            View.onHide();
            clock.onHide();
            spriteLeft = null;
            spriteRight = null;
        }

        function loadSprites() as Void {
            // System.println("Loading sprite for sid " + pokemon.sid);
            spriteLeft = new Resources.Sprite(pokemon, false);
            spriteRight = new Resources.Sprite(pokemon, true);
        }
    }
}
