import Toybox.Lang;
using Toybox.WatchUi;

module Delegates {
    class GenericConfirmationDelegate extends WatchUi.ConfirmationDelegate {
        typedef Confirm as (Method());
        var callback as Confirm;

        function initialize(callback as Confirm) {
            ConfirmationDelegate.initialize();
            self.callback = callback;
        }

        function onResponse(response as WatchUi.Confirm) as Boolean {
            callback.invoke();
            return true;
        }
    }
}
