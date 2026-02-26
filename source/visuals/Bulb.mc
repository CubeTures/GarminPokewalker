import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;

module Visuals {
    const bulbCenterX = 144;
    const bulbCenterY = 32;
    const bulbRadius = 31;
    const bulbOuterRadius = 41;

    var condition as Number = 0;

    function drawBulb(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillCircle(bulbCenterX, bulbCenterY, bulbOuterRadius);

        var icons =
            WatchUi.loadResource(Rez.Drawables.weather) as Graphics.BitmapType;

        var offsetX = (condition % 4) * 42;
        var offsetY = (condition % 3) * 42;
        dc.setClip(bulbCenterX - 21, bulbCenterY - 21, 42, 42);
        dc.drawBitmap(bulbCenterX - 21 - offsetX, bulbCenterY - 21 - offsetY, icons);
        dc.clearClip();
    }
}
