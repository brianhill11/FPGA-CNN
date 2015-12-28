`timescale 1ns/1ns

program mult_test_tb;
	class FillerParameter;
		//Member variables
		string _type; //default 'constant'
		shortreal value; //default 0
		shortreal min; //default 0
		shortreal max; //default 1
		shortreal mean; //default 0
		shortreal std; //default 1
		integer sparse; //default -1
		typedef enum {
			FAN_IN = 0;
			FAN_OUT = 1;
			AVERAGE = 2;
		} VarianceNorm;
		VarianceNorm variance_norm; //default FAN_IN
		//Constuctor 
		function new ();
			begin
				this._type = 'constant';
				this.min = 0.0;
				this.max = 1.0;
				this.mean = 0.0;
				this.std = 1.0;
				this.sparse = -1;
				this.variance_norm = FAN_IN;
			end
		endfunction
		//Accessor methods 
		//'type' variable
		function bit has_type();
			begin
				if (this._type.len() > 0) begin
					return 1'b1;
				end else begin
					return 1'b0;
				end
			end
		endfunction
		
		function void clear_type();
			begin
				this._type = '';
			end
		endfunction
		
		function string _type();
			begin
				return this._type;
			end
		endfunction
		
		function void set_type(string new_type);
			begin
				this._type = new_type;
			end
		endfunction
		//'min' variable
		function bit has_min();
			begin
				return 1'b1;
			end
		endfunction
		
		function void clear_min();
			begin
				this.min = 0.0;
			end
		endfunction
		
		function shortreal min();
			begin
				return this.min;
			end
		endfunction
		
		function void set_min(shortreal new_min);
			begin
				this.min = new_min;
			end
		endfunction
		//'max' variable
		function bit has_max();
			begin
				return 1'b1;
			end
		endfunction
		
		function void clear_max();
			begin
				this.max = 1.0;
			end
		endfunction
		
		function shortreal max();
			begin
				return this.max;
			end
		endfunction
		
		function void set_max(shortreal new_max);
			begin
				this.max = new_max;
			end
		endfunction
		//'mean' variable
		function bit has_mean();
			begin
				return 1'b1;
			end
		endfunction
		
		function void clear_mean();
			begin
				this.mean = 0.0;
			end
		endfunction
		
		function shortreal mean();
			begin
				return this.mean;
			end
		endfunction
		
		function void set_mean(shortreal new_mean);
			begin
				this.mean = new_mean;
			end
		endfunction
		//'std' variable
		function bit has_std();
			begin
				return 1'b1;
			end
		endfunction
		
		function void clear_std();
			begin
				this.std = 1.0;
			end
		endfunction
		
		function shortreal std();
			begin
				return this.std;
			end
		endfunction
		
		function void set_std(shortreal new_std);
			begin
				this.std = new_std;
			end
		endfunction
		//'sparse' variable
		function bit has_sparse();
			begin
				return 1'b1;
			end
		endfunction
		
		function void clear_sparse();
			begin
				this.sparse = -1;
			end
		endfunction
		
		function integer sparse();
			begin
				return this.sparse;
			end
		endfunction
		
		function void set_sparse(integer new_sparse);
			begin
				this.sparse = new_sparse;
			end
		endfunction
		//'VarianceNorm' variable
		function bit has_variance_norm();
			begin
				return 1'b1;
			end
		endfunction
		
		function void clear_variance_norm();
			begin
				this.variance_norm = FAN_IN;
			end
		endfunction
		
		function VarianceNorm variance_norm();
			begin
				return this.variance_norm;
			end
		endfunction
		
		function void set_variance_norm(VarianceNorm new_variance_norm);
			begin
				this.variance_norm = new_variance_norm;
			end
		endfunction
	endclass
	
	class ConvolutionParameter;
		unsigned integer num_output;
		bit bias_term; //default true
		unsigned integer pad;
		unsigned integer kernel_size;
		unsigned integer stride;
		unsigned integer pad_h; //default 0
		unsigned integer pad_w; //default 0
		unsigned integer kernel_h;
		unsigned integer kernel_w;
		unsigned integer stride_h;
		unsigned integer stride_w;
		unsigned integer group; //default 1
		FillerParameter weight_filler;
		FillerParameter bias_filler;
		typedef enum {
			DEFAULT = 0;
			CAFFE = 1;
			CUDNN = 2;
		} Engine;
		Engine engine; //default = DEFAULT
		integer axis; //default 1
		bit force_nd_im2col; //default false
		//Constructor
		function new ();
			begin
				this.bias_term = 1'b1;
				this.pad_h = 0;
				this.pad_w = 0;
				this.kernel_h = 1;
				this.kernel_w = 1;
				this.stride_h = 1;
				this.stride_w = 1;
				this.group = 1;
				this.engine = DEFAULT;
				this.axis = 1;
				this.force_nd_im2col = 1'b0;
			end
		endfunction
		//Accessor functions
		//'num_output' variable
		function unsigned integer num_output();
			begin
				return this.num_output;
			end
		endfunction
		
		function void set_num_output(unsigned integer new_num_output);
			begin
				this.num_output = new_num_output;
			end
		endfunction
		//'bias_term' variable
		function bit bias_term();
			begin
				return this.bias_term;
			end
		endfunction
		
		function void set_bias_term(bit new_bias_term);
			begin
				this.bias_term = new_bias_term;
			end
		endfunction
		//'pad' variable
		function unsigned integer pad();
			begin
				return this.pad;
			end
		endfunction
		
		function void set_pad(unsigned integer new_pad);
			begin
				this.pad = new_pad;
			end
		endfunction
		//'kernel_size' variable
		function unsigned integer kernel_size();
			begin
				return this.kernel_size();
			end
		endfunction
		
		function void set_kernel_size(unsigned integer new_kernel_size);
			begin
				this.kernel_size = new_kernel_size;
			end
		endfunction
		//'stride' variable
		function unsigned integer stride();
			begin
				return this.stride;
			end
		endfunction
		
		function void set_stride(unsigned integer new_stride);
			begin
				this.stride = new_stride;
			end
		endfunction
		//'pad_h' variable
		function bit has_pad_h();
			begin
				if (this.pad_h > 0) begin
					return 1'b1;
				end else begin
					return 1'b0;
				end
			end
		endfunction
		
		function unsigned integer pad_h();
			begin
				return this.pad_h;
			end
		endfunction
		
		function void set_pad_h(unsigned integer new_pad_h);
			begin
				this.pad_h = new_pad_h;
			end
		endfunction
		//'pad_w' variable
		function bit has_pad_w();
			begin
				if (this.pad_w > 0) begin
					return 1'b1;
				end else begin
					return 1'b0;
				end
			end
		endfunction
		
		function unsigned integer pad_w();
			begin
				return this.pad_w;
			end
		endfunction
		
		function void set_pad_w(unsigned integer new_pad_w);
			begin
				this.pad_w = new_pad_w;
			end
		endfunction
		//'kernel_h' variable
		function bit has_kernel_h();
			begin
				if (this.kernel_h > 1) begin
					return 1'b1;
				end else begin
					return 1'b0;
				end
			end
		endfunction
		
		function unsigned integer kernel_h();
			begin
				return this.kernel_h;
			end
		endfunction 
		
		function void set_kernel_h(unsigned integer new_kernel_h);
			begin
				this.kernel_h = new_kernel_h;
			end
		endfunction
		//'kernel_w' variable
		function bit has_kernel_w();
			begin
				if (this.kernel_w > 1) begin
					return 1'b1;
				end else begin
					return 1'b0;
				end
			end
		endfunction
		
		function unsigned integer kernel_w();
			begin
				return this.kernel_w;
			end
		endfunction 
		
		function void set_kernel_w(unsigned integer new_kernel_w);
			begin
				this.kernel_w = new_kernel_w;
			end
		endfunction
		//'stride_h' variable
		function bit has_stride_h();
			begin
				if (this.stride_h > 1) begin
					return 1'b1;
				end else begin
					return 1'b0;
				end
			end
		endfunction
		
		function unsigned integer stride_h();
			begin
				return this.stride_h;
			end
		endfunction 
		
		function void set_stride_h(unsigned integer new_stride_h);
			begin
				this.stride_h = new_stride_h;
			end
		endfunction
		//'stride_w' variable
		function bit has_stride_w();
			begin
				if (this.stride_w > 1) begin
					return 1'b1;
				end else begin
					return 1'b0;
				end
			end
		endfunction
		
		function unsigned integer stride_w();
			begin
				return this.stride_w;
			end
		endfunction 
		
		function void set_stride_w(unsigned integer new_stride_w);
			begin
				this.stride_w = new_stride_w;
			end
		endfunction
		//'group' variable
		function unsigned integer group();
			begin
				return this.group;
			end
		endfunction
		
		function void set_group(unsigned integer new_group);
			begin
				this.group = new_group;
			end
		endfunction
		//'weight_filler' variable
		function FillerParameter weight_filler();
			begin
				return this.weight_filler;
			end
		endfunction
		
		function void set_weight_filler(FillerParameter new_weight_filler);
			begin
				this.weight_filler = new_weight_filler;
			end
		endfunction
		//'bias_filler' variable
		function FillerParameter bias_filler();
			begin
				return this.bias_filler;
			end
		endfunction
		
		function void set_bias_filler(FillerParameter new_bias_filler);
			begin
				this.bias_filler = new_bias_filler;
			end
		endfunction
	endclass
	
	parameter CYCLE = 10;
	reg clk;
	shortreal a;
	shortreal b;
	reg [31:0] c;
	
	logic [31:0] x [7:0][7:0];
	logic [31:0] f [1:0][1:0];
	logic [31:0] y [3:0];
	
	initial begin
		clk <= 0;
		forever begin
			#(CYCLE/2) clk = ~clk;
		end
	end
	
	function [31:0]conv(logic [31:0] x [7:0][7:0], logic [31:0] f [1:0][1:0]);
		
	endfunction
	
	function caffe_conv(in, ConvolutionParameter conv_param, weights, out);
		begin
			//Set Kernel size
			int kernel_h, kernel_w;
			if (conv_param.has_kernel_h() || conv_param.has_kernel_w()) begin
				kernel_h = conv_param.kernel_h();
				kernel_w = conv_param.kernel_w();
			end else begin
				kernel_h = kernel_w = conv_param.kernel_size();
			end
			//Set Kernel pad
			int pad_h, pad_w;
			if (conv_param.has_pad_h() || conv_param.has_pad_w()) begin
				pad_h = conv_param.pad_h();
				pad_w = conv_param.pad_w();
			end else begin
				pad_h = pad_w = conv_param.pad_size() ? con_param.pad() : 0;
			end
			//Set Kernel stride
			int stride_h, stride_w;
			if (conv_param.has_stride_h() || conv_param.has_stride_w()) begin
				stride_h = conv_param.stride_h();
				stride_w = conv_param.stride_w();
			end else begin
				stride_h = stride_w = conv_param.stride_size() ? conv_param.stride() : 1;
			end
			//Set Kernel depth
			//TODO
			//Groups
			int groups, o_g, k_g, o_head, k_head;
			groups = conv_param.group();
			
			
		end
	endfunction

	
	mult_test mult_test_inst( .clk(clk), .in_data(a), 
										.mult(b), .out_data(c) );
	
	initial begin
		x[0][0] = $shortrealtobits(1.0);
		x[0][1] = $shortrealtobits(2.0);
		x[0][2] = $shortrealtobits(3.0);
		x[0][3] = $shortrealtobits(4.0);
		x[0][0] = $shortrealtobits(1.0);
		x[0][1] = $shortrealtobits(2.0);
		x[0][2] = $shortrealtobits(3.0);
		x[0][3] = $shortrealtobits(4.0);
		y[0] = conv( x, f );
		$display("x[0][0]: %b\ny: %b\n", x[0][0], y[0]);
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
	
endprogram
	