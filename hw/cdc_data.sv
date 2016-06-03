//====================================================================
//
// cdc_data.sv
//
// Original Author : George Powley
// Original Date   : 2014/08/20
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
//
//====================================================================

module cdc_data
  (
    input logic in_clk,
    input logic in_data,
    input logic out_clk,
    output logic out_data   
   );

   logic in_data_ff;
   logic out_data_p1;

   always_ff @(posedge in_clk) begin
      in_data_ff <= in_data;
   end

   always_ff @(posedge out_clk) begin
      out_data_p1 <= in_data_ff;
      out_data <= out_data_p1;
   end

endmodule // cdc_data
