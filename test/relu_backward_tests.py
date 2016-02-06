#!/usr/bin/python

import csv
import random
import struct
import argparse

data_file_name = 'test_data/relu_backward_test_data.hex'

# convert floating point value to hex value
def float_to_hex(f):
	return format(struct.unpack('<I', struct.pack('<f', f))[0], 'x')

#####################################################################
# the test data file will consist of hexadecimal values without the 
# '0x' prefix since Quartus doesn't like that. 
# 
# Each row will contain:
#	2 32-bit floating-point vals 
#  where row structure (order) is:
# (1): input 32-bit float
# (2): result from the ReLU operation
# 
# example: //input0, result
#####################################################################
def main():
	# parse command line arguments
	parser = argparse.ArgumentParser()
	parser.add_argument('--NUM_TESTS', '-n', type=int, default=10000,
				help='number of tests to generate (default: 10000)')
	parser.add_argument('--UPPER_RANGE', '-ur', type=int, default=100,
				help='upper range of random number gen (default: 100)')
	parser.add_argument('--LOWER_RANGE', '-lr', type=int, default=-100,
				help='lower range of random number gen (default: -100)')
	parser.add_argument('--NEGATIVE_SLOPE', '-s', type=float, default=0.0,
				help='negative slope value (default: 0.0)')
	parser.add_argument('--FILENAME', '-f', default=data_file_name,
				help='location/filename of data file to create')
	parser.add_argument('--DEBUG', '-d', action='store_true', default=False,
				help='flag for debug (default: False)')
	args = parser.parse_args()	

	NUM_TESTS = args.NUM_TESTS
	UPPER_RANGE = args.UPPER_RANGE
	LOWER_RANGE = args.LOWER_RANGE
	NEGATIVE_SLOPE = args.NEGATIVE_SLOPE
	FILENAME = args.FILENAME
	DEBUG = args.DEBUG

	with open( FILENAME, 'wb') as data_f:
		print 'Creating test data file...'
		f = csv.writer( data_f, delimiter='\t' )
		# create header for test data file
		header = []
		# add input column headers
		header.append( '//input0' )
		# add result column header
		header.append( 'result' )
		# write header 
		f.writerow( header )
	
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
			# for debugging/sanity check..
			if (DEBUG):	
				f.writerow( [a, b] )	


if __name__ == '__main__':
	main()
