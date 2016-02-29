/* Author: Youthawin Philavastvanid 
 * Date  : 02/08/2016 
 * 
 * Module: pooling_backward_opt
 * Desc  :
 *   
 * Design:  
 * Input : Takes in a 1D vector containing all the floating point values
 * Ouput : Maximum value of the float
 *
 * WARNING: Max number the module can handle is 32  floating point
*/

module pooling_backward_opt#(
	parameter 			
					k_w=3,		//kernel width
					k_h=3,		//kernel height
					k_size= k_w*k_h)(//kernel size


	input logic 				reset_n,			//reset
	input logic					clk,				//clock
	input logic	[7:0]			max_flt_idx,	//idx of max float in a kernel	
	input logic	[31:0]		data_vect_in[k_size-1:0],	//data input
	input logic	[31:0]		error_term,		//error term for a kernel

	output reg  [31:0]	data_vect_out[k_size-1:0]	//Vector data output
); 

reg [31:0]  max;
reg [31:0] result;

//	data_vect_out[row][col] <= data_vect_in[row][col]*error_term;
float_mult float_mult_inst	(
										.clk_en(!reset_n),
										.clock(clk),
										.dataa(max),
										.datab(error_term),
										.result(result)	
									);

	always @(posedge clk) begin
		for(int i=0; i<k_size; i++) begin: for_row_itr
			if(i != max_flt_idx) begin
				data_vect_out[i] <= data_vect_in[i];
			end else begin
				max <= data_vect_in[max_flt_idx];
				data_vect_out[max_flt_idx] <= result;
			end
		end //End here -- for(i)
	end //End here -- always
	
endmodule
