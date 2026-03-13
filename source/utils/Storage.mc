import Toybox.Lang;
using Toybox.Application;

module Utils {
    function getGameStateProperty(
        key as String
    ) as Application.PropertyValueType {
        return Application.Storage.getValue(createGameStateKey(key));
    }

    function setGameStateProperty(
        key as String,
        value as Application.PropertyValueType
    ) as Void {
        Application.Storage.setValue(createGameStateKey(key), value);
    }

    function createGameStateKey(key as String) as String {
        return "gs__" + key;
    }
}
