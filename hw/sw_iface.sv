//====================================================================
//
// sw_iface.sv
//
// Original Author : George Powley
// Original Date   : 2015/01/21
//
// Copyright (c) 2015 Intel Corporation
// Intel Proprietary
//
// Description:
//  - Accelerator interface
//====================================================================

`include "sw.vh"

interface sw_bus_t;
   logic start;
   logic valid;
	 logic filters_finished;
	 logic pipeline_full;
	 logic pipeline_empty;
	 logic [12:0] max_weight_buffer_addr;
	 logic [WEIGHT_ADDR_WIDTH-1:0] addr_a;
   logic [IMAGE_ADDR_WIDTH-1:0] addr_b;
   logic [CACHE_WIDTH-1:0] data_a [NUM_PE-1:0];
   logic [CACHE_WIDTH-1:0] data_b;
	 logic [CACHE_WIDTH-1:0] result;
endinterface // sw_bus_t
