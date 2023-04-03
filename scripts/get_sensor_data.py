#!/usr/bin/env python3

from pymodbus.client import ModbusSerialClient as ModbusClient

# for mac find serial port name with the following command: ls /dev/tty.usb*
port = "/dev/tty.usbserial-1420" # variable

def s16(value): # two's complement for 16 bits
    return -(value & 0x8000) | (value & 0x7fff)

client = ModbusClient(method='rtu', port=port, baudrate=4800, bytesize=8, parity='N', stopbits=1, timeout=20.0)
connection = client.connect()

read_vals  = client.read_holding_registers(0, 7, 1) # start_address, count, slave_id
values = read_vals.registers
humidity = values[0]/10  # %
temperature =  s16(values[1])/10 # celcius in twos complement
ph = values[3]/10
nitrogen = values[4] # mg
phosphorus = values[5] # mg
potassium = values[6] # mg

print("humidity:", humidity, "%")
print("temperature:", temperature, "℃")
print("ph:", ph)
print("nitrogen:", nitrogen, "mg")
print("phosphorus:", phosphorus, "mg")
print("potassium:", potassium, "mg")


