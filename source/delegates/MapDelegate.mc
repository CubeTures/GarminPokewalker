import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.System;

module Delegates {
    class MapDelegate extends WatchUi.BehaviorDelegate {
        var view as Views.MapView;

        function initialize(view as Views.MapView) {
            BehaviorDelegate.initialize();
            self.view = view;
        }

        function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Boolean {
            if (keyEvent.getKey() == WatchUi.KEY_UP) {
                view.mapManager.updateLocation(-1);
            } else if (keyEvent.getKey() == WatchUi.KEY_DOWN) {
                view.mapManager.updateLocation(1);
                WatchUi.requestUpdate();
            }

            return true;
        }
    }
}
