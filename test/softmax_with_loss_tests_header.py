#!/usr/bin/python

import csv
import random
import struct
import argparse
import numpy as np

data_file_name = 'test_data/softmax_with_loss_test_data.vh'

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
	parser.add_argument('--FILENAME', '-f', default=data_file_name,
				help='location/filename of data file to create')
	parser.add_argument('--DEBUG', '-d', action='store_true', default=False,
				help='flag for debug (default: False)')
	args = parser.parse_args()	

	NUM_TESTS = args.NUM_TESTS
	UPPER_RANGE = args.UPPER_RANGE
	LOWER_RANGE = args.LOWER_RANGE
	VECTOR_LENGTH = args.VECTOR_LENGTH
	FILENAME = args.FILENAME
	DEBUG = args.DEBUG

	with open( FILENAME, 'wb') as data_f:
		print 'Creating test data file...'
		f = csv.writer( data_f, delimiter='\t' )
		# create header for test data file
		f.writerow( ['`ifndef SOFTMAX_WITH_LOSS_TEST_H'] )
		f.writerow( ['`define SOFTMAX_WITH_LOSS_TEST_H'] )
		# define memory array 
		f.writerow( ['reg [31:0] test_input [' + str(VECTOR_LENGTH*NUM_TESTS) + '];'] )
		f.writerow( ['reg [31:0] test_label [' + str(NUM_TESTS) + '];'] )
		f.writerow( ['reg [31:0] test_sub [' + str(VECTOR_LENGTH*NUM_TESTS) + '];'] )
		f.writerow( ['reg [31:0] test_exp [' + str(VECTOR_LENGTH*NUM_TESTS) + '];'] )
		f.writerow( ['reg [31:0] test_sum [' + str(NUM_TESTS) + '];'] )
		f.writerow( ['reg [31:0] test_div [' + str(NUM_TESTS) + '];'] )
		f.writerow( ['reg [31:0] test_output [' + str(NUM_TESTS) + '];'] )
		# add 'initial begin'
		f.writerow( ['initial begin'] )
		# add data to header file
		for i in range(0, NUM_TESTS*VECTOR_LENGTH, VECTOR_LENGTH):
			# generate a random vector of floats: LOWER_RANGE <= a < UPPER_RANGE
			input_vec = np.random.uniform( LOWER_RANGE, UPPER_RANGE, VECTOR_LENGTH )
			# generate a random integer label from 0 < UPPER_RANGE
			#label = np.random.randint( 0, VECTOR_LENGTH )
			label = np.argmax( input_vec )
			# scale input vector by subtracting label value from all values to prevent overflow 
			scaled_input_vec = np.subtract( input_vec, np.repeat( input_vec[label], VECTOR_LENGTH ) )
			# compute exp of every element in input_vec
			exp_vec = np.exp( scaled_input_vec )
			# calculate sum of exp_vec
			exp_vec_sum = np.sum( exp_vec )
			# exp of scaled label value
			exp_label = np.exp( scaled_input_vec[label] )
			# divide exp of label by sum of all exps
			div = np.divide( exp_label, exp_vec_sum )
			# compute the log loss
			output = np.multiply( np.log( div ), -1.0 )
			# write row to file
			f.writerow( build_data_line( 'test_input', input_vec, i, 'hex' ) )
			f.writerow( build_data_line( 'test_label', input_vec[label], i/VECTOR_LENGTH, 'hex' ) )
			f.writerow( build_data_line( 'test_sub', scaled_input_vec, i, 'hex' ) )
			f.writerow( build_data_line( 'test_exp', exp_vec, i, 'hex' ) )
			f.writerow( build_data_line( 'test_sum', exp_vec_sum, i/VECTOR_LENGTH, 'hex' ) )
			f.writerow( build_data_line( 'test_div', div, i/VECTOR_LENGTH, 'hex' ) )
			f.writerow( build_data_line( 'test_output', output, i/VECTOR_LENGTH, 'hex' ) )
			# for debugging/sanity check..
			if (DEBUG):	
				f.writerow( ["/*############ DEBUG ############"] )
				f.writerow( build_data_line( 'test_input', input_vec, i, 'float' ) )
				f.writerow( build_data_line( 'test_label', input_vec[label], i/VECTOR_LENGTH, 'float' ) )
				f.writerow( build_data_line( 'test_sub', scaled_input_vec, i, 'float' ) )
				f.writerow( build_data_line( 'test_exp', exp_vec, i, 'float' ) )
				f.writerow( build_data_line( 'test_sum', exp_vec_sum, i/VECTOR_LENGTH, 'float' ) )
				f.writerow( build_data_line( 'test_div', div, i/VECTOR_LENGTH, 'float' ) )
				f.writerow( build_data_line( 'test_output', output, i/VECTOR_LENGTH, 'float' ) )
				f.writerow( ["############ END DEBUG ############*/"] )


		# end the 'initial begin' statement
		f.writerow( ['end'] )
		# add endif statement
		f.writerow( ['`endif'] )


if __name__ == '__main__':
	main()
