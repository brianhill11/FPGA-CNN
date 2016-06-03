//====================================================================
//
// spl_iface.sv
//
// Original Author : George Powley
// Original Date   : 2015/01/21
//
// Copyright (c) 2015 Intel Corporation
// Intel Proprietary
//
// Description:
//  - SPL interface
//====================================================================

`include "spl.vh"

interface spl_bus_t;
   logic    spl_enable;
   logic    spl_reset;
   rd_req_t rd_req;
   wr_req_t wr_req;
   rw_rsp_t rw_rsp;
   wr_rsp_t wr_rsp;
endinterface // spl_bus_t
