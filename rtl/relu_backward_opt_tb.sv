`timescale 1ns/1ns

module relu_backward_opt_tb();

    parameter CYCLE = 100;
    //use $shortrealtobuts() to convert float to binary
    parameter NEG_SLOPE = $shortrealtobits(0.0001);

    reg clk, reset;
    shortreal a;
    reg [31:0] b;
    reg random_sign;            //1 bit for random float sign
    reg [7:0] random_exp;       //8 bits for random float exp
    reg [22:0] random_mantissa; //23 bits for random float mantissa
    
    //forever cycle the clk
    initial begin
        clk <= 0;
        forever begin
            #(CYCLE/2) clk = ~clk;
        end
    end

    relu_backward_opt #(.NEGATIVE_SLOPE(NEG_SLOPE)) relu( .clk(clk), .reset(reset), .in_data(a), .out_data(b) );

    int i;
    initial begin
        reset = 0;
        repeat(10000) begin
            i = i+1;
            //generate a random sign bit, exponent, and mantissa value
            random_sign = $urandom(i) % 2;
            random_exp = $urandom(i+2) % 255;
            random_mantissa = $urandom(i+5);
            //concatenate sign bit, exponent, and mantissa to make float
            a = {random_sign, random_exp, random_mantissa};
            #(3*CYCLE)
            //if the input value is greater than zero, then
            //output should be same as input
            if ($bitstoshortreal(a) > 0e0) begin
                //$display("%f is greater than zero: %b\n", a, a);
                //$display("a: %b b: %b\n", a, b); 
                assert( a == b );
            //else input value less than or equal to zero,
            //so output should be NEG_SLOPE
            end else begin
                //$display("%f is less than or equal to zero: %b\n", a, a);
                //$display("NEG_SLOPE: %b\n", NEG_SLOPE);
                //$display("a: %b b: %b\n", a, b); 
                assert( $bitstoshortreal(b) == $bitstoshortreal(NEG_SLOPE) );
            end
        end
        $display("############################################\n");
        $display("All tests passed!\n");
        $display("############################################\n");
    end
endmodule

