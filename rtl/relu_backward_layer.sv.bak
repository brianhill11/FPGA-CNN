
module relu_backward_layer #(parameter WIDTH = 4, parameter NEGATIVE_SLOPE = 0)
                            ( input   logic           clk,                //clock signal
                            input   logic           reset,              //reset signal
                            input   logic [31:0]    in_vec  [WIDTH-1:0],//vector of floats
                            output  reg   [31:0]    out_vec [WIDTH-1:0] //vector of floats
                          );

    //parameter NEGATIVE_SLOPE = 0;
    //parameter WIDTH = 4;
 
    generate
        genvar i;
    
        for (i = 0; i < WIDTH; i = i+1) begin
            relu_backward_opt #(.NEGATIVE_SLOPE(NEGATIVE_SLOPE)) 
                relu_ops ( .clk(clk), .reset(reset), 
                            .in_data(in_vec[i]), .out_data(out_vec[i]) );
        end
    endgenerate

endmodule
