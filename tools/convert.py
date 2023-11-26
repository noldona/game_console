from PIL import Image

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

def rgb_to_str(r, g, b):
    return 'x"{:02x}", '.format(RED[r] | GREEN[g] | BLUE[b])

def cnt_to_hex(cnt):
    return '{:06x}'.format(cnt * 16).upper()

image = Image.open("test_image_small.png")
image = image.convert("RGB")
pixels = image.load()

out_file = open("test_image_small.bin", "wb")
out_file_2 = open("text_image_small.txt", "w")

cnt = 0
row_cnt = 0

for y in range(150):
    for x in range(200):
        try:
            cnt = cnt + 1
            out_file.write(rgb_to_byte(*pixels[x, y]))
            out_file_2.write(rgb_to_str(*pixels[x, y]))
            if cnt == 16:
                out_file_2.write(' -- {}\n\t\t'.format(cnt_to_hex(row_cnt)))
                cnt = 0
                row_cnt = row_cnt + 1
        except IndexError:
            out_file.write(chr(0))
