import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Time.Gregorian as Calendar;

module Visuals {
    class Clock {
        var date as WatchUi.Text?;
        var clock as WatchUi.Text?;

        function onShow() as Void {
            date = new WatchUi.Text({
                :color => Graphics.COLOR_WHITE,
                :font => Graphics.FONT_MEDIUM,
                :locX => K.POS_3 + K.POS_STEP / 3,
                :locY => K.POS_0,
                :justification => Graphics.TEXT_JUSTIFY_RIGHT,
            });
            clock = new WatchUi.Text({
                :color => Graphics.COLOR_WHITE,
                :font => Graphics.FONT_NUMBER_THAI_HOT,
                :locX => K.POS_3 + K.POS_STEP / 3,
                :locY => K.POS_1 - K.POS_STEP / 3,
                :justification => Graphics.TEXT_JUSTIFY_RIGHT,
            });
        }

        function draw(dc as Graphics.Dc) as Void {
            if (clock != null) {
                var time = System.getClockTime();
                var min = time.min;
                var minStr = min.toString();
                if (min < 10) {
                    minStr = "0" + minStr;
                }
                clock.setText((time.hour % 12) + ":" + minStr);
                clock.draw(dc);
            }
            if (date != null) {
                var today = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
                date.setText(
                    Lang.format("$1$ $2$", [
                        today.day_of_week,
                        today.day,
                    ]).toUpper()
                );
                date.draw(dc);
            }
        }

        function onHide() as Void {
            clock = null;
        }
    }
}
