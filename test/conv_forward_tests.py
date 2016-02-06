#!/usr/bin/python

import csv
import random
import struct
import numpy as np
import argparse

data_file_name = 'test_data/conv_forward_test_data.hex'

# convert floating point value to hex value
def float_to_hex(f):
	return format(struct.unpack('<I', struct.pack('<f', f))[0], 'x')

#####################################################################
# the test data file will consist of hexadecimal values without the 
# '0x' prefix since Quartus doesn't like that. 
# 
# Each row will contain [VECTOR_LENGTH*2 + 1] 32-bit floating-point vals:
# (1): input data vector of length VECTOR_LENGTH 
# (2): weight data vector of length VECTOR_LENGTH 
# (3): result from the dot product of the input data and weights
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
	parser.add_argument('--FILENAME', '-f', default=data_file_name,
				help='location/filename of data file to create')
	args = parser.parse_args()	

	NUM_TESTS = args.NUM_TESTS
	FILENAME = args.FILENAME
	UPPER_RANGE = args.UPPER_RANGE
	LOWER_RANGE = args.LOWER_RANGE
	VECTOR_LENGTH = args.VECTOR_LENGTH
	
	with open( FILENAME, 'wb') as data_f:
		print 'Creating test data file...'
		f = csv.writer( data_f, delimiter='\t' )
		# create header for test data file
		header = []
		# add input column headers
		for i in range( 0, VECTOR_LENGTH ):
			#add comment char to first column
			if (i == 0):
				header.append( '//input0' )
			else:
				header.append( 'input' + str(i) )
		# add weight column headers
		for i in range( 0, VECTOR_LENGTH ):
			header.append( 'weight' + str(i) )
		# add result column header
		header.append( 'result' )
		# write header 
		f.writerow( header )

		# generate random values for input data, weights, and compute dot product
		for i in range( 0, NUM_TESTS ):
			# generate a random vector of floats: LOWER_RANGE <= a < UPPER_RANGE
			input_vec = np.random.uniform( LOWER_RANGE, UPPER_RANGE, VECTOR_LENGTH )
			weight_vec = np.random.uniform( LOWER_RANGE, UPPER_RANGE, VECTOR_LENGTH )
			# take the dot product
			result = np.dot( input_vec, weight_vec )
			# add all values to list to be written
			row = []
			for i in input_vec:
				row.append( float_to_hex(i) )
			for i in weight_vec:
				row.append( float_to_hex(i) )
			row.append( float_to_hex(result) )
			# write row to file
			f.writerow( row )	

		print 'Finished creating test data file'

if __name__ == '__main__':
	main()
