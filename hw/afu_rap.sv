//====================================================================
//
// afu_rap.sv
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

`include "spl.vh"
`include "afu.vh"
//`include "afu_csr.vh"
module afu_rap
  (
   input logic clk,
   input logic resetb,
   
   spl_bus_t spl_bus,
   afu_bus_t afu_bus
   );
   
   afu_csr afu_csr_0(.*);
   status_writer status_writer_0(.*);
   prefetch_rob prefetch_rob_0(.*);
   
endmodule // afu_rap
