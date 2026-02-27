import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.System;

module Delegates {
    class HomeDelegate extends WatchUi.BehaviorDelegate {
        var view as Views.HomeView;

        function initialize(view as Views.HomeView) {
            BehaviorDelegate.initialize();
            self.view = view;
        }

        function onMenu() as Boolean {
            WatchUi.pushView(
                new Rez.Menus.MainMenu(),
                new Delegates.MainMenuDelegate(),
                WatchUi.SLIDE_UP
            );

            return true;
        }

        function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Boolean {
            if (keyEvent.getKey() == WatchUi.KEY_UP) {
                view.pokemon.sid--;
                if (view.pokemon.sid < 0) {
                    view.pokemon.sid = 806;
                }
                view.loadSprites();
                WatchUi.requestUpdate();
            }
            if (keyEvent.getKey() == WatchUi.KEY_DOWN) {
                view.pokemon.sid++;
                if (view.pokemon.sid > 806) {
                    view.pokemon.sid = 0;
                }
                view.loadSprites();
                WatchUi.requestUpdate();
            }

            return true;
        }
    }
}
