set RTL "$::env(MODEL_ROOT)/src/hw"

# RTL
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/interfaces.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/cci_ext_afu.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/afu_top.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/afu_engine.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/afu_rap.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/spl_adaptor.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/afu_csr.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/afu_pll.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/cdc_data.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/cdc_handshake.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/prefetch_rob.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/status_writer.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/sw_array.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/rob_512x256.sv"
set_global_assignment -name SYSTEMVERILOG_FILE "$RTL/sw_pe.sv"

# Altera Quartus IP
set_global_assignment -name QIP_FILE "$RTL/qip/fixed_pll.qip"
set_global_assignment -name QIP_FILE "$RTL/qip/ram_2p.qip"

# Design Constraints
set_global_assignment -name SDC_FILE "$RTL/afu.sdc"
