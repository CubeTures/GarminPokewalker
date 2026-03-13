import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class BattleDelegate extends KeyDelegate {
        private var view as Views.BattleView;

        function initialize(view as Views.BattleView) {
            KeyDelegate.initialize();
            self.view = view;
        }

        function onUp() as Boolean {
            view.updateOption(-1);
            return true;
        }

        function onDown() as Boolean {
            view.updateOption(1);
            return true;
        }

        function onSelect() as Boolean {
            view.select();
            return true;
        }
    }
}
