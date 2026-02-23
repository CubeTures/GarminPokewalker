import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

(:background)
class PokewalkerApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {}

    function onStop(state as Dictionary?) as Void {}

    (:typecheck(disableBackgroundCheck))
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new PokewalkerView(), new PokewalkerDelegate()];
    }

    function getServiceDelegate() as [$.Toybox.System.ServiceDelegate] {
        return [new PokewalkerServiceDelegate()];
    }
}

function getApp() as PokewalkerApp {
    return Application.getApp() as PokewalkerApp;
}
