import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Weather;

module Visuals {
    (:initialized)
    var subScreen as Visuals.SubScreen;

    class SubScreen {
        private var x as Number = 144;
        private var y as Number = 32;
        private var r as Number = 31;
        private var icon as Icon?;

        function initialize() {
            computeDimensions();
        }

        function computeDimensions() as Void {
            var box = WatchUi.getSubscreen();
            if (box != null) {
                if (box.x != null) {
                    var x = box.x as Number;
                    self.x = x + box.width / 2;
                }
                if (box.y != null) {
                    var y = box.y as Number;
                    self.y = y + box.height / 2;
                }
                r = box.width / 2;
            }
        }

        function draw(dc as Graphics.Dc) as Void {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            dc.fillCircle(x, y, r);

            if (icon != null) {
                icon.draw(dc, x, y);
            }
        }

        function setIcon(icon as Icon) as Void {
            self.icon = icon;
        }
    }
}
