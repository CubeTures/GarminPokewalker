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


def gen_func(name: str, blocks: list[str], return_type: str = "ResourceId") -> str:
    return f"""\tfunction {name}(p as Models.Pokemon) as {return_type} {{
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

    sheet = 0
    func = 0
    funcs: list[str] = []
    names = [
        "loadBaseSprite",
        "loadFemaleSprite",
        "loadFormSprite",
        "loadRightSprite",
        "loadRightFormSprite",
    ]

    for partition in partitions:
        statements: list[tuple[str, str]] = []
        for i in range(math.ceil(len(partition) / constants.sheet_capacity)):
            idx = min(
                i * constants.sheet_capacity + constants.sheet_capacity, len(partition)
            )
            sid = partition[idx - 1].idx
            statements.append(
                (f"p.sid <= {sid}", f"return Rez.Drawables.sprites_{sheet};")
            )
            sheet += 1
        funcs.append(gen_func(names[func], [gen_if(statements)]))
        func += 1

    funcs.append(
        gen_func(
            "_loadBaseSpriteOffset",
            [
                f"\t\treturn [p.sid % {constants.sheet_width} * {constants.sprite_width}, p.sid % {constants.sheet_height} * {constants.sprite_height}];"
            ],
            "[Number, Number]",
        )
    )

    # TODO
    todos = [
        ("hasFemaleSprite", "return false;", "Boolean"),
        ("hasRightSprite", "return false;", "Boolean"),
        ("hasRightFormSprite", "return false;", "Boolean"),
        ("loadBaseSpriteOffset", "return [0, 0];", "[Number, Number]"),
        ("loadFemaleSpriteOffset", "return [0, 0];", "[Number, Number]"),
        ("loadFormSpriteOffset", "return [0, 0];", "[Number, Number]"),
        ("loadRightSpriteOffset", "return [0, 0];", "[Number, Number]"),
        ("loadRightFormSpriteOffset", "return [0, 0];", "[Number, Number]"),
    ]

    for todo in todos:
        funcs.append(gen_func(todo[0], [f"\t\t{todo[1]}"], todo[2]))

    module = gen_mod("Generated", funcs)
    with open("source/_generated/LoadSprite.mc", "w") as file:
        file.write(module)


if __name__ == "__main__":
    xml()
    mc()
