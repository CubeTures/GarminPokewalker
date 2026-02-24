import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class HomeDelegate extends WatchUi.BehaviorDelegate {
        function initialize() {
            BehaviorDelegate.initialize();
        }

        function onMenu() as Boolean {
            WatchUi.pushView(
                new Rez.Menus.MainMenu(),
                new Delegates.MainMenuDelegate(),
                WatchUi.SLIDE_UP
            );
            return true;
        }
    }
}
