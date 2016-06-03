//====================================================================
//
// prefetch_rob.sv
//
// Original Author : George Powley
// Original Date   : 2014/09/08
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
//
//====================================================================

`include "spl.vh"
`include "afu.vh"
`include "sw.vh"

module prefetch_rob
  #(BUFFER_ADDR_WIDTH=16, DATA_WIDTH=512)
  (
    input logic clk,
    input logic resetb,
   
    spl_bus_t spl_bus,
    afu_bus_t afu_bus
   );

   //=================================================================
   // control FSM
   //=================================================================
   typedef enum logic [1:0] {IDLE, ISSUE_A, WAIT_A, WRITE} state_t;

   state_t state;
   state_t next_state;
   logic a_reads_issued;
   logic b_reads_issued;
   logic a_reads_complete;
   logic b_reads_complete;

   // FSM state
   always_ff @(posedge clk) begin
      if (!resetb || !afu_bus.csr.afu_en || !spl_bus.spl_enable) begin
         state <= IDLE;
      end else begin
         state <= next_state;
      end
   end

   always_comb begin
      case (state)
        IDLE :
          next_state = afu_bus.csr.doorbell[31] ? ISSUE_A : IDLE;
        ISSUE_A :
          next_state = a_reads_issued ? WAIT_A : ISSUE_A;
        WAIT_A :
          next_state = a_reads_complete && afu_bus.reader.ready ? WRITE : WAIT_A;
//        ISSUE_B :
//          next_state = b_reads_issued ? WAIT_B : ISSUE_B;
//        WAIT_B :
//          next_state = b_reads_complete && afu_bus.reader.ready ? WRITE : WAIT_B;
        WRITE :
          next_state = afu_bus.reader.ready && !afu_bus.csr.load_weights && !afu_bus.csr.load_images ? WRITE : IDLE;
        default :
          next_state = state;
      endcase // case (state)
   end // always_comb begin


   //=================================================================
   // transmit read requests using SPL Read Request transactions
   //=================================================================

   logic [BUFFER_ADDR_WIDTH-1:0] a_read_lines;
   
   // clear doorbell csr when reads start issuing
   assign afu_bus.csr.reset_doorbell = (state == ISSUE_A) && afu_bus.csr.doorbell[31];

   logic issue_reads;
   assign issue_reads = state == ISSUE_A;

   logic [15:0] read_offset;

   always_ff @(posedge clk) begin
      if (!issue_reads) begin
         read_offset <= 0;
      end else if (issue_reads && !spl_bus.rd_req.almostfull) begin
         read_offset <= read_offset + 1;
      end
   end

   // number of reads = number of data CL
   assign a_reads_issued = read_offset == a_read_lines - 1;

   logic [57:0] read_addr;

   assign read_addr = afu_bus.csr.read_buffer_base[63:6] + read_offset + 
                      1;

   logic almostfull_ff;

   always_ff @(posedge clk) begin
      almostfull_ff <= spl_bus.rd_req.almostfull;
   end

   rd_req_header_t header;

   always_comb begin
      header = 0;
      header.block_size = 1;
      header.hi_address = read_addr[57:32];
      header.pv = Virtual;
      header.request_type = RdLine;
      header.address = read_addr[31:0];
      header.mdata = read_offset;
   end

   // register outputs to SPL
   always_ff @(posedge clk) begin
      spl_bus.rd_req.header <= header;
      spl_bus.rd_req.rd_valid <= issue_reads && !almostfull_ff;
   end

   //=================================================================
   // re-order buffers
   //=================================================================
/*
	 logic [15:0] tid;
   logic [7:0] wr_addr;
   logic wr_en_rob_weights;
   logic wr_en_rob_image;
   
   logic [DATA_WIDTH-1:0] rd_data_weights;
   logic [DATA_WIDTH-1:0] rd_data_image;

   always_comb begin
//      wr_addr = spl_bus.rw_rsp.header.mdata[BUFFER_ADDR_WIDTH-1:0];
//      wr_addr = spl_bus.rw_rsp.header.mdata[11:0];
   end

	 //enable writing to weight/image buffer depending on flag
	 assign wr_en_rob_weights = afu_bus.csr.load_weights;
	 assign wr_en_rob_image = afu_bus.csr.load_images;
*/ 
	 logic [15:0] tid;
   logic [WEIGHT_ADDR_WIDTH-1:0] wr_addr;
   logic [3:0] buffer_sel;
   logic [NUM_PE-1:0] wr_en_rob_weights;
   logic wr_en_rob_image;
   
   logic [CACHE_WIDTH-1:0] rd_data_weights [NUM_PE-1:0];
   logic [CACHE_WIDTH-1:0] rd_data_image;

	 always_ff @(posedge clk) begin
      buffer_sel <= spl_bus.rw_rsp.header.mdata[3:0];
	 end

   always_comb begin
//      wr_addr = spl_bus.rw_rsp.header.mdata[BUFFER_ADDR_WIDTH-1:0];
      wr_addr = tid[11:4];
   end

	//decode to determine which buffer to write into 
	assign wr_en_rob_weights = 	(buffer_sel == 4'h0 && afu_bus.csr.load_weights) ? 16'b0000000000000001 :
															(buffer_sel == 4'h1 && afu_bus.csr.load_weights) ? 16'b0000000000000010 : 
															(buffer_sel == 4'h2 && afu_bus.csr.load_weights) ? 16'b0000000000000100 : 
															(buffer_sel == 4'h3 && afu_bus.csr.load_weights) ? 16'b0000000000001000 : 
															(buffer_sel == 4'h4 && afu_bus.csr.load_weights) ? 16'b0000000000010000 : 
															(buffer_sel == 4'h5 && afu_bus.csr.load_weights) ? 16'b0000000000100000 : 
															(buffer_sel == 4'h6 && afu_bus.csr.load_weights) ? 16'b0000000001000000 : 
															(buffer_sel == 4'h7 && afu_bus.csr.load_weights) ? 16'b0000000010000000 : 
															(buffer_sel == 4'h8 && afu_bus.csr.load_weights) ? 16'b0000000100000000 : 
															(buffer_sel == 4'h9 && afu_bus.csr.load_weights) ? 16'b0000001000000000 : 
															(buffer_sel == 4'ha && afu_bus.csr.load_weights) ? 16'b0000010000000000 : 
															(buffer_sel == 4'hb && afu_bus.csr.load_weights) ? 16'b0000100000000000 : 
															(buffer_sel == 4'hc && afu_bus.csr.load_weights) ? 16'b0001000000000000 : 
															(buffer_sel == 4'hd && afu_bus.csr.load_weights) ? 16'b0010000000000000 : 
															(buffer_sel == 4'he && afu_bus.csr.load_weights) ? 16'b0100000000000000 : 
															(buffer_sel == 4'hf && afu_bus.csr.load_weights) ? 16'b1000000000000000 : 
																										 														 16'b0000000000000000;
	assign wr_en_rob_image = afu_bus.csr.load_images;

	genvar i;
	generate
		for (i = 0; i < NUM_PE; i++) begin : GEN_MEM
			rob_512x4096 rob_weight_buff
     		(.wr_clk(clk),
     		 .wr_en(wr_en_rob_weights[i]),
     		 .wr_addr(wr_addr),
     		 .wr_data(spl_bus.rw_rsp.data),
     		 .rd_clk(clk),
     		 .rd_addr(afu_bus.reader.addr_a),
     		 .rd_data(rd_data_weights[i])
 				);
		end
	endgenerate

/*
		rob_512x65536 rob_weight_buff
     		(.wr_clk(clk),
     		 .wr_en(wr_en_rob_weights),
     		 .wr_addr( {4'b0, buffer_sel} ),
     		 .wr_data(spl_bus.rw_rsp.data),
     		 .rd_clk(clk),
     		 .rd_addr(afu_bus.reader.addr_a),
     		 .rd_data(rd_data_weights)
 				);
*/

		rob_512x256 rob_image_buff
     		(.wr_clk(clk),
     		 .wr_en(wr_en_rob_image),
//     		 .wr_addr(wr_addr[IMAGE_ADDR_WIDTH-1:0]),
     		 .wr_addr( {4'b0, buffer_sel} ),
     		 .wr_data(spl_bus.rw_rsp.data),
     		 .rd_clk(clk),
     		 .rd_addr(afu_bus.reader.addr_b),
     		 .rd_data(rd_data_image)
     		 );

   assign afu_bus.reader.data_a = rd_data_weights;
   assign afu_bus.reader.data_b = rd_data_image;

   logic [BUFFER_ADDR_WIDTH:0] response_count;
   logic reset_response_count;

   assign reset_response_count = state == IDLE || (state == WAIT_A && next_state == WRITE);
   
   always_ff @(posedge clk) begin
      if (reset_response_count) begin
         response_count <= 0;
      end else if (spl_bus.rw_rsp.rd_valid) begin
         response_count <= response_count + 1;
      end
   end

   // number of reads = number of data CL
   assign a_reads_complete = response_count == a_read_lines;

   //=================================================================
   // assert valid to accelerator
   //=================================================================
   assign afu_bus.reader.valid = state == WRITE;
//		assign afu_bus.reader.valid = !afu_bus.csr.load_weights;

   //=================================================================
   // update DSM to ack read
   //=================================================================
   logic [31:0] time_doorbell;
   logic [31:0] doorbell_ack;
   
   always_ff @(posedge clk) begin
      if ((next_state == ISSUE_A) && afu_bus.csr.doorbell[31]) begin
         doorbell_ack <= afu_bus.csr.doorbell;
         a_read_lines <= afu_bus.csr.read_buffer_lines;
//         a_read_lines <= afu_bus.csr.doorbell[15:8];
         tid <= afu_bus.csr.doorbell[30:16];
         time_doorbell <= afu_bus.status.perf_counter;
      end
   end

   assign afu_bus.reader.tid = tid;

   always_ff @(posedge clk) begin
      if (state == WAIT_A && next_state == WRITE) begin
         afu_bus.status.update[0] <= 1;
      end else begin
         afu_bus.status.update[0] <= 0;
      end
   end

   always_ff @(posedge clk) begin
      if (state == WAIT_A && next_state == WRITE) begin
         afu_bus.status.status_array[4] <= doorbell_ack;
         afu_bus.status.status_array[12] <= time_doorbell;
      end
   end


   //=================================================================
   // debug hooks
   //=================================================================
   // synthesis translate_off
   initial begin
      $monitor("ready = 0x%h, state = 0x%h, next_state = 0x%h, doorbell_ack = 0x%h, reader.ready = 0x%h", afu_bus.csr.doorbell, state, next_state, doorbell_ack, afu_bus.reader.ready);
   end
 /* 
	 always_ff @(posedge clk) begin
			$display("state: 0x%h next_state: 0x%h", state, next_state);
			$display("afu_bus.csr.doorbell: 0x%h", afu_bus.csr.doorbell);
			$display("afu_bus.status.doorbell_ack: 0x%h", afu_bus.status.status_array[4]);
			$display("afu_bus.status.update: 0x%h", afu_bus.status.update);
			$display("afu_bus.reader.ready: 0x%h", afu_bus.reader.ready);
	 end
	*/
	 always_ff @(posedge clk) begin
		 	if (spl_bus.rw_rsp.rd_valid && afu_bus.csr.load_weights) begin
			$display("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW");
			$display("wr_en_rob_weights: 0x%b", wr_en_rob_weights);
			$display("rd_addr_a: 0x%h", afu_bus.reader.addr_a);
			$display("wr_addr:       0x%h", wr_addr);
			$display("rw_rsp_data  : 0x%h", spl_bus.rw_rsp.data);
			$display("afu_bus.csr.doorbell: 0x%h", afu_bus.csr.doorbell);
			$display("afu_bus.status.doorbell_ack: 0x%h", afu_bus.status.status_array[4]);
			$display("afu_bus.writer.valid: 0x%h", afu_bus.writer.valid);
//			$display("afu_bus.reader.data_a: 0x%h", afu_bus.reader.data_a);
//			$display("afu_bus.reader.data_b: 0x%h", afu_bus.reader.data_b);
			$display("W W W W W W W W W W W W W W W W W W W W W W W W W W W W W W W W");
	 		end
		 	else if (spl_bus.rw_rsp.rd_valid && afu_bus.csr.load_images) begin
			$display("IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
			$display("wr_en_rob_images: 0x%b", wr_en_rob_image);
			$display("rd_addr_b: 0x%h", afu_bus.reader.addr_b);
			$display("wr_addr:       0x%h", wr_addr);
			$display("rw_rsp_data  : 0x%h", spl_bus.rw_rsp.data);
//			$display("afu_bus.reader.data_a: 0x%h", afu_bus.reader.data_a);
//			$display("afu_bus.reader.data_b: 0x%h", afu_bus.reader.data_b);
			$display("I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I  I");
	 		end
	 end

   always_ff @(posedge clk) begin
//      if (spl_bus.rw_rsp.rd_valid) begin
      if (0) begin
				 $display("^^^^^^^^^^^^^^^^^^^ rw_rsp ^^^^^^^^^^^^^^^");
         $display("rw_rsp.mdata = 0x%x, rw_rsp.data[31:0] = 0x%x", spl_bus.rw_rsp.header[12:0], spl_bus.rw_rsp.data[31:0]);
         $display("afu_bus.csr.read_buffer_base = 0x%x", afu_bus.csr.read_buffer_base);
         $display("afu_bus.csr.read_buffer_base[63:6] = 0x%x", afu_bus.csr.read_buffer_base[63:6]);
				 $display("wr_addr:       0x%h", wr_addr);
				 $display("rw_rsp_data  : 0x%h", spl_bus.rw_rsp.data);
				 $display("afu_bus.csr.load_weights: 0x%h", afu_bus.csr.load_weights);
				 $display("afu_bus.csr.load_images: 0x%h", afu_bus.csr.load_images);
				 $display("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
      	 $display("");
			end
   end
/*
	always_ff @(posedge clk) begin
		if (afu_bus.csr.load_images) begin
			if (spl_bus.rw_rsp.header.mdata[12:0] == 0) begin
				$display("mdata == 0, data: 0x%h", spl_bus.rw_rsp.data);
			end
			if (spl_bus.rw_rsp.header.mdata[12:0] == 1) begin
				$display("mdata == 1, data: 0x%h", spl_bus.rw_rsp.data);
			end
		end
	end
*/
   always_ff @(posedge clk) begin
      if (spl_bus.rd_req.rd_valid) begin
//         $display("Tx0 Read = 0x%x", spl_bus.rd_req.header);
         
				 $display("|||||||||||||||||||| rd_req |||||||||||||");
				 $display("rd_req.header.hi_address: 0x%x", header.hi_address);
         $display("rd_req.header.address: 0x%x", header.address);
         $display("rd_req.header.mdata: 0x%x", header.mdata);
				 $display("|||||||||||||||||||||||||||||||||||||||||");
      	 $display("");
      end
   end
   // synthesis translate_on

endmodule // prefetch_rob
