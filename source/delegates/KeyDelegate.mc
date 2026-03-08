import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class KeyDelegate extends WatchUi.BehaviorDelegate {
        function initialize() {
            BehaviorDelegate.initialize();
        }

        function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Boolean {
            switch (keyEvent.getKey()) {
                case WatchUi.KEY_UP:
                    return onUp();
                case WatchUi.KEY_DOWN:
                    return onDown();
                default:
                    return false;
            }
        }

        function onUp() as Boolean {
            return false;
        }

        function onDown() as Boolean {
            return false;
        }
    }
}
