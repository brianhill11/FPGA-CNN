// megafunction wizard: %ALTFP_MULT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTFP_MULT 

// ============================================================
// File Name: float_mult.v
// Megafunction Name(s):
// 			ALTFP_MULT
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 15.1.1 Build 189 12/02/2015 SJ Standard Edition
// ************************************************************


//Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, the Altera Quartus Prime License Agreement,
//the Altera MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Altera and sold by Altera or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.


//altfp_mult DEDICATED_MULTIPLIER_CIRCUITRY="YES" DENORMAL_SUPPORT="NO" DEVICE_FAMILY="Stratix V" EXCEPTION_HANDLING="NO" PIPELINE=5 REDUCED_FUNCTIONALITY="NO" ROUNDING="TO_NEAREST" WIDTH_EXP=8 WIDTH_MAN=23 clk_en clock dataa datab result
//VERSION_BEGIN 15.1 cbx_alt_ded_mult_y 2015:11:24:18:49:55:SJ cbx_altbarrel_shift 2015:11:24:18:49:55:SJ cbx_altera_mult_add 2015:11:24:18:49:55:SJ cbx_altera_mult_add_rtl 2015:11:24:18:49:55:SJ cbx_altfp_mult 2015:11:24:18:49:55:SJ cbx_altmult_add 2015:11:24:18:49:55:SJ cbx_cycloneii 2015:11:24:18:49:55:SJ cbx_lpm_add_sub 2015:11:24:18:49:55:SJ cbx_lpm_compare 2015:11:24:18:49:55:SJ cbx_lpm_mult 2015:11:24:18:49:55:SJ cbx_mgl 2015:11:24:20:43:33:SJ cbx_nadder 2015:11:24:18:49:55:SJ cbx_padd 2015:11:24:18:49:55:SJ cbx_parallel_add 2015:11:24:18:49:55:SJ cbx_stratix 2015:11:24:18:49:55:SJ cbx_stratixii 2015:11:24:18:49:55:SJ cbx_util_mgl 2015:11:24:18:49:55:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



//lpm_add_sub DEVICE_FAMILY="Stratix V" LPM_PIPELINE=1 LPM_WIDTH=9 aclr cin clken clock dataa datab result
//VERSION_BEGIN 15.1 cbx_cycloneii 2015:11:24:18:49:55:SJ cbx_lpm_add_sub 2015:11:24:18:49:55:SJ cbx_mgl 2015:11:24:20:43:33:SJ cbx_nadder 2015:11:24:18:49:55:SJ cbx_stratix 2015:11:24:18:49:55:SJ cbx_stratixii 2015:11:24:18:49:55:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Stratix V" LPM_WIDTH=10 cin dataa datab result
//VERSION_BEGIN 15.1 cbx_cycloneii 2015:11:24:18:49:55:SJ cbx_lpm_add_sub 2015:11:24:18:49:55:SJ cbx_mgl 2015:11:24:20:43:33:SJ cbx_nadder 2015:11:24:18:49:55:SJ cbx_stratix 2015:11:24:18:49:55:SJ cbx_stratixii 2015:11:24:18:49:55:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Stratix V" LPM_DIRECTION="SUB" LPM_PIPELINE=0 LPM_REPRESENTATION="UNSIGNED" LPM_WIDTH=10 dataa datab result
//VERSION_BEGIN 15.1 cbx_cycloneii 2015:11:24:18:49:55:SJ cbx_lpm_add_sub 2015:11:24:18:49:55:SJ cbx_mgl 2015:11:24:20:43:33:SJ cbx_nadder 2015:11:24:18:49:55:SJ cbx_stratix 2015:11:24:18:49:55:SJ cbx_stratixii 2015:11:24:18:49:55:SJ  VERSION_END


//lpm_add_sub DEVICE_FAMILY="Stratix V" LPM_PIPELINE=0 LPM_WIDTH=25 dataa datab result
//VERSION_BEGIN 15.1 cbx_cycloneii 2015:11:24:18:49:55:SJ cbx_lpm_add_sub 2015:11:24:18:49:55:SJ cbx_mgl 2015:11:24:20:43:33:SJ cbx_nadder 2015:11:24:18:49:55:SJ cbx_stratix 2015:11:24:18:49:55:SJ cbx_stratixii 2015:11:24:18:49:55:SJ  VERSION_END


