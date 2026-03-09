import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class LocationMenuDelegate extends WatchUi.Menu2InputDelegate {
        var menu as Views.LocationMenu;

        function initialize(menu as Views.LocationMenu) {
            Menu2InputDelegate.initialize();
            self.menu = menu;
        }

        function onSelect(item as WatchUi.MenuItem) as Void {
            if (item.getId() == :location_menu_encounters) {
                menu.submenu = true;
                var delegate = new LocationMenuDelegate(menu);
                WatchUi.pushView(
                    createEncounterMenu(),
                    delegate,
                    WatchUi.SLIDE_UP
                );
            }
        }

        function createEncounterMenu() as WatchUi.Menu2 {
            var encounters =
                menu.encounters.load(menu.location).create() as
                Models.Encounter;
            var next = new WatchUi.Menu2({ :title => "Encounters" });

            for (var i = 0; i < encounters.encounters.size(); i++) {
                var sid = encounters.encounters[i] - 1;
                var name = menu.dexNames.load(sid).string();
                var item = new WatchUi.MenuItem(name, null, name, {});
                next.addItem(item);
            }

            return next;
        }
    }
}
