import scripts.utils.off64 as off64
import scripts.generate.resources as resources


def _create_strings_xml(
    name: str,
    entries: list[str],
) -> list[int]:
    with_length: list[str] = []

    for entry in entries:
        length = len(entry)
        with_length.append(off64.encode(length, 2).decode() + entry)

    legend = f"Entry (2 + $len Bytes): $len (2), String ($len)"
    return resources.create_resources_xml(name, with_length, 0, legend)


def create_strings(
    name: str,
    strings: list[str],
):
    groups = _create_strings_xml(name, strings)
    resources.create_resources_mc(name, groups)
