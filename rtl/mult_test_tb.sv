`timescale 1ns/1ns

module mult_test_tb();
	parameter CYCLE = 10;
	reg clk;
	shortreal a;
	shortreal b;
	reg [31:0] c;
	
	initial begin
		clk <= 0;
		forever begin
			#(CYCLE/2) clk = ~clk;
		end
	end
	
	mult_test mult_test_inst( .clk(clk), .in_data(a), 
										.mult(b), .out_data(c) );
	
	initial begin
		a = 2.0e3;
		b = 2.0e1;
		#(6*CYCLE)
		$display("a: %f\tb: %f\n", a, b);
		$display("a*b:\t %b\n", $shortrealtobits(a*b) );
		$display("c:\t %b\n", c);
		assert( c == $shortrealtobits(a*b) );
		a = 2.42232e2;
		b = 2.0e1;
		#(6*CYCLE)
		$display("a: %f\tb: %f\n", a, b);
		$display("a*b:\t %b\n", $shortrealtobits(a*b) );
		$display("c:\t %b\n", c);
		assert( c == $shortrealtobits(a*b) );
	end
	
endmodule
	