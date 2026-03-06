import json
import time
from bs4 import Tag

import scripts.utils.paths as paths
import scripts.scrape.html as html
import scripts.scrape.fetch as fetch
import scripts.utils.utils as utils

PokemonList = list[str]
LocationData = dict[str, PokemonList]

BASE_URL = "https://bulbapedia.bulbagarden.net"
GAME_MAP = {
    "markers_super": "smd",
    "markers_rescue": "rt",
    "markers_explorers": "exp",
    "markers_gates": "gti",
    "markers_other": "etc",
}
EXCLUDE_KEYWORDS = [
    "Pok%C3%A9mon_world",
    "Super_Mystery_Dungeon",
    "File:",
    "Category:",
    "Kecleon_Shop",
]
POKEMON_SECTION_ID = "Pok.C3.A9mon_encountered"
POKEMON_SECTION_TEXT = "Pokémon encountered"


def _scrape_location_encounters(url: str) -> PokemonList:
    soup = fetch.fetch_soup(url)
    if soup is None:
        return []

    table = html.find_section_table(soup, POKEMON_SECTION_ID, POKEMON_SECTION_TEXT)
    if table is None:
        return []

    pokemon_names: PokemonList = []
    for row in table.find_all("tr", style=lambda s: s and "#fff" in s.lower()):  # type: ignore
        if not isinstance(row, Tag):
            continue
        name = html.extract_name_from_row(row)
        if name:
            pokemon_names.append(name)

    return pokemon_names


def scrape_encounters() -> None:
    try:
        soup = html.load_soup(f"{paths.DATA}/locations.html")
    except FileNotFoundError:
        print("Error: locations.html not found.")
        return

    to_process: dict[str, str] = {}
    for link in soup.find_all("a", href=True):
        href: str = link["href"]  # type: ignore[assignment]
        title: str = link.get("title", "Unknown Location")  # type: ignore[assignment]
        if href.startswith("/wiki/") and not any(ex in href for ex in EXCLUDE_KEYWORDS):
            full_url = f"{BASE_URL}{href}"
            if full_url not in to_process:
                to_process[full_url] = title

    encountered_data: LocationData = {}
    for url, location_name in to_process.items():
        print(f"Scraping: {location_name}...")
        encountered_data[location_name] = _scrape_location_encounters(url)
        time.sleep(0.5)

    utils.write_file(
        f"{paths.OUTPUT}/locations/encounters.json",
        json.dumps(encountered_data),
    )


def sort_encounters_by_stats() -> None:
    names_data = utils.read_json(f"{paths.POKEDB}/ndex_names.json")
    names: dict[str, int] = {e["name_english"]: int(e["ndex_id"]) for e in names_data}

    sorting: dict[str, list[str]] = utils.read_json(
        f"{paths.LOCATIONS}/encounters.json"
    )

    forms_data = utils.read_json(f"{paths.POKEDB}/pokemon_forms.json")
    forms: dict[int, int] = {}
    for d in forms_data:
        if d["ndex_id"] not in forms:
            forms[d["ndex_id"]] = d["stat_total"]

    for location, encounters in sorting.items():
        sorting[location] = sorted(encounters, key=lambda name: forms[names[name]])

    utils.write_file(
        f"{paths.OUTPUT}/locations/encounters_sorted.json",
        json.dumps(sorting),
    )


def count_encounters() -> None:
    names_data = utils.read_json(f"{paths.POKEDB}/ndex_names.json")
    names: dict[str, int] = {e["name_english"]: int(e["ndex_id"]) for e in names_data}

    counts: dict[str, list[str]] = {name: [] for name in names}

    encounters = utils.read_json(f"{paths.LOCATIONS}/encounters.json")
    for location, encounters in encounters.items():
        for encounter in encounters:
            counts[encounter].append(location)

    utils.write_file(f"{paths.LOCATIONS}/encounters_count.json", json.dumps(counts))
