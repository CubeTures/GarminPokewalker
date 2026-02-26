import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.System;

module AppHome {
    (:initialized)
    var pokemon as Models.Pokemon;
    var spriteLeft as Resources.Sprite?;
    var spriteRight as Resources.Sprite?;

    function loadSprites() as Void {
        System.println("Loading sprite for sid " + pokemon.sid);
        spriteLeft = new Resources.Sprite(pokemon, false);
        spriteRight = new Resources.Sprite(pokemon, true);
    }

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

        function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Boolean {
            if (keyEvent.getKey() == WatchUi.KEY_UP) {
                Visuals.condition--;
                pokemon.sid--;
                if (pokemon.sid <= 0) {
                    pokemon.sid = 807;
                }
                loadSprites();
                WatchUi.requestUpdate();
            }
            if (keyEvent.getKey() == WatchUi.KEY_DOWN) {
                Visuals.condition++;
                pokemon.sid++;
                if (pokemon.sid >= 808) {
                    pokemon.sid = 1;
                }
                loadSprites();
                WatchUi.requestUpdate();
            }
            return true;
        }
    }
}
