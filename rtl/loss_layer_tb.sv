`timescale 1ns/100ps

module loss_layer_tb();
	`include "/home/b/bear_git/FPGA-CNN/test/test_data/softmax_with_loss_test_data.vh"
	parameter CYCLE			= 5;				//clk period: 5ns = 200 Mhz
	parameter MULT_DELAY		= 5;				//#clks to complete a mult
	parameter ADD_DELAY		= 7;				//#clks to complete an add
	parameter SUB_DELAY		= 7;				//#clks to complete a sub
	parameter EXP_DELAY		= 17;				//#clks to complete an exponential
	parameter LOG_DELAY		= 21;				//#clks to complete a log
	parameter DIV_DELAY		= 6;				//#clks to complte a div
	parameter WIDTH			= 8;				//input vector width
	
	parameter NUM_TESTS		= 10000;
	parameter MEM_SIZE		= NUM_TESTS*WIDTH; 

	reg clk, reset;
	logic [31:0] in_vec [WIDTH-1:0];			//input vec to module
	logic [31:0] label;							//correct classification
	logic [7:0]  id;								//identification value
	logic [31:0] out;								//output from module
	logic 		 f_overall_sum;
	int i, j, num_errors, num_add_levels, delay, sub_exp_add_delay, div_log_delay;
	
	//initialize clk
	initial begin
		clk = 0;
	end
	
	//forever cycle the clk
	always begin
		#(CYCLE/2.0) clk = ~clk;
	end
	
	//instantiate the module 
	lol_opt 	#(.WIDTH(WIDTH))
		lol_opt_inst(
								.clk(clk),
								.reset_n(reset),
								.in_ID(id),
								.f_overall_sum(f_overall_sum),
								.all_clsf(in_vec),
								.corr_clsf(label),
								.data_out(out)
								);

	initial begin
		reset = 1;
		id = 0;
		f_overall_sum = 0;
		num_errors = 0;
		num_add_levels = 1;
		//calculate log2(WIDTH)
		while (WIDTH / (2*num_add_levels) != 1) begin
			num_add_levels++;
		end
		//calculate total delay of one calculation 
		sub_exp_add_delay = CYCLE*(SUB_DELAY + EXP_DELAY + ADD_DELAY*(num_add_levels));
		div_log_delay = CYCLE*(DIV_DELAY + LOG_DELAY-1);
		
		$display("num add levels: %d", num_add_levels);
		//for all test cases
		 for (i = 0; i < MEM_SIZE; i = i + WIDTH) begin
			//reset module
			reset = 0;
			#CYCLE reset = 1;
			
			//copy each value to input vector
			for (j = 0; j < WIDTH; j++) begin
				in_vec[j] = test_input[i+j];
			end
			
			//copy label
			label = test_label[i/WIDTH];
			
			//wait for computation to finish 
			#(sub_exp_add_delay)
			f_overall_sum = 1;
			#CYCLE
			f_overall_sum = 0;
			//add to overall sum
			#(CYCLE*ADD_DELAY)
			//div and log
			#(div_log_delay)
			
			//if we were wrong, check for rounding error
			if( out != test_output[i/WIDTH] ) begin
				//if log(1.0) in NumPy gave us garbage, do our own check	
				if ( test_div[i/WIDTH] == 32'h3f800000 ) begin
					if ( out != 32'h80000000 ) begin
						$display("Error! Module did not correctly handle log(1.0)");
						$display("output: %h\tcalculated: 32'h80000000", out);
					end
				//if the number was off because of a rounding error, ignore
				end else if ( out - test_output[i/WIDTH] < 32'h0000ffff ||
									test_output[i/WIDTH] - out < 32'h0000ffff ) begin
						//$display("Rounding error");
				//otherwise, complain
				end else begin
					//assert( out == test_output[i/WIDTH] );
					$display("Error! Module result not expected value");
					$display("output: %h\tcalculated: %h", out, test_output[i/WIDTH]);
					$display("out&:\t\t%b", out & 32'hfffff000);
					$display("corr&:\t\t%b", test_output[i/WIDTH] & 32'hfffff000);
					$display("out-corr:\t\t%b", out - test_output[i/WIDTH]);
					$display("corr-out:\t\t%b", test_output[i/WIDTH] - out);
					num_errors++;
				end
			end
			$display("(%f percent)\n", 100.0*((i/WIDTH)+1-num_errors)/((i/WIDTH)+1));
		end
		$display("############################################\n");
		$display("Testing complete!\n");
		$display("%d of %d tests passed\n", NUM_TESTS-num_errors, NUM_TESTS);
		$display("(%f percent)\n", 100.0*(NUM_TESTS-num_errors)/NUM_TESTS);
		$display("############################################\n");
	end

endmodule
