module conv_forward_layer #(parameter WIDTH = 16)
									(
										input		logic					clk,
										input		logic					reset,
										input		logic		[7:0]		id,
//										input		logic		[31:0] 	in_data 		[WIDTH-1:0],
//										input		logic		[31:0]	weight_vec	[WIDTH-1:0],
										input		logic		[(WIDTH*32)-1:0] 	in_data,
										input		logic		[(WIDTH*32)-1:0]	weight_vec,
//										input		logic		[31:0]	bias_term,
										output	logic		[31:0]	out_data,
										output	logic		[7:0]		id_out
									);
										
	logic [31:0] connections [2*WIDTH] ;
	
	genvar i, j;
	generate 
		//create float_mult blocks to multiply WIDTH number 
		//of inputs with weight_vec
		for (i = 0; i < WIDTH; i++) begin : GEN_MULTS
			float_mult float_mult_inst(
												.clk_en(reset),
												.clock(clk),
												.dataa(in_data[(i+1)*32-1:i*32]),
												.datab(weight_vec[(i+1)*32-1:i*32]),
												.result(connections[i+WIDTH])
												);
		end 
		//sum the products, and reduce to single value
		for (i = WIDTH; i > 1; i = i / 2) begin : GEN_SUMS
			for (j = i; j > i/2 && j != 1; j--) begin : SUM_MULTS
					float_add float_add_inst(
												 .aclr(!reset),
												 .clock(clk),
												 .dataa(connections[2*j-1]),
												 .datab(connections[2*j-2]),
												 .result(connections[j-1])
												 );
			end
		end
	endgenerate
	
	//add bias term to sum to produce final sum
//	float_add float_add_bias_term(
//												 .aclr(reset),
//												 .clock(clk),
//												 .dataa(connections[1]),
//												 .datab(bias_term),
//												 .result(connections[0])
//												 );
	//write result to output reg + pass id val on
	always @(posedge clk) begin
		out_data <= connections[1];
		id_out = id;
	end

endmodule 
