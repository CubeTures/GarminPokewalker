import Toybox.Lang;
using Toybox.Graphics;

module Managers {
    class MapManager {
        private enum MapState {
            MAP_STATE_CONTINENT,
            MAP_STATE_LOCATION,
        }

        private var state as MapState = MAP_STATE_CONTINENT;
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
        }

        function update(offset as Number) as Void {
            maps[state].update(offset);
            WatchUi.requestUpdate();
        }

        function select() as Boolean {
            if (state == MAP_STATE_CONTINENT) {
                state = MAP_STATE_LOCATION;
                maps[1].bounds = getLocationIndexBounds(maps[0].index);
                maps[1].update(maps[1].bounds[0] - maps[1].index);
                WatchUi.requestUpdate();
                return true;
            } else if (state == MAP_STATE_LOCATION) {
                // TODO push view
                // display location data
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
            if (state == MAP_STATE_LOCATION) {
                state = MAP_STATE_CONTINENT;
                WatchUi.requestUpdate();
                return true;
            }

            return false;
        }

        function getName() as String {
            return maps[state].name;
        }

        function draw(dc as Graphics.Dc) as Void {
            maps[state].draw(dc);
        }
    }
}
