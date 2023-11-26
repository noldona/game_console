import os
import pathlib
import struct
import sys


class BinaryEOFException(Exception):
    def __init__(self) -> None:
        pass

    def __str__(self) -> str:
        return "Premature end of file"


class BinaryReader:
    def __init__(self, filename) -> None:
        self.file = open(filename, 'rb')

    def unpack(self, type_format):
        type_size = struct.calcsize(type_format)
        value = self.file.read(type_size)
        if type_size != len(value):
            raise BinaryEOFException
        return struct.unpack(type_format, value)[0]

    def __del__(self) -> None:
        self.file.close()


def print_usage():
    print("Usage: %s <bin file>" % sys.argv[0])


if len(sys.argv) < 1:
    print_usage()
    exit(1)

source_filename = sys.argv[1]
output_path = pathlib.Path(source_filename).parent

try:
    width_in_bits = 8
    source_file_size = os.path.getsize(source_filename)
    if source_file_size == 0:
        print("Empty file")
        exit(0)
    binaryReader = BinaryReader(source_filename)

    dest = pathlib.Path(output_path).joinpath(pathlib.Path(source_filename).stem + ".mif")
    with dest.open('w') as fh:
        for i in range(source_file_size):
            value = binaryReader.unpack("B")
            fh.write(f"{value:02x}\n")

except OSError:
    print("File error")

