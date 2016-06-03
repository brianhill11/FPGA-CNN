//====================================================================
//
// spl.vh
//
// Original Author : George Powley
// Original Date   : 2014/08/14
//
// Copyright (c) 2014 Intel Corporation
// Intel Proprietary
//
// Description:
// - Common types, structs, and functions used by SPL designs
//
//====================================================================

`ifndef SPL_VH
`define SPL_VH

//--------------------------------------------------------------------
// AFU Read Request (Tx 0)
//--------------------------------------------------------------------
typedef enum logic {Virtual=1'b1, Physical=1'b0} pv_t;
typedef enum logic [3:0] {RdLine=4'h4} rd_request_t;

typedef struct packed {
   logic [98:93] block_size;
   logic [92:67] hi_address;
   pv_t          pv;
   logic [65:61] rsvd2;
   logic [60:56] rsvd1;
   rd_request_t  request_type;
   logic [51:46] rsvd0;
   logic [45:14] address;
   logic [13:0]  mdata;
} rd_req_header_t;

typedef struct {
   rd_req_header_t header;
   logic           rd_valid;
   logic           almostfull;
} rd_req_t;

//--------------------------------------------------------------------
// AFU Write Request (Tx 1)
//--------------------------------------------------------------------
typedef enum logic [3:0] {WrThru=4'h1, WrLine=4'h2, WrFence=4'h5} wr_request_t;

typedef struct packed {
   logic [98:93] block_size;
   logic [92:67] hi_address;
   pv_t          pv;
   logic [65:61] rsvd2;
   logic [60:56] rsvd1;
   wr_request_t  request_type;
   logic [51:46] rsvd0;
   logic [45:14] address;
   logic [13:0]  mdata;
} wr_req_header_t;

typedef struct {
   wr_req_header_t header;
   logic [511:0]   data;
   logic           wr_valid;
   logic           intr_valid;
   logic           almostfull;
} wr_req_t;


//--------------------------------------------------------------------
// AFU Read/Write Response (Rx 0)
//--------------------------------------------------------------------
typedef enum logic [3:0] {CfgWrite=4'h0, Write=4'h1, Read=4'h4} response_t;

typedef struct packed {
   logic [23:18] rsvd1;
   response_t    response_type;
   logic         rsvd0;
   logic [12:0]  mdata;
} rw_rsp_header_t;


typedef struct {
   rw_rsp_header_t header;
   logic [511:0]    data;
   logic            wr_valid;
   logic            rd_valid;
   logic            cfg_valid;
   logic            intr_valid;
   logic            umsg_valid;
} rw_rsp_t;

//--------------------------------------------------------------------
// AFU Write Response (Rx 1)
//--------------------------------------------------------------------
typedef struct packed {
   logic [23:18] rsvd1;
   response_t    response_type;
   logic         rsvd0;
   logic [12:0]  mdata;
} wr_rsp_header_t;

typedef struct {
   wr_rsp_header_t header;
   logic            wr_valid;
   logic            intr_valid;
} wr_rsp_t;

// Function: Returns physical address for a DSM register
function automatic [31:0] dsm_offset2addr;
   input    [9:0]  offset_b;
   input    [63:0] base_b;
   begin
      dsm_offset2addr = base_b[37:6] + offset_b[9:6];
   end
endfunction

`endif //  `ifndef SPL_VH
