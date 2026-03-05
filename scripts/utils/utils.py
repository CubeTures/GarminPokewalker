import os
import json
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
