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
            } else if (item.getId() == :main_menu_search) {
                var player = new Models.SimpleMon(0);
                var opponent = new Models.SimpleMon(3);
                var view = new Views.BattleView(player, opponent);
                var delegate = new Delegates.BattleDelegate(view);
                WatchUi.pushView(view, delegate, WatchUi.SLIDE_UP);   
            }
        }
    }
}
