import Toybox.Lang;
using Toybox.Math;

module Models {
    class SimpleMon {
        var health as Number = 4;

        function takeDamage() as Void {
            health -= 1;
        }

        function tryCatch() as Boolean {
            return Math.rand() % 2 == 0;
        }
    }
}
