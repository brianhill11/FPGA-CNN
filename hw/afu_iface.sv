//====================================================================
//
// afu_iface.sv
//
// Original Author : George Powley
// Original Date   : 2015/01/21
//
// Copyright (c) 2015 Intel Corporation
// Intel Proprietary
//
// Description:
//  - AFU engine interface
//====================================================================

`include "afu_csr.vh"
`include "afu.vh"

interface afu_bus_t;
   afu_csr_t csr;
   status_t status;
   prefetch_reader_bus_t reader;
   writer_bus_t writer;
endinterface // afu_bus_t
