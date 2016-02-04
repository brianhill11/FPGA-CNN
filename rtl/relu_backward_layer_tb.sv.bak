`timescale 1ns/1ns

module relu_backward_layer_tb();

    parameter CYCLE = 100;
    //use $shortrealtobuts() to convert float to binary
    parameter NEG_SLOPE = $shortrealtobits(0.0001);
    parameter WIDTH = 4;

    reg clk, reset;
    shortreal a [WIDTH-1:0];
    reg [31:0] b [WIDTH-1:0];
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

    relu_backward_layer #(.NEGATIVE_SLOPE(NEG_SLOPE), .WIDTH(WIDTH) )
                    relu( .clk(clk), .reset(reset), .in_vec(a), .out_vec(b) );

    int i, j;
    initial begin
        reset = 0;
        repeat(10) begin
            i = i+1;
            //build the input vector of floats
            for (j = 0; j < WIDTH; j = j+1) begin
                $display("Build\tIteration %d\tinput %d\n", i, j);
                //generate a random sign bit, exponent, and mantissa value
                random_sign = $urandom(i+j) % 2;
                random_exp = $urandom(i+j+2) % 255;
                random_mantissa = $urandom(i+j+5);
                //concatenate sign bit, exponent, and mantissa to make float
                a[j] = {random_sign, random_exp, random_mantissa};
            end
            //take a quick break
            $display("a[0]: %b\n", a[0]);
            #(3*CYCLE)
            //check the output vector of floats
            for (j = 0; j < WIDTH; j = j+1) begin
                $display("Test: Iteration %d\tinput %d\n", i, j);
                //if the input value is greater than zero, then
                //output should be same as input
                if ($bitstoshortreal(a[j]) > 0e0) begin
                    $display("%f is greater than zero: %b\n", a[j], a[j]);
                    $display("a: %b b: %b\n", a[j], b[j]); 
                    assert( a[j] == b[j] );
                //else input value less than or equal to zero,
                //so output should be NEG_SLOPE
                end else begin
                    $display("%f is less than or equal to zero: %b\n", a[j], a[j]);
                    $display("NEG_SLOPE: %b\n", NEG_SLOPE);
                    $display("a: %b b: %b\n", a[j], b[j]); 
                    assert( $bitstoshortreal(b[j]) == $bitstoshortreal(NEG_SLOPE) );
                end
            end
        end
        $display("############################################\n");
        $display("All tests passed!\n");
        $display("############################################\n");
    end
endmodule

