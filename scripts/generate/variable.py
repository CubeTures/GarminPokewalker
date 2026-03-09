import scripts.utils.off64 as off64
import scripts.generate.resources as resources


def _create_variable_xml(
    name: str, entries: list[str], legend: str | None = None
) -> list[int]:
    with_length: list[str] = []

    for entry in entries:
        length = len(entry)
        with_length.append(off64.enc_str(length, 2) + entry)

    legend_var = "Variable Entry (2 + $len Bytes): $len (2), Data ($len)"
    legend_str = "Data ($len): String ($len)"
    return resources.create_resources_xml(
        name, with_length, 0, [legend_var, legend] if legend else [legend_var, legend_str]
    )


def create_variable(name: str, strings: list[str], legend: str | None = None):
    groups = _create_variable_xml(name, strings, legend)
    resources.create_resources_mc(name, groups)
