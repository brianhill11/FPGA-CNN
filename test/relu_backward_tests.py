#!/usr/bin/python

import csv
import random
import struct

NUM_TESTS = 10000
filename = 'test_data/relu_backward_test_data.hex'
UPPER_RANGE = 100
LOWER_RANGE = -100
NEGATIVE_SLOPE = 0.0
DEBUG = 0

# convert floating point value to hex value
def float_to_hex(f):
	return format(struct.unpack('<I', struct.pack('<f', f))[0], 'x')

def main():
	with open( filename, 'wb') as data_f:
		f = csv.writer( data_f, delimiter='\t' )
		for i in range(0, NUM_TESTS):
			# generate a random float value LOWER_RANGE <= a < UPPER_RANGE
			a = random.uniform( LOWER_RANGE, UPPER_RANGE )
			# if a > 0, output = input
			if (a > 0):
				b = a;
			# else, output = NEGATIVE_SLOPE (usually 0)
			else:
				b = NEGATIVE_SLOPE

			f.writerow( [float_to_hex(a), float_to_hex(b)] )	


if __name__ == '__main__':
	main()
