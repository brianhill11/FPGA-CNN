`include "sw.vh"

module sw_array(
					input logic clk,
					input logic resetb,
					sw_bus_t 		sw_bus
					);
	
	
	typedef enum logic [2:0] {IDLE, RUN, FINISH} state_t;
	
	state_t state;
	state_t next_state;

	logic [8:0]		pipeline_delay_counter;
	logic [15:0]	max_weight_buffer_addr;
	logic [7:0] 	image_rd_addr;
	logic [12:0] 	weight_rd_addr;
	logic [CACHE_WIDTH-1:0] image_buffer_in;
	logic [CACHE_WIDTH-1:0] weight_buffer_in	[NUM_PE-1:0];
	logic [CACHE_WIDTH-1:0] result_out;
	
	logic [7:0] 	cycle_count;
	
	//finished with an image section once we have gone through all filters
	assign max_weight_buffer_addr = sw_bus.max_weight_buffer_addr;
	assign filters_finished = weight_rd_addr == max_weight_buffer_addr;

	//we feed input to the convolutional layer every clock cycle, 
	//so at the start the pipeline is empty and once we have finished 
	//with the final input we still need to wait until the computation
	//has finished (i.e. pipeline is empty)
	assign pipeline_full = pipeline_delay_counter == NUM_CYCLES;
	assign pipeline_empty = pipeline_delay_counter == 0;

	assign sw_bus.pipeline_full = pipeline_full;
	assign sw_bus.pipeline_empty = pipeline_empty;

	//=================================================================
	//  FSM 
	//=================================================================
	
	// FSM state update
	always_ff @(posedge clk) begin
		if (!resetb) begin
			state <= IDLE;
		end else begin
			state <= next_state;
		end
	end

	// IDLE		: either module was reset or we finished with an image section
	// RUN		: weight data was loaded and we have an image section to use 
	// FINISH	: we have finished with all filters and pipeline is empty
	always_comb begin
		case (state)
			IDLE:
				next_state = sw_bus.start ? RUN : IDLE;
			RUN:
				next_state = filters_finished ? FINISH : RUN;
			FINISH:
				next_state = pipeline_empty ? IDLE : FINISH;
			default:
				next_state = state;
		endcase
	end
	
	//=================================================================
	//  COUNTERS 
	//=================================================================
/*
	always_ff @(posedge clk) begin
		if (!resetb) begin
			max_weight_buffer_addr <= 0;
		end 
		else begin
			max_weight_buffer_addr <= sw_bus.max_weight_buffer_addr;
		end
	end
*/

	always_ff @(posedge clk) begin
		if (!resetb) begin
			pipeline_delay_counter <= 0;
		end
		else if (state == RUN && ~pipeline_full) begin
			pipeline_delay_counter <= pipeline_delay_counter + 1;
		end
		else if (state == FINISH && ~pipeline_empty) begin
			pipeline_delay_counter <= pipeline_delay_counter - 1;;
		end
		else begin
			pipeline_delay_counter <= 0;
		end
	end
	
	//=================================================================
	//  SIGNALING TO ENGINE/PREFETCH 
	//=================================================================

	//once the pipeline is full, we have valid data and then
	//when we have finished with the last filter we still have 
	//valid data in the pipeline until it has cleard out 
	always_ff @(posedge clk) begin
		if (!resetb) begin
			sw_bus.valid <= 0;
		end
		else if (pipeline_full || state == FINISH) begin
			sw_bus.valid <= 1;
		end
		else begin
			sw_bus.valid <= 0;
		end
	end

	//when we have finished and no more data in pipeline, we're done
	always_ff @(posedge clk) begin
		if (!resetb) begin
			sw_bus.filters_finished <= 0;
		end
		else if (state == FINISH) begin
			sw_bus.filters_finished <= 1;
		end
		else begin
			sw_bus.filters_finished <= 0;
		end
	end

	//=================================================================
	//  DATA ADDRESSING
	//=================================================================

	//increment weight_rd_addr once per clock cycle
	always_ff @(posedge clk) begin
		if (!resetb || filters_finished) begin
			weight_rd_addr <= 0;
		end 
		else if (state == RUN) begin
			weight_rd_addr <= weight_rd_addr + 1;
		end 
	end

	//increment image_rd_addr once we have finished with every filter
	always_ff @(posedge clk) begin
		if (!resetb) begin
			image_rd_addr <= 0;
		end 
		else if (filters_finished) begin
//			image_rd_addr <= image_rd_addr + 1;
			image_rd_addr <= 0;
		end
	end
	
	assign sw_bus.addr_a = state == IDLE ? 0 : weight_rd_addr;
	assign sw_bus.addr_b = state == IDLE ? 0 : image_rd_addr; 

	//=================================================================
	//  DATA MOVEMENT
	//=================================================================
	
	//if running, fill weight buffer at each clk 
	always_ff @(posedge clk) begin
			weight_buffer_in <= sw_bus.data_a;
	end

	//if idle or we completed all filters, fill image buffer 
	always_ff @(posedge clk) begin
		if (state == IDLE || state == RUN) begin
			image_buffer_in <= sw_bus.data_b;
		end
	end

	//output result to bus if data is valid
	always_ff @(posedge clk) begin
		if (!resetb) begin
			sw_bus.result <= 0;
		end 
		else if (~pipeline_empty) begin
			sw_bus.result <= result_out;
		end
	end
	
	//=================================================================
	//  CONVOLUTION LAYER INSTANTIATION 
	//=================================================================
	
	genvar i;
	generate 
		for (i = 0; i < NUM_PE; i++) begin : GEN_CONV_PE		
			conv_forward_layer #(.WIDTH(16))
				conv_forward_inst(
											.clk(clk),
											.reset(resetb),
											.id(weight_rd_addr[7:0]),
											.in_data(image_buffer_in),
											.weight_vec(weight_buffer_in[i]),
											.out_data(result_out[(i+1)*32-1:i*32])
										);

		end
	endgenerate

	// synthesis translate_off
	always_ff @(posedge clk) begin
//		if (image_buffer_in != 0) begin
		if (0) begin
			$display("///////////////////  RUNNING  ///////////////////");
			$display("weight_buffer_in: 0x%h", weight_buffer_in[0]);
			$display("image_buffer_in: 0x%h", image_buffer_in);
			$display("result_out: 0x%h", result_out);
			$display("max_weight_buffer_addr: 0x%h", max_weight_buffer_addr);
			$display("pipeline_delay_counter: %d pipeline_full: 0x%h pipeline_empty: 0x%h", pipeline_delay_counter, pipeline_full, pipeline_empty);
			$display("conv state = 0x%h, image_rd_addr: 0x%h, weight_rd_addr: 0x%h, sw_bus.result: 0x%h", state, image_rd_addr, weight_rd_addr, sw_bus.result);
			$display("/////////////////////////////////////////////////");
			$display("");
		end
	end
	
	always_ff @(posedge clk) begin
		if (0) begin
			$display("(((((((((((((((((( RESULT ))))))))))))))))))");
			$display("weight_buffer_in: 0x%h", sw_bus.data_a[0]);
			$display("image_buffer_in: 0x%h", sw_bus.data_b);
			$display("conv state = 0x%h, image_rd_addr: 0x%h, weight_rd_addr: 0x%h, sw_bus.result: 0x%h", state, image_rd_addr, weight_rd_addr, sw_bus.result);
			$display("RESULT: 0x%h ", result_out);
			$display("(((((((((((((((((((       )))))))))))))))))))");
			$display("");
		end
	end

	
	// synthesis translate_on
	
	
endmodule
						
