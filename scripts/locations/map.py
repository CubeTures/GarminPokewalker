import json
from bs4 import Tag, Comment
from typing import Any

import scripts.utils.paths as paths
import scripts.scrape.html as html
import scripts.utils.utils as utils


GAME_MAP = {
    "markers_super": "smd",
    "markers_rescue": "rt",
    "markers_explorers": "exp",
    "markers_gates": "gti",
    "markers_other": "etc",
}


def parse_map_locations() -> None:
    soup = html.load_soup(f"{paths.DATA}/map.html")
    data: list[dict[str, Any]] = []

    for container_id, game_code in GAME_MAP.items():
        container = soup.find("div", id=container_id)
        if not isinstance(container, Tag):
            continue
        for marker in container.find_all("div", class_="poi marker"):
            link = marker.find("a")
            if not isinstance(link, Tag):
                continue

            continent: str | None = None
            for sibling in marker.previous_siblings:
                if isinstance(sibling, Comment):
                    continent = sibling.strip().replace(" Continent", "")
                    break

            location: str = link.get_text(separator=" ", strip=True)
            location = location.split("(")[0].strip()
            style: str = marker.get("style", "")  # type: ignore[assignment]
            x, y = html.extract_marker_position(style)
            data.append(
                {
                    "continent": continent,
                    "location": location,
                    "game": game_code,
                    "x": x,
                    "y": y,
                }
            )

    utils.write_file(f"{paths.OUTPUT}/locations/map_locations.json", json.dumps(data))
