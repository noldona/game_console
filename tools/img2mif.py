from PIL import Image
import pathlib
import sys

# Palette (Hex)
# Binary    000     001     010     011     100     101     110     111
# Red       #000000 #240000 #490000 #6D0000 #920000 #B60000 #DB0000 #FF0000
# Green     #000000 #002400 #004900 #006D00 #009200 #00B600 #00DB00 #00FF00
# Blue      #000000 #000055 #0000AA #0000FF
# Binary    00      01      10      11

# Palette (RGB)
# Binary    000     001     010     011     100     101     110     111
# Red       00      36      73      109     146     182     219     255
# Green     00      36      73      109     146     182     219     255
# Blue      00      85      170     255
# Binary    00      01      10      11

RED = {
    0:   0b00000000,
    36:  0b00100000,
    73:  0b01000000,
    109: 0b01100000,
    146: 0b10000000,
    182: 0b10100000,
    219: 0b11000000,
    255: 0b11100000
}

GREEN = {
    0:   0b00000000,
    36:  0b00000100,
    73:  0b00001000,
    109: 0b00001100,
    146: 0b00010000,
    182: 0b00010100,
    219: 0b00011000,
    255: 0b00011100
}

BLUE = {
    0:   0b00000000,
    85:  0b00000001,
    170: 0b00000010,
    255: 0b00000011
}


def rgb_to_byte(r, g, b):
    return bytes([RED[r] | GREEN[g] | BLUE[b]])


def rgb_to_hex_str(r, g, b):
    return '{:02x}'.format(RED[r] | GREEN[g] | BLUE[b])


def print_usage():
    print("Usage: %s <image file>" % sys.argv[0])


if len(sys.argv) < 1:
    print_usage()
    exit(1)

source_filename = sys.argv[1]
output_path = pathlib.Path(source_filename).parent

try:
    image = Image.open(source_filename)
    image = image.convert("RGB")
    pixels = image.load()

    dest = pathlib.Path(output_path).joinpath(pathlib.Path(source_filename).stem + ".mif")
    with dest.open('w') as fh:
        for y in range(240):
            for x in range(320):
                try:
                    fh.write(f"{rgb_to_hex_str(*pixels[x, y])}\n")
                except IndexError:
                    fh.write(f"{chr(0):02x}\n")
except OSError:
    print("File error")
