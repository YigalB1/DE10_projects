import serial
import sys
import time
import serial.tools.list_ports

ftdi_name= "CP210x"
baud=115200

def list_serial_ports():
    """Lists serial ports."""
    ports = serial.tools.list_ports.comports()
    if not ports:
        print("No serial ports found.")
        return None
    else:
        #print("Available serial ports:")
        for port, desc, hwid in sorted(ports):
            #print(f"{port}: {desc} [{hwid}]")
            if ftdi_name in desc:
                #print("it's me!!" + " " + port)
                return port
        return None
            

def create_serial_port(port, baudrate):
    """Creates and returns a serial port object."""
    try:
        ser = serial.Serial(port, baudrate)
        #print(f"Connected to {port} at {baudrate} baud (inside function)")
        return ser
    except serial.SerialException as e:
        print(f"Serial port error in function: {e}")
        return None
    

def send_byte(ser,val_to_send):
    ser.write(val_to_send)




def read_uart(ser):
    start_time = time.time()  # Current time in seconds
    end_time = start_time + 10  # +30 seconds
    while time.time() < end_time:
        if ser.in_waiting > 0:
            #print("got it! ")
            available_bytes = ser.in_waiting
            #print("available bytes in queue: " + str(available_bytes))
            byte = ser.read(1)  # Read a single byte
            #print(f"Received byte: {byte.hex()}")  # Print byte as hex
            return byte                
        else:
            #print(".", end='') # no new line
            time.sleep(0.01)
    return None