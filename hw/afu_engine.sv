//====================================================================
//
// afu_engine.sv
//
// Original Author : George Powley
// Original Date   : 2014/08/14
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
//
//====================================================================

`include "afu.vh"
`include "sw.vh"

module afu_engine
  (
   input logic clk,
   input logic resetb,
   
   afu_bus_t afu_bus
   );

   // hardcoded AFU ID
   assign afu_bus.status.status_array[3] = 32'haced0003;
   assign afu_bus.status.status_array[2] = 32'haced0002;
   assign afu_bus.status.status_array[1] = 32'haced0001;
   assign afu_bus.status.status_array[0] = 32'haced0000;

   //=================================================================
   //=================================================================
   // AFU interface clock domain
   //=================================================================
   //=================================================================
   logic [CACHE_WIDTH-1:0] sw_data;
   logic sw_ready;
   logic sw_valid;
	 logic sw_finished;
   logic [15:0] offset;

	 sw_bus_t sw_bus();
	 
	 always_ff @(posedge clk) begin
//	    sw_ready <= sw_bus.ready;
//	    sw_ready <= sw_bus.finished;
	    sw_ready <= 1;
	 end

	 //when accel is ready, tell reader to start
   assign afu_bus.reader.ready = sw_ready;
   
//   assign sw_valid = sw_bus.ready & ~sw_ready_ff;
	 assign sw_valid = sw_bus.valid;
	 assign sw_finished = sw_bus.filters_finished;

	 assign afu_bus.writer.valid = sw_bus.valid;
	 assign afu_bus.writer.pipeline_full = sw_bus.pipeline_full;
	 assign afu_bus.writer.pipeline_empty = sw_bus.pipeline_empty;

	 always_ff @(posedge clk) begin
			if (!resetb) begin
				offset <= 0;
			end
			else if (sw_valid) begin
				offset <= offset + 1;
			end 
			else begin
				offset <= 0;
			end
	 end

   always_ff @(posedge clk) begin
      if (sw_valid) begin
         sw_data <= sw_bus.result;
      end
   end

	 //once reader has issued read reqs and has valid data, start
   logic start_ff;
  
	 //once weight data has been loaded, start your engines 
   always_ff @(posedge clk) begin
      start_ff <= afu_bus.reader.valid && afu_bus.csr.load_images;
   end

   always_comb begin
      sw_bus.start    = start_ff;
   end

	logic [8:0] pipeline_delay_counter;
	logic sw_finished_ff;
	assign pipeline_full = pipeline_delay_counter == NUM_CYCLES;
	//generate pulse when we finish with all filters on an image segment
	assign start_timer = sw_bus.filters_finished & ~sw_finished_ff;

	//counter started every time we finish a batch of filters;
	//we need to wait until the last cacheline of data has made
	//it through the pipeline before signaling the CPU 
	always_ff @(posedge clk) begin
		if (!resetb) begin
			pipeline_delay_counter <= 0;
		end
		else if (start_timer) begin
			pipeline_delay_counter <= 0;
		end
		else if (pipeline_full) begin
			pipeline_delay_counter <= NUM_CYCLES;
		end
		else begin
			pipeline_delay_counter <= pipeline_delay_counter + 1;
		end
	end
	
	//generate pulse once the pipeline timer has hit the top
	assign results_ready = pipeline_full & ~pipeline_delay_counter;

	 always_ff @(posedge clk) begin
			if (results_ready) begin
				afu_bus.status.status_array[5] <= 32'hffffffff;
			end
			else begin
				afu_bus.status.status_array[5] <= 32'h00000000;
			end
	 end

	 always_ff @(posedge clk) begin
      if (sw_valid) begin
				afu_bus.status.status_array[7] <= sw_data[31:0];
				afu_bus.writer.data = sw_data;
				afu_bus.writer.offset = offset;
      end
   end
   
	 always_ff @(posedge clk) begin
      if (results_ready) begin
         afu_bus.status.update[1] <= 1;
      end else begin
         afu_bus.status.update[1] <= 0;
      end
   end


   assign afu_bus.reader.rd_clk = clk;
	 assign sw_bus.max_weight_buffer_addr = afu_bus.csr.max_weight_buffer_addr;
   
	 assign afu_bus.reader.addr_a = sw_bus.addr_a;
   assign afu_bus.reader.addr_b = sw_bus.addr_b;
   
	 assign sw_bus.data_a = afu_bus.reader.data_a;
   assign sw_bus.data_b = afu_bus.reader.data_b;
		

   sw_array 
   sw_array_0(.clk(clk),
              .resetb(resetb),
              .sw_bus(sw_bus)
              );

   //=================================================================
   // debug code
   //=================================================================
   //synthesis translate_off

	 always_ff @(posedge clk) begin
		 if (~pipeline_full) begin
		 		$display("pipeline_delay_counter: %d", pipeline_delay_counter);
		 end
	 end

	 always_ff @(posedge clk) begin
		 if (results_ready) begin
				$display("<<<<<<<<<<<<<<<<<<< RESULTS READY >>>>>>>>>>>>>>>>>>>");
		 end
	 end

/* -----\/----- EXCLUDED -----\/-----
   always_ff @(posedge e_clk) begin
      if (e_start_ff) begin
         $display("SEQ_CHECK: %d, %x, %d, %x", sw_bus.len_s, sw_bus.s_in, sw_bus.len_t, sw_bus.t_in);
      end
   end
 -----/\----- EXCLUDED -----/\----- */
   
   //synthesis translate_on

endmodule // afu_engine
