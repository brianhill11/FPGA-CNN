# afu csrs
# register name, bits [, reset]

afu_en, 1
doorbell, 32, reset_doorbell

read_buffer_lines, 32
read_buffer_base, 64
write_buffer_base, 64

update_dsm, 32, reset_update_dsm

pll_reset, 1
load_weights, 1
num_cl_per_filter, 8
num_filters, 16
max_weight_buffer_addr, 16
load_images, 1

write_fence, 1, DEFAULT
