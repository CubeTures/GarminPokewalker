import Toybox.Lang;
using Toybox.Graphics;
using Toybox.StringUtil;

module Managers {
    class MapManager {
        var mapBitmap as Graphics.BitmapType;
        var locationNames as ByteArray;
        var mapLocations as ByteArray;
        var locationIndex as Number = 0;
        var location as Models.MapLocation;
        var locationName as String;

        function initialize() {
            mapBitmap =
                WatchUi.loadResource(Rez.Drawables.map) as Graphics.BitmapType;
            locationNames = Utils.loadByteArray(Rez.Strings.locationNames_0);
            locationName = Utils.getNthString(locationNames, locationIndex);
            mapLocations = Utils.loadByteArray(Rez.Strings.mapCoordinates_0);
            location = new Models.MapLocation(mapLocations, locationIndex);
        }

        function updateLocation(offset as Number) as Void {
            locationIndex += offset;
            while (locationIndex < 0) {
                locationIndex += mapLocations.size();
            }
            while (locationIndex >= mapLocations.size()) {
                locationIndex -= mapLocations.size();
            }

            locationName = Utils.getNthString(locationNames, locationIndex);
            location = new Models.MapLocation(mapLocations, locationIndex);
            WatchUi.requestUpdate();
        }

        function draw(dc as Graphics.Dc) as Void {
            dc.drawBitmap(88 - location.x, 88 - location.y, mapBitmap);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            dc.fillCircle(88, 88, 6);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillCircle(88, 88, 4);
        }
    }
}
