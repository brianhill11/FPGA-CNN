module mult_test(	input 	logic 	clk,
						input 	logic [31:0] in_data,
						input 	logic [31:0] mult,
						output 	logic [31:0] out_data);
	
	float_mult float_mult_inst( .clock(clk), .dataa(in_data), 
					.datab(mult), .result(out_data));
						
	
endmodule