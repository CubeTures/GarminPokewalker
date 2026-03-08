import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;

module Visuals {
    const weatherIconSize = 42;

    function loadWeatherIcon() as Icon {
        var bitmap =
            WatchUi.loadResource(Rez.Drawables.weather) as Graphics.BitmapType;
        var offset = [0, 0];

        var weather = Utils.getWeatherCondition();
        if (weather == Utils.WEATHER_SUN) {
            offset = [0, 0];
        } else if (weather == Utils.WEATHER_MOON) {
            offset = [weatherIconSize, 0];
        } else if (weather == Utils.WEATHER_CLOUD) {
            offset = [weatherIconSize * 2, 0];
        } else if (weather == Utils.WEATHER_FOG) {
            offset = [weatherIconSize * 3, 0];
        } else if (weather == Utils.WEATHER_HAIL) {
            offset = [weatherIconSize, weatherIconSize];
        } else if (weather == Utils.WEATHER_RAIN) {
            offset = [0, weatherIconSize];
        } else if (weather == Utils.WEATHER_SNOW) {
            offset = [0, weatherIconSize * 2];
        } else if (weather == Utils.WEATHER_TORNADO) {
            offset = [weatherIconSize * 3, weatherIconSize * 2];
        } else if (weather == Utils.WEATHER_THUNDER) {
            offset = [weatherIconSize * 2, weatherIconSize * 2];
        } else if (weather == Utils.WEATHER_WIND) {
            offset = [weatherIconSize, weatherIconSize * 2];
        } else if (weather == Utils.WEATHER_WINTERMIX) {
            offset = [weatherIconSize * 2, weatherIconSize];
        }

        return new Icon(bitmap, weatherIconSize, offset);
    }
}
