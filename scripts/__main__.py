import argparse
from typing import Callable
from scripts.sprites.recolor import recolor_sprites
from scripts.sprites.pack import pack_sprites
from scripts.sprites.gen_sprites import gen_sprites
from scripts.locations.map import parse_map_locations
from scripts.locations.encounters import scrape_encounters, sort_encounters_by_stats
from scripts.locations.gen_locations import gen_location_strings, gen_map_coordinates


def _parse_args():
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
    parse_map_locations()
    print("Parsed game locations")
    if not args.simple:
        scrape_encounters()
        print("Scraped encounters")
    sort_encounters_by_stats()
    print("Sorted encounters")
    gen_location_strings()
    print("Generated location resources")
    gen_map_coordinates()
    print("Generated map coordinates")
    print("* Completed locations module")


def main():
    args = _parse_args()
    modules: list[tuple[str, Callable[[argparse.Namespace], None]]] = [
        ("sprites", _sprites),
        ("locations", _locations),
    ]

    if args.all or args.generate:
        for module, call in modules:
            if args.generate == module or args.all:
                call(args)
        if not any(args.generate == module for module, _ in modules):
            print(f"Invalid generation target '{args.generate}'")
    else:
        print("Please provide an argument")


if __name__ == "__main__":
    main()
