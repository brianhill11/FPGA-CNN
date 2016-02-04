`timescale 1ns/1ns

module relu_backward_layer_tb();

    parameter CYCLE = 100;
    //use $shortrealtobuts() to convert float to binary
    parameter NEG_SLOPE = 0.0001;
    parameter WIDTH = 1024;
	 
	 parameter NUM_TESTS 	= 10000;
	 parameter NUM_COLS 		= 2;
	 parameter MEM_SIZE		= NUM_TESTS*NUM_COLS; 

    reg clk, reset;
    reg [31:0] a [WIDTH-1:0];
    reg [31:0] b [WIDTH-1:0];
    reg [31:0] mem [MEM_SIZE];
	 reg random_sign;            //1 bit for random float sign
    reg [7:0] random_exp;       //8 bits for random float exp
    reg [22:0] random_mantissa; //23 bits for random float mantissa
    
    //forever cycle the clk
    always begin
        #2 clk = 0;
        #2 clk = 1;
    end

    relu_backward_layer #(.NEGATIVE_SLOPE(NEG_SLOPE), .WIDTH(WIDTH) )
                    relu( .clk(clk), .reset(reset), .in_vec(a), .out_vec(b) );

    int i, j;
    initial begin
        reset = 0;
		  $readmemh("/home/b/FPGA-CNN/test/test_data/relu_backward_test_data.hex", mem);
		  for (i = 0; i < MEM_SIZE; i = i+(NUM_COLS*WIDTH)) begin
				for (j = 0; j < WIDTH; j++) begin
					//use value from file as input to module
					a[j] = mem[i+j];
				end
				//wait for it...
				#3
				for (j = 0; j < WIDTH; j++) begin
					//check output of module against value calculated by Python
					assert( b[j] == mem[i+j+1] );
				end
			end
        $display("############################################\n");
        $display("All tests passed!\n");
        $display("############################################\n");
    end
endmodule

