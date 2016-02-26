
module relu_backward_layer	#(parameter WIDTH = 16, parameter NEGATIVE_SLOPE = 0.0)
									(
										input		logic				clk,						//clock signal
										input		logic				reset,					//reset signal
										input		logic	[7:0]		id,						//id value
										input		logic	[31:0]	in_vec	[WIDTH-1:0],//vector of floats
										output	reg	[7:0]		id_out,					//output id value
										output	reg	[31:0]	out_vec	[WIDTH-1:0]	//vector of floats
									);

	generate
		genvar i;

			for (i = 0; i < WIDTH; i = i+1) begin : RELU_BACKWARD
				relu_backward_opt #(.NEGATIVE_SLOPE(NEGATIVE_SLOPE)) 
						relu_ops (	.clk(clk), .reset(reset), 
										.in_data(in_vec[i]), .out_data(out_vec[i]) );
			end
	endgenerate
	
	always @(posedge clk) begin
		id_out <= id;
	end
endmodule
