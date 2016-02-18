#!/usr/bin/python

import csv
import random
import struct
import argparse
import numpy as np

data_file_name = 'test_data/relu_forward_test_data.vh'

# convert floating point value to hex value
def float_to_hex(f):
	return format(struct.unpack('<I', struct.pack('<f', f))[0], 'x') 

def build_data_line(vec_name, vec, start_index, hex_or_float):
	# if given a single float, try statement will fail 
	try:
		# build assignment 
		line = vec_name + '[' + str(start_index) + ':' + str(start_index + len(vec)-1) + '] = \'{'
		# for each val in vector, add to array literal
		for i in range( 0, len(vec) ):
			if (i != len(vec)-1):
				if (hex_or_float == 'hex'):
					line = line + '32\'h' + float_to_hex( vec[i] ) + ', '
				else:
					line = line + str(vec[i]) + ', '
			else:
				if (hex_or_float == 'hex'):
					line = line + '32\'h' + float_to_hex( vec[i] ) + '};'
				else:
					line = line + str(vec[i]) + '};'
	except TypeError:
		line = vec_name + '[' + str(start_index) + '] = \'{'
		if (hex_or_float == 'hex'):
			line = line + '32\'h' + float_to_hex( vec ) + '};'
		else:
			line = line + str(vec) + '};'
	return [line]

#####################################################################
# the test data file will consist of hexadecimal values without the 
# '0x' prefix since Quartus doesn't like that. 
# 
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
		f.writerow( ['`ifndef RELU_FORWARD_TEST_H'] )
		f.writerow( ['`define RELU_FORWARD_TEST_H'] )
		# define memory array 
		f.writerow( ['reg [31:0] test_input [' + str(VECTOR_LENGTH*NUM_TESTS) + '];'] )
		f.writerow( ['reg [31:0] test_output [' + str(VECTOR_LENGTH*NUM_TESTS) + '];'] )
		# add 'initial begin'
		f.writerow( ['initial begin'] )
		# add data to header file
		for i in range(0, NUM_TESTS*VECTOR_LENGTH, VECTOR_LENGTH):
			# generate a random float value LOWER_RANGE <= input_val < UPPER_RANGE
			input_vec = np.random.uniform( LOWER_RANGE, UPPER_RANGE, VECTOR_LENGTH )
			output_vec = []
			# build input and output vectors
			for j in range(0, VECTOR_LENGTH):
				# if input_val > 0, output = input
				if (input_vec[j] > 0):
					output_vec.append( input_vec[j] );
				# else, output = NEGATIVE_SLOPE (usually 0)
				else:
					output_vec.append( input_vec[j]*NEGATIVE_SLOPE )
			f.writerow( build_data_line( 'test_input', input_vec, i, 'hex' ) )
			f.writerow( build_data_line( 'test_output', output_vec, i, 'hex' ) )
			# for debugging/sanity check..
			if (DEBUG):	
				f.writerow( ["/*############ DEBUG ############"] )
				f.writerow( build_data_line( 'test_input', input_vec, i, 'float' ) )
				f.writerow( build_data_line( 'test_output', output_vec, i, 'float' ) )
				f.writerow( ["############ END DEBUG ############*/"] )
		
		# end the 'initial begin' statement
		f.writerow( ['end'] )
		# add endif statement
		f.writerow( ['`endif'] )


if __name__ == '__main__':
	main()
