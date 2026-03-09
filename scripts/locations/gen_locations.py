import scripts.utils.paths as paths
import scripts.generate.variable as variable
import scripts.generate.resources as resources
import scripts.utils.utils as utils
import scripts.utils.off64 as off64


def gen_location_strings():
    locations = utils.read_json(f"{paths.LOCATIONS}/locations.json")
    locations = [loc for loc in locations if loc["game"] == "smd"]
    variable.create_variable("locationNames", [loc["location"] for loc in locations])


def gen_location_coords():
    locations = utils.read_json(f"{paths.LOCATIONS}/locations.json")
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
        output += off64.enc_str(ci, 1)
        output += off64.enc_str(i, 2)
        output += off64.enc_str(int(loc["x"]), 2)
        output += off64.enc_str(int(loc["y"]), 2)
        entries.append(output)

    resources.create_resources(
        "locationCoords",
        entries,
        "Entry (7 Bytes): Continent ID (1), Location ID (2), X (2), Y (2)",
    )


def gen_continent_strings():
    continents = utils.read_json(f"{paths.DATA}/continent_coords.json")
    variable.create_variable("continentNames", [con["name"] for con in continents])


def gen_continent_coords():
    continents = utils.read_json(f"{paths.DATA}/continent_coords.json")

    entries: list[str] = []
    for i, con in enumerate(continents):
        output = ""
        output += off64.enc_str(i, 1)
        output += off64.enc_str(int(con["x"]), 2)
        output += off64.enc_str(int(con["y"]), 2)
        entries.append(output)

    resources.create_resources(
        "continentCoords",
        entries,
        "Entry (5 Bytes): Continent ID (2), X (2), Y (2)",
    )
