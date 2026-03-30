import Toybox.Lang;
using Toybox.Math;

module Models {
    class SimpleMon {
        var sid as Number = -1;
        var health as Number = 4;

        function initialize(sid as Number) {
            self.sid = sid;
        }

        function takeDamage() as Void {
            health -= 1;
        }

        function tryCatch() as Boolean {
            return Math.rand() % 2 == 0;
        }
    }
}
