import Toybox.Lang;
using Toybox.Application;
using Toybox.WatchUi;

(:background)
class App extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getServiceDelegate() as [$.Toybox.System.ServiceDelegate] {
        return [new Delegates.AppServiceDelegate()];
    }

    (:typecheck(disableBackgroundCheck))
    function onStart(state as Dictionary?) as Void {
        // Game.prepareSaveState();
    }

    (:typecheck(disableBackgroundCheck))
    function onStop(state as Dictionary?) as Void {
        // register for background checks
    }

    (:typecheck(disableBackgroundCheck))
    function getInitialView() as [WatchUi.Views] or
        [WatchUi.Views, WatchUi.InputDelegates] {
        return [new Views.HomeView(), new Delegates.HomeDelegate()];
    }
}

function getApp() as App {
    return Application.getApp() as App;
}
