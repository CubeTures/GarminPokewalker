# Garmin Pokewalker

A re-imagining of the [Pokewalker](https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9walker) for the GarminOS.

> Due to copyright restrictions, this app cannot be published on the Connect IQ Store; if you would like to install this app on your watch you will need to install it yourself. Check the [release tab](https://github.com/CubeTures/GarminPokewalker/releases) for the latest version.

## References

Without these references, this project would not have been possible. Thank you:

- [PokeSprite](https://github.com/msikma/pokesprite), for their extensive documentation and database of sprites;
- [Garth](https://github.com/matin/garth), for documenting the Garmin Connect API (as the API is frustratingly [only available to businesses](https://developer.garmin.com/gc-developer-program/overview/));
- And the [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/discussion/) and their lovely regulars, as they were basically the only source of knowledge outside of the [documentation](https://developer.garmin.com/connect-iq/overview/) I could rely on.

## Contributing

I welcome any and all contributions to this project to improve it. However, there are a few guidelines which you must abide by if you wish for your issue or pull request to be accepted:

1. It must remain compatible and working with all devices already supported
    - It must not exceed the memory and storage limit of the least capable device
    - It must not introduce new, exclusive APIs for anything other than bonus features
    - It must use conditional logic to add new features where necessary
2. The original vision of the app must be maintained
    - The app must remain offline-first
    - The visuals must remain monochrome
3. Constraints should be overcome with clever loading and data storage, not bad coding practices
    - No removing classes unnecessarily to save data
    - No changing out enums and consts to save data
    - Etc.
