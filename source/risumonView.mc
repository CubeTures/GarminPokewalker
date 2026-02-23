import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class risumonView extends WatchUi.View {
    var hamster as Graphics.BitmapType?;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        hamster = WatchUi.loadResource(Rez.Drawables.sprites_1) as BitmapType;
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        if (hamster != null) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            dc.clear();
            dc.setClip(73, 68, 40, 30);
            dc.drawBitmap(73 - 80, 68 - 0, hamster);
            dc.clearClip();
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        hamster = null;
    }

    function drawRleSprite(
        bufferDc as Graphics.Dc,
        rleBytes as ByteArray
    ) as Void {
        var x = 0;
        var y = 0;
        var byteCount = rleBytes.size();

        for (var i = 0; i < byteCount; i++) {
            var byte = rleBytes[i];

            // Extract the Top 2 bits for color (0x03 is binary 00000011)
            var colorCode = (byte >> 6) & 0x03;

            // Extract the Bottom 6 bits for length (0x3F is binary 00111111)
            var runLen = byte & 0x3f;

            // Only draw if it's NOT transparent
            if (colorCode != 0) {
                if (colorCode == 1) {
                    bufferDc.setColor(
                        Graphics.COLOR_WHITE,
                        Graphics.COLOR_TRANSPARENT
                    );
                } else {
                    // colorCode == 2
                    bufferDc.setColor(
                        Graphics.COLOR_BLACK,
                        Graphics.COLOR_TRANSPARENT
                    );
                }

                // Draw a single horizontal line for this run
                bufferDc.drawLine(x, y, x + runLen - 1, y);
            }

            x += runLen;
            if (x >= 40) {
                x = 0;
                y++;
            }
        }
    }
}
