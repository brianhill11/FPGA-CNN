module conv_forward_layer #(parameter WIDTH = 8)
									(
										input logic					clk,
										input logic					reset,
										input logic					enable,
										input logic		[31:0] 	in_data 	[WIDTH-1:0],
										input logic		[31:0]	weights	[WIDTH-1:0],
										output logic	[31:0] 	out_data
									);
										
	logic [31:0] connections [2*WIDTH] ;
	reg [31:0] final_result;
	
	genvar i, j;
	int k;
	generate 
		//create float_mult blocks to multiply WIDTH number 
		//of inputs with weights
		for (i = 0; i < WIDTH; i++) begin : GEN_MULTS
			wire [31:0] result;
			float_mult float_mult_inst(
												.clk_en(enable),
												.clock(clk),
												.dataa(in_data[i]),
												.datab(weights[i]),
												.result(connections[i])
												);
		end 
		//need input from 2 previous blocks so number of 
		//blocks in each next layer is half of previous
		//layer 1
		for (i = 0; i < WIDTH/2; i++) begin : GEN_SUMS1
					float_add float_add_inst(
												 .aclr(!enable),
												 .clock(clk),
												 .dataa(connections[i]),
												 .datab(connections[i+WIDTH/2]),
												 .result(connections[i+WIDTH])
												 );
		end
		//layer 2
		for (i = WIDTH; i < WIDTH+WIDTH/4; i++) begin : GEN_SUMS2
					float_add float_add_inst(
												 .aclr(!enable),
												 .clock(clk),
												 .dataa(connections[i]),
												 .datab(connections[i+WIDTH/4]),
												 .result(connections[i+WIDTH/2])
												 );
		end
		//layer 3
		for (i = WIDTH+WIDTH/2; i < WIDTH+WIDTH/2+WIDTH/8; i++) begin : GEN_SUMS3
					float_add float_add_inst(
												 .aclr(!enable),
												 .clock(clk),
												 .dataa(connections[i]),
												 .datab(connections[i+WIDTH/8]),
												 .result(connections[i+WIDTH/4])
												 );
		end
//		for (i = 1; i < WIDTH; i = i * 2) begin : GEN_SUMS
//			wire [31:0] results [i];
//			//for each block in new layer, connect to 2 prev 
//			//if first iteration, connect with result from mult
//			if (i == 1) begin
//				for (j = 0; j < i; j++) begin : SUM_MULTS
//					float_add float_add_inst(
//												 .aclr(!enable),
//												 .clock(clk),
//												 .dataa(GEN_SUMS[1].REDUCE_SUMS[0].float_add_inst.result),
//												 .datab(GEN_SUMS[1].REDUCE_SUMS[1].float_add_inst.result),
//												 .result(final_result)
//												 );
//				end
//			//else connect to result from addition
//			end else begin
//				for (j = 0; j < i; j++) begin : REDUCE_SUMS
//					float_add float_add_inst(
//												 .aclr(!enable),
//												 .clock(clk),
//												 .dataa(GEN_SUMS[i]..result),
//												 .datab(GEN_MULTS[j+i].result),
//												 //.result(results[j])
//												 );
//				end
//			
//			end
//		end
		

	endgenerate
	
		always @(posedge clk) begin
			out_data <= connections[0];
		end

endmodule 