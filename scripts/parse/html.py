import re
from bs4 import BeautifulSoup, Tag
from typing import cast


def load_soup(filepath: str) -> BeautifulSoup:
    with open(filepath, "r", encoding="utf-8") as f:
        return BeautifulSoup(f, "html.parser")


def extract_marker_position(style: str) -> tuple[str, str]:
    x_match = re.search(r"left:\s*(\d+)px", style)
    y_match = re.search(r"top:\s*(\d+)px", style)
    return (x_match.group(1) if x_match else "", y_match.group(1) if y_match else "")


def find_section_table(
    soup: BeautifulSoup, heading_id: str, heading_text: str
) -> Tag | None:
    span = soup.find("span", id=heading_id)
    if isinstance(span, Tag):
        heading = span.parent if isinstance(span.parent, Tag) else None
    else:

        def matches(t: Tag) -> bool:
            return heading_text in t if t else False

        result = soup.find(["h2", "h3"], string=cast(None, matches))
        heading = result if isinstance(result, Tag) else None

    if heading is None:
        return None

    table = heading.find_next("table")
    return table if isinstance(table, Tag) else None


def extract_name_from_row(row: Tag, name_cell_index: int = 1) -> str | None:
    cells = row.find_all("td")
    if len(cells) <= name_cell_index:
        return None
    link = cells[name_cell_index].find("a")
    if isinstance(link, Tag):
        name = link.get_text(strip=True)
        return name if name else None
    return None
