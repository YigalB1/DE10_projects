def generate_mif(file_name, data, width=32, depth=1024):
    with open(file_name, 'w') as file:
        file.write("WIDTH={};\n".format(width))
        file.write("DEPTH={};\n".format(depth))
        file.write("ADDRESS_RADIX=HEX;\n")
        file.write("DATA_RADIX=HEX;\n\n")
        file.write("BEGIN\n\n")

        for address, value in enumerate(data):
            file.write("{:08X} : {:0{}X};\n".format(address, value, width // 4))

        file.write("\nEND;\n")

# Example usage
data = [0x00000000, 0xFFFFFFFF, 0x0F0F0F0F, 0xF0F0F0F0] * 256
generate_mif('memory.mif', data)