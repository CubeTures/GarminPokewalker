import requests
from bs4 import BeautifulSoup


def fetch_soup(url: str) -> BeautifulSoup | None:
    try:
        response = requests.get(url, timeout=10)
        if response.status_code != 200:
            return None
        return BeautifulSoup(response.content, "html.parser")
    except Exception as e:
        print(f"Error fetching {url}: {e}")
        return None
