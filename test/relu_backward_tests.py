#!/usr/bin/python

import csv
import random
import struct
import argparse

data_file_name = 'test_data/relu_backward_test_data.hex'

# convert floating point value to hex value
def float_to_hex(f):
	vec = []
	for i in range( 0, len(f) ):
		vec.append( format(struct.unpack('<I', struct.pack('<f', f[i]))[0], 'x') )
	return vec

#####################################################################
# the test data file will consist of hexadecimal values without the 
# '0x' prefix since Quartus doesn't like that. 
# 
# Each row will contain:
#	2*VECTOR_LENGTH 32-bit floating-point vals 
#  where row structure (order) is:
# (1): VECTOR_LENGTH input 32-bit floats, followed by
# (2): VECTOR_LENGTH results from the ReLU operation
# 
# example: //input0, input1, result0, result1
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
	parser.add_argument('--VECTOR_LENGTH', '-l', type=int, default=8,
				help='input vector length (default: 8)')
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
	VECTOR_LENGTH = args.VECTOR_LENGTH
	NEGATIVE_SLOPE = args.NEGATIVE_SLOPE
	FILENAME = args.FILENAME
	DEBUG = args.DEBUG

	with open( FILENAME, 'wb') as data_f:
		print 'Creating test data file...'
		f = csv.writer( data_f, delimiter='\t' )
		# create header for test data file
		header = []
		for i in range( 0, VECTOR_LENGTH ):
			if (i == 0):
				# add input column headers
				header.append( '//input0' )
			else:	
				header.append( 'input' + str(i) )
		for i in range( 0, VECTOR_LENGTH ):
			# add result column header
			header.append( 'result' + str(i) )
		# write header 
		f.writerow( header )
	
		for i in range(0, NUM_TESTS):
			input_vec = []
			output_vec = []
			# build input and output vectors
			for j in range(0, VECTOR_LENGTH):
				# generate a random float value LOWER_RANGE <= input_val < UPPER_RANGE
				input_val = random.uniform( LOWER_RANGE, UPPER_RANGE )
				# if input_val > 0, output = input
				if (input_val > 0):
					output_val = input_val;
				# else, output = NEGATIVE_SLOPE (usually 0)
				else:
					output_val = NEGATIVE_SLOPE
				# add to vectors
				input_vec.append( input_val )
				output_vec.append( output_val )
			f.writerow( float_to_hex(input_vec) + float_to_hex(output_vec) )	
			# for debugging/sanity check..
			if (DEBUG):	
				f.writerow( input_vec + output_vec )	


if __name__ == '__main__':
	main()
