import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.StringUtil;
using Toybox.System;

module Views {
    class MapView extends WatchUi.View {
        (:initialized)
        var mapManager as Managers.MapManager;
        (:initialized)
        var text as WatchUi.Text;

        function initialize() {
            View.initialize();
        }

        function onShow() {
            View.onShow();
            mapManager = new Managers.MapManager();
            text = new WatchUi.Text({
                :color => Graphics.COLOR_WHITE,
                :justification => Graphics.TEXT_JUSTIFY_CENTER,
                :font => Graphics.FONT_SMALL,
                :locX => Constants.POS_2 + 28,
                :locY => 146,
            });
        }

        function onUpdate(dc as Graphics.Dc) as Void {
            View.onUpdate(dc);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();
            mapManager.draw(dc);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillRectangle(0, 141, 176, 35);
            text.setText(mapManager.locationName);
            text.draw(dc);
        }

        (:typecheck(false))
        function onHide() {
            View.onHide();
            mapManager = null;
            text = null;
        }
    }
}
