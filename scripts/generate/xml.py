import scripts.utils.utils as utils


def gen_xml(path: str, entries: list[str]):
    output = f"""<resources xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="https://developer.garmin.com/downloads/connect-iq/resources.xsd">\n\t{"\n\t".join(entries)}\n</resources>"""
    utils.write_file(path, output)
