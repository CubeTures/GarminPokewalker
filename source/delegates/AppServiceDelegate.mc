using Toybox.System;

module Delegates {
    (:background)
    class AppServiceDelegate extends System.ServiceDelegate {
        function initialize() {
            ServiceDelegate.initialize();
        }

        function onTemporalEvent() as Void {
            // do stuff
        }
    }
}
