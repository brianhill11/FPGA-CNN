

module sw_array(
					input logic clk,
					input logic resetb,
					sw_bus_t 		sw_bus
					);
	
	parameter NUM_BLOCKS = 8;
	parameter NUM_CYCLES = 5 + 7; //5 cycles for mult, 7 for add
	parameter MIN_CL_COUNT = 12; //randomly selected for the moment
	parameter BUFFER_DEPTH = 256;
	
	typedef enum logic [2:0] {IDLE, READ, RUN, FINISH} state_t;
	
	state_t state;
	state_t next_state;
	logic [7:0] cl_count;
	logic [7:0] rd_addr;
	logic [4:0] cycle_count;
	
	// FSM state update
	always_ff @(posedge clk) begin
		if (!resetb) begin
			state <= IDLE;
		end else begin
			state <= next_state;
		end
	end
	
	
	always_comb begin
		case (state)
			IDLE:
				next_state = sw_bus.start ? READ : IDLE;
			READ: 				
				next_state = RUN;
			RUN:
				next_state = cycle_count == NUM_CYCLES ? FINISH : RUN;
			FINISH:
				next_state = sw_bus.ready ? IDLE : FINISH;
			default:
				next_state = state;
		endcase
	end
	
	//in idle we reset the counter variables
	always_ff @(posedge clk) begin
		if (state == IDLE) begin
			cl_count <= 0;
		end
	end
	
	logic [255:0] conv_out;
	logic [511:0] data_buffer_in;
	logic [511:0] weight_buffer_in;
	
	//if starting, fill data and weight buffers
	always_ff @(posedge clk) begin
		if (state == READ) begin
			data_buffer_in <= sw_bus.data_a;
			weight_buffer_in <= sw_bus.data_b;
		end
	end
	
	//after we have completed a computation, increment addr
	always_ff @(posedge clk) begin
		if (state == RUN) begin
			if (cycle_count > NUM_CYCLES) begin
				cycle_count <= 0;
			end else begin
				cycle_count <= cycle_count + 1;
			end
		end
	end

	//if busy, we're not ready
	always_ff @(posedge clk) begin
		if (!resetb) begin
			sw_bus.ready <= 1;
		end else if (state == READ) begin
			sw_bus.ready <= 0;
		end else if (cycle_count > NUM_CYCLES) begin
			sw_bus.ready <= 1;
		end
	end

	//output conv_out to bus
	always_ff @(posedge clk) begin
		if (state == READ) begin
			sw_bus.max_out <= 0;
		end else if (cycle_count == NUM_CYCLES) begin
			sw_bus.max_out <= conv_out;
		end
	end
								
	genvar i;
	generate 
		for (i = 0; i < NUM_BLOCKS; i++) begin : GEN_CONV
			conv_forward_layer #(.WIDTH(2))
				conv_forward_inst(
											.clk(clk),
											.reset(resetb),
											.id(rd_addr),
											.in_data(data_buffer_in[(i+1)*64-1:i*64]),
											.weight_vec(weight_buffer_in[(i+1)*64-1:i*64]),
											.out_data(conv_out[(i+1)*32-1:i*32])
										);
		end
	endgenerate
	
	
	
endmodule
						
