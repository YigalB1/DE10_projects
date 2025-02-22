#

# from https://www.youtube.com/watch?v=Kr1RyK6WENQ&t=437s
# to detect ports: python -m serial.tools.list_ports

import serial
import sys
import time

import serial.tools.list_ports

ftdi_name= "CP210x"


def list_serial_ports():
    """Lists serial ports."""
    ports = serial.tools.list_ports.comports()
    if not ports:
        print("No serial ports found.")
    else:
        print("Available serial ports:")
        for port, desc, hwid in sorted(ports):
            print(f"{port}: {desc} [{hwid}]")
            if ftdi_name in desc:
                print("it's me!!" + " " + port)
                return port

if __name__ == "__main__":
    com_port= list_serial_ports()



if type(com_port) is not str:
    print("com_port is NOT available ")
    sys.exit()


print("it's me again!!" + " " + com_port)

#ser = serial.Serial(port='COM8',baudrate=9600)
ser = serial.Serial(port=com_port,baudrate=115200)
print("ser is  " + " " + ser.port)

if (ser.port==com_port):
    print("port connected OK")
else:
    print("port connection FAILED")
    sys.exit()

#        print(f"Connected to {port} at {baudrate} baud")



start_time = time.time()  # Get the current time in seconds
end_time = start_time + 30  # Calculate the end time (1 minute later)

ser.write(bytes("x",'utf-8'))
while time.time() < end_time:
    if ser.in_waiting > 0:
        print("got it! ")
        byte = ser.read(1)  # Read a single byte
        print(f"Received byte: {byte.hex()}")  # Print byte as hex                
    else:
        print(".", end='') # no new line
        time.sleep(1)

sys.exit()
count = 0
while count < 15:
    ser.write(count)
    time.sleep(1)  # Small delay
    if ser.in_waiting > 0:
        

        byte = ser.read(1)  # Read a single byte
        print(f"Received byte: {byte.hex()}")  # Print byte as hex
    count += 1


sys.exit()

