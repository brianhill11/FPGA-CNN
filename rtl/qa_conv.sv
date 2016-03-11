

module qa_conv(
					input logic clk, 
					input logic resetb,
					input logic ready,
					input logic start,
					input logic buffer_select,
					input logic [7:0] wr_addr,
					input logic [511:0] data,
					output logic [511:0] result
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
				next_state = start ? READ : IDLE;
			READ: //read until we have at least MIN_CL_COUNT cachelines in buff
				next_state = cacheline_count < MIN_CL_COUNT ? READ : RUN;
			RUN:
				next_state = rd_addr == BUFFER_DEPTH-1 ? FINISH : RUN;
			FINISH:
				next_state = ready ? IDLE : FINISH;
			default:
				next_state = state;
		endcase
	end
	
	//in idle we reset the counter variables
	always_ff @(posedge clk) begin
		if (state == IDLE) begin
			cl_count <= 0;
			rd_addr <= 0;
			cycle_count <= 0;
		end
	end
	
	//if starting, fill data and weight buffers
	always_ff @(posedge clk) begin
		if (state == READ && !buffer_select) begin
			cl_count <= cl_count + 1;
		end
	end
	
	//after we have completed a computation, increment addr
	always_ff @(posedge clk) begin
		if (state == RUN) begin
			if (cycle_count > NUM_CYCLES) begin
				rd_addr <= rd_addr + 1;
				cycle_count <= 0;
			end else begin
				cycle_count <= cycle_count + 1;
			end
		end
	end
	
	//select buffer to write to 
	assign wr_en_input_data = !buffer_select;
	assign wr_en_weight_data = buffer_select;
	
	
	logic [255:0] conv_out;
	logic [511:0] data_buffer_out;
	logic [511:0] weight_buffer_out;
	
	cacheline_buffer input_data_buffer(
											.wr_clk(clk),
											.wr_en(wr_en_input_data),
											.wr_addr(wr_addr),
											.wr_data(data),
											.rd_clk(clk),
											.rd_addr(rd_addr),
											.rd_data(data_buffer_out)
										);
										
	cacheline_buffer weight_data_buffer(
											.wr_clk(clk),
											.wr_en(wr_en_weight_data),
											.wr_addr(wr_addr),
											.wr_data(data),
											.rd_clk(clk),
											.rd_addr(rd_addr),
											.rd_data(weight_buffer_out)
										);										
										
	ram_2p result_data_buffer(
											.wrclock(clk),
											.wren(clk),
											.wraddress(rd_addr),
											.data(conv_out),
											.rdclock(clk),
											.rdaddress(),
											.q(result)
										);	
								
	genvar i;
	generate 
		for (i = 0; i < NUM_BLOCKS; i++) begin : GEN_CONV
			conv_forward_layer #(WIDTH=2)
				conv_forward_inst(
											.clk(clk),
											.reset(resetb),
											.id(rd_addr),
											.in_data(conv_bus.data[(i+1)*64-1:i*64]),
											.weight_vec(conv_bus.weights[(i+1)*64-1:i*64]),
//											.bias_term(conv_bus.bias[(i+1)*32-1:i*32]),
											.out_data(conv_out[(i+1)*32-1:i*32])
										);
		end
	endgenerate
	
	
	
endmodule
						