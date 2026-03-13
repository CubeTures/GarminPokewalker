import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class HomeDelegate extends KeyDelegate {
        var view as Views.HomeView;

        function initialize(view as Views.HomeView) {
            KeyDelegate.initialize();
            self.view = view;
        }

        function onMenu() as Boolean {
            Managers.pushView(
                new Rez.Menus.MainMenu(),
                new Delegates.MainMenuDelegate(),
                WatchUi.SLIDE_UP
            );

            return true;
        }

        function onUp() as Boolean {
            view.pokemon.sid--;
            if (view.pokemon.sid < 0) {
                view.pokemon.sid = 806;
            }
            view.loadSprites();
            WatchUi.requestUpdate();
            return true;
        }

        function onDown() as Boolean {
            view.pokemon.sid++;
            if (view.pokemon.sid > 806) {
                view.pokemon.sid = 0;
            }
            view.loadSprites();
            WatchUi.requestUpdate();
            return true;
        }
    }
}
