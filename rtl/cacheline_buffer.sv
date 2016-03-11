module cacheline_buffer(
	input logic wr_clk,
	input logic wr_en,
	input logic [7:0] wr_addr, 
	input logic [511:0] wr_data,
	input logic rd_clk,
	input logic [7:0] rd_addr,
	output logic [511:0] rd_data
	);
	
	ram_2p ram_2p_low(
		.data(wr_data[255:0]),
		.rdaddress(rd_addr),
		.rdclock(rd_clk), 
		.wraddress(wr_addr),
		.wrclock(wr_clk),
		.wren(wr_en),
		.q(rd_data[255:0])
	);
	
	ram_2p ram_2p_high(
		.data(wr_data[511:256]),
		.rdaddress(rd_addr),
		.rdclock(rd_clk), 
		.wraddress(wr_addr),
		.wrclock(wr_clk),
		.wren(wr_en),
		.q(rd_data[511:256])
	);
	
endmodule 
