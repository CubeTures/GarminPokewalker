import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
        function initialize() {
            Menu2InputDelegate.initialize();
        }

        function onSelect(item as WatchUi.MenuItem) as Void {
            if (item.getId() == :main_menu_map) {
                var view = new Views.MapView();
                var delegate = new Delegates.MapDelegate(view);
                WatchUi.pushView(view, delegate, WatchUi.SLIDE_UP);
            }
        }
    }
}
