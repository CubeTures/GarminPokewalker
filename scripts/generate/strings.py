import scripts.utils.utils as utils
import scripts.generate.mc as mc
import scripts.utils.paths as paths
import scripts.generate.xml as xml
import scripts.utils.off64 as off64


BYTE_THRESHOLD = (4 << 10) - 4


def _write_strings_xml(name: str, strings: list[str]) -> list[int]:
    result: list[int] = []
    i = 0

    entries: list[bytearray] = []
    entry: bytearray = off64.encode(0, 2)
    used_bytes = 0

    for string in strings:
        assert len(string) <= off64.ENCODING_MAX and len(string) < BYTE_THRESHOLD
        length = len(string) & off64.ENCODING_MAX
        if length + used_bytes >= BYTE_THRESHOLD:
            entry.extend(off64.encode(0, 2))
            entries.append(entry)
            entry = off64.encode(i, 2)
            used_bytes = 0
            result.append(i)

        entry.extend(off64.encode(length, 2))
        entry.extend(string.encode())
        used_bytes += 2 + length
        i += 1

    entry.extend(off64.encode(0, 2))
    entries.append(entry)
    result.append(i)

    xml_lines: list[str] = []
    for i, entry in enumerate(entries):
        xml_lines.append(f"""<string id="{name}_{i}">{entry.decode()}</string>""")
    xml.gen_xml(f"{paths.RESOURCES}/strings/{name}.xml", xml_lines)

    return result


def create_strings(name: str, strings: list[str]):
    groups = _write_strings_xml(name, strings)
    conditions = [
        (f"(i <= {group})", f"return Rez.Strings.{name}_{i};")
        for i, group in enumerate(groups)
    ]
    ifs = mc.gen_if(conditions, "return Rez.Strings.string_unknown;")
    func = mc.gen_func(f"load{utils.capitalize(name)}", [ifs], "i as Number")
    mod = mc.gen_mod("Generated", [func])
    utils.write_file(f"{paths.SOURCE}/Load{utils.capitalize(name)}.mc", mod)
