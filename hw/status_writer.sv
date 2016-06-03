//====================================================================
//
// status_writer.sv
//
// Original Author : George Powley
// Original Date   : 2014/08/15
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
// - Update AFU ID after SW writes afu_dsm_base
// - Update Device Status Memory when requested
//
//====================================================================

`include "spl.vh"
`include "afu.vh"

module status_writer
  (
    input logic clk,
    input logic resetb,
   
    spl_bus_t spl_bus,
    afu_bus_t afu_bus
   );

   typedef enum {IDLE, WRITE, READY} state_t;
   state_t state;
   state_t next_state;
	 
	 logic wr_dsm;
	
	//=================================================================
	//  DSM STATUS UPDATE GENERATION
	//=================================================================
   
   logic [511:0] status;

   genvar i;
   generate
      for (i = 0; i < 16; i++) begin : gen_status
         assign status[32*(i+1)-1:32*i] = afu_bus.status.status_array[i];
      end
   endgenerate
   
   logic request_write;

	 // request if writing doorbell ack or writing back results
   always_ff @(posedge clk) begin
      if (state == IDLE || state == WRITE) begin
         request_write <= 0;
      end else if (afu_bus.csr.update_dsm[31] || |afu_bus.status.update || afu_bus.writer.valid) begin
         request_write <= 1;
      end
   end

   assign afu_bus.csr.reset_update_dsm = afu_bus.csr.update_dsm[31] & request_write;

	 always_ff @(posedge clk) begin
	 		if (state == IDLE || state == WRITE) begin
				wr_dsm <= 0;
			end	
			else if (afu_bus.csr.update_dsm[31] || |afu_bus.status.update) begin
				wr_dsm <= 1;
			end 
	 end

   // send running total of tx transactions in status
   logic [31:0] txid;

   always_ff @(posedge clk) begin
      if (!resetb) begin
         txid <= 0;
      end else if (state == WRITE) begin
         txid <= txid + 1;
      end
   end

   assign afu_bus.status.status_array[10] = txid;


   // send ack for update_dsm
   logic [31:0] update_ack;

   always_ff @(posedge clk) begin
      if (!resetb) begin
         update_ack <= 0;
      end else if (afu_bus.csr.update_dsm) begin
         update_ack <= afu_bus.csr.update_dsm;
      end
   end
   
   assign afu_bus.status.status_array[11] = update_ack;


   // performance counter
   logic [31:0] perf_counter;
   
   always_ff @(posedge clk) begin
      if (!resetb) begin
         perf_counter <= 0;
      end else begin
         perf_counter <= perf_counter + 1;
      end
   end
   
   assign afu_bus.status.perf_counter = perf_counter;
   
	 //=================================================================
   // Result FIFO
   //=================================================================
	 wire full;
	 wire empty;
	 wire f1;
	 wire f2;
	 wire e1; 
	 wire e2;
	 wire [5:0] used_words;
	 logic [511:0] result;
