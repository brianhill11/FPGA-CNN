`timescale 1ns/100ps

module relu_forward_tb();
	`include "/nfs/stak/students/z/zhangso/ECE441/relu_forward/test_data/relu_forward_test_data.vh"
	parameter CYCLE			= 5;	//clk period: 5 ns = 200 MHz signal
	parameter NEG_SLOPE		= 0.0;	//parameter negative slope
	parameter WIDTH			= 8;	//width of the input and output vectors

	parameter NUM_TESTS		= 4000;	//number of test iterations
	parameter MEM_SIZE		= NUM_TESTS*WIDTH; 

	reg clk, reset;
	reg clk_en;
	reg [31:0] in_data [WIDTH-1:0];	//input vec to module
	reg [31:0] out_data [WIDTH-1:0];	//output vec from module
	int i, j, num_errors;
	
	//initialize clk
	initial begin
		clk = 0;
		//clk_en = 1;
	end
	
	//forever cycle the clk
	always begin
		#(CYCLE/2.0) clk = ~clk;
	end
	
	//instantiate the module
	relu_forward #(.negative_slope(NEG_SLOPE), .WIDTH(8) )
        	relu( .reset_n(reset), .clk(clk), .clk_en(clk_en), .in_data(in_data), .out_data(out_data) );

	initial begin
		reset = 0;
		num_errors = 0;
		//for all test cases
		for (i = 0; i < MEM_SIZE; i = i+(WIDTH)) begin
			//for each value in input vector
			for (j = 0; j < WIDTH; j++) begin
				//use test input value as input
				in_data[j] = test_input[i+j];
			end
			//wait for it...
			#(5*CYCLE) //5*CYCLE due to multiplication
			//for each value in output vector (same size as input)
			for (j = 0; j < WIDTH; j++) begin
				//check output of module against value calculated by Python
				$display("output: %h\tcalculated:%h", out_data[j], test_output[i+j]);
				assert( out_data[j] == test_output[i+j] );
				//if we were wrong, increase error count
				if( out_data[j] != test_output[i+j] ) begin
					num_errors++;
				end
			end
		end
		$display("############################################\n");
		$display("Testing complete!\n");
		$display("%d of %d tests passed!\n", NUM_TESTS-num_errors, NUM_TESTS);
		$display("(%f percent)\n", 100.0*(NUM_TESTS-num_errors)/NUM_TESTS);
		$display("############################################\n");
	end
endmodule
