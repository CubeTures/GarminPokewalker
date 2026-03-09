import scripts.utils.paths as paths
import scripts.utils.utils as utils

_sid: dict[str, int] | None = None
_loc: dict[str, int] | None = None


def sid_from_name(name: str) -> int:
    global _sid
    if _sid is None:
        names_data = utils.read_json(f"{paths.POKEDB}/ndex_names.json")
        _sid = {e["name_english"]: int(e["ndex_id"]) for e in names_data}
    if name in _sid:
        return _sid[name]
    return -1


def loc_from_name(name: str) -> int:
    global _loc
    if _loc is None:
        loc_data = utils.read_json(f"{paths.LOCATIONS}/locations.json")
        _loc = {e["location"]: i for i, e in enumerate(loc_data)}
    if name in _loc:
        return _loc[name]
    return -1
