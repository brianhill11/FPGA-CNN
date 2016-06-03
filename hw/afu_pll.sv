//====================================================================
//
// afu_pll.sv
//
// Original Author : George Powley
// Original Date   : 2014/08/28
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
//
//====================================================================

module afu_pll
  (
   input logic clk,
   input logic resetb,
   output logic outclk,
   output logic locked
   );


`ifdef SIMULATION
   // simple clock for simulation, with different frequency
   
   assign locked = resetb;
   
   initial begin
      outclk = 0;
      forever begin
         outclk = #3 ~outclk;
      end
   end

`else
   fixed_pll engine_pll
     (
      .refclk(clk),
      .rst(!resetb),
      .outclk_0(outclk),
      .locked(locked)
      );
`endif

endmodule // afu_pll
