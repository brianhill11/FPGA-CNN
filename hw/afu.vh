//====================================================================
//
// afu.vh
//
// Original Author : George Powley
// Original Date   : 2014/08/14
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
// - Common types, structs, and functions used by AFU designs
//
//====================================================================

`ifndef AFU_VH
`define AFU_VH

localparam CACHE_WIDTH = 512;

// note: status_array is type bit so it doesn't hold Xs, which cause the status writer to write forever in simulation
typedef struct 
  {
   logic ready;                      // from writer : 1 = ready for data; 0 = busy, write is ignored
   logic valid;                      // from accel  : data and offset are valid
   logic [CACHE_WIDTH-1:0] data;     // from accel  : data to write
   logic [9:0] offset;               // from accel  : offset into status region
   logic [127:0] afu_id;             // from accel  : unique AFU identifier
   bit   [31:0] status_array [15:0]; // from multiple : status registers
   bit   [15:0] update;              // from multiple : status update request
   logic [31:0] perf_counter;        // from status : common free running counter for reporting performance
 } status_t;

typedef struct
  {
   logic ready;                        // from accel  : ready for data
   logic valid;                        // from reader : data is valid
   logic buffer_sel;                   // from accel  : select A or B buffer
   logic rd_clk;                       // from accel  : clock for addr signals
   logic [15:0] addr_a;                 // from accel  : buffer A read addr 
   logic [7:0] addr_b;                 // from accel  : buffer B read addr
   logic [CACHE_WIDTH-1:0] data_a [NUM_PE-1:0];// from reader : data read from memory
   logic [CACHE_WIDTH-1:0] data_b;// from reader : data read from memory
   logic [15:0] tid;                   // from reader : transaction id from software
 } prefetch_reader_bus_t;

typedef struct
  {
   logic ready;                     // from writer : 1 = ready for data; 0 = busy, write is ignored
   logic valid;                     // from accel  : data is valid
	 logic pipeline_full;							// from accel	 : computation pipeline is full
	 logic pipeline_empty;						// from accel	 : computation pipeline is empty
	 logic [9:0]             offset;  // from accel  : data to write
   logic [CACHE_WIDTH-1:0] data;    // from accel  : data to write
 } writer_bus_t;

`endif //  `ifndef AFU_VH
