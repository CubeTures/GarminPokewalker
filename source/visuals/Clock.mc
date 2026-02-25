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
                :font => Graphics.FONT_XTINY,
                :locX => Constants.POS_3 + Constants.POS_STEP / 3,
                :locY => Constants.POS_0 + Constants.POS_STEP / 4,
                :justification => Graphics.TEXT_JUSTIFY_RIGHT,
            });
            clock = new WatchUi.Text({
                :color => Graphics.COLOR_WHITE,
                :font => Graphics.FONT_NUMBER_THAI_HOT,
                :locX => Constants.POS_3 + Constants.POS_STEP / 3,
                :locY => Constants.POS_1 - Constants.POS_STEP / 4,
                :justification => Graphics.TEXT_JUSTIFY_RIGHT,
            });
        }

        function draw(dc as Graphics.Dc) as Void {
            if (clock != null) {
                var time = System.getClockTime();
                clock.setText((time.hour % 12) + ":" + time.min);
                clock.draw(dc);
            }
            if (date != null) {
                var today = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
                date.setText(
                    Lang.format("$1$ $2$", [today.day_of_week, today.day])
                );
                date.draw(dc);
            }
        }

        function onHide() as Void {
            clock = null;
        }
    }
}
