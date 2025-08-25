with open("mem_test.mif", "w") as f:
    f.write("DEPTH = 1024;\n")
    f.write("WIDTH = 32;\n")
    f.write("ADDRESS_RADIX = DEC;\n")
    f.write("DATA_RADIX = DEC;\n")
    f.write("CONTENT BEGIN\n")
    for i in range(1024):
        address = f"{i:08X}"
        data = f"{i:08X}"
        f.write(f"    {address} : {data};\n")

    f.write("END;\n")