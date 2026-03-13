import Toybox.Lang;
using Toybox.WatchUi;

module Utils {
    function returnHome() as Void {
        var view = new Views.HomeView();
        var delegate = new Delegates.HomeDelegate(view);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_UP);
    }
}
