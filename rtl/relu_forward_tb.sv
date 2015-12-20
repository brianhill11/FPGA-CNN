`timescale 1ns/1ns

module relu_forward_tb();
        parameter CYCLE = 100;
        parameter WIDTH = 4;
        parameter negative_slope = $shortrealtobits(0.0001);

        // initialize registers and variables
        reg clk;                        // clock
        reg reset_n;                    // reset
        shortreal a [WIDTH-1:0];        // float a
        reg [31:0] b [WIDTH-1:0];               // float b

        reg sign;               // 1 bit for random float sign
        reg [10:0] exp;         // 8 bits for random float sign
        reg [51:0] mantissa;    // 23 bits for random float mantissa
        int i, j;               // Used in for-loop

        // create the clock
        initial begin
                clk <= 0;
                forever begin // clock cycles forever
                        #(CYCLE/2) clk = ~clk;
                end
        end



        // ReLU Forward Activation Layer
        relu_forward relu( .clk(clk), .reset_n(reset_n), .in_data(a), .out_data(b) );


        // Randomizing real numbers in terms of sign, exponents, and mantissa
        initial begin
                reset_n = 0;    //initialize reset
                repeat(10) begin
                        i = i + 1;

                        // Create an input vector of floats
                        for (j = 0; j < WIDTH; j = j + 1) begin
                                // Prints message
                                $display("Creating Inputs of %d Iterations\n", i);
                                // Generates a random unsigned value. Positive values have sign = 0.
                                // Negative values have sign = 1.
                                sign = $urandom(i) % 2;
                                // Generates a random unsigned exponent
                                exp = $urandom(i+2) % 255;
                                // Generates a random mantissa value
                                mantissa = $random(i+5);
                                // concatenate sign bit, exponent value, and mantissa to produce a float
                                a = {sign, exp, mantissa};
                        end

                        // Print out the first value in the input vector
                        $display("The first value in the input vector a[0] is: %b\n", a[0]);
                        #(3*CYCLE)
                        // checks the outputs produced after the comparison made
                        for (j = 0; j < WIDTH; j = j+1) begin
                                // Displays the iteration to help the user keep track
                                $display("Interation %d tested with input %d\n", i, j);

                                // if the last bit of the input value is equal to zero, then the
                                // output should be the same as the input
                                if($bitstoshortreal(a[31]) == 0e0) begin
                                        $display("The last bit %f is equal to zero: %b\n", a[j], a[j]);
                                        $display("a[31]: %b c: %b\n", a[j], b[j]);
                                        assert(a[j] == b[j]);
                                end

                                // Otherwise, if the last bit of the input value is equal to one,
                                // then the output should be the product of the input and the
                                // negative slope.
                                else begin
                                        $display("%f is greater than 0: %b\n", a[j], a[j]);
                                        $display("input a: %b\n",  a[j]);
                                        $display("negative_slope: %b\n", negative_slope);
                                        //$display("a: %b c: %b\n", a, c);
                                end
                        end

                end

                $display("\n\n All tests have passed \n\n");
        end
endmodule

