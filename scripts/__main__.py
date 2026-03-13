import argparse
from typing import Callable
from scripts.sprites.recolor import recolor_sprites
from scripts.sprites.pack import pack_sprites
from scripts.sprites.gen_sprites import gen_sprites
from scripts.locations.map import parse_location_coords
from scripts.locations.gen_locations import (
    gen_location_strings,
    gen_location_coords,
    gen_continent_strings,
    gen_continent_coords,
)
from scripts.encounters.encounters import scrape_encounters, sort_encounters_by_stats
from scripts.encounters.gen_encounters import gen_encounters
from scripts.dex.gen_dex import gen_dex_names
from scripts.state.gen_state import gen_state


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="Garmin Pokewalker Generator",
        description="Generate the necessary files for Garmin Pokewalker Development",
    )
    parser.add_argument(
        "-a",
        "--all",
        action="store_true",
        help="Generate all modules",
    )
    parser.add_argument(
        "-s",
        "--simple",
        action="store_true",
        help="Only run simple commands (don't scrape or run expensive tasks)",
    )
    parser.add_argument(
        "-g",
        "--generate",
        help="Specify a module to generate",
    )
    return parser.parse_args()


def _sprites(args: argparse.Namespace):
    print("* Started sprites module")
    if not args.simple:
        recolor_sprites()
        print("Recolored sprites")
        pack_sprites()
        print("Packed sprites")
    gen_sprites()
    print("Generated sprite resources and code")
    print("* Completed sprites module")


def _locations(args: argparse.Namespace):
    print("* Started locations module")
    parse_location_coords()
    print("Parsed game locations")
    gen_location_strings()
    print("Generated location strings")
    gen_location_coords()
    print("Generated location coordinates")
    gen_continent_strings()
    print("Generated continent strings")
    gen_continent_coords()
    print("Generated continent coordinates")
    print("* Completed locations module")


def _encounters(args: argparse.Namespace):
    print("* Started encounters module")
    if not args.simple:
        scrape_encounters()
        print("Scraped encounters")
    sort_encounters_by_stats()
    print("Sorted encounters")
    gen_encounters()
    print("Generated encounter tables")
    print("* Completed encounters module")


def _dex(args: argparse.Namespace):
    print("* Started dex module")
    gen_dex_names()
    print("Generated dex names")
    print("* Completed dex module")


def _state(args: argparse.Namespace):
    print("* Started state module")
    gen_state()
    print("Generated game state")
    print("* Completed state module")


def main():
    args = _parse_args()
    modules: list[tuple[str, Callable[[argparse.Namespace], None]]] = [
        ("sprites", _sprites),
        ("locations", _locations),
        ("encounters", _encounters),
        ("dex", _dex),
        ("state", _state),
    ]

    if args.all or args.generate:
        for module, call in modules:
            if args.generate == module or args.all:
                call(args)
        if not args.all and not any(args.generate == module for module, _ in modules):
            print(f"Invalid generation target '{args.generate}'")
    else:
        print("Please provide an argument")


if __name__ == "__main__":
    main()
