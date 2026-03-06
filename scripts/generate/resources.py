import scripts.utils.paths as paths
import scripts.utils.utils as utils
import scripts.generate.mc as mc
import scripts.generate.xml as xml
import scripts.utils.off64 as off64

BYTE_THRESHOLD = (4 << 10) - 4


def create_resources_xml(
    name: str,
    entries: list[str],
    legend: str | None = None,
) -> list[int]:
    result: list[int] = []
    i = 0

    lines: list[bytearray] = []
    line: bytearray = off64.encode(0, 2)
    used_bytes = 0

    for entry in entries:
        length = len(entry)
        assert length < BYTE_THRESHOLD
        if length + used_bytes >= BYTE_THRESHOLD:
            line.extend(off64.encode(0, 2))
            lines.append(line)
            line = off64.encode(i, 2)
            used_bytes = 0
            result.append(i)

        line.extend(entry.encode())
        used_bytes += length
        i += 1

    line.extend(off64.encode(0, 2))
    lines.append(line)
    result.append(i)

    xml_lines: list[str] = []
    if legend is not None:
        xml_lines.append(f"<!-- {legend} -->")
    for i, line in enumerate(lines):
        xml_lines.append(f"""<string id="{name}_{i}">{line.decode()}</string>""")
    xml.gen_xml(f"{paths.RESOURCES}/strings/{name}.xml", xml_lines)

    return result


def create_resources_mc(name: str, groups: list[int]):
    conditions = [
        (f"(i <= {group})", f"return Rez.Strings.{name}_{i};")
        for i, group in enumerate(groups)
    ]
    ifs = mc.gen_if(conditions, "return Rez.Strings.string_unknown;")
    func = mc.gen_func(f"load{utils.capitalize(name)}", [ifs], "i as Number")
    mod = mc.gen_mod("Generated", [func])
    utils.write_file(f"{paths.SOURCE}/Load{utils.capitalize(name)}.mc", mod)


def create_resources(name: str, entries: list[str], legend: str | None = None):
    groups = create_resources_xml(name, entries, legend)
    create_resources_mc(name, groups)
