//====================================================================
//
// sw_pe.sv
//
// Original Author : George Powley
// Original Date   : 2014/08/29
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
//
//====================================================================

`include "sw.vh"

module sw_pe
  #(
    parameter DATA_WIDTH = 16,
    parameter BP_WIDTH   = 2,
    parameter COST_WIDTH = 5
    )
   (
    input logic clk,

    sw_bus_t sw_bus,

    input logic active_pe,

    input logic [BP_WIDTH-1:0] s_in,
    input logic [BP_WIDTH-1:0] t_in,

    input logic valid_in,
    input logic [DATA_WIDTH-1:0] max_in,
    input logic [DATA_WIDTH-1:0] v_in,
    input logic [DATA_WIDTH-1:0] f_in,

    output logic valid_out,
    output logic [BP_WIDTH-1:0] t_out,
    output logic [DATA_WIDTH-1:0] max_out,
    output logic [DATA_WIDTH-1:0] v_out,
    output logic [DATA_WIDTH-1:0] f_out
    );

   logic [BP_WIDTH-1:0] s_in_ff;
   logic [DATA_WIDTH-1:0] v_diag;
   logic [DATA_WIDTH-1:0] v_diag_cost;
   logic [DATA_WIDTH-1:0] e_in;
   logic [DATA_WIDTH-1:0] e_out;
   logic [DATA_WIDTH-1:0] f_max;
   logic [DATA_WIDTH-1:0] v_diag_cost_e_max;
   logic signed [COST_WIDTH-1:0] cost;
   

   always_ff @(posedge clk) begin
      if (~valid_in) begin
         s_in_ff <= s_in;
      end
   end
   
   always_ff @(posedge clk) begin
      if (~valid_in) begin
         t_out <= 0;
      end else begin
         t_out <= t_in;
      end
   end
   
   always_ff @(posedge clk) begin
      if (~valid_in) begin
         valid_out <= 0;
      end else begin
         valid_out <= valid_in;
      end
   end

   always_ff @(posedge clk) begin
      if (~valid_in) begin
         v_diag <= 0;
      end else begin
         v_diag <= v_in;
      end
   end

   assign e_in = max(sub(v_out, sw_bus.alpha), sub(e_out, sw_bus.beta));

   always_ff @(posedge clk) begin
      if (~valid_in) begin
         e_out <= 0;
      end else begin
         e_out <= e_in;
      end
   end

   assign f_max = max(sub(v_in, sw_bus.alpha), sub(f_in, sw_bus.beta));
   
   always_ff @(posedge clk) begin
      if (~valid_in) begin
         f_out <= 0;
      end else begin
         f_out <= f_max;
      end
   end

   
   assign cost = s_in_ff == t_in ? sw_bus.match : sw_bus.mismatch;

   assign v_diag_cost = add(v_diag, cost);

   assign v_diag_cost_e_max = max(v_diag_cost, e_in);

   always_ff @(posedge clk) begin
      if (~valid_in) begin
         v_out <= 0;
      end else begin
         v_out <= max(v_diag_cost_e_max, f_max);
      end
   end


   always_ff @(posedge clk) begin
      if (active_pe) begin
         if (~valid_in) begin
            max_out <= 0;
         end else begin
            max_out <= max(max_in, v_out);
         end
      end else begin
         max_out <= max_in;
      end
   end

   //=================================================================
   // debug code
   //=================================================================
   //synthesis translate_off
   
/* -----\/----- EXCLUDED -----\/-----
   int valid_count;

   always_ff @(posedge clk) begin
      if (valid_in == 1) begin
         valid_count <= valid_count + 1;
//         if (active_pe && valid_count > 0 && valid_count < sw_array.len_t + 2) begin
         if (active_pe && valid_out) begin
            $display("%m, %d, %d", valid_count, v_out);
         end
      end else begin
         valid_count <= 0;
      end
   end
 -----/\----- EXCLUDED -----/\----- */
   
   //synthesis translate_on

endmodule // sw_pe
