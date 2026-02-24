import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;

module Views {
    class HomeView extends WatchUi.View {
        var sprite as Resources.Sprite?;
        var reflect as Graphics.AffineTransform;

        function initialize() {
            View.initialize();

            reflect = new Graphics.AffineTransform();
            reflect.scale(-1.0, 1.0);
        }

        // Load your resources here
        function onLayout(dc as Graphics.Dc) as Void {
            setLayout(Rez.Layouts.MainLayout(dc));
        }

        // Called when this View is brought to the foreground. Restore
        // the state of this View and prepare it to be shown. This includes
        // loading resources into memory.
        function onShow() as Void {
            var p = new Models.Pokemon();
            p.sid = 422;
            p.form = 0;
            sprite = new Resources.Sprite(p);
        }

        // Update the view
        function onUpdate(dc as Graphics.Dc) as Void {
            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
            if (sprite != null) {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
                dc.clear();
                sprite.drawSprite(dc, true, 68, 73);
                if (sprite != null) {
                    sprite.drawSprite(dc, false, 68, 73);
                }
            }

            // [(-1 0) (0 1)] to reflect over y
        }

        // Called when this View is removed from the screen. Save the
        // state of this View here. This includes freeing resources from
        // memory.
        function onHide() as Void {
            sprite = null;
        }
    }
}
