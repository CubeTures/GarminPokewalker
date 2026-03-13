import Toybox.Lang;
using Toybox.WatchUi;

module Managers {
    (:initialized)
    var viewDepth as Number = 0;

    function pushView(
        view as WatchUi.Views,
        delegate as WatchUi.InputDelegates?,
        transition as WatchUi.SlideType
    ) as Void {
        viewDepth += 1;
        WatchUi.pushView(view, delegate, transition);
    }

    function popView(transition as WatchUi.SlideType) as Void {
        viewDepth -= 1;
        WatchUi.popView(transition);
    }

    function returnHome() as Void {
        for (var i = 0; i < viewDepth; i++) {
            WatchUi.popView(WatchUi.SLIDE_UP);
        }
        viewDepth = 0;
    }
}
