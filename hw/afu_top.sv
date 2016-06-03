//====================================================================
//
// afu_top.sv
//
// Original Author : George Powley
// Original Date   : 2014/08/14
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
// - Instantiates the afu_shim and afu_engine
// - afu_shim contains common accelerator interface logic
// - afu_engine contains the accelerator logic
//
//====================================================================

`include "spl.vh"
`include "afu.vh"

module afu_top
  #(parameter TXHDR_WIDTH=99, RXHDR_WIDTH=24, CACHE_WIDTH=512)
  (
    input  wire                             clk,
    input  wire                             reset_n,
    input  wire                             spl_enable,
    input  wire                             spl_reset,
        
    // AFU TX read request
    input  wire                             spl_tx_rd_almostfull,
    output wire                             afu_tx_rd_valid,
    output wire [98:0]                      afu_tx_rd_hdr,
    
    // AFU TX write request
    input  wire                             spl_tx_wr_almostfull,
    output wire                             afu_tx_wr_valid,
    output wire                             afu_tx_intr_valid,
    output wire [98:0]                      afu_tx_wr_hdr,    
    output wire [511:0]                     afu_tx_data,
    
    // AFU RX read response
    input  wire                             spl_rx_rd_valid,
    input  wire                             spl_rx_wr_valid0,
    input  wire                             spl_rx_cfg_valid,
    input  wire                             spl_rx_intr_valid0,
    input  wire                             spl_rx_umsg_valid,
    input  wire [23:0]                      spl_rx_hdr0,
    input  wire [511:0]                     spl_rx_data,
    
    // AFU RX write response
    input  wire                             spl_rx_wr_valid1,
    input  wire                             spl_rx_intr_valid1,
    input  wire [23:0]                      spl_rx_hdr1
   );

   // reset AFU when either reset is asserted
   wire resetb = reset_n & ~spl_reset;

   // instantiate buses
   afu_bus_t afu_bus();
   spl_bus_t spl_bus();

   // connect SPL pins to spl_bus
   spl_adaptor spl_adaptor_0(.*);

   // AFU reconfigurable access port
   afu_rap afu_rap_0(.*);

   // AFU engine
   afu_engine afu_engine_0(.*);
   
endmodule // afu_top
