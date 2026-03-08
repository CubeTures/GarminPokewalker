import Toybox.Lang;
using Toybox.Graphics;
using Toybox.System;

module Game {
    class MapState {
        typedef Coord as interface {
            var x as Number;
            var y as Number;
        };

        var map as Graphics.BitmapType;
        var index as Number = 0;
        var names as CSV;
        var name as String;
        var coords as CSV;
        var coord as Coord;

        var bounds as [Number, Number] = [0, 0];

        function initialize(
            mapRez as ResourceId,
            namesSym as Symbol,
            coordsSym as Symbol,
            factorySym as Symbol,
            bound as Number
        ) {
            map = WatchUi.loadResource(mapRez) as Graphics.BitmapType;
            names = new CSV(namesSym, null);
            name = names.load(index).string();
            coords = new CSV(coordsSym, factorySym);
            coord = coords.load(index).create() as Coord;
            bounds[1] = bound;
        }

        function update(offset as Number) as Void {
            index = Utils.wrapIndexFull(index, offset, bounds[0], bounds[1]);
            name = names.load(index).string();
            coord = coords.load(index).create() as Coord;
        }

        function draw(dc as Graphics.Dc) as Void {
            dc.drawBitmap(K.POS_CENTER - coord.x, K.POS_CENTER - coord.y, map);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            dc.fillCircle(K.POS_CENTER, K.POS_CENTER, 6);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillCircle(K.POS_CENTER, K.POS_CENTER, 4);
        }
    }
}
