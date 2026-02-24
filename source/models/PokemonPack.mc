import Toybox.Lang;

module Models {
    function pokemonFromPacked(bytes as ByteArray) as Pokemon {
        var p = new Pokemon();

        var nickEnd = 0;
        while (nickEnd < 8 && bytes[nickEnd] != 0) {
            nickEnd++;
        }
        if (nickEnd > 0) {
            var nickBytes = bytes.slice(0, nickEnd);
            p.nickname = nickBytes.toString();
        } else {
            p.nickname = "";
        }

        p.exp = Utils.parseUint32(bytes, 8);

        var uint32 = Utils.parseUint32(bytes, 12);
        p.sid = uint32 & 0xffff;
        p.nature = ((uint32 >> 16) & 0x1f) as Pokemon.Nature;
        p.ability = ((uint32 >> 21) & 0x03) as Pokemon.Ability;
        p.gender = ((uint32 >> 23) & 0x03) as Pokemon.Gender;
        p.form = (uint32 >> 25) & 0x3f;
        p.shiny = (uint32 >> 31) & 0x01;

        uint32 = Utils.parseUint32(bytes, 16);
        p.ivs = new Array<Number>[6];
        p.ivs[0] = uint32 & 0x1f;
        p.ivs[1] = (uint32 >> 5) & 0x1f;
        p.ivs[2] = (uint32 >> 10) & 0x1f;
        p.ivs[3] = (uint32 >> 15) & 0x1f;
        p.ivs[4] = (uint32 >> 20) & 0x1f;
        p.ivs[5] = (uint32 >> 25) & 0x1f;

        uint32 = Utils.parseUint32(bytes, 20);
        p.evs = new Array<Number>[6];
        p.evs[0] = uint32 & 0xff;
        p.evs[1] = (uint32 >> 8) & 0xff;
        p.evs[2] = (uint32 >> 16) & 0xff;
        p.evs[3] = (uint32 >> 24) & 0xff;

        uint32 = Utils.parseUint32(bytes, 24);
        p.evs[4] = uint32 & 0xff;
        p.evs[5] = (uint32 >> 8) & 0xff;
        p.currentHp = (uint32 >> 16) & 0xffff;

        p.moves = new Array<Pokemon.Move>[4];
        for (var i = 0; i < 4; i++) {
            p.moves[i] = new Pokemon.Move();
        }

        uint32 = Utils.parseUint32(bytes, 28);
        p.moves[0].moveId = uint32 & 0xffff;
        p.moves[0].pp = (uint32 >> 16) & 0x3f;
        p.moves[0].ups = (uint32 >> 22) & 0x03;
        var m1_id_low = (uint32 >> 24) & 0xff;

        uint32 = Utils.parseUint32(bytes, 32);
        var m1_id_high = uint32 & 0xff;
        p.moves[1].moveId = m1_id_low | (m1_id_high << 8);
        p.moves[1].pp = (uint32 >> 8) & 0x3f;
        p.moves[1].ups = (uint32 >> 14) & 0x03;
        p.moves[2].moveId = (uint32 >> 16) & 0xffff;

        uint32 = Utils.parseUint32(bytes, 36);
        p.moves[2].pp = uint32 & 0x3f;
        p.moves[2].ups = (uint32 >> 6) & 0x03;
        p.moves[3].moveId = (uint32 >> 8) & 0xffff;
        p.moves[3].pp = (uint32 >> 24) & 0x3f;
        p.moves[3].ups = (uint32 >> 30) & 0x03;

        uint32 = Utils.parseUint32(bytes, 40);
        p.heldItem = uint32 & 0x1fff;
        p.status = (uint32 >> 13) & 0x07;
        p.ball = (uint32 >> 16) & 0x1f;
        p.typeA = (uint32 >> 21) & 0x1f;
        p.typeB = (uint32 >> 26) & 0x1f;

        uint32 = Utils.parseUint32(bytes, 44);
        p.friendship = uint32 & 0xff;
        p.metDate = new Pokemon.MetDate();
        p.metDate.year = (uint32 >> 8) & 0xfff;
        p.metDate.month = (uint32 >> 20) & 0x0f;
        p.metDate.day = (uint32 >> 24) & 0x1f;
        p.expCurve = (uint32 >> 29) & 0x07;

        return p;
    }

