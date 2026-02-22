using Toybox.System;

(:background)
class risumonServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() as Void {
        // do stuff
    }
}
