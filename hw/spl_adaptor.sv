//====================================================================
//
// spl_adaptor.sv
//
// Original Author : George Powley
// Original Date   : 2014/08/15
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
// - Connect SPL pins to spl_bus interface
//
//====================================================================

`include "spl.vh"
`include "afu.vh"

module spl_adaptor
  #(parameter TXHDR_WIDTH=99, RXHDR_WIDTH=24, CACHE_WIDTH=512)
   (
    input  wire                             spl_enable,
    input  wire                             spl_reset,
    
    // AFU TX read request
    input  wire                             spl_tx_rd_almostfull,
    output wire                             afu_tx_rd_valid,
    output wire [TXHDR_WIDTH-1:0]           afu_tx_rd_hdr,
    
    // AFU TX write request
    input  wire                             spl_tx_wr_almostfull,
    output wire                             afu_tx_wr_valid,
    output wire                             afu_tx_intr_valid,
    output wire [TXHDR_WIDTH-1:0]           afu_tx_wr_hdr,    
    output wire [CACHE_WIDTH-1:0]           afu_tx_data,
    
    // AFU RX read response
    input  wire                             spl_rx_rd_valid,
    input  wire                             spl_rx_wr_valid0,
    input  wire                             spl_rx_cfg_valid,
    input  wire                             spl_rx_intr_valid0,
    input  wire                             spl_rx_umsg_valid,
    input  wire [RXHDR_WIDTH-1:0]           spl_rx_hdr0,
    input  wire [CACHE_WIDTH-1:0]           spl_rx_data,
    
    // AFU RX write response
    input  wire                             spl_rx_wr_valid1,
    input  wire                             spl_rx_intr_valid1,
    input  wire [RXHDR_WIDTH-1:0]           spl_rx_hdr1,

    // SPL bus interface
    spl_bus_t                               spl_bus
   );

   // SPL control
   assign spl_bus.spl_enable         = spl_enable;
   assign spl_bus.spl_reset          = spl_reset;

   // AFU read request (Tx 0)
   assign spl_bus.rd_req.almostfull  = spl_tx_rd_almostfull;
   assign afu_tx_rd_valid            = spl_bus.rd_req.rd_valid;
   assign afu_tx_rd_hdr              = spl_bus.rd_req.header;

   // AFU write request (Tx 1)
   assign spl_bus.wr_req.almostfull  = spl_tx_wr_almostfull;
   assign afu_tx_wr_valid            = spl_bus.wr_req.wr_valid;
   assign afu_tx_intr_valid          = spl_bus.wr_req.intr_valid;
   assign afu_tx_wr_hdr              = spl_bus.wr_req.header;
   assign afu_tx_data                = spl_bus.wr_req.data;
      
   // AFU read/write response (Rx 0)
   assign spl_bus.rw_rsp.rd_valid    = spl_rx_rd_valid;
   assign spl_bus.rw_rsp.wr_valid    = spl_rx_wr_valid0;
   assign spl_bus.rw_rsp.cfg_valid   = spl_rx_cfg_valid;
   assign spl_bus.rw_rsp.intr_valid  = spl_rx_intr_valid0;
   assign spl_bus.rw_rsp.umsg_valid  = spl_rx_umsg_valid;
   assign spl_bus.rw_rsp.header      = spl_rx_hdr0;
   assign spl_bus.rw_rsp.data        = spl_rx_data;

   // AFU write response (Rx 1)
   assign spl_bus.wr_rsp.wr_valid    = spl_rx_wr_valid1;
   assign spl_bus.wr_rsp.intr_valid  = spl_rx_intr_valid1;
   assign spl_bus.wr_rsp.header      = spl_rx_hdr1;

endmodule // spl_adaptor
