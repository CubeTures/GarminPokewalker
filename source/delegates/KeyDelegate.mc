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
                    return up();
                case WatchUi.KEY_DOWN:
                    return down();
                default:
                    return false;
            }
        }

        function up() as Boolean {
            return false;
        }

        function down() as Boolean {
            return false;
        }
    }
}
