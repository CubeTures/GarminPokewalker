import Toybox.Lang;
using Toybox.Graphics;

module Managers {
    var mapState as MapManager.MapState = MapManager.MAP_STATE_CONTINENT;
    var continent as Number = -1;
    var location as Number = -1;

    function exploreLocation() as Void {
        mapState = MapManager.MAP_STATE_CONTINENT;
        Game.state.setContinent(continent);
        Game.state.setLocation(location);
    }

    class MapManager {
        enum MapState {
            MAP_STATE_CONTINENT,
            MAP_STATE_LOCATION,
        }

        private var maps as [Game.MapState, Game.MapState];

        function initialize() {
            var continents = new Game.MapState(
                Rez.Drawables.map_sm,
                :loadContinentNames,
                :loadContinentCoords,
                :newContinent,
                Generated.numContinentCoords
            );
            var locations = new Game.MapState(
                Rez.Drawables.map,
                :loadLocationNames,
                :loadLocationCoords,
                :newLocation,
                Generated.numLocationCoords
            );
            maps = [continents, locations];

            if (continent == -1) {
                continent = Game.state.getContinent();
            }
            if (location == -1) {
                location = Game.state.getLocation();
            }
            maps[0].update(continent - maps[0].index);
            maps[1].update(location - maps[1].index);
        }

        function update(offset as Number) as Void {
            maps[mapState].update(offset);
            WatchUi.requestUpdate();
        }

        function select() as Boolean {
            if (mapState == MAP_STATE_CONTINENT) {
                mapState = MAP_STATE_LOCATION;
                if (maps[0].index != continent) {
                    maps[1].bounds = getLocationIndexBounds(maps[0].index);
                    maps[1].update(maps[1].bounds[0] - maps[1].index);
                    continent = maps[0].index;
                    location = maps[1].index;
                }
                if (maps[0].index == Game.state.getContinent()) {
                    maps[1].update(maps[1].index - Game.state.getLocation());
                }
                WatchUi.requestUpdate();
                return true;
            } else if (mapState == MAP_STATE_LOCATION) {
                location = maps[1].index;
                var menu = new Views.LocationMenu(getName(), maps[1].index);
                var delegate = new Delegates.LocationMenuDelegate(menu);
                Managers.pushView(menu, delegate, WatchUi.SLIDE_UP);
                return true;
            }

            return false;
        }

        private function getLocationIndexBounds(
            continent as Number
        ) as [Number, Number] {
            var floor = -1;
            var ceil = -1;

            for (var i = 0; i < Generated.numLocationCoords; i++) {
                var loc = maps[1].coords.load(i).create() as Models.Location;
                if (loc.continent == continent) {
                    if (floor == -1) {
                        floor = loc.location;
                    }
                    ceil = loc.location;
                }
            }

            return [floor, ceil];
        }

        function back() as Boolean {
            if (mapState == MAP_STATE_LOCATION) {
                mapState = MAP_STATE_CONTINENT;
                WatchUi.requestUpdate();
                return true;
            }

            return false;
        }

        function getName() as String {
            return maps[mapState].name;
        }

        function draw(dc as Graphics.Dc) as Void {
            maps[mapState].draw(dc);
        }
    }
}
