import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;

module AppHome {
    class HomeView extends WatchUi.View {
        function initialize() {
            View.initialize();
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
            loadSprites();
        }

        // Update the view
        function onUpdate(dc as Graphics.Dc) as Void {
            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
            if (spriteLeft != null && spriteRight != null) {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
                dc.clear();
                spriteLeft.drawSprite(dc, 68 - 20, 73);
                (spriteRight as Resources.Sprite).drawSprite(dc, 68 + 20, 73);
            }
        }

        // Called when this View is removed from the screen. Save the
        // state of this View here. This includes freeing resources from
        // memory.
        function onHide() as Void {
            spriteLeft = null;
            spriteRight = null;
        }
    }
}
