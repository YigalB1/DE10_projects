import serial #pip onstall pyserial
import sys
import time
import serial.tools.list_ports
import random

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

def test_many(_ser,_num):
    good_num=0
    bad_num=0
    
    t_start = time.time() 
    for i in range(_num):
        random_byte = random.randint(0, 255)
        #print(random_byte)
        my_byte = bytes([random_byte])
        send_byte(_ser,my_byte)
        #print("Byte sent  ", end='')

        ret_byte=read_uart(_ser)
        if ret_byte is None:
            print("failed to read port while in Loop. exiting.")
            return "failed",good_num,bad_num
        #print("Got: "+ str(ret_byte))

        sent_val = my_byte[0]
        ret_val = ret_byte[0] 
        #print(sent_val)
        #print(ret_val)


        #if(sent_val+1==ret_val):
        if(my_byte[0]+1==ret_byte[0]):
            good_num+=1
        else:
            bad_num+=1

    t_end = time.time() 
    print(str(t_end-t_start))
    elapsed_time = t_end-t_start
    print(f"Elapsed time: {elapsed_time:.4f} seconds")

    print("Good: "+str(good_num) + "     Bad: "+str(bad_num)) 
    return "passed",good_num,bad_num
    #_ser.close()