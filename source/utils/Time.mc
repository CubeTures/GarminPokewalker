import Toybox.Lang;
using Toybox.Time;
using Toybox.Position;
using Toybox.Weather;
using Toybox.System;

module Utils {
    function isDay() as Boolean {
        var info = Position.getInfo();
        var pos = info.position;

        if (pos != null) {
            var now = Time.now();
            var sunrise = Weather.getSunrise(pos, now);
            var sunset = Weather.getSunset(pos, now);

            if (sunrise != null && sunset != null) {
                return sunrise.lessThan(now) && !now.greaterThan(sunset);
            }
        }

        var time = System.getClockTime();
        return 6 < time.hour && time.hour <= 18;
    }
}
