import scripts.utils.paths as paths
import scripts.generate.strings as strings
import scripts.generate.resources as resources
import scripts.utils.utils as utils
import scripts.utils.off64 as off64


def gen_location_strings():
    locations = utils.read_json(f"{paths.LOCATIONS}/map_locations.json")
    locations = [loc for loc in locations if loc["game"] == "smd"]
    strings.create_strings("locationNames", [loc["location"] for loc in locations])


def gen_map_coordinates():
    locations = utils.read_json(f"{paths.LOCATIONS}/map_locations.json")
    locations = [loc for loc in locations if loc["game"] == "smd"]

    continent_i = 0
    continents: dict[str, int] = {}
    entries: list[str] = []
    for i, loc in enumerate(locations):
        if loc["continent"] not in continents:
            continents[loc["continent"]] = continent_i
            continent_i += 1
        output: str = ""
        output += off64.encode(continent_i, 1).decode()
        output += off64.encode(i, 2).decode()
        output += off64.encode(int(loc["x"]), 2).decode()
        output += off64.encode(int(loc["y"]), 2).decode()
        entries.append(output)

    resources.create_resources(
        "mapCoordinates",
        entries,
        "7 bytes: 1 - continent id, 2 - location name id, 2 - x pos, 2 - y pos",
    )
