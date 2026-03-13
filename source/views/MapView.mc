import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.StringUtil;

module Views {
    class MapView extends WatchUi.View {
        (:initialized)
        var mapManager as Managers.MapManager;
        (:initialized)
        var text as Visuals.Marquee;

        function initialize() {
            View.initialize();
        }

        function onShow() {
            View.onShow();
            mapManager = new Managers.MapManager();
            text = new Visuals.Marquee({
                :color => Graphics.COLOR_WHITE,
                :font => Graphics.FONT_SMALL,
                :locX => 40,
                :locY => 142,
                :width => 96,
                :height => 34,
            });
        }

        function onUpdate(dc as Graphics.Dc) as Void {
            View.onUpdate(dc);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();
            mapManager.draw(dc);
            Visuals.subScreen.draw(dc);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillRectangle(0, 142, 176, 34);
            text.setText(mapManager.getName());
            text.draw(dc);
        }

        (:typecheck(false))
        function onHide() {
            View.onHide();
            mapManager = null;
            WatchUi.cancelAllAnimations();
            text = null;
        }
    }
}
