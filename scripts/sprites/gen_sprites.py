import math
import scripts.sprites.sprite as sprite
import scripts.utils.constants as constants
import scripts.generate.mc as mc
import scripts.generate.xml as xml
import scripts.utils.paths as paths
import scripts.utils.utils as utils


def gen_sprites_xml():
    sprites = sprite.load_sprites()
    partitions = sprite.partition_sprites(sprites)

    sheet = 0
    entries: list[str] = []
    for partition in partitions:
        for _ in range(math.ceil(len(partition) / constants.SHEET_CAPACITY)):
            entries.append(
                f"""<bitmap id="sprites_{sheet}" filename="{sheet}.png" compress="true"/>"""
            )
            sheet += 1

    xml.gen_xml(f"{paths.RESOURCES}/sprites/_sprites.xml", entries)


def gen_sprites_mc():
    sprites = sprite.load_sprites()
    partitions = sprite.partition_sprites(sprites)

    arrays: list[str] = []
    groups = [
        ("femaleSprites", partitions[1]),
        ("formSprites", partitions[2]),
    ]
    for name, group in groups:
        sids = list(map(lambda sprite: str(sprite.idx), group))
        arrays.append(f"\tconst {name} = [{", ".join(sids)}] as Array<Number>;")

    sheet = 0
    func = 0
    funcs: list[str] = []
    names = [
        "loadBaseSprite",
        "loadFemaleSprite",
        "loadFormSprite",
        "loadRightBaseSprite",
        "loadRightFemaleSprite",
        "loadRightFormSprite",
    ]

    for partition in partitions:
        statements: list[tuple[str, str]] = []
        for i in range(math.ceil(len(partition) / constants.SHEET_CAPACITY)):
            idx = min(
                i * constants.SHEET_CAPACITY + constants.SHEET_CAPACITY, len(partition)
            )
            sid = partition[idx - 1].idx
            form = partition[idx - 1].form_i
            if "Form" in names[func]:
                condition = f"p.sid < {sid} || (p.sid == {sid} && p.form <= {form})"
            else:
                condition = f"p.sid <= {sid}"
            statements.append((condition, f"return Rez.Drawables.sprites_{sheet};"))
            sheet += 1
        funcs.append(mc.gen_func(names[func], [mc.gen_if(statements)]))
        func += 1

    funcs.append(
        mc.gen_func(
            "loadSpriteOffset",
            [
                f"\t\treturn [(i % {constants.SHEET_WIDTH}) * {constants.SPRITE_WIDTH}, ((i % {constants.SHEET_CAPACITY}) / {constants.SHEET_HEIGHT}) * {constants.SPRITE_HEIGHT}];"
            ],
            "i as Number",
            "[Number, Number]",
        )
    )
    
    mod = mc.gen_mod("Generated", arrays + funcs)
    utils.write_file(f"{paths.SOURCE}/LoadSprite.mc", mod)


def gen_sprites():
    gen_sprites_mc()
    gen_sprites_xml()
