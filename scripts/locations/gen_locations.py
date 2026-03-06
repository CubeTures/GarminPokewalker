import scripts.utils.paths as paths
import scripts.generate.strings as strings
import scripts.generate.resources as resources
import scripts.utils.utils as utils
import scripts.utils.off64 as off64


def gen_location_strings():
    locations = utils.read_json(f"{paths.LOCATIONS}/location_coords.json")
    locations = [loc for loc in locations if loc["game"] == "smd"]
    strings.create_strings("locationNames", [loc["location"] for loc in locations])


def gen_location_coords():
    locations = utils.read_json(f"{paths.LOCATIONS}/location_coords.json")
    locations = [loc for loc in locations if loc["game"] == "smd"]

    continent_i = 0
    continents: dict[str, int] = {}
    entries: list[str] = []
    for i, loc in enumerate(locations):
        if loc["continent"] not in continents:
            continents[loc["continent"]] = continent_i
            continent_i += 1
        ci = continents[loc["continent"]]
        output: str = ""
        output += off64.encode(ci, 1).decode()
        output += off64.encode(i, 2).decode()
        output += off64.encode(int(loc["x"]), 2).decode()
        output += off64.encode(int(loc["y"]), 2).decode()
        entries.append(output)

    resources.create_resources(
        "locationCoords",
        entries,
        "7 bytes: 1 - continent id, 2 - location id, 2 - x pos, 2 - y pos",
    )


def gen_continent_strings():
    continents = utils.read_json(f"{paths.DATA}/continent_coords.json")
    strings.create_strings("continentNames", [con["name"] for con in continents])


def gen_continent_coords():
    continents = utils.read_json(f"{paths.DATA}/continent_coords.json")

    entries: list[str] = []
    for i, con in enumerate(continents):
        output = ""
        output += off64.encode(i, 1).decode()
        output += off64.encode(int(con["x"]), 2).decode()
        output += off64.encode(int(con["y"]), 2).decode()
        entries.append(output)

    resources.create_resources(
        "continentCoords",
        entries,
        "5 bytes: 1 - continent id, 2 - x pos, 2 - y pos",
    )
