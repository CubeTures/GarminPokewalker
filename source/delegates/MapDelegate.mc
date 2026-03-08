import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class MapDelegate extends KeyDelegate {
        var view as Views.MapView;

        function initialize(view as Views.MapView) {
            KeyDelegate.initialize();
            self.view = view;
        }

        function up() as Boolean {
            view.mapManager.update(-1);
            return true;
        }

        function down() as Boolean {
            view.mapManager.update(1);
            return true;
        }

        function onSelect() as Boolean {
            return view.mapManager.select();
        }

        function onBack() as Boolean {
            return view.mapManager.back();
        }
    }
}
