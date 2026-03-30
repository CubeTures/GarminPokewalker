import Toybox.Lang;
using Toybox.Graphics;

module Visuals {
    function drawTextBox(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 142, 176, 34);
    }
}
