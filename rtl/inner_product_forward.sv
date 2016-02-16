/* 
 * ECE 44x Senior Design
 * Block: Inner Product Layer (Forward)
 * File Name: inner_product_forward.sv
 * Module: Inner Product Layer (Forward)
 * Description: The inner product layer (forward) is the dot product of the weight and an input vector. 
 * Both the forward and backward passes can include a bias.
 */

module ip_forward#(parameter WIDTH = 4) 
				(	
					input logic clk,	//clock signal
					input logic reset,	//reset
					input logic [31:0] in_data [WIDTH-1:0], //input data
					input logic [31:0] weights [WIDTH-1:0], //used in dot product
					input logic [7:0] in_id,
					output logic [31:0] out_data, //output data
					output logic [7:0] out_id
				);

	logic [31:0] connections [2*WIDTH];
	genvar i, j;
	generate
		//create float_mult blocks to multiply the WIDTH number of inputs by the weights
		for (i = 0; i < WIDTH-1; i++) begin : GEN_MULTS
			wire [31:0] results;
			floating_mult floating_mult_inst(
					.clk_en(!reset),
					.clock(clk),
					.dataa(in_data[i]),
					.datab(weights[i]),
					.result(connections[i+WIDTH])
				);
		end

		//add the products and reduce to a single value
		for (i = WIDTH; i > 1; i = i / 2) begin : GEN_SUMS
			for (j = i; j > i / 2 && j != 1; j--) begin : SUM_MULTS
				float_add float_add_inst(
					.aclr(reset),
					.clock(clk),
					.dataa(connections[2*j-1]),
					.datab(connections[2*j-2]),
					.result(connections[j-1])
				);
			end
		end
	endgenerate


	always @(posedge clk) begin
		out_data <= connections[1];
		out_id <= in_id;
	end

endmodule


