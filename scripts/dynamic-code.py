import os


def xml():
    output = """<resources xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="https://developer.garmin.com/downloads/connect-iq/resources.xsd">\n"""

    sheets = os.listdir("scripts-custom/pack-output")
    for i in range(len(sheets)):
        output += (
            f"""\t<bitmap id="sprites_{i}" filename="{i}.png" compress="true"/>\n"""
        )

    output += "</resources>"

    with open("scripts-custom/sprites.xml", "w") as file:
        file.write(output)


def mc():
    # sprites = import_sprites()
    # for the basic form, use if statements with 
    pass


if __name__ == "__main__":
    xml()
    mc()
