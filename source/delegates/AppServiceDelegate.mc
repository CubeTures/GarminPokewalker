module Delegates {
    (:background)
    class AppServiceDelegate extends $.Toybox.System.ServiceDelegate {
        function initialize() {
            ServiceDelegate.initialize();
        }

        function onTemporalEvent() as Void {
            // do stuff
        }
    }
}
