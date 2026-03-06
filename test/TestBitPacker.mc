import Toybox.Test;
import Toybox.Lang;

(:test)
function testBitPackerRoundtrip(logger as Test.Logger) as Boolean {
    var bp = new Utils.BitPacker(null);
    bp.write(0x1f, 5);
    bp.write(0x03, 2);
    bp.write(0x00, 1);
    bp.write(0x1ff, 9);

    bp.reset();
    Test.assertEqualMessage(bp.read(5), 0x1f, "5-bit value");
    Test.assertEqualMessage(bp.read(2), 0x03, "2-bit value");
    Test.assertEqualMessage(bp.read(1), 0x00, "1-bit value");
    Test.assertEqualMessage(bp.read(9), 0x1ff, "9-bit value");
    return true;
}

(:test)
function testBitPackerOverflow(logger as Test.Logger) as Boolean {
    var bp = new Utils.BitPacker(null);
    bp.write(0xff, 4);
    bp.reset();
    Test.assertEqualMessage(bp.read(4), 0x0f, "mask clamps to 4 bits");
    return true;
}

(:test)
function testPokemonPackRoundtrip(logger as Test.Logger) as Boolean {
    var p = new Models.Pokemon();
    p.nickname = "Pikachu";
    p.exp = 123456;
    p.sid = 0xabcd;
    p.nature = 12 as Models.Pokemon.Nature;
    p.ability = 1 as Models.Pokemon.Ability;
    p.gender = 2 as Models.Pokemon.Gender;
    p.form = 3;
    p.shiny = 1;
    p.ivs = [31, 30, 29, 28, 27, 26] as Array<Number>;
    p.evs = [252, 0, 4, 0, 252, 0] as Array<Number>;
    p.currentHp = 200;
    p.moves = new Array<Models.Pokemon.Move>[4];
    for (var i = 0; i < 4; i++) {
        var m = new Models.Pokemon.Move();
        m.moveId = 100 + i;
        m.pp = 10 + i;
        m.ups = i % 3;
        p.moves[i] = m;
    }
    p.heldItem = 0x1a2;
    p.status = 2;
    p.ball = 5;
    p.typeA = 3;
    p.typeB = 14;
    p.friendship = 255;
    p.metDate = new Models.Pokemon.MetDate();
    p.metDate.year = 2024;
    p.metDate.month = 6;
    p.metDate.day = 15;
    p.expCurve = 4;

    var packed = Models.pokemonToPacked(p);
    var p2 = Models.pokemonFromPacked(packed);

    Test.assertEqualMessage(p2.nickname, p.nickname, "nickname");
    Test.assertEqualMessage(p2.exp, p.exp, "exp");
    Test.assertEqualMessage(p2.sid, p.sid, "sid");
    Test.assertEqualMessage(p2.nature, p.nature, "nature");
    Test.assertEqualMessage(p2.ability, p.ability, "ability");
    Test.assertEqualMessage(p2.gender, p.gender, "gender");
    Test.assertEqualMessage(p2.form, p.form, "form");
    Test.assertEqualMessage(p2.shiny, p.shiny, "shiny");
    for (var i = 0; i < 6; i++) {
        Test.assertEqualMessage(p2.ivs[i], p.ivs[i], "iv " + i);
        Test.assertEqualMessage(p2.evs[i], p.evs[i], "ev " + i);
    }
    Test.assertEqualMessage(p2.currentHp, p.currentHp, "currentHp");
    for (var i = 0; i < 4; i++) {
        Test.assertEqualMessage(
            p2.moves[i].moveId,
            p.moves[i].moveId,
            "move " + i + " id"
        );
        Test.assertEqualMessage(
            p2.moves[i].pp,
            p.moves[i].pp,
            "move " + i + " pp"
        );
        Test.assertEqualMessage(
            p2.moves[i].ups,
            p.moves[i].ups,
            "move " + i + " ups"
        );
    }
    Test.assertEqualMessage(p2.heldItem, p.heldItem, "heldItem");
    Test.assertEqualMessage(p2.status, p.status, "status");
    Test.assertEqualMessage(p2.ball, p.ball, "ball");
    Test.assertEqualMessage(p2.typeA, p.typeA, "typeA");
    Test.assertEqualMessage(p2.typeB, p.typeB, "typeB");
    Test.assertEqualMessage(p2.friendship, p.friendship, "friendship");
    Test.assertEqualMessage(p2.metDate.year, p.metDate.year, "year");
    Test.assertEqualMessage(p2.metDate.month, p.metDate.month, "month");
    Test.assertEqualMessage(p2.metDate.day, p.metDate.day, "day");
    Test.assertEqualMessage(p2.expCurve, p.expCurve, "expCurve");

    return true;
}
