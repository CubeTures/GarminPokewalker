import Toybox.Lang;
using Toybox.Graphics;

module Visuals {
    class Icon {
        var bitmap as Graphics.BitmapType;
        var size as Number;
        var offset as [Number, Number];

        function initialize(
            bitmap as Graphics.BitmapType,
            size as Number,
            offset as [Number, Number]
        ) {
            self.bitmap = bitmap;
            self.size = size;
            self.offset = offset;
        }

        function draw(dc as Graphics.Dc, x as Number, y as Number) as Void {
            dc.setClip(x - size / 2, y - size / 2, size, size);
            dc.drawBitmap(
                x - size / 2 - offset[0],
                y - size / 2 - offset[1],
                bitmap
            );
            dc.clearClip();
        }
    }
}
