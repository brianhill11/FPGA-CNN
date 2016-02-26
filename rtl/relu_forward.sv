module relu_forward #(parameter negative_slope = 0, parameter WIDTH = 8)
			(	
				input logic          reset_n,   //reset	
				input logic				clk_en,
				input logic          clk,	//clock signal
				input logic  [31:0]  in_data [WIDTH-1:0], 	//data vector of floats
				input logic [7:0] in_id,
				output reg [31:0]  out_data [WIDTH-1:0],	//data vector of floats
				output reg [7:0] out_id
			);


	//default negative slope is 0
	
	genvar i;
	generate
		for(i = 0; i < WIDTH; i = i+1) begin : RELU_FORWARD_MULT
			relu_forward_opt #(.negative_slope(negative_slope))
				opt(
										.reset_n(reset_n),
										.clk_en(clk_en),
										.clk(clk),
										.in_data(in_data[i]),
										.out_data(out_data[i])
									);
		end
	
	endgenerate
	
	always @(posedge clk) begin
		//b <= out_data;
		out_id <= in_id;
	end
						
endmodule

module relu_forward_opt #(parameter negative_slope = 0)
			(	
				input logic          reset_n,   //reset
				input logic				clk_en,
				input logic          clk,	//clock signal
				input logic  [31:0] 	in_data, 	//data vector of floats
				output reg 	 [31:0]  out_data //data vector of floats
			);

	reg [31:0] b; 
	floating_mult floating_mult_inst( 
										.clk_en(clk_en),
										.clock(clk), 
										.dataa(in_data), 
										.datab(b), 
										.result(out_data)
										); 
	
		always @(posedge clk) begin
			if (in_data[31] == 0) begin
				//if positive, multiply input by 1 (don't change)
				b <= 1'b00111111100000000000000000000000;
			end else begin
				b <= negative_slope;
			end
			b <= out_data;
		end
		
endmodule
