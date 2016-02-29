`timescale 1ns/100ps
`define DEBUG 1
module pooling_backward_layer_tb();
	`include "/home/b/bear_git/FPGA-CNN/test/test_data/pooling_backward_test_data.vh"
	parameter CYCLE			= 5;
	parameter MULT_DELAY		= 5;
	parameter KERNEL_WIDTH	= 3;
	parameter KERNEL_HEIGHT	= 3;
	parameter WIDTH			= KERNEL_WIDTH*KERNEL_HEIGHT;
	
	parameter NUM_TESTS		= 5000;
	parameter MEM_SIZE		= NUM_TESTS*WIDTH;

	
	reg clk, reset;
	logic [31:0] in_vec			[WIDTH-1:0];			//input vec to module
	logic [7:0]	 in_idx;
	logic [31:0] in_err_term;
	logic [31:0] out_data		[WIDTH-1:0];				//output from module
	int i, j, k, num_errors, num_depth, delay;

	//initialize clk
	initial begin
		clk = 0;
	end

	//forever cycle the clk
	always begin
		#(CYCLE/2.0) clk = ~clk;
	end

	//instantiate the module
	pooling_backward_opt #( .k_w(KERNEL_WIDTH), .k_h(KERNEL_HEIGHT) )
		pooling_backward_tbmodule	(
												.reset_n			(reset),	//reset
												.clk				(clk),		//clock
												.max_flt_idx	(in_idx),
												.data_vect_in	(in_vec),	//Vector data input
												.error_term		(in_err_term),

												.data_vect_out	(out_data)	//Vector data output
											);

	initial begin
		reset = 0;
		num_errors = 0;

		//calculate total delay of one calculation
		//one multiplication, plus one cycle to load operand, one to load result
		delay = CYCLE*(MULT_DELAY + 3); 

		//for all test cases
		 for (i = 0; i < MEM_SIZE; i = i + WIDTH) begin
			//copy each value to input vector
			
			for (j = 0; j < WIDTH; j++) begin
				in_vec[j] = test_input[i+j];
			end

			in_idx = test_index[i/WIDTH];
			in_err_term = test_error_term[i/WIDTH];

			//wait for computation to finish
			#(delay)
			
			$display("test case: %d\t", i/WIDTH);
			$display("test idx: %d\t", in_idx);
			$display("err_term: %h\t", in_err_term);
			`ifdef DEBUG
				$display("in_vec\t test_input");
				for (j = 0; j < WIDTH; j++) begin
					$display("%h\t%h", in_vec[j], test_input[i+j]);
				end
				$display("out_data\t test_output\t");
				for (j = 0; j < WIDTH; j++) begin
					$display("%h\t%h", out_data[j], test_output[i+j]);
				end
			`endif

			if( out_data[in_idx] != test_output[i+in_idx]) begin
				//if the number was off because of a rounding error, ignore
				if ( out_data[in_idx] - test_output[i+in_idx] < 32'h000000ff || 
						test_output[i+in_idx] - out_data[in_idx] < 32'h000000ff ) begin
					`ifdef DEBUG
						$display("rounding error");
					`endif
				//otherwise, complain 
				end else begin
					assert( out_data == test_output[i+in_idx] );
					$display("output: %h\tcalculated: %h", out_data[in_idx], test_output[i+in_idx]);
					num_errors++;
				end
			end

			$display("\n\n");

		end
		$display("############################################\n");
		$display("Testing complete!\n");
		$display("%d of %d tests passed\n", NUM_TESTS-num_errors, NUM_TESTS);
		$display("(%f percent)\n", 100.0*(NUM_TESTS-num_errors)/NUM_TESTS);
		$display("############################################\n");
	end

endmodule
