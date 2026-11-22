# CLAUDE.md

GarminPokewalker is a re-imagining of the original Pokewalker for GarminOS. As a health-first platform, it attempts to reward healthy habits with meaningly gameplay and consequences. It features a map, multiple environments, rich encounters, health-tied gameplay, battling, a pokedex, and a pc.

## Technology Stack

- App: Monkey C (GarminOS proprietary language) + strict typing enabled
- Scripting: Python + Pylance strict typing enabled

## Architecture

```bash
resources/
├── _generated/ # Auto generated resource files from scripting (do not edit manually)
│   ├── sprites/ # Sprite sheets
│   └── strings/ # Binary data for CSV.mc
├── drawables/ # Images for UI
├── layouts/ # Layouts with UI components (mostly unused in favor of procedural creation)
├── menus/ # Menu definitions (mostly unused in favor of procedural creation)
└── strings/ # Static strings for UI (mostly unused in favor of procedural definition)

scripts/
├── _data/ # Static data that needed manual creation or cleanup
├── _output/ # Intermediate output from scripts (final output in resources/_generated)
├── _references/ # Complex external references downloaded locally
├── generate/ # Resource and code file generation utilities
├── scrape/ # Scraping and parsing utilities
├── utils/ # Utility functions
├── */ # Module for generating related information
└── __main__.py # Entry point of the CLI

source/
├── _generated/ # Auto generated code files from scripting (do not edit manually)
├── delegates/ # Input handlers corresponding to views
├── game/ # Game logic
├── managers/ # Complex UI state managers
├── models/ # Data structures
├── resources/ # Resource adjacent loaders and classes
├── test/ # Unit tests
├── utils/ # Various utility functions
├── views/ # UI screens
├── visuals/ # Rendering components and helpers
└── App.mc # Entry point
```

## Building

- Building the app
    - VSCode Monkey C extension
    - Command Palette
    - Monkey C: Build Current Project
    - Output into `bin/`

- Generating resources (python)
    - Available modules: sprites, locations, encounters, dex, state
    - Only use `--all` if multiple modules have changed
    - Only exclude `--simple` if data has changed

```bash
python3 -m sprites --all # Generate all resources
python3 -m sprites --simple # Skip scraping (fast regeneration)
python3 -m sprites --generate xyz # Generate specific module only
```

## Pipeline

- Data
    - Input data from `_data/`, `_output/`, or `_references/`
- Script
    - Python scripts read input, perform logic, and generate files for use in the app
- Generated
    - Files are generated and placed into special folders to be detected by the Monkey C compiler
- CSV
    - Binary data is interpreted by `CSV.mc` which provides a simple wrapper around data parsing
- Instance
    - Instances are created from `CSV.mc` and used for logic in the app

## Constraints

- RAM
    - Strict RAM constraints exist and careful loading of data lazily and immediate deallocation is necessary to work
- Scope
    - To limit scope, all values are hardcoded for the Instinct 3 Solar 45/50mm
    - API restrictions follow like not having `drawBitmap2`
    - Completely black and white display; not even transparent is a valid color
