using Toybox.Application;
using Toybox.System;

module Game {
    function prepareSaveState() as Void {
        var initialized = Application.Storage.getValue("initialized");
        if (initialized != null) {
            return;
        }

        var starter = createStarter();
        System.println("Starter: " + starter.sid);

        // Application.Storage.setValue("initialized", true);
    }

    function createStarter() as Models.Pokemon {
        var p = Models.pokemonFromGeneration(531);

        // set as first in box
        // set in party

        return p;
    }
}
