import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;

module Views {
    class LocationMenu extends WatchUi.Menu2 {
        var name as String;
        var location as Number;
        var submenu as Boolean = false;
        (:initialized)
        var encounters as CSV;
        (:initialized)
        var dexNames as CSV;

        function initialize(name as String, location as Number) {
            Menu2.initialize({ :title => name, :footer => "Test Footer" });
            Menu2.addItem(
                new WatchUi.MenuItem(
                    "Explore",
                    null,
                    :location_menu_explore,
                    {}
                )
            );
            self.name = name;
            self.location = location;
        }

        function onShow() as Void {
            if (!submenu) {
                encounters = new CSV(:loadEncounters, :newEncounter);
                dexNames = new CSV(:loadDexNames, null);

                var table =
                    encounters.load(location).create() as Models.Encounter;
                var subtext = Utils.pluralize(
                    table.encounters.size(),
                    "encounter",
                    "encounters"
                );
                Menu2.addItem(
                    new WatchUi.MenuItem(
                        "Encounters",
                        subtext,
                        :location_menu_encounters,
                        {}
                    )
                );
            } else {
                submenu = false;
            }
        }

        function onUpdate(dc as Graphics.Dc) as Void {
            Menu2.onUpdate(dc);
        }

        (:typecheck(false))
        function onHide() as Void {
            if (!submenu) {
                encounters = null;
                dexNames = null;

                Menu2.deleteItem(Menu2.findItemById(:location_menu_encounters));
            }
        }
    }
}
