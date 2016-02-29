/* Author: Youthawin Philavastvanid 
 * Date  : 02/08/2016 
 * 
 * Module: loss_opt
 * Desc  :
 *   
 * Design:  
 * Input : 
 * Ouput :
 *
 * Timeline: 
 
 * WARNING: 
	f_inc_idx should be a pulse w/ 1 clk cyc WIDTH indicating it is time increment the idx of the adder
	f_inc_idx_exp should be a pulse w/ 1 clk cyc WIDTH indicating it is time increment the idx of the e^( z_correctClassification )
*/

module lol_opt#(
	parameter 				WEIGHT=1,
							WIDTH=8	//number of float input 
					 )(

	input					reset_n,	//reset
	input 					clk,		//clock
	input					f_overall_sum,				//Summer inc flag 
	input		[31:0]		all_clsf [WIDTH-1:0],	//calculated classification
	input		[31:0]		corr_clsf,				//correcnt classification
	input reg	[7:0]		in_ID,

	output reg	[7:0]		out_ID,
	output reg  [31:0]		data_out	//Vector data output

); 

	reg [31:0] sub_result [WIDTH-1:0];
	reg [31:0] corr_clsf_sub_result;
	reg [31:0] overall_sum;
	reg [31:0] buff_overall_sum;
	reg [31:0] current_sum;
	
	reg [31:0] sum_e_all_clsf;				//SUM( e^( z_allClassification ) )
	reg [31:0] buff_sum_e_all_clsf;			//output buff for SUM( e^( z_allClassification ) )

	reg [31:0] e_all_clsf	   [WIDTH-1:0];	//e^( z_allClassification ) 
	reg [15:0] idx_e_all_clsf;				//idx for e_all_clsf
	reg 	   f_set_inc_idx_e_all;			//increment flag for idx_e_all_clsf

	reg [31:0] e_corr_clsf;					//e^( z_correctClassification )

	reg [31:0] div_ecorr_sumall;			//e^( z_correctClassification ) / SUM( e^( z_allClassification )

	reg [31:0] buff_out_div;
	reg [31:0] buff_out;

	logic [31:0] connections [2*WIDTH] ;
	
	genvar i, j;
	generate 
		//create float_sub blocks to subtract WIDTH number 
		//of inputs with weight_vec
		for (i = 0; i < WIDTH; i++) begin : GEN_SUBS
			flt_sub flt_sub_inst(									
												.aclr(!reset_n),
												.clock(clk),
												.dataa(all_clsf[i]),
												.datab(corr_clsf),
												.result(sub_result[i])
												);
		end 
		//create float_exp blocks to multiply WIDTH number 
		//of inputs with weight_vec
		for (i = 0; i < WIDTH; i++) begin : GEN_EXPS
			flt_exp flt_exp_inst(									
												.aclr(!reset_n),
												.clock(clk),
												.data(sub_result[i]),
												.result(connections[i+WIDTH])
												);
		end 
		//sum the products, and reduce to single value
		for (i = WIDTH; i > 1; i = i / 2) begin : GEN_SUMS
			for (j = i; j > i/2 && j != 1; j--) begin : SUM_MULTS
					flt_add flt_add_inst(
												 .aclr(!reset_n),
												 .clock(clk),
												 .dataa(connections[2*j-1]),
												 .datab(connections[2*j-2]),
												 .result(connections[j-1])
												 );
			end
		end
	endgenerate

	flt_add_new flt_add_overall_sum( 
												 .aclr(!reset_n),
												 .clock(clk),
												 .dataa(current_sum),
												 .datab(overall_sum),
												 .result(buff_overall_sum)
												 );
	//forwarding the ID
	assign out_ID = in_ID;
	assign current_sum = connections[1];
	always_ff @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			overall_sum <= 0;
		end else begin
			if( f_overall_sum ) 
				overall_sum <= buff_overall_sum;
			else 
				overall_sum <= overall_sum;
		end
	end


	//Dividing --  e^( z_correctClassification ) / SUM( e^( z_allClassification ) )
	flt_div_new flt_div_inst(																//[+6]
		.aclr	(!reset_n),
		.clock	(clk),
		.dataa	(32'h3f800000),
		.datab	(buff_overall_sum),
		.result	(div_ecorr_sumall)		);
		
	//Taking log of quotion product
	flt_log flt_log(																//[+21]
		.aclr	(!reset_n),
		.clock	(clk),
		.data	(div_ecorr_sumall),
		.result	(buff_out_div)			);
		
	//Multiply (-1)
	assign data_out = buff_out_div ^ (1<<31);

endmodule

