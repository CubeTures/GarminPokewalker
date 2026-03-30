// "konstants"
module K {
    const POS_STEP = 29;
    const POS_CENTER = 88;

    enum Position {
        POS_0 = 1,
        POS_1 = 30,
        POS_2 = 59,
        POS_3 = 88,
        POS_4 = 117,
        POS_5 = 146,
        POS_6 = 175,
    }

    const SPRITE_WIDTH = 42;
    const SPRITE_HEIGHT = 32;

    const META_START_INDEX_SIZE = 2;
    const META_NUM_ENTRIES_SIZE = 2;
    const META_ENTRY_LEN_SIZE = 2;
    const META_SIZE =
        META_START_INDEX_SIZE + META_NUM_ENTRIES_SIZE + META_ENTRY_LEN_SIZE;
    const VARIABLE_LENGTH_SIZE = 2;

    const STRING_UNK = "UNKNOWN";
}
