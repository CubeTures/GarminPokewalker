import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

(:background)
class risumonApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {}

    function onStop(state as Dictionary?) as Void {}

    (:typecheck(disableBackgroundCheck))
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new risumonView(), new risumonDelegate()];
    }

    function getServiceDelegate() as [$.Toybox.System.ServiceDelegate] {
        return [new risumonServiceDelegate()];
    }
}

function getApp() as risumonApp {
    return Application.getApp() as risumonApp;
}
