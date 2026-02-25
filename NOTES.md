# Sources

- Pixel Sprites
    - https://github.com/msikma/pokesprite
- Showdown Code
    - https://github.com/smogon/pokemon-showdown/tree/master/sim
- PokeDB
    - https://pokedb.org/data-export
- Data
    - https://baselight.app/u/kaggle/dataset/maca11_all_pokemon_dataset
- Mystery Dungeon Map
    - https://eddyk28.github.io/PMD%20Map/
- Original Mechanics
    - https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9walker
- Reverse Engineer of Garmin API
    - https://github.com/matin/garth
- Garmin STL Reference
    - https://developer.garmin.com/connect-iq/api-docs/index.html
        - `:extendedCode`
        - `--warn --typecheck 3 --optimization 2pz`
- Smogon Sprites
    - https://play.pokemonshowdown.com/sprites/pokemonicons-sheet.png
    - https://github.com/smogon/pokemon-showdown-client/blob/e263055242b6e35cceb5abbfb07f33c588c8131d/play.pokemonshowdown.com/src/battle-dex.ts#L805
    - https://github.com/smogon/pokemon-showdown-client/blob/e263055242b6e35cceb5abbfb07f33c588c8131d/play.pokemonshowdown.com/src/battle-dex-data.ts#L151

# Thoughts

- Load as much as possible on demand and all at once
    - Try not to read files often as it could cause stuttering

- 176 x 176 pixels display instinct 3 solar 45mm

- Optimal image compression algorithm
    - (2 bits color, 1 byte length)

- Starter
    - Audino

- enter, up, menu, down, esc

# Mechanics

## Tenants

- Standalone title (no connection to main game, is a full experience in of itself)
- Focus on health and fun, in that order (to that regard, incentivize good health and reward it)
- Catch em all is a central focus (make catching as stress enducing and high-stakes as in the mainline titles -- likely requires an in-depth battling system and luck for rarer pokemon)
- Legendaries feel legendary again (they should be hard to catch and rewarding to get)
- Walking with your partners is the second focus (being pretty and having a nice time observing your caught pokemon should feel rewarding in itself)

## Brainstorming

- Hitting goals like step goal gets rewards
- Good sleep score grants rewards
- Reward activity
- Don't require playing while active
    - Some storage mechanic
- Cap rewards per day by active minutes or steps to prevent overexertion
- Additional captures of the same pokemon gets candy
    - Candy can be used to raised iv of that specific pokemon
    - Possibly additional use for candy
- 2400 pc slots

### Gameplay Loop (No Activity)

- Home screen
    - Shop
        - Buy items
    - Dex
        - List of all mons and missing
    - Search
        - Select from 3 grasses
        - Get pokemon
    - Battle
        - Fight competitive teams
        - Win badges

### Activity

- Goals
    - Steps
    - Elevation
    - Activity Minutes
        - Based on week
        -
- Complications
    - Steps
    - Floors climbed
    - Calories
    - Solar input
- API
    - Sleep Score
        - Sleeping heals your pokemon
    - Sleep Consistency

- Increased battle prowess

- Unlock high tier encounter bracket
- Increase probability of rare table rolls
- Increase legendary encounter chance
- Multi-spawn events

- Encounter chances
- Pokeballs

## Save Data

```c
// 48 bytes; 3 spare bits
typedef struct {
    // ---------- Identity ----------
    uint64_t nickname;
    uint32_t exp;

    uint32_t sid     :16;
    uint32_t nature  :5;
    uint32_t ability :2;
    uint32_t gender  :2;
    uint32_t form    :6;
    uint32_t shiny   :1;

    // ---------- Genetics ----------
    uint32_t iv_hp      :5;
    uint32_t iv_atk     :5;
    uint32_t iv_def     :5;
    uint32_t iv_spa     :5;
    uint32_t iv_spd     :5;
    uint32_t iv_spe     :5;
    uint32_t spare_iv   :2;

    uint32_t ev_hp      :8;
    uint32_t ev_atk     :8;
    uint32_t ev_def     :8;
    uint32_t ev_spa     :8;

    uint32_t ev_spd     :8;
    uint32_t ev_spe     :8;
    uint32_t current_hp :16;

    // ---------- Moveset ----------
    uint32_t move0  :16;
    uint32_t pp0    :6;
    uint32_t ppups0 :2;
    uint32_t move1  :16;
    uint32_t pp1    :6;
    uint32_t ppups1 :2;

    uint32_t move2  :16;
    uint32_t pp2    :6;
    uint32_t ppups2 :2;
    uint32_t move3  :16;
    uint32_t pp3    :6;
    uint32_t ppups3 :2;

    // ---------- Battle ----------
    uint32_t held_item :13;
    uint32_t status    :3;
    uint32_t ball      :5;
    uint32_t type_a    :5;
    uint32_t type_b    :5;
    uint32_t spare_btl :1;

    // ---------- Misc ----------
    uint32_t friendship :8;
    uint32_t met_year   :12;  // 0–4095
    uint32_t met_month  :4;   // 1–12
    uint32_t met_day    :5;   // 1–31
    uint32_t exp_curve  :3;
} Pokemon;
```

# Structure

- resources
    - layouts // various pages
        - home
        - pc
    - sprites // various packed sprites
        - environment
        - pokemon
        - items
        - icons
- src
    - main // core loop
    - garth // connection to garmin connect api
        - oauth
        - sleep
    - game // only game mechanics, no checking of complications
        - pc
        - pokedex
        - battle
        - catch
    - activity // translate activity to in game rewards, check for special events
        - background
        - steps
        - sleep
        - exercise
    - graphics // render various graphics
        - home
        - battle
        - sprite
        - environment
    - interaction // menus
