import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class MainMenuDelegate extends WatchUi.MenuInputDelegate {
        function initialize() {
            MenuInputDelegate.initialize();
        }

        function onMenuItem(item as Symbol) as Void {
            if (item == :menu_map) {
                var view = new Views.MapView();
                var delegate = new Delegates.MapDelegate(view);
                WatchUi.pushView(view, delegate, WatchUi.SLIDE_UP);
            }
        }
    }
}
