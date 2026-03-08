import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Timer;

module Visuals {
    class FrameClock {
        var timer as Timer.Timer;

        function initialize(fps as Number) {
            timer = new Timer.Timer();
            timer.start(method(:onTimer), 1000 / fps, true);
        }

        function onTimer() as Void {
            WatchUi.requestUpdate();
        }

        //! Call stop before cleaning up this class
        //! unless you want a memory leak.
        function stop() as Void {
            timer.stop();
        }
    }
}
