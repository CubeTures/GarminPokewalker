import Toybox.Lang;
using Toybox.Graphics;

module Visuals {
    const lines = [0, 29, 58, 87, 116, 145, 174] as Array<Number>;

    function drawGrid(dc as Graphics.Dc) as Void {
        for (var i = 0; i < lines.size(); i++) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            dc.drawLine(lines[i], 0, lines[i], 176);
            dc.drawLine(0, lines[i], 176, lines[i]);
        }
    }
}
