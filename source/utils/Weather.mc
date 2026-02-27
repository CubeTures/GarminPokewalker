import Toybox.Lang;
using Toybox.Weather;

module Utils {
    enum WeatherCondition {
        WEATHER_SUN,
        WEATHER_MOON,
        WEATHER_CLOUD,
        WEATHER_FOG,
        WEATHER_HAIL,
        WEATHER_RAIN,
        WEATHER_SNOW,
        WEATHER_TORNADO,
        WEATHER_THUNDER,
        WEATHER_WIND,
        WEATHER_WINTERMIX,
    }

    function getWeatherCondition() as WeatherCondition {
        var condition = Weather.getCurrentConditions();
        var timeBased = Utils.isDay() ? WEATHER_SUN : WEATHER_MOON;

        if (condition == null) {
            return timeBased;
        }

        switch (condition) {
            case Weather.CONDITION_FAIR:
            case Weather.CONDITION_CLEAR:
            case Weather.CONDITION_MOSTLY_CLEAR:
            case Weather.CONDITION_PARTLY_CLEAR:
                return timeBased;
            case Weather.CONDITION_CLOUDY:
            case Weather.CONDITION_MOSTLY_CLOUDY:
            case Weather.CONDITION_PARTLY_CLOUDY:
            case Weather.CONDITION_THIN_CLOUDS:
                return WEATHER_CLOUD;
            case Weather.CONDITION_FOG:
            case Weather.CONDITION_MIST:
            case Weather.CONDITION_SMOKE:
            case Weather.CONDITION_HAZY:
            case Weather.CONDITION_HAZE:
            case Weather.CONDITION_DUST:
            case Weather.CONDITION_SAND:
            case Weather.CONDITION_VOLCANIC_ASH:
                return WEATHER_FOG;
            case Weather.CONDITION_HAIL:
                return WEATHER_HAIL;
            case Weather.CONDITION_RAIN:
            case Weather.CONDITION_LIGHT_RAIN:
            case Weather.CONDITION_HEAVY_RAIN:
            case Weather.CONDITION_DRIZZLE:
            case Weather.CONDITION_SHOWERS:
            case Weather.CONDITION_LIGHT_SHOWERS:
            case Weather.CONDITION_HEAVY_SHOWERS:
            case Weather.CONDITION_SCATTERED_SHOWERS:
            case Weather.CONDITION_CHANCE_OF_SHOWERS:
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
            case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                return WEATHER_RAIN;
            case Weather.CONDITION_SNOW:
            case Weather.CONDITION_LIGHT_SNOW:
            case Weather.CONDITION_HEAVY_SNOW:
            case Weather.CONDITION_CHANCE_OF_SNOW:
            case Weather.CONDITION_FLURRIES:
                return WEATHER_SNOW;
            case Weather.CONDITION_TORNADO:
            case Weather.CONDITION_HURRICANE:
            case Weather.CONDITION_TROPICAL_STORM:
                return WEATHER_TORNADO;
            case Weather.CONDITION_THUNDERSTORMS:
            case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
            case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                return WEATHER_THUNDER;
            case Weather.CONDITION_SQUALL:
            case Weather.CONDITION_WINDY:
                return WEATHER_WIND;
            case Weather.CONDITION_ICE:
            case Weather.CONDITION_WINTRY_MIX:
            case Weather.CONDITION_LIGHT_RAIN_SNOW:
            case Weather.CONDITION_HEAVY_RAIN_SNOW:
            case Weather.CONDITION_RAIN_SNOW:
            case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
            case Weather.CONDITION_FREEZING_RAIN:
            case Weather.CONDITION_SLEET:
            case Weather.CONDITION_ICE_SNOW:
                return WEATHER_WINTERMIX;
            case Weather.CONDITION_UNKNOWN:
            default:
                return timeBased;
        }
    }
}
