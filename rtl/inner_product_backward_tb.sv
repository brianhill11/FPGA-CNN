`timescale 1ns/100ps

module inner_product_backward_tb();
	//`include "/nfs/stak/students/z/zhangso/ECE441/inner_product_backward/test_data/ip_backward_test_data.vh"
	`include "/home/b/FPGA-CNN/test/test_data/inner_product_backward_test_data.vh"

	parameter CYCLE			= 5;
	parameter MULT_DELAY		= 5;
	parameter ADD_DELAY		= 7;
	parameter WIDTH			= 8;
	
	parameter NUM_TESTS		= 5000;
	parameter MEM_SIZE		= NUM_TESTS*WIDTH; 

	reg clk, reset;
	logic [31:0] in_vec [WIDTH-1:0];	//input vec to module
	logic [31:0] weight_vec [WIDTH-1:0];	//weight vec to module
	logic [31:0] bias_term;
	logic [31:0] out;			//output from module
	int i, j, num_errors, num_add_levels, delay;
	
	//initialize clk
	initial begin
		clk = 0;
	end
	
	//forever cycle the clk
	always begin
		#(CYCLE/2.0) clk = ~clk;
	end
	
	//instantiate the module 
	ip_backward 	#(.WIDTH(WIDTH))
		ip_backward_inst(
								.clk(clk),
								.reset(reset),
								.in_data(in_vec),
								.weights(weight_vec),
								.bias(bias_term),
								.in_id(8'b0),
								.out_data(out)
								);

	initial begin
		reset = 0;
		num_errors = 0;
		num_add_levels = 1;
		//calculate log2(WIDTH)
		while (WIDTH / (2*num_add_levels) != 1) begin
			num_add_levels++;
		end
		//calculate total delay of one calculation 
		//1 mult delay, log2(WIDTH) add delays to sum products, 1 add delay for bias term
		delay = CYCLE*(MULT_DELAY + ADD_DELAY*(num_add_levels + 1) + 1);
		
		$display("num add levels: %d", num_add_levels);
		//for all test cases
		 for (i = 0; i < MEM_SIZE; i = i + WIDTH) begin
			//copy each value to input vector
			for (j = 0; j < WIDTH; j++) begin
				in_vec[j] = test_input[i+j];
			end
			//copy each value to weight vector
			for (j = 0; j < WIDTH; j++) begin
				weight_vec[j] = test_weights[i+j];
			end
			//copy bias term 
			bias_term = test_bias[i/WIDTH];
			
			//wait for computation to finish
			#(delay)
			
			$display("output: %h\tcalculated: %h", out, test_output[i/WIDTH]);
			if( out != test_output[i/WIDTH] ) begin
				//if the number was off because of a rounding error, ignore
				if ( out - test_output[i/WIDTH] < 32'h000000ff || 
						test_output[i/WIDTH] - out < 32'h000000ff ) begin
					//ignore 
				//otherwise, complain 
				end else begin
					assert( out == test_output[i/WIDTH] );
					$display("output: %h\tcalculated: %h", out, test_output[i/WIDTH]);
					num_errors++;
				end
			end
		end
		$display("############################################\n");
		$display("Testing complete!\n");
		$display("%d of %d tests passed\n", NUM_TESTS-num_errors, NUM_TESTS);
		$display("(%f percent)\n", 100.0*(NUM_TESTS-num_errors)/NUM_TESTS);
		$display("############################################\n");
	end

endmodule
