
module relu_backward_opt( input   logic         clk,        //clock signal
                          input   logic         reset,      //reset signal
                          input   logic [31:0]  in_data,    //32-bit float
                          output  reg   [31:0]  out_data);  //32-bit float

    parameter NEGATIVE_SLOPE = 0;
    parameter WIDTH = 256;
  
    //at rising edge of clock
    always_ff @(posedge clk, negedge reset) begin 
        //check for reset value, else continue
        if (!reset) begin
            //if value is positive, output the value
            if (in_data[31] == 0) begin
                out_data <= in_data;
            //else output the NEGATIVE_SLOPE (usually 0)
            end else begin
                out_data <= NEGATIVE_SLOPE;
            end
        end
    end
endmodule
