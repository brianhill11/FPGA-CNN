//====================================================================
//
// cdc_handshake.sv
//
// Original Author : George Powley
// Original Date   : 2014/08/19
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
//
//====================================================================

module cdc_handshake
  #(parameter DATA_WIDTH = 4096)
  (
    input logic in_clk,
    input logic in_resetb,
    input logic [DATA_WIDTH-1:0] in_data,
    input logic in_valid,

    input logic out_clk,
    output logic [DATA_WIDTH-1:0] out_data,
    output logic out_valid
   );

   logic in_load;
   logic in_ack;
   logic out_load;
   logic out_load_ff;

   cdc_data cdc_data_0(in_clk, in_load, out_clk, out_load);
   cdc_data cdc_data_1(out_clk, out_load, in_clk, in_ack);

   always_ff @(posedge in_clk) begin
      if (!in_resetb || in_ack) begin
         in_load <= 0;
      end else if (in_valid) begin
         in_load <= 1;
      end
   end

   always_ff @(posedge out_clk) begin
      if (out_load) begin
         out_data <= in_data;
      end
   end

   always_ff @(posedge out_clk) begin
      out_load_ff <= out_load;
   end

   assign out_valid = ~out_load & out_load_ff;
   
endmodule // cdc_handshake
