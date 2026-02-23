using Toybox.StringUtil;
import Toybox.Lang;

module Models {
    class Pokemon {
        (:initialized)
        var nickname as String;
        (:initialized)
        var exp as Number;

        (:initialized)
        var sid as Number;
        (:initialized)
        var nature as Nature;
        (:initialized)
        var ability as Ability;
        (:initialized)
        var gender as Gender;
        (:initialized)
        var form as Number;
        (:initialized)
        var shiny as Number;

        (:initialized)
        var ivs as Array<Number>;
        (:initialized)
        var evs as Array<Number>;
        (:initialized)
        var currentHp as Number;

        (:initialized)
        var moves as Array<Move>;

        (:initialized)
        var heldItem as Number;
        (:initialized)
        var status as Number;
        (:initialized)
        var ball as Number;
        (:initialized)
        var typeA as Number;
        (:initialized)
        var typeB as Number;

        (:initialized)
        var friendship as Number;
        (:initialized)
        var metDate as MetDate;
        (:initialized)
        var expCurve as Number;

        enum Nature {
            HARDY,
            LONELY,
            ADAMANT,
            NAUGHTY,
            BRAVE,
            BOLD,
            DOCILE,
            IMPISH,
            LAX,
            RELAXED,
            MODEST,
            MILD,
            BASHFUL,
            RASH,
            QUIET,
            CALM,
            GENTLE,
            CAREFUL,
            QUIRKY,
            SASSY,
            TIMID,
            HASTY,
            JOLLY,
            NAIVE,
            SERIOUS,
        }

        enum Ability {
            A,
            B,
            HIDDEN,
        }

        enum Gender {
            MALE,
            FEMALE,
            GENDERLESS,
        }

        class Move {
            (:initialized)
            var moveId as Number;
            (:initialized)
            var pp as Number;
            (:initialized)
            var ups as Number;
        }

        class MetDate {
            (:initialized)
            var year as Number;
            (:initialized)
            var month as Number;
            (:initialized)
            var day as Number;
        }

        function calculateVolatileStats() as Void {
            // calculate:
            // level
            // max hp
            // HP, Atk, Def, SpA, SpD, Spe
        }
    }
}