//lpm_mult DEDICATED_MULTIPLIER_CIRCUITRY="YES" DEVICE_FAMILY="Stratix V" LPM_PIPELINE=2 LPM_REPRESENTATION="UNSIGNED" LPM_WIDTHA=24 LPM_WIDTHB=24 LPM_WIDTHP=48 LPM_WIDTHS=1 aclr clken clock dataa datab result
//VERSION_BEGIN 15.1 cbx_cycloneii 2015:11:24:18:49:55:SJ cbx_lpm_add_sub 2015:11:24:18:49:55:SJ cbx_lpm_mult 2015:11:24:18:49:55:SJ cbx_mgl 2015:11:24:20:43:33:SJ cbx_nadder 2015:11:24:18:49:55:SJ cbx_padd 2015:11:24:18:49:55:SJ cbx_stratix 2015:11:24:18:49:55:SJ cbx_stratixii 2015:11:24:18:49:55:SJ cbx_util_mgl 2015:11:24:18:49:55:SJ  VERSION_END

//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  float_mult_mult
	( 
	aclr,
	clken,
	clock,
	dataa,
	datab,
	result) /* synthesis synthesis_clearbox=1 */;
	input   aclr;
	input   clken;
	input   clock;
	input   [23:0]  dataa;
	input   [23:0]  datab;
	output   [47:0]  result;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   aclr;
	tri1   clken;
	tri0   clock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	reg  [23:0]  dataa_input_reg;
	reg  [23:0]  datab_input_reg;
	reg  [47:0]  result_output_reg;
	wire [23:0]    dataa_wire;
	wire [23:0]    datab_wire;
	wire [47:0]    result_wire;


	// synopsys translate_off
	initial
		dataa_input_reg = 0;
	// synopsys translate_on
	always @(posedge clock or posedge aclr)
		if (aclr == 1'b1)    dataa_input_reg <= 24'b0;
		else if (clken == 1'b1)	dataa_input_reg <= dataa;
	// synopsys translate_off
	initial
		datab_input_reg = 0;
	// synopsys translate_on
	always @(posedge clock or posedge aclr)
		if (aclr == 1'b1)    datab_input_reg <= 24'b0;
		else if (clken == 1'b1)	datab_input_reg <= datab;
	// synopsys translate_off
	initial
		result_output_reg = 0;
	// synopsys translate_on
	always @(posedge clock or posedge aclr)
		if (aclr == 1'b1)    result_output_reg <= 48'b0;
		else if (clken == 1'b1)	result_output_reg <= result_wire[47:0];

	assign dataa_wire = dataa_input_reg;
	assign datab_wire = datab_input_reg;
	assign result_wire = dataa_wire * datab_wire;
	assign result = ({result_output_reg});

endmodule //float_mult_mult

//synthesis_resources = lut 55 reg 136 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  float_mult_altfp_mult
	( 
	clk_en,
	clock,
	dataa,
	datab,
	result) /* synthesis synthesis_clearbox=1 */;
	input   clk_en;
	input   clock;
	input   [31:0]  dataa;
	input   [31:0]  datab;
	output   [31:0]  result;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1   clk_en;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	reg	dataa_exp_all_one_ff_p1;
	reg	dataa_exp_not_zero_ff_p1;
	reg	dataa_man_not_zero_ff_p1;
	reg	dataa_man_not_zero_ff_p2;
	reg	datab_exp_all_one_ff_p1;
	reg	datab_exp_not_zero_ff_p1;
	reg	datab_man_not_zero_ff_p1;
	reg	datab_man_not_zero_ff_p2;
	reg	[9:0]	delay_exp2_bias;
	reg	[9:0]	delay_exp_bias;
	reg	delay_man_product_msb;
	reg	delay_man_product_msb_p0;
	reg	[8:0]	exp_add_p1;
	reg	[7:0]	exp_result_ff;
	reg	input_is_infinity_dffe_0;
	reg	input_is_infinity_dffe_1;
	reg	input_is_infinity_ff1;
	reg	input_is_nan_dffe_0;
	reg	input_is_nan_dffe_1;
	reg	input_is_nan_ff1;
	reg	input_not_zero_dffe_0;
	reg	input_not_zero_dffe_1;
	reg	input_not_zero_ff1;
	reg	lsb_dffe;
	reg	[22:0]	man_result_ff;
	reg	[23:0]	man_round_p;
	reg	[24:0]	man_round_p2;
	reg	round_dffe;
	reg	[0:0]	sign_node_ff0;
	reg	[0:0]	sign_node_ff1;
	reg	[0:0]	sign_node_ff2;
	reg	[0:0]	sign_node_ff3;
	reg	[0:0]	sign_node_ff4;
	reg	sticky_dffe;
	(* ALTERA_ATTRIBUTE = {"POWER_UP_LEVEL=LOW"} *)
	reg	[8:0]	wire_exp_add_adder_pipeline_dffe_Q;
	wire	[8:0]	wire_exp_add_adder_pipeline_dffe_D;
	wire	[9:0]	wire_exp_add_adder_result_int;
	wire	wire_exp_add_adder_aclr;
	wire	wire_exp_add_adder_cin;
	wire	wire_exp_add_adder_clken;
	wire	wire_exp_add_adder_clock;
	wire	[8:0]	wire_exp_add_adder_dataa;
	wire	[8:0]	wire_exp_add_adder_datab;
	wire	[8:0]	wire_exp_add_adder_result;
	wire	[10:0]	wire_exp_adj_adder_result_int;
	wire	wire_exp_adj_adder_cin;
	wire	[9:0]	wire_exp_adj_adder_dataa;
	wire	[9:0]	wire_exp_adj_adder_datab;
	wire	[9:0]	wire_exp_adj_adder_result;
	wire	[9:0]	wire_exp_bias_subtr_dataa;
	wire	[9:0]	wire_exp_bias_subtr_datab;
	wire	[9:0]	wire_exp_bias_subtr_result;
	wire	[24:0]	wire_man_round_adder_dataa;
	wire	[24:0]	wire_man_round_adder_datab;
	wire	[24:0]	wire_man_round_adder_result;
	wire  [23:0]   wire_man_product2_mult_dataa;
	wire  [23:0]   wire_man_product2_mult_datab;
	wire  [47:0]   wire_man_product2_mult_result;
	wire aclr;
	wire  [9:0]  bias;
	wire  [7:0]  dataa_exp_all_one;
	wire  [7:0]  dataa_exp_not_zero;
	wire  [22:0]  dataa_man_not_zero;
	wire  [7:0]  datab_exp_all_one;
	wire  [7:0]  datab_exp_not_zero;
	wire  [22:0]  datab_man_not_zero;
	wire  exp_is_inf;
	wire  exp_is_zero;
	wire  [9:0]  expmod;
	wire  [7:0]  inf_num;
	wire  lsb_bit;
	wire  [23:0]  man_result_round;
	wire  [24:0]  man_shift_full;
	wire  [7:0]  result_exp_all_one;
	wire  [8:0]  result_exp_not_zero;
	wire  round_bit;
	wire  round_carry;
	wire  [22:0]  sticky_bit;

	// synopsys translate_off
	initial
		dataa_exp_all_one_ff_p1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) dataa_exp_all_one_ff_p1 <= 1'b0;
		else if  (clk_en == 1'b1)   dataa_exp_all_one_ff_p1 <= dataa_exp_all_one[7];
	// synopsys translate_off
	initial
		dataa_exp_not_zero_ff_p1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) dataa_exp_not_zero_ff_p1 <= 1'b0;
		else if  (clk_en == 1'b1)   dataa_exp_not_zero_ff_p1 <= dataa_exp_not_zero[7];
	// synopsys translate_off
	initial
		dataa_man_not_zero_ff_p1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) dataa_man_not_zero_ff_p1 <= 1'b0;
		else if  (clk_en == 1'b1)   dataa_man_not_zero_ff_p1 <= dataa_man_not_zero[10];
	// synopsys translate_off
	initial
		dataa_man_not_zero_ff_p2 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) dataa_man_not_zero_ff_p2 <= 1'b0;
		else if  (clk_en == 1'b1)   dataa_man_not_zero_ff_p2 <= dataa_man_not_zero[22];
	// synopsys translate_off
	initial
		datab_exp_all_one_ff_p1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) datab_exp_all_one_ff_p1 <= 1'b0;
		else if  (clk_en == 1'b1)   datab_exp_all_one_ff_p1 <= datab_exp_all_one[7];
	// synopsys translate_off
	initial
		datab_exp_not_zero_ff_p1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) datab_exp_not_zero_ff_p1 <= 1'b0;
		else if  (clk_en == 1'b1)   datab_exp_not_zero_ff_p1 <= datab_exp_not_zero[7];
	// synopsys translate_off
	initial
		datab_man_not_zero_ff_p1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) datab_man_not_zero_ff_p1 <= 1'b0;
		else if  (clk_en == 1'b1)   datab_man_not_zero_ff_p1 <= datab_man_not_zero[10];
	// synopsys translate_off
	initial
		datab_man_not_zero_ff_p2 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) datab_man_not_zero_ff_p2 <= 1'b0;
		else if  (clk_en == 1'b1)   datab_man_not_zero_ff_p2 <= datab_man_not_zero[22];
	// synopsys translate_off
	initial
		delay_exp2_bias = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) delay_exp2_bias <= 10'b0;
		else if  (clk_en == 1'b1)   delay_exp2_bias <= delay_exp_bias;
	// synopsys translate_off
	initial
		delay_exp_bias = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) delay_exp_bias <= 10'b0;
		else if  (clk_en == 1'b1)   delay_exp_bias <= wire_exp_bias_subtr_result;
	// synopsys translate_off
	initial
		delay_man_product_msb = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) delay_man_product_msb <= 1'b0;
		else if  (clk_en == 1'b1)   delay_man_product_msb <= delay_man_product_msb_p0;
	// synopsys translate_off
	initial
		delay_man_product_msb_p0 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) delay_man_product_msb_p0 <= 1'b0;
		else if  (clk_en == 1'b1)   delay_man_product_msb_p0 <= wire_man_product2_mult_result[47];
	// synopsys translate_off
	initial
		exp_add_p1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) exp_add_p1 <= 9'b0;
		else if  (clk_en == 1'b1)   exp_add_p1 <= wire_exp_add_adder_result;
	// synopsys translate_off
	initial
		exp_result_ff = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) exp_result_ff <= 8'b0;
		else if  (clk_en == 1'b1)   exp_result_ff <= ((inf_num & {8{((exp_is_inf | input_is_infinity_ff1) | input_is_nan_ff1)}}) | ((wire_exp_adj_adder_result[7:0] & {8{(~ exp_is_zero)}}) & {8{input_not_zero_ff1}}));
	// synopsys translate_off
	initial
		input_is_infinity_dffe_0 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_is_infinity_dffe_0 <= 1'b0;
		else if  (clk_en == 1'b1)   input_is_infinity_dffe_0 <= ((dataa_exp_all_one_ff_p1 & (~ (dataa_man_not_zero_ff_p1 | dataa_man_not_zero_ff_p2))) | (datab_exp_all_one_ff_p1 & (~ (datab_man_not_zero_ff_p1 | datab_man_not_zero_ff_p2))));
	// synopsys translate_off
	initial
		input_is_infinity_dffe_1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_is_infinity_dffe_1 <= 1'b0;
		else if  (clk_en == 1'b1)   input_is_infinity_dffe_1 <= input_is_infinity_dffe_0;
	// synopsys translate_off
	initial
		input_is_infinity_ff1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_is_infinity_ff1 <= 1'b0;
		else if  (clk_en == 1'b1)   input_is_infinity_ff1 <= input_is_infinity_dffe_1;
	// synopsys translate_off
	initial
		input_is_nan_dffe_0 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_is_nan_dffe_0 <= 1'b0;
		else if  (clk_en == 1'b1)   input_is_nan_dffe_0 <= ((dataa_exp_all_one_ff_p1 & (dataa_man_not_zero_ff_p1 | dataa_man_not_zero_ff_p2)) | (datab_exp_all_one_ff_p1 & (datab_man_not_zero_ff_p1 | datab_man_not_zero_ff_p2)));
	// synopsys translate_off
	initial
		input_is_nan_dffe_1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_is_nan_dffe_1 <= 1'b0;
		else if  (clk_en == 1'b1)   input_is_nan_dffe_1 <= input_is_nan_dffe_0;
	// synopsys translate_off
	initial
		input_is_nan_ff1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_is_nan_ff1 <= 1'b0;
		else if  (clk_en == 1'b1)   input_is_nan_ff1 <= input_is_nan_dffe_1;
	// synopsys translate_off
	initial
		input_not_zero_dffe_0 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_not_zero_dffe_0 <= 1'b0;
		else if  (clk_en == 1'b1)   input_not_zero_dffe_0 <= (dataa_exp_not_zero_ff_p1 & datab_exp_not_zero_ff_p1);
	// synopsys translate_off
	initial
		input_not_zero_dffe_1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_not_zero_dffe_1 <= 1'b0;
		else if  (clk_en == 1'b1)   input_not_zero_dffe_1 <= input_not_zero_dffe_0;
	// synopsys translate_off
	initial
		input_not_zero_ff1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) input_not_zero_ff1 <= 1'b0;
		else if  (clk_en == 1'b1)   input_not_zero_ff1 <= input_not_zero_dffe_1;
	// synopsys translate_off
	initial
		lsb_dffe = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) lsb_dffe <= 1'b0;
		else if  (clk_en == 1'b1)   lsb_dffe <= lsb_bit;
	// synopsys translate_off
	initial
		man_result_ff = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) man_result_ff <= 23'b0;
		else if  (clk_en == 1'b1)   man_result_ff <= {((((((man_result_round[22] & input_not_zero_ff1) & (~ input_is_infinity_ff1)) & (~ exp_is_inf)) & (~ exp_is_zero)) | (input_is_infinity_ff1 & (~ input_not_zero_ff1))) | input_is_nan_ff1), (((((man_result_round[21:0] & {22{input_not_zero_ff1}}) & {22{(~ input_is_infinity_ff1)}}) & {22{(~ exp_is_inf)}}) & {22{(~ exp_is_zero)}}) & {22{(~ input_is_nan_ff1)}})};
	// synopsys translate_off
	initial
		man_round_p = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) man_round_p <= 24'b0;
		else if  (clk_en == 1'b1)   man_round_p <= man_shift_full[24:1];
	// synopsys translate_off
	initial
		man_round_p2 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) man_round_p2 <= 25'b0;
		else if  (clk_en == 1'b1)   man_round_p2 <= wire_man_round_adder_result;
	// synopsys translate_off
	initial
		round_dffe = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) round_dffe <= 1'b0;
		else if  (clk_en == 1'b1)   round_dffe <= round_bit;
	// synopsys translate_off
	initial
		sign_node_ff0 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_node_ff0 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_node_ff0 <= (dataa[31] ^ datab[31]);
	// synopsys translate_off
	initial
		sign_node_ff1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_node_ff1 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_node_ff1 <= sign_node_ff0[0:0];
	// synopsys translate_off
	initial
		sign_node_ff2 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_node_ff2 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_node_ff2 <= sign_node_ff1[0:0];
	// synopsys translate_off
	initial
		sign_node_ff3 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_node_ff3 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_node_ff3 <= sign_node_ff2[0:0];
	// synopsys translate_off
	initial
		sign_node_ff4 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_node_ff4 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_node_ff4 <= sign_node_ff3[0:0];
	// synopsys translate_off
	initial
		sticky_dffe = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sticky_dffe <= 1'b0;
		else if  (clk_en == 1'b1)   sticky_dffe <= sticky_bit[22];
	assign
		wire_exp_add_adder_result_int = {wire_exp_add_adder_dataa, wire_exp_add_adder_cin} + {wire_exp_add_adder_datab, wire_exp_add_adder_cin};
	//synopsys translate_off
	initial
		wire_exp_add_adder_pipeline_dffe_Q = 0;
	//synopsys translate_on
	always @(posedge wire_exp_add_adder_clock or posedge wire_exp_add_adder_aclr)
		if (wire_exp_add_adder_aclr == 1'b1) wire_exp_add_adder_pipeline_dffe_Q <= 9'b0;
		else if (wire_exp_add_adder_clken == 1'b1) wire_exp_add_adder_pipeline_dffe_Q <= wire_exp_add_adder_pipeline_dffe_D;
	assign
		wire_exp_add_adder_result = wire_exp_add_adder_pipeline_dffe_Q[8:0],
		wire_exp_add_adder_pipeline_dffe_D[8:0] = wire_exp_add_adder_result_int[9:1];
	assign
		wire_exp_add_adder_aclr = aclr,
		wire_exp_add_adder_cin = 1'b0,
		wire_exp_add_adder_clken = clk_en,
		wire_exp_add_adder_clock = clock,
		wire_exp_add_adder_dataa = {1'b0, dataa[30:23]},
		wire_exp_add_adder_datab = {1'b0, datab[30:23]};
	assign
		wire_exp_adj_adder_result_int = {wire_exp_adj_adder_dataa, wire_exp_adj_adder_cin} + {wire_exp_adj_adder_datab, wire_exp_adj_adder_cin};
	assign
		wire_exp_adj_adder_result = wire_exp_adj_adder_result_int[10:1];
	assign
		wire_exp_adj_adder_cin = 1'b0,
		wire_exp_adj_adder_dataa = delay_exp2_bias,
		wire_exp_adj_adder_datab = expmod;
	assign
		wire_exp_bias_subtr_result = wire_exp_bias_subtr_dataa - wire_exp_bias_subtr_datab;
	assign
		wire_exp_bias_subtr_dataa = {1'b0, exp_add_p1[8:0]},
		wire_exp_bias_subtr_datab = {bias[9:0]};
	assign
		wire_man_round_adder_result = wire_man_round_adder_dataa + wire_man_round_adder_datab;
	assign
		wire_man_round_adder_dataa = {1'b0, man_round_p},
		wire_man_round_adder_datab = {{24{1'b0}}, round_carry};
	float_mult_mult   man_product2_mult
	( 
	.aclr(aclr),
	.clken(clk_en),
	.clock(clock),
	.dataa({1'b1, dataa[22:0]}),
	.datab({1'b1, datab[22:0]}),
	.result(wire_man_product2_mult_result));
	assign
		aclr = 1'b0,
		bias = {{3{1'b0}}, {7{1'b1}}},
		dataa_exp_all_one = {(dataa[30] & dataa_exp_all_one[6]), (dataa[29] & dataa_exp_all_one[5]), (dataa[28] & dataa_exp_all_one[4]), (dataa[27] & dataa_exp_all_one[3]), (dataa[26] & dataa_exp_all_one[2]), (dataa[25] & dataa_exp_all_one[1]), (dataa[24] & dataa_exp_all_one[0]), dataa[23]},
		dataa_exp_not_zero = {(dataa[30] | dataa_exp_not_zero[6]), (dataa[29] | dataa_exp_not_zero[5]), (dataa[28] | dataa_exp_not_zero[4]), (dataa[27] | dataa_exp_not_zero[3]), (dataa[26] | dataa_exp_not_zero[2]), (dataa[25] | dataa_exp_not_zero[1]), (dataa[24] | dataa_exp_not_zero[0]), dataa[23]},
		dataa_man_not_zero = {(dataa[22] | dataa_man_not_zero[21]), (dataa[21] | dataa_man_not_zero[20]), (dataa[20] | dataa_man_not_zero[19]), (dataa[19] | dataa_man_not_zero[18]), (dataa[18] | dataa_man_not_zero[17]), (dataa[17] | dataa_man_not_zero[16]), (dataa[16] | dataa_man_not_zero[15]), (dataa[15] | dataa_man_not_zero[14]), (dataa[14] | dataa_man_not_zero[13]), (dataa[13] | dataa_man_not_zero[12]), (dataa[12] | dataa_man_not_zero[11]), dataa[11], (dataa[10] | dataa_man_not_zero[9]), (dataa[9] | dataa_man_not_zero[8]), (dataa[8] | dataa_man_not_zero[7]), (dataa[7] | dataa_man_not_zero[6]), (dataa[6] | dataa_man_not_zero[5]), (dataa[5] | dataa_man_not_zero[4]), (dataa[4] | dataa_man_not_zero[3]), (dataa[3] | dataa_man_not_zero[2]), (dataa[2] | dataa_man_not_zero[1]), (dataa[1] | dataa_man_not_zero[0]), dataa[0]},
		datab_exp_all_one = {(datab[30] & datab_exp_all_one[6]), (datab[29] & datab_exp_all_one[5]), (datab[28] & datab_exp_all_one[4]), (datab[27] & datab_exp_all_one[3]), (datab[26] & datab_exp_all_one[2]), (datab[25] & datab_exp_all_one[1]), (datab[24] & datab_exp_all_one[0]), datab[23]},
		datab_exp_not_zero = {(datab[30] | datab_exp_not_zero[6]), (datab[29] | datab_exp_not_zero[5]), (datab[28] | datab_exp_not_zero[4]), (datab[27] | datab_exp_not_zero[3]), (datab[26] | datab_exp_not_zero[2]), (datab[25] | datab_exp_not_zero[1]), (datab[24] | datab_exp_not_zero[0]), datab[23]},
		datab_man_not_zero = {(datab[22] | datab_man_not_zero[21]), (datab[21] | datab_man_not_zero[20]), (datab[20] | datab_man_not_zero[19]), (datab[19] | datab_man_not_zero[18]), (datab[18] | datab_man_not_zero[17]), (datab[17] | datab_man_not_zero[16]), (datab[16] | datab_man_not_zero[15]), (datab[15] | datab_man_not_zero[14]), (datab[14] | datab_man_not_zero[13]), (datab[13] | datab_man_not_zero[12]), (datab[12] | datab_man_not_zero[11]), datab[11], (datab[10] | datab_man_not_zero[9]), (datab[9] | datab_man_not_zero[8]), (datab[8] | datab_man_not_zero[7]), (datab[7] | datab_man_not_zero[6]), (datab[6] | datab_man_not_zero[5]), (datab[5] | datab_man_not_zero[4]), (datab[4] | datab_man_not_zero[3]), (datab[3] | datab_man_not_zero[2]), (datab[2] | datab_man_not_zero[1]), (datab[1] | datab_man_not_zero[0]), datab[0]},
		exp_is_inf = (((~ wire_exp_adj_adder_result[9]) & wire_exp_adj_adder_result[8]) | ((~ wire_exp_adj_adder_result[8]) & result_exp_all_one[7])),
		exp_is_zero = (wire_exp_adj_adder_result[9] | (~ result_exp_not_zero[8])),
		expmod = {{8{1'b0}}, (delay_man_product_msb & man_round_p2[24]), (delay_man_product_msb ^ man_round_p2[24])},
		inf_num = {8{1'b1}},
		lsb_bit = man_shift_full[1],
		man_result_round = ((man_round_p2[23:0] & {24{(~ man_round_p2[24])}}) | (man_round_p2[24:1] & {24{man_round_p2[24]}})),
		man_shift_full = ((wire_man_product2_mult_result[46:22] & {25{(~ wire_man_product2_mult_result[47])}}) | (wire_man_product2_mult_result[47:23] & {25{wire_man_product2_mult_result[47]}})),
		result = {sign_node_ff4[0:0], exp_result_ff[7:0], man_result_ff[22:0]},
		result_exp_all_one = {(result_exp_all_one[6] & wire_exp_adj_adder_result[7]), (result_exp_all_one[5] & wire_exp_adj_adder_result[6]), (result_exp_all_one[4] & wire_exp_adj_adder_result[5]), (result_exp_all_one[3] & wire_exp_adj_adder_result[4]), (result_exp_all_one[2] & wire_exp_adj_adder_result[3]), (result_exp_all_one[1] & wire_exp_adj_adder_result[2]), (result_exp_all_one[0] & wire_exp_adj_adder_result[1]), wire_exp_adj_adder_result[0]},
		result_exp_not_zero = {(result_exp_not_zero[7] | wire_exp_adj_adder_result[8]), (result_exp_not_zero[6] | wire_exp_adj_adder_result[7]), (result_exp_not_zero[5] | wire_exp_adj_adder_result[6]), (result_exp_not_zero[4] | wire_exp_adj_adder_result[5]), (result_exp_not_zero[3] | wire_exp_adj_adder_result[4]), (result_exp_not_zero[2] | wire_exp_adj_adder_result[3]), (result_exp_not_zero[1] | wire_exp_adj_adder_result[2]), (result_exp_not_zero[0] | wire_exp_adj_adder_result[1]), wire_exp_adj_adder_result[0]},
		round_bit = man_shift_full[0],
		round_carry = (round_dffe & (lsb_dffe | sticky_dffe)),
		sticky_bit = {(sticky_bit[21] | (wire_man_product2_mult_result[47] & wire_man_product2_mult_result[22])), (sticky_bit[20] | wire_man_product2_mult_result[21]), (sticky_bit[19] | wire_man_product2_mult_result[20]), (sticky_bit[18] | wire_man_product2_mult_result[19]), (sticky_bit[17] | wire_man_product2_mult_result[18]), (sticky_bit[16] | wire_man_product2_mult_result[17]), (sticky_bit[15] | wire_man_product2_mult_result[16]), (sticky_bit[14] | wire_man_product2_mult_result[15]), (sticky_bit[13] | wire_man_product2_mult_result[14]), (sticky_bit[12] | wire_man_product2_mult_result[13]), (sticky_bit[11] | wire_man_product2_mult_result[12]), (sticky_bit[10] | wire_man_product2_mult_result[11]), (sticky_bit[9] | wire_man_product2_mult_result[10]), (sticky_bit[8] | wire_man_product2_mult_result[9]), (sticky_bit[7] | wire_man_product2_mult_result[8]), (sticky_bit[6] | wire_man_product2_mult_result[7]), (sticky_bit[5] | wire_man_product2_mult_result[6]), (sticky_bit[4] | wire_man_product2_mult_result[5]), (sticky_bit[3] | wire_man_product2_mult_result[4]), (sticky_bit[2] | wire_man_product2_mult_result[3]), (sticky_bit[1] | wire_man_product2_mult_result[2]), (sticky_bit[0] | wire_man_product2_mult_result[1]), wire_man_product2_mult_result[0]};
endmodule //float_mult_altfp_mult
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module float_mult (
	clk_en,
	clock,
	dataa,
	datab,
	result)/* synthesis synthesis_clearbox = 1 */;

	input	  clk_en;
	input	  clock;
	input	[31:0]  dataa;
	input	[31:0]  datab;
	output	[31:0]  result;

	wire [31:0] sub_wire0;
	wire [31:0] result = sub_wire0[31:0];

	float_mult_altfp_mult	float_mult_altfp_mult_component (
				.clk_en (clk_en),
				.clock (clock),
				.dataa (dataa),
				.datab (datab),
				.result (sub_wire0));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: PRIVATE: FPM_FORMAT STRING "Single"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix V"
// Retrieval info: CONSTANT: DEDICATED_MULTIPLIER_CIRCUITRY STRING "YES"
// Retrieval info: CONSTANT: DENORMAL_SUPPORT STRING "NO"
// Retrieval info: CONSTANT: EXCEPTION_HANDLING STRING "NO"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "UNUSED"
// Retrieval info: CONSTANT: LPM_HINT STRING "UNUSED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altfp_mult"
// Retrieval info: CONSTANT: PIPELINE NUMERIC "5"
// Retrieval info: CONSTANT: REDUCED_FUNCTIONALITY STRING "NO"
// Retrieval info: CONSTANT: ROUNDING STRING "TO_NEAREST"
// Retrieval info: CONSTANT: WIDTH_EXP NUMERIC "8"
// Retrieval info: CONSTANT: WIDTH_MAN NUMERIC "23"
// Retrieval info: USED_PORT: clk_en 0 0 0 0 INPUT NODEFVAL "clk_en"
// Retrieval info: CONNECT: @clk_en 0 0 0 0 clk_en 0 0 0 0
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: USED_PORT: dataa 0 0 32 0 INPUT NODEFVAL "dataa[31..0]"
// Retrieval info: CONNECT: @dataa 0 0 32 0 dataa 0 0 32 0
// Retrieval info: USED_PORT: datab 0 0 32 0 INPUT NODEFVAL "datab[31..0]"
// Retrieval info: CONNECT: @datab 0 0 32 0 datab 0 0 32 0
// Retrieval info: USED_PORT: result 0 0 32 0 OUTPUT NODEFVAL "result[31..0]"
// Retrieval info: CONNECT: result 0 0 32 0 @result 0 0 32 0
// Retrieval info: GEN_FILE: TYPE_NORMAL float_mult.v TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL float_mult.qip TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL float_mult.bsf TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL float_mult_inst.v TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL float_mult_bb.v TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL float_mult.inc TRUE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL float_mult.cmp TRUE TRUE
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX NUMERIC "1"
// Retrieval info: LIB_FILE: lpm
