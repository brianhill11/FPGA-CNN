/*
 * ECE 441 Senior Design
 * Block: ReLU Forward Propagation
 * Sophia Zhang
 * File Name: relu_forward.sv
 * Module: ReLU Forward Activation Layer
 * Description: The forward activation layer for the ReLU layer using single
 * precision floating point values.  Takes a row of an array.  For each data
 * vector, it takes the sum of two values.  The first value is the maximum value
 * between the input and 0.  The second value is the product of the negative slope
 * and the minimum value between the input and 0.  The sum is then set as the output.
 */

module relu_forward #(parameter negative_slope = 0, parameter WIDTH = 4)
                   (    input logic           reset_n,                  //reset
                        input logic          clk,                       //clock signal
                        input logic  [31:0]  in_data [WIDTH-1:0],       //data vector of floats
                        output reg [31:0]  out_data [WIDTH-1:0]         //data vector of floats
                );


        generate
                genvar i;
                for(i = 0; i < WIDTH; i = i+1) begin
                        always@(posedge clk, negedge reset_n) begin
                                if(in_data[i][31] == 0)
                                        out_data[i] <= in_data[i];
                                else //in_data[i][31] == 1
                // output is the product of the negative slope and the input. Since the negative
                // slope is 0, the output is 0 because the product of 0 and a value is 0.

                                out_data[i] <= in_data[i] * negative_slope;

                //relu_forward_mult relu_forward_mult_inst( .clock(clk), .dataa(in_data[i]), .datab(negative_slope), .result(out_data[i]) );
                // above is an instance for relu_forward_mult_altfp_mult_fkn module for floating
                // point multiplication of the input value and the negative slope. It also takes
                // in clock and the out_data for the output vector.

// for each value 'x' in input data vector, calculate max(0, 'x')
// takes max of value between input and 0 (part 1)
// takes product of negative slope value and min value between input
// and 0 (part 2)
// calculates sum of part 1 and part 2; sets that value to the output
                        end
                end
        endgenerate
endmodule
