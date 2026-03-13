import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

module Views {
    class BattleView extends WatchUi.View {
        private var player as Models.SimpleMon;
        private var opponent as Models.SimpleMon;

        private var option as Number = 0;
        (:initialized)
        var text as Visuals.Marquee;

        function initialize(
            player as Models.SimpleMon,
            opponent as Models.SimpleMon
        ) {
            View.initialize();
            self.player = player;
            self.opponent = opponent;
        }

        function onShow() as Void {
            text = new Visuals.Marquee({
                :color => Graphics.COLOR_WHITE,
                :font => Graphics.FONT_SMALL,
                :locX => 40,
                :locY => 142,
                :width => 96,
                :height => 34,
            });
            updateOption(0);
        }

        function select() as Void {
            var opt = Math.rand() % 3;

            if (option == 0) {
                if (opt == 0) {
                    player.takeDamage();
                    opponent.takeDamage();
                } else if (opt == 1) {
                    player.takeDamage();
                } else {
                    player.takeDamage();
                    opponent.takeDamage();
                    opponent.takeDamage();
                }
            } else if (option == 1) {
                if (opt == 0) {
                    opponent.takeDamage();
                } else if (opt == 1) {
                    // nothing
                } else {
                    onFailure();
                }
            } else {
                if (opponent.tryCatch()) {
                    onCatch();
                } else {
                    onFailure();
                }
            }

            if (opponent.health == 0) {
                onWin();
            }

            System.println(
                "State: " + player.health + " vs " + opponent.health
            );
            WatchUi.requestUpdate();
        }

        function updateOption(offset as Number) as Void {
            option = Utils.wrapIndex(option, offset, 3);

            switch (option) {
                case 0:
                    text.setText("Attack");
                    break;
                case 1:
                    text.setText("Evade");
                    break;
                case 2:
                    text.setText("Catch");
                    break;
            }

            WatchUi.requestUpdate();
        }

        function onUpdate(dc as Graphics.Dc) as Void {
            View.onUpdate(dc);

            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.clear();

            Visuals.subScreen.setIcon(null);
            Visuals.subScreen.draw(dc);

            text.draw(dc);
        }

        function onCatch() as Void {
            text.setText("You caught it!");
        }

        function onWin() as Void {
            text.setText("You killed it?");
        }

        function onFailure() as Void {
            text.setText("It ran away...");
        }

        (:typecheck(false))
        function onHide() as Void {
            text.stop();
            text = null;
        }
    }
}
