set_false_path -from [get_keepers {*cdc_handshake:*|out_data*}] -to [get_keepers {*afu_bus.status.status_array*}]
set_false_path -from [get_keepers {*cdc_data:*|in_data_ff}] -to [get_keepers {*cdc_data:*|out_data_p1}]
set_false_path -to [get_keepers {*cdc_handshake:*|out_data*}]

set_false_path -from [get_keepers {*csr.alpha*}]
set_false_path -from [get_keepers {*csr.beta*}]
set_false_path -from [get_keepers {*csr.match*}]
set_false_path -from [get_keepers {*csr.mismatch*}]
