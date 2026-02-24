import Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;

module Delegates {
    class MainMenuDelegate extends WatchUi.MenuInputDelegate {
        function initialize() {
            MenuInputDelegate.initialize();
        }

        function onMenuItem(item as Symbol) as Void {
            if (item == :item_1) {
                System.println("item 1");
            } else if (item == :item_2) {
                System.println("item 2");
            }
        }
    }
}
