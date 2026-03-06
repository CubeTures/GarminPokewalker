import Toybox.Lang;
using Toybox.Graphics;
using Toybox.StringUtil;

module Managers {
    class MapManager {
        private enum MapState {
            MAP_STATE_CONTINENT,
            MAP_STATE_LOCATION,
        }

        private var state as MapState = MAP_STATE_CONTINENT;

        private var mapSmBitmap as Graphics.BitmapType;
        private var continentNames as ByteArray;
        private var continentIndex as Number = 0;
        private var continentName as String;
        private var continentCoords as ByteArray;
        private var continent as Models.Continent;

        private var locationNames as ByteArray;
        private var mapBitmap as Graphics.BitmapType;
        private var locationIndex as Number = 0;
        private var locationName as String;
        private var locationCoords as ByteArray;
        private var location as Models.Location;

        (:initialized)
        private var locationIndexBounds as [Number, Number];

        function initialize() {
            mapSmBitmap =
                WatchUi.loadResource(Rez.Drawables.map_sm) as
                Graphics.BitmapType;
            continentNames = Utils.loadByteArray(Rez.Strings.continent_names_0);
            continentName = Utils.getNthString(continentNames, continentIndex);
            continentCoords = Utils.loadByteArray(
                Rez.Strings.continent_coords_0
            );
            continent = new Models.Continent(continentCoords, continentIndex);

            mapBitmap =
                WatchUi.loadResource(Rez.Drawables.map) as Graphics.BitmapType;
            locationNames = Utils.loadByteArray(Rez.Strings.location_names_0);
            locationName = Utils.getNthString(locationNames, locationIndex);
            locationCoords = Utils.loadByteArray(Rez.Strings.location_coords_0);
            location = new Models.Location(locationCoords, locationIndex);
        }

        function update(offset as Number) as Void {
            if (state == MAP_STATE_CONTINENT) {
                updateContinent(offset);
            } else if (state == MAP_STATE_LOCATION) {
                updateLocation(offset);
            }
        }

        private function updateContinent(offset as Number) as Void {
            continentIndex = Utils.wrapIndex(
                continentIndex,
                offset,
                Generated.numContinentCoords
            );
            continentName = Utils.getNthString(continentNames, continentIndex);
            continent = new Models.Continent(continentCoords, continentIndex);
            WatchUi.requestUpdate();
        }

        private function updateLocation(offset as Number) as Void {
            locationIndex = Utils.wrapIndexFull(
                locationIndex,
                offset,
                locationIndexBounds[0],
                locationIndexBounds[1]
            );
            locationName = Utils.getNthString(locationNames, locationIndex);
            location = new Models.Location(locationCoords, locationIndex);
            WatchUi.requestUpdate();
        }

        function select() as Boolean {
            if (state == MAP_STATE_CONTINENT) {
                state = MAP_STATE_LOCATION;
                locationIndexBounds = getLocationIndexBounds(continentIndex);
                updateLocation(locationIndexBounds[0] - locationIndex);
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
                var loc = new Models.Location(locationCoords, i);
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
            if (state == MAP_STATE_CONTINENT) {
                return continentName;
            } else if (state == MAP_STATE_LOCATION) {
                return locationName;
            } else {
                return K.STRING_UNK;
            }
        }

        function draw(dc as Graphics.Dc) as Void {
            if (state == MAP_STATE_CONTINENT) {
                dc.drawBitmap(
                    K.POS_CENTER - continent.x,
                    K.POS_CENTER - continent.y,
                    mapSmBitmap
                );
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
                dc.fillCircle(K.POS_CENTER, K.POS_CENTER, 6);
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
                dc.fillCircle(K.POS_CENTER, K.POS_CENTER, 4);
            } else if (state == MAP_STATE_LOCATION) {
                dc.drawBitmap(
                    K.POS_CENTER - location.x,
                    K.POS_CENTER - location.y,
                    mapBitmap
                );
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
                dc.fillCircle(K.POS_CENTER, K.POS_CENTER, 6);
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
                dc.fillCircle(K.POS_CENTER, K.POS_CENTER, 4);
            }
        }
    }
}
