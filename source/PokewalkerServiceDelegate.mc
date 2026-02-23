using Toybox.System;

(:background)
class PokewalkerServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() as Void {
        // do stuff
    }
}
