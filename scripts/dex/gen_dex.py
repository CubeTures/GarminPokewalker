import scripts.generate.variable as variable
import scripts.utils.paths as paths
import scripts.utils.utils as utils


def gen_dex_names():
    names = utils.read_json(f"{paths.POKEDB}/ndex_names.json")
    flat = sorted([e for e in names], key=lambda e: e["ndex_id"])
    flat = [utils.to_ascii(e["name_english"]) for e in flat]
    variable.create_variable("dexNames", flat)
