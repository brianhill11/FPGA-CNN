/* Sophia Zhang
 * ECE 44x Senior Design
 * Block: Inner Product Layer (Backward)
 * File Name: inner_product_backward.sv
 * Module: Inner Product Layer (Backward)
 * Description: The inner product layer (backpropagation) takes in the number of filters
 * along with the height and width of the vectors. The bias and weight are used along with
 * floating point multiplication, for dot product, to learn the differences. 
 * The bias_filler is a constant with a default value of zero, while the weight_filler is
 * a constant set to zero by default.
 */

module ip_backward#(parameter WIDTH = 8)
			(
				input logic clk, //clock signal
				input logic reset, //reset
				input logic [31:0] in_data [WIDTH-1:0], //input data, vector of floats
				input logic [31:0] weights [WIDTH-1:0], //weight
				input logic [31:0] bias,
				input logic [7:0] in_id,
				output logic [31:0] out_data, //output data, vector of floats
				output logic [7:0] out_id
			);

	logic [31:0] connections [2*WIDTH]; 
	genvar i, j;
	generate
		//create float_mult blocks to multiply WIDTH number of inputs with weights
		for (i = 0; i < WIDTH; i++) begin : GEN_MULTS
			float_mult floating_mult_inst(
						.clk_en(!reset),
						.clock(clk),
						.dataa(in_data[i]),
						.datab(weights[i]),
						.result(connections[i + WIDTH])
			);
		end

		//add the products, and reduce to a single value
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
	
	//add bias term to sum to produce final sum
	float_add float_add_bias_term(
							.aclr(reset),
							.clock(clk),
							.dataa(connections[1]),
							.datab(bias),
							.result(connections[0])
							);
	
		always @(posedge clk) begin
			out_data <= connections[0];
			out_id <= in_id;
		end
	
endmodule
