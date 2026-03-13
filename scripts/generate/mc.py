def gen_if(
    statements: list[tuple[str, str]],
    else_case: str = "return Rez.Drawables.unknown;",
) -> str:
    output = "\t\t"
    for condition, block in statements:
        output += f"""if ({condition}) {{
            {block}
        }} else """
    output += f"""{{
            {else_case}
        }}"""
    return output


def gen_func(
    name: str,
    blocks: list[str],
    params: str = "p as Models.Pokemon",
    return_type: str = "ResourceId",
) -> str:
    return f"""\tfunction {name}({params}){f" as {return_type}" if return_type else ""} {{
{"\n\n".join(blocks)}
    }}"""


def gen_class(name: str, blocks: list[str]) -> str:
    return f"""class {name} {{
{"\n\n".join(blocks)}
}}"""


def gen_mod(name: str, blocks: list[str]) -> str:
    return f"""import Toybox.Lang;

module {name} {{
{"\n\n".join(blocks)}
}}"""
