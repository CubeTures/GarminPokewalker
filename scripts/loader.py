import json
from copy import deepcopy
from typing import Any, Callable
import constants


class Sprite:
    idx: int
    name: str
    slug: str
    form: str
    form_i: int
    is_female: bool = False
    is_right: bool = False
    is_shiny: bool = False

    def get_path(self) -> str:
        root: str = "shiny" if self.is_shiny else "regular"
        nest: str = "female" if self.is_female else ("right" if self.is_right else "")
        nest: str = f"/{nest}" if nest else ""
        mod: str = self.form if self.form != "$" else ""
        mod: str = f"-{mod}" if mod else ""
        return f"scripts/pokesprite/pokemon-gen7x/{root}{nest}/{self.slug}{mod}.png"

    def get_target(self) -> str:
        f: str = "f" if self.is_female else ""
        r: str = "r" if self.is_right else ""
        s: str = "s" if self.is_shiny else ""
        _ = "_" if f or r or s else ""
        return f"{self.idx}_{self.form_i}{_}{f}{r}{s}"


def import_sprites():
    sprites: list[Sprite] = []

    with open("scripts/pokesprite/data/pokemon.json") as file:
        pokemon: dict[str, Any] = json.load(file)

        for data in pokemon.values():
            if data["gen-7"] == {}:
                continue

            aliases: list[str] = []

            base = Sprite()
            base.idx = int(data["idx"])
            base.name = data["name"]["eng"]
            base.slug = data["slug"]["eng"]

            if base.idx in constants.skip_mons:
                continue

            def form_filter(data: tuple[str, Any]) -> bool:
                _, details = data
                return not details.get("is_alias_of")

            def form_key(data: tuple[str, Any]) -> int:
                form, details = data
                if form == "$":
                    priority = 0
                elif details["has_right"]:
                    priority = 1
                else:
                    priority = 2
                return priority

            forms: dict[str, Any] = data["gen-7"]["forms"]
            forms_filtered = filter(form_filter, forms.items())
            forms_sorted = list(sorted(forms_filtered, key=form_key))
            for i, [form, details] in enumerate(forms_sorted):
                if form in ["galar", "starter"]:
                    continue

                if details.get("is_unofficial_icon"):
                    continue

                has_female = details["has_female"] and not details.get(
                    "has_unofficial_female_icon"
                )
                has_right = details["has_right"]

                aliases.append(form)
                sprite = deepcopy(base)
                sprite.form = form
                sprite.form_i = i
                sprites.append(sprite)

                if has_female:
                    female = deepcopy(sprite)
                    female.is_female = True
                    sprites.append(female)

                if has_right:
                    right = deepcopy(sprite)
                    right.is_right = True
                    sprites.append(right)

    return sprites


def partition_sprites(sprites: list[Sprite]) -> list[list[Sprite]]:
    partition: list[list[Sprite]] = []

    def add_partition(check: Callable[[Sprite], bool]):
        collection: list[Sprite] = []
        for sprite in sprites:
            if check(sprite):
                collection.append(sprite)
        partition.append(collection)

    add_partition(
        lambda sprite: (
            not sprite.is_female and sprite.form == "$" and not sprite.is_right
        )
    )
    add_partition(
        lambda sprite: (sprite.is_female and sprite.form == "$" and not sprite.is_right)
    )
    add_partition(
        lambda sprite: (
            not sprite.is_female and sprite.form != "$" and not sprite.is_right
        )
    )
    add_partition(
        lambda sprite: (not sprite.is_female and sprite.form == "$" and sprite.is_right)
    )
    add_partition(
        lambda sprite: (not sprite.is_female and sprite.form != "$" and sprite.is_right)
    )

    return partition
