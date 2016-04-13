#!/bin/sh 

# this command is used to query the Nvidia GPUs for various metrics 

nvidia-smi --query-gpu=timestamp,index,pstate,memory.total,memory.used,memory.free,utilization.gpu,utilization.memory,power.draw,power.limit,clocks.gr,clocks.sm,clocks.mem,clocks.applications.gr,clocks.applications.mem,gpu_uuid -l 10 -f gpu_metric_dump.csv --format=csv,nounits
