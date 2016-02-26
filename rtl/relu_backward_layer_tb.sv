`timescale 1ns/100ps

module relu_backward_layer_tb();
	`include "/home/b/FPGA-CNN/test/test_data/relu_backward_test_data.vh"
	parameter CYCLE 			= 5;		//clk period: 5ns = 200Mhz signal
	parameter NEG_SLOPE 		= 0.0;	//negative slope param
	parameter WIDTH 			= 8;		//width of input/output vec
	
	parameter NUM_TESTS 		= 5000;	//number of test iterations
	parameter MEM_SIZE		= NUM_TESTS*WIDTH; 

	reg clk, reset;
	reg [31:0] in_vec [WIDTH-1:0];	//input vec to module
	reg [31:0] out_vec [WIDTH-1:0];	//outout vec from module
	int i, j, num_errors;
	
	//initialize clk
	initial begin
		clk = 0;
	end
	
	//forever cycle the clk
	always begin
		#(CYCLE/2.0) clk = ~clk;
	end
	
	//instantiate the module
	relu_backward_layer #(.WIDTH(8), .NEGATIVE_SLOPE(NEG_SLOPE) )
							relu( .clk(clk), .reset(reset), .id(8'b0), .in_vec(in_vec), .out_vec(out_vec) );
					
	initial begin
		reset = 0;
		num_errors = 0;
		//for all test cases
		for (i = 0; i < MEM_SIZE; i = i+(WIDTH)) begin
			//for each value in input vector
			for (j = 0; j < WIDTH; j++) begin
				//use test input value as input
				in_vec[j] = test_input[i+j];
			end
			//wait for it...
			#(CYCLE)
			//for each value in output vector (same size as input)
			for (j = 0; j < WIDTH; j++) begin
				//check output of module against value calculated by Python
				$display("output: %h\tcalculated:%h", out_vec[j], test_output[i+j]);
				assert( out_vec[j] == test_output[i+j] );
				//if we were wrong, increase error count
				if( out_vec[j] != test_output[i+j] ) begin
					num_errors++;
				end
			end
		end
		$display("############################################\n");
		$display("Testing complete!\n");
		$display("%d of %d tests passed!\n", NUM_TESTS-num_errors, NUM_TESTS);
		$display("(%f percent)\n", 100*(NUM_TESTS-num_errors)/NUM_TESTS);
		$display("############################################\n");
	end
endmodule