    function pokemonToPacked(p as Pokemon) as ByteArray {
        var bytes = new [48]b;

        var nickname = p.nickname.toUtf8Array();
        for (var i = 0; i < 8; i++) {
            if (i < nickname.size()) {
                bytes.encodeNumber(nickname[i], Lang.NUMBER_FORMAT_UINT8, {
                    :offset => i,
                });
            } else {
                bytes.encodeNumber(0, Lang.NUMBER_FORMAT_UINT8, {
                    :offset => i,
                });
            }
        }

        Utils.packUint32(bytes, 8, p.exp);
        Utils.packUint32(
            bytes,
            12,
            (p.sid & 0xffff) |
                ((p.nature & 0x1f) << 16) |
                ((p.ability & 0x03) << 21) |
                ((p.gender & 0x03) << 23) |
                ((p.form & 0x3f) << 25) |
                ((p.shiny & 0x01) << 31)
        );
        Utils.packUint32(
            bytes,
            16,
            (p.ivs[0] & 0x1f) |
                ((p.ivs[1] & 0x1f) << 5) |
                ((p.ivs[2] & 0x1f) << 10) |
                ((p.ivs[3] & 0x1f) << 15) |
                ((p.ivs[4] & 0x1f) << 20) |
                ((p.ivs[5] & 0x1f) << 25)
        );
        Utils.packUint32(
            bytes,
            20,
            (p.evs[0] & 0xff) |
                ((p.evs[1] & 0xff) << 8) |
                ((p.evs[2] & 0xff) << 16) |
                ((p.evs[3] & 0xff) << 24)
        );
        Utils.packUint32(
            bytes,
            24,
            (p.evs[4] & 0xff) |
                ((p.evs[5] & 0xff) << 8) |
                ((p.currentHp & 0xffff) << 16)
        );
        Utils.packUint32(
            bytes,
            28,
            // Lower 8 bits of move1
            (p.moves[0].moveId & 0xffff) |
                ((p.moves[0].pp & 0x3f) << 16) |
                ((p.moves[0].ups & 0x03) << 22) |
                ((p.moves[1].moveId & 0xff) << 24)
        );
        Utils.packUint32(
            bytes,
            32,
            // Upper 8 bits of move1
            ((p.moves[1].moveId >> 8) & 0xff) |
                ((p.moves[1].pp & 0x3f) << 8) |
                ((p.moves[1].ups & 0x03) << 14) |
                ((p.moves[2].moveId & 0xffff) << 16)
        );
        Utils.packUint32(
            bytes,
            36,
            (p.moves[2].pp & 0x3f) |
                ((p.moves[2].ups & 0x03) << 6) |
                ((p.moves[3].moveId & 0xffff) << 8) |
                ((p.moves[3].pp & 0x3f) << 24) |
                ((p.moves[3].ups & 0x03) << 30)
        );
        Utils.packUint32(
            bytes,
            40,
            (p.heldItem & 0x1fff) |
                ((p.status & 0x07) << 13) |
                ((p.ball & 0x1f) << 16) |
                ((p.typeA & 0x1f) << 21) |
                ((p.typeB & 0x1f) << 26)
        );
        Utils.packUint32(
            bytes,
            44,
            (p.friendship & 0xff) |
                ((p.metDate.year & 0xfff) << 8) |
                ((p.metDate.month & 0x0f) << 20) |
                ((p.metDate.day & 0x1f) << 24) |
                ((p.expCurve & 0x07) << 29)
        );

        return bytes;
    }
}
