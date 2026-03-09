import scripts.generate.variable as variable
import scripts.utils.off64 as off64
import scripts.utils.paths as paths
import scripts.utils.utils as utils
import scripts.utils.lookup as lookup


def gen_encounters():
    table = utils.read_json(f"{paths.LOCATIONS}/encounters_sorted.json")
    entries: list[str] = []

    for location, encounters in enumerate(table):
        output: str = ""
        output += off64.enc_str(location, 2)
        output += off64.enc_str(len(encounters), 2)
        for encounter in encounters:
            print(encounter)
            output += off64.enc_str(lookup.sid_from_name(encounter), 2)
        entries.append(output)

    variable.create_variable(
        "encounters",
        entries,
        "Data (2 + $size * 2 Bytes): Location ID (2), $size (2), [Species ID (2)] ($size)",
    )