//	 logic fifo_rd_req;
	 assign full = f1 | f2;
	 assign empty = e1 | e2;
	 //write to FIFO when we have valid data (pipeline is full, or there
	 //is no more data and we're waiting for the pipeline to empty
	 assign fifo_wr_req = afu_bus.writer.valid & ~full;
	 //read from FIFO when we have valid data and we're not updating DSM
	 assign fifo_rd_req = ~empty & ~wr_dsm;
	/*
	 always_ff @(posedge clk) begin
			if (!resetb) begin
				fifo_rd_req <= 0;
			end
			else if (~empty & ~wr_dsm) begin
				fifo_rd_req <= 1;
			end 
			else begin
				fifo_rd_req <= 0;
			end
	 end
	 */

   fifo fifo_hi(
	 								.clock(clk),
									.data(afu_bus.writer.data[511:256]),
									.wrreq(fifo_wr_req),
									.rdreq(fifo_rd_req),
									.full(f1),
									.empty(e1),
									.usedw(used_words),
									.q(result[511:256])
								);

   fifo fifo_lo(
	 								.clock(clk),
									.data(afu_bus.writer.data[255:0]),
									.wrreq(fifo_wr_req),
									.rdreq(fifo_rd_req),
									.full(f2),
									.empty(e2),
									.usedw(used_words),
									.q(result[255:0])
								);
   
   //=================================================================
   // FSM
   //=================================================================

   always_ff @(posedge clk) begin
      if (!resetb) begin
         state <= IDLE;
      end else begin
         state <= next_state;
      end
   end

   always_comb begin
      case (state)
        IDLE : 
          next_state = afu_bus.csr.afu_dsm_base_valid && !spl_bus.wr_req.almostfull ? WRITE : IDLE;
        WRITE :
          next_state = READY;
        READY :
          next_state = request_write && !spl_bus.wr_req.almostfull ? WRITE : READY;
        default :
          next_state = state;
      endcase // case (state)
   end // always_comb begin


   //=================================================================
   // create write request transaction
   //=================================================================
   wr_req_header_t header;
	 logic [9:0] dsm_offset;
   logic [511:0] data;
	 logic [63:0] wr_addr;
   logic [9:0] offset;
	 logic [15:0] max_weight_buffer_addr;
	 
	 assign max_weight_buffer_addr = afu_bus.csr.max_weight_buffer_addr;
	 assign filters_finished = offset == max_weight_buffer_addr;

	 //increment offset when we read from FIFO, reset when we have sent all data
	 always_ff @(posedge clk) begin
			if (!resetb) begin
				offset <= 0;
			end
			else if (~empty & ~wr_dsm) begin
				offset <= offset + 1;
			end 
			else if (filters_finished) begin
				 offset <= 0;
			end
	 end

	 assign wr_addr = afu_bus.csr.write_buffer_base[63:6] + offset;
	 assign dsm_offset = 0;
   always_comb begin
      if (wr_dsm) begin
				data = status;
//				dsm_offset = 0;
    	  
				header = 0;
    	  header.pv = Physical;
    	  header.request_type = afu_bus.csr.write_fence ? WrFence : WrLine;
    	  header.address = dsm_offset2addr(dsm_offset, afu_bus.csr.afu_dsm_base);
			end 
			
			else if (fifo_rd_req) begin
				data = result;
				
				header = 0;
				header.hi_address = wr_addr[57:32];
				header.pv = Virtual;
				header.request_type = afu_bus.csr.write_fence ? WrFence : WrLine;
				header.address = wr_addr[31:0];
//				header.mdata = offset;
//				offset = 0;
			end
			else begin
				data = status;
//				dsm_offset = 0;
    	  
				header = 0;
    	  header.pv = Physical;
    	  header.request_type = afu_bus.csr.write_fence ? WrFence : WrLine;
    	  header.address = dsm_offset2addr(dsm_offset, afu_bus.csr.afu_dsm_base);
			end
	 end
   
   // register outputs to CCI
   always_ff @(posedge clk) begin
      spl_bus.wr_req.header <= header;
      spl_bus.wr_req.wr_valid <= state == WRITE;
      spl_bus.wr_req.data <= data;
   end

	// synthesis translate_off
	always_ff @(posedge clk) begin
		if (afu_bus.writer.valid) begin
			$display("fifo_wr_req: 0x%h", fifo_wr_req);
			$display("fifo_rd_req: 0x%h", fifo_rd_req);
			$display("wr_dsm: 0x%h", wr_dsm);
			$display("empty: 0x%h", empty);
		end
	end

	always_ff @(posedge clk) begin
		if (fifo_rd_req) begin
			$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
			$display("header.hi_address: 0x%h", header.hi_address);
			$display("header.address: 0x%h", header.address);
			$display("offset: 0x%h", offset);
			$display("used_words: 0x%h", used_words);
			$display("data: 0x%h", data);
		end
	end
	// synthesis translate_on
endmodule // status_writer
