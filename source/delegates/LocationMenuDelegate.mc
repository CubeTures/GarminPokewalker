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
            if (item.getId() == :location_menu_explore) {
                WatchUi.pushView(
                    new WatchUi.Confirmation("Explore " + menu.name + "?"),
                    new GenericConfirmationDelegate(method(:explore)),
                    WatchUi.SLIDE_UP
                );
            } else if (item.getId() == :location_menu_encounters) {
                var submenu = createEncounterMenu();
                if (submenu != null) {
                    menu.submenu = true;
                    var delegate = new LocationMenuDelegate(menu);
                    Managers.pushView(submenu, delegate, WatchUi.SLIDE_UP);
                }
            }
        }

        function explore() as Void {
            Managers.exploreLocation();
            WatchUi.popView(WatchUi.SLIDE_UP);
            WatchUi.popView(WatchUi.SLIDE_UP);
            WatchUi.popView(WatchUi.SLIDE_UP);
            // Utils.returnHome();
        }

        function createEncounterMenu() as WatchUi.Menu2? {
            var encounters =
                menu.encounters.load(menu.location).create() as
                Models.Encounter;
            if (encounters.encounters.size() == 0) {
                return null;
            }

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
