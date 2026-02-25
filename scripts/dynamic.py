import os
import loader
import math
import constants


def xml():
    sprites = loader.import_sprites()
    partitions = loader.partition_sprites(sprites)
    output = """<drawables xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="https://developer.garmin.com/downloads/connect-iq/resources.xsd">\n"""

    sheet = 0
    for partition in partitions:
        for _ in range(math.ceil(len(partition) / constants.sheet_capacity)):
            output += f"""\t<bitmap id="sprites_{sheet}" filename="{sheet}.png" compress="true"/>\n"""
            sheet += 1

    output += "</drawables>"

    path = "resources/_generated/sprites/"
    os.makedirs(path, exist_ok=True)
    with open(f"{path}_sprites.xml", "w") as file:
        file.write(output)


def gen_if(statements: list[tuple[str, str]]) -> str:
    output = "\t\t"
    for condition, block in statements:
        output += f"""if ({condition}) {{
            {block}
        }} else """
    output += f"""{{
            return Rez.Drawables.unknown;
        }}"""
    return output


def gen_func(
    name: str,
    blocks: list[str],
    params: str = "p as Models.Pokemon",
    return_type: str = "ResourceId",
) -> str:
    return f"""\tfunction {name}({params}) as {return_type} {{
{"\n\n".join(blocks)}
    }}"""


def gen_mod(name: str, blocks: list[str]) -> str:
    return f"""import Toybox.Lang;

module {name} {{
{"\n\n".join(blocks)}
}}"""


def mc():
    sprites = loader.import_sprites()
    partitions = loader.partition_sprites(sprites)

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
        for i in range(math.ceil(len(partition) / constants.sheet_capacity)):
            idx = min(
                i * constants.sheet_capacity + constants.sheet_capacity, len(partition)
            )
            sid = partition[idx - 1].idx
            form = partition[idx - 1].form_i
            if "Form" in names[func]:
                condition = f"p.sid < {sid} || (p.sid == {sid} && p.form <= {form})"
            else:
                condition = f"p.sid <= {sid}"
            statements.append((condition, f"return Rez.Drawables.sprites_{sheet};"))
            sheet += 1
        funcs.append(gen_func(names[func], [gen_if(statements)]))
        func += 1

    funcs.append(
        gen_func(
            "loadSpriteOffset",
            [
                f"\t\treturn [(i % {constants.sheet_width}) * {constants.sprite_width}, ((i % {constants.sheet_capacity}) / {constants.sheet_height}) * {constants.sprite_height}];"
            ],
            "i as Number",
            "[Number, Number]",
        )
    )

    module = gen_mod("Generated", arrays + funcs)
    with open("source/_generated/LoadSprite.mc", "w") as file:
        file.write(module)


if __name__ == "__main__":
    xml()
    mc()
