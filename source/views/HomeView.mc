import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;

module AppHome {
    class HomeView extends WatchUi.View {
        var clock as Visuals.Clock;

        function initialize() {
            View.initialize();
            clock = new Visuals.Clock();
            pokemon = new Models.Pokemon();
            pokemon.sid = 1;
            pokemon.form = 0;
        }

        // Load your resources here
        function onLayout(dc as Graphics.Dc) as Void {
            setLayout(Rez.Layouts.MainLayout(dc));
        }

        // Called when this View is brought to the foreground. Restore
        // the state of this View and prepare it to be shown. This includes
        // loading resources into memory.
        function onShow() as Void {
            clock.onShow();
            loadSprites();
        }

        // Update the view
        function onUpdate(dc as Graphics.Dc) as Void {
            View.onUpdate(dc);

            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();
            Visuals.drawGrid(dc);
            clock.draw(dc);
            Visuals.drawBulb(dc);

            // if (spriteLeft != null) {
            //     spriteLeft.drawSprite(dc, 68 - 20, 73);
            // }
            // if (spriteRight != null) {
            //     spriteRight.drawSprite(dc, 68 + 20, 73);
            // }
        }

        // Called when this View is removed from the screen. Save the
        // state of this View here. This includes freeing resources from
        // memory.
        function onHide() as Void {
            clock.onHide();
            spriteLeft = null;
            spriteRight = null;
        }
    }
}
