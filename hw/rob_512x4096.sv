//====================================================================
//
// rob_512x4096
//
// Original Author : George Powley
// Original Date   : 2014/09/08
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
//
//====================================================================

module rob_512x4096
  (
    input logic wr_clk,
    input logic wr_en,
    input logic [11:0] wr_addr,
    input logic [511:0] wr_data,
    input logic rd_clk,
    input logic [11:0] rd_addr,
    output logic [511:0] rd_data
   );

   ram_2p_4096 ram_2p_lo (
	.data(wr_data[255:0]),
	.rdaddress(rd_addr),
	.clock(wr_clk),
	.wraddress(wr_addr),
	.wren(wr_en),
	.q(rd_data[255:0])
	);

   ram_2p_4096 ram_2p_hi (
	.data(wr_data[511:256]),
	.rdaddress(rd_addr),
	.clock(wr_clk),
	.wraddress(wr_addr),
	.wren(wr_en),
	.q(rd_data[511:256])
	);

endmodule // rob_512x4096
