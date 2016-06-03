//====================================================================
//
// sw.vh
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

`ifndef SW_VH
`define SW_VH

//localparam DATA_WIDTH = 256;
parameter NUM_CYCLES = 33; //5 cycles for mult (x1), 7 for add (x4)

localparam WEIGHT_ADDR_WIDTH = 12;
localparam IMAGE_ADDR_WIDTH = 8;

localparam NUM_PE = 16;

`endif
