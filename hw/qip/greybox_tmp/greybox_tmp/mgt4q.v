//scfifo ADD_RAM_OUTPUT_REGISTER="ON" CBX_SINGLE_OUTPUT_FILE="ON" INTENDED_DEVICE_FAMILY=""Stratix V"" LPM_NUMWORDS=64 LPM_SHOWAHEAD="OFF" LPM_TYPE="scfifo" LPM_WIDTH=256 LPM_WIDTHU=6 OVERFLOW_CHECKING="ON" UNDERFLOW_CHECKING="ON" USE_EAB="OFF" clock data empty full q rdreq usedw wrreq
//VERSION_BEGIN 13.1 cbx_mgl 2014:03:12:21:10:00:SJ cbx_stratixii 2014:03:12:18:15:31:SJ cbx_util_mgl 2014:03:12:18:15:30:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2014 Altera Corporation
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, Altera MegaCore Function License 
//  Agreement, or other applicable license agreement, including, 
//  without limitation, that your use is for the sole purpose of 
//  programming logic devices manufactured by Altera and sold by 
//  Altera or its authorized distributors.  Please refer to the 
//  applicable agreement for further details.



//synthesis_resources = scfifo 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgt4q
	( 
	clock,
	data,
	empty,
	full,
	q,
	rdreq,
	usedw,
	wrreq) /* synthesis synthesis_clearbox=1 */;
	input   clock;
	input   [255:0]  data;
	output   empty;
	output   full;
	output   [255:0]  q;
	input   rdreq;
	output   [5:0]  usedw;
	input   wrreq;

	wire  wire_mgl_prim1_empty;
	wire  wire_mgl_prim1_full;
	wire  [255:0]   wire_mgl_prim1_q;
	wire  [5:0]   wire_mgl_prim1_usedw;

	scfifo   mgl_prim1
	( 
	.clock(clock),
	.data(data),
	.empty(wire_mgl_prim1_empty),
	.full(wire_mgl_prim1_full),
	.q(wire_mgl_prim1_q),
	.rdreq(rdreq),
	.usedw(wire_mgl_prim1_usedw),
	.wrreq(wrreq));
	defparam
		mgl_prim1.add_ram_output_register = "ON",
		mgl_prim1.intended_device_family = ""Stratix V"",
		mgl_prim1.lpm_numwords = 64,
		mgl_prim1.lpm_showahead = "OFF",
		mgl_prim1.lpm_type = "scfifo",
		mgl_prim1.lpm_width = 256,
		mgl_prim1.lpm_widthu = 6,
		mgl_prim1.overflow_checking = "ON",
		mgl_prim1.underflow_checking = "ON",
		mgl_prim1.use_eab = "OFF";
	assign
		empty = wire_mgl_prim1_empty,
		full = wire_mgl_prim1_full,
		q = wire_mgl_prim1_q,
		usedw = wire_mgl_prim1_usedw;
endmodule //mgt4q
//VALID FILE
