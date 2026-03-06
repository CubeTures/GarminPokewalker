import Toybox.Lang;
using Toybox.StringUtil;

module Models {
    function pokemonFromPacked(bytes as ByteArray) as Pokemon {
        var p = new Pokemon();
        var bp = new Utils.BitPacker(bytes);

        var nickBytes = []b;
        for (var i = 0; i < 8; i++) {
            var b = bp.read(8);
            if (b != 0) {
                nickBytes.add(b);
            }
        }
        p.nickname =
            nickBytes.size() > 0
                ? StringUtil.convertEncodedString(nickBytes, {
                      :fromRepresentation
                      =>
                      StringUtil.REPRESENTATION_BYTE_ARRAY,
                      :toRepresentation
                      =>
                      StringUtil.REPRESENTATION_STRING_PLAIN_TEXT,
                  }) as String
                : "";

        p.exp = bp.read(32);
        p.sid = bp.read(16);
        p.nature = bp.read(5) as Pokemon.Nature;
        p.ability = bp.read(2) as Pokemon.Ability;
        p.gender = bp.read(2) as Pokemon.Gender;
        p.form = bp.read(6);
        p.shiny = bp.read(1);

        p.ivs = new Array<Number>[6];
        for (var i = 0; i < 6; i++) {
            p.ivs[i] = bp.read(5);
        }

        p.evs = new Array<Number>[6];
        for (var i = 0; i < 4; i++) {
            p.evs[i] = bp.read(8);
        }
        p.evs[4] = bp.read(8);
        p.evs[5] = bp.read(8);
        p.currentHp = bp.read(16);

        p.moves = new Array<Pokemon.Move>[4];
        for (var i = 0; i < 4; i++) {
            var m = new Pokemon.Move();
            m.moveId = bp.read(16);
            m.pp = bp.read(6);
            m.ups = bp.read(2);
            p.moves[i] = m;
        }

        p.heldItem = bp.read(13);
        p.status = bp.read(3);
        p.ball = bp.read(5); // skips 2 padding bits to align
        p.typeA = bp.read(5);
        p.typeB = bp.read(5);

        p.friendship = bp.read(8);
        p.metDate = new Pokemon.MetDate();
        p.metDate.year = bp.read(12);
        p.metDate.month = bp.read(4);
        p.metDate.day = bp.read(5);
        p.expCurve = bp.read(3);

        return p;
    }

    function pokemonToPacked(p as Pokemon) as ByteArray {
        var bp = new Utils.BitPacker(null);

        var nickname = p.nickname.toUtf8Array();
        for (var i = 0; i < 8; i++) {
            bp.write(i < nickname.size() ? nickname[i] : 0, 8);
        }

        bp.write(p.exp, 32);
        bp.write(p.sid, 16);
        bp.write(p.nature, 5);
        bp.write(p.ability, 2);
        bp.write(p.gender, 2);
        bp.write(p.form, 6);
        bp.write(p.shiny, 1);

        for (var i = 0; i < 6; i++) {
            bp.write(p.ivs[i], 5);
        }

        for (var i = 0; i < 6; i++) {
            bp.write(p.evs[i], 8);
        }
        bp.write(p.currentHp, 16);

        for (var i = 0; i < 4; i++) {
            bp.write(p.moves[i].moveId, 16);
            bp.write(p.moves[i].pp, 6);
            bp.write(p.moves[i].ups, 2);
        }

        bp.write(p.heldItem, 13);
        bp.write(p.status, 3);
        bp.write(p.ball, 5); // skips 2 padding bits to align
        bp.write(p.typeA, 5);
        bp.write(p.typeB, 5);

        bp.write(p.friendship, 8);
        bp.write(p.metDate.year, 12);
        bp.write(p.metDate.month, 4);
        bp.write(p.metDate.day, 5);
        bp.write(p.expCurve, 3);

        return bp.getBytes();
    }
}
