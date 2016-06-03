//====================================================================
//
// result_writer.sv
//
// Original Author : Brian Hill
// Original Date   : 2016/03/18
//
// Description:
// - When accelerator data is valid, write to FIFO
// - Write results from FIFO back to memory when possible
//
//====================================================================

`include "spl.vh"
`include "afu.vh"

module result_writer
  (
    input logic clk,
    input logic resetb,
   
    spl_bus_t spl_bus,
    afu_bus_t afu_bus
   );

   typedef enum {IDLE, WRITE, READY} state_t;
   state_t state;
   state_t next_state;

   logic request_write;

   always_ff @(posedge clk) begin
      if (state == IDLE || state == WRITE) begin
         request_write <= 0;
      end else if (afu_bus.writer.valid && !(afu_bus.csr.update_dsm[31] || |afu_bus.status.update)) begin
         request_write <= 1;
      end
   end

	 wire full;
	 wire empty;
	 wire [5:0] used_words;
	 assign fifo_wr_req = afu_bus.writer.valid & !full;
	 assign fifo_rd_req = request_write;
	 assign result = afu_bus.writer.data;
   
	 logic [511:0] data;
	 logic [511:0] result;

   fifo fifo_hi(
	 								.clock(clk),
									.data(result[511:256]),
									.wrreq(fifo_wr_req),
									.rdreq(fifo_rd_req),
									.full(full),
									.empty(empty),
									.usedw(used_words),
									.q(data[511:256])
								);

   fifo fifo_lo(
	 								.clock(clk),
									.data(result[255:0]),
									.wrreq(fifo_wr_req),
									.rdreq(fifo_rd_req),
									.full(full),
									.empty(empty),
									.usedw(used_words),
									.q(data[255:0])
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
          next_state = afu_bus.writer.valid && !spl_bus.wr_req.almostfull ? WRITE : IDLE;
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
   logic [9:0] offset;
	 logic [63:0] wr_addr;
   wr_req_header_t header;

	 always_ff @(posedge clk) begin
			if (!resetb) begin
				offset <= 0;
			end
			else if (fifo_rd_req) begin
				offset <= offset + 1;
			end 
			else begin
				offset <= 0;
			end
	 end

	 assign wr_addr = afu_bus.csr.write_buffer_base[63:6] + offset;
	 	
   always_comb begin
				header = 0;
				header.hi_address = wr_addr[57:32];
				header.pv = Virtual;
				header.request_type = afu_bus.csr.write_fence ? WrFence : WrLine;
				header.address = wr_addr[31:0];
				header.mdata = offset;
	 end
   
   // register outputs to CCI
   always_ff @(posedge clk) begin
      if (fifo_rd_req) begin
				spl_bus.wr_req.header <= header;
      	spl_bus.wr_req.wr_valid <= state == WRITE;
      	spl_bus.wr_req.data <= data;
			end
   end

	 // synthesis translate_off
		 always_ff @(posedge clk) begin
				if (fifo_wr_req) begin
					$display("used words: %d", used_words);
				end
		 end
	 // synthesis translate_on 

endmodule // status_writer
