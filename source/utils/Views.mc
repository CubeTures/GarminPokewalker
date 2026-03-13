import Toybox.Lang;
using Toybox.WatchUi;

module Utils {
    function popViews(count as Number) as Void {
        for (var i = 0; i < count; i++) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }
}
