import serial
import sys
import time
import serial.tools.list_ports
import random


ftdi_name= "CP210x"
baud=115200

import utils



com_port=None # init it
if __name__ == "__main__":
    com_port= utils.list_serial_ports()

if com_port is None:
    print("Failed to open the FTDI port")
    sys.exit()

if type(com_port) is not str:
    print("com_port is NOT available ")
    sys.exit()

#print("I am the port:  " + com_port, end='')
ser = utils.create_serial_port(com_port, baud)
#print("Ser port created.... ", end='')

my_byte = bytes([0x64])
utils.send_byte(ser,my_byte)
#print("Byte sent  ", end='')

ret_byte = utils.read_uart(ser)
if ret_byte is None:
    print("failed to read port - is FPGA programmed?")
    sys.exit()


good_num=0
bad_num=0
#for i in range(0x10, 0x13, 1):  # from 10 to 20, steps pf 1
t_start = time.time() 
for i in range(1000):
    random_byte = random.randint(0, 255)
    #print(random_byte)
    my_byte = bytes([random_byte])
    utils.send_byte(ser,my_byte)
    #print("Byte sent  ", end='')

    ret_byte=utils.read_uart(ser)
    if ret_byte is None:
        print("failed to read port while in Loop. exiting.")
        sys.exit()
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
ser.close()



sys.exit()


random_byte = random.randint(0, 255)
print(random_byte)
