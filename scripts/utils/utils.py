import os
import json
import re
import unicodedata
from typing import Any


def capitalize(string: str) -> str:
    return string[0].upper() + string[1:]


def read_json(path: str) -> Any:
    result: dict[Any, Any] = {}
    with open(path) as file:
        result = json.load(file)
    return result


def write_file(path: str, contents: str):
    dir, _ = os.path.split(path)
    os.makedirs(dir, exist_ok=True)
    with open(path, "w") as file:
        file.write(contents)


# Source - https://stackoverflow.com/a/69079951
# Posted by azro
# Retrieved 2026-03-06, License - CC BY-SA 4.0


def snake_case(string: str) -> str:
    string = (
        re.sub(r"(?<=[a-z])(?=[A-Z])|[^a-zA-Z]", " ", string).strip().replace(" ", "_")
    )
    return "".join(string.lower())


def to_ascii(s: str) -> str:
    return unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")