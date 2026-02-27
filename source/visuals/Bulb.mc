import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Weather;

module Visuals {
    const bulbCenterX = 144;
    const bulbCenterY = 32;
    const bulbRadius = 31;
    const bulbOuterRadius = 41;
    const weatherIconSize = 42;
    var bulbIconBitmap as Graphics.BitmapType?;
    var bulbIconOffset as [Number, Number]?;

    function drawBulb(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillCircle(bulbCenterX, bulbCenterY, bulbOuterRadius);
    }

    function drawWeather(dc as Graphics.Dc) as Void {
        if (bulbIconBitmap == null || bulbIconOffset == null) {
            return;
        }

        dc.setClip(
            bulbCenterX - weatherIconSize / 2,
            bulbCenterY - weatherIconSize / 2,
            weatherIconSize,
            weatherIconSize
        );
        dc.drawBitmap(
            bulbCenterX - weatherIconSize / 2 - bulbIconOffset[0],
            bulbCenterY - weatherIconSize / 2 - bulbIconOffset[1],
            bulbIconBitmap
        );
        dc.clearClip();
    }

    function loadWeatherIcon() as Void {
        bulbIconBitmap =
            WatchUi.loadResource(Rez.Drawables.weather) as Graphics.BitmapType;

        var weather = Utils.getWeatherCondition();
        if (weather == Utils.WEATHER_SUN) {
            bulbIconOffset = [0, 0];
        } else if (weather == Utils.WEATHER_MOON) {
            bulbIconOffset = [weatherIconSize, 0];
        } else if (weather == Utils.WEATHER_CLOUD) {
            bulbIconOffset = [weatherIconSize * 2, 0];
        } else if (weather == Utils.WEATHER_FOG) {
            bulbIconOffset = [weatherIconSize * 3, 0];
        } else if (weather == Utils.WEATHER_HAIL) {
            bulbIconOffset = [weatherIconSize, weatherIconSize];
        } else if (weather == Utils.WEATHER_RAIN) {
            bulbIconOffset = [0, weatherIconSize];
        } else if (weather == Utils.WEATHER_SNOW) {
            bulbIconOffset = [0, weatherIconSize * 2];
        } else if (weather == Utils.WEATHER_TORNADO) {
            bulbIconOffset = [weatherIconSize * 3, weatherIconSize * 2];
        } else if (weather == Utils.WEATHER_THUNDER) {
            bulbIconOffset = [weatherIconSize * 2, weatherIconSize * 2];
        } else if (weather == Utils.WEATHER_WIND) {
            bulbIconOffset = [weatherIconSize, weatherIconSize * 2];
        } else if (weather == Utils.WEATHER_WINTERMIX) {
            bulbIconOffset = [weatherIconSize * 2, weatherIconSize];
        }
    }
}
