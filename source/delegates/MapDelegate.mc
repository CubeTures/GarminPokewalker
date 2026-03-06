import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class MapDelegate extends WatchUi.BehaviorDelegate {
        var view as Views.MapView;

        function initialize(view as Views.MapView) {
            BehaviorDelegate.initialize();
            self.view = view;
        }

        function onPreviousPage() as Boolean {
            view.mapManager.update(-1);
            WatchUi.requestUpdate();
            return true;
        }

        function onNextPage() as Boolean {
            view.mapManager.update(1);
            WatchUi.requestUpdate();
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
