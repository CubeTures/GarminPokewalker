import scripts.utils.paths as paths
import scripts.generate.strings as strings
import scripts.utils.utils as utils


def gen_location_strings():
    locations = utils.read_json(f"{paths.LOCATIONS}/map_locations.json")
    locations = [loc for loc in locations if loc["game"] == "smd"]
    strings.create_strings("locationNames", [loc["location"] for loc in locations])
