#

# from https://www.youtube.com/watch?v=Kr1RyK6WENQ&t=437s
# to detect ports: python -m serial.tools.list_ports

import serial

ser = serial.Serial(port='COM8',baudrate=9600)
switchOn="1"
switchOff="2"



while True:
    ser.write(bytes(switchOn,'utf-8'))
    value= ser.readline()
    valueInString=str(value,'UTF-8')
    print(valueInString)