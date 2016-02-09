module conv_forward_layer #(parameter WIDTH = 16)
									(
										input logic					clk,
										input logic					reset,
										input logic					enable,
										input logic		[31:0] 	in_data 	[WIDTH-1:0],
										input logic		[31:0]	weights	[WIDTH-1:0],
										input logic		[31:0]	bias_term,
										output logic	[31:0] 	out_data
									);
										
	logic [31:0] connections [2*WIDTH] ;
	
	genvar i, j;
	generate 
		//create float_mult blocks to multiply WIDTH number 
		//of inputs with weights
		for (i = 0; i < WIDTH; i++) begin : GEN_MULTS
			wire [31:0] results;
			float_mult float_mult_inst(
												.clk_en(enable),
												.clock(clk),
												.dataa(in_data[i]),
												.datab(weights[i]),
												.result(connections[i+WIDTH])
												);
		end 
		//sum the products, and reduce to single value
		for (i = WIDTH; i > 1; i = i / 2) begin : GEN_SUMS
			for (j = i; j > i/2 && j != 1; j--) begin : SUM_MULTS
					float_add float_add_inst(
												 .aclr(!enable),
												 .clock(clk),
												 .dataa(connections[2*j-1]),
												 .datab(connections[2*j-2]),
												 .result(connections[j-1])
												 );
			end
		end
	endgenerate
	
	//add bias term to sum to produce final sum
	float_add float_add_bias_term(
												 .aclr(!enable),
												 .clock(clk),
												 .dataa(connections[1]),
												 .datab(connections[bias_term]),
												 .result(connections[0])
												 );
	
		always @(posedge clk) begin
			out_data <= connections[0];
		end

endmodule 