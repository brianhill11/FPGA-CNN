#include <stdlib.h>
#include <time.h>
#include <cmath>
#include "AFU.hpp"
#include "afu_csr.h"
#include "afu_dsm.h"

//#include "caffe/blob.hpp"
//#include "caffe/filler.hpp"
//#include "caffe/layers/conv_layer.hpp"

#define AFU_DSM_SIZE CL(4)
#define AFU_WORKSPACE_SIZE MB(256)
#define AFU_DEBUG 0

volatile AFU_DSM *pDSM = NULL;
FILE *fp_check = NULL;
int pass = 0;
int fail = 0;
int debug = 1;

union float_bits {
	uint32_t i;
	float f;
};

inline uint32_t
format_doorbell(int tid, int num_bytes_s, int num_bytes_t) {
  uint32_t doorbell = 1 << 31;
  doorbell |= (tid % (1 << 15)) << 16;
//  doorbell |= ((num_bytes_s >> 6) + 2) << 8; // extra +1 CL for control data
  doorbell |= ((num_bytes_s >> 6)) << 8; // extra +1 CL for control data
  doorbell |= (num_bytes_t >> 6);
  return doorbell;
}

int
send_weight_data(AFU afu, volatile AFU_DSM *pDSM, btVirtAddr pWorkspace, const float *weight_data   ) {
	//number of floats per filter
	int filter_size = 75;
	//number of cachelines needed to store a single filter
	int num_cacheline_per_filter = (int)ceil( (filter_size * sizeof(float)) / 64.0);
	//int num_cacheline_per_filter = (int)ceil( (weight_blob->count(1) * sizeof(float)) / 64.0);
	//total number of filters
	int num_filters = 10;
	//int num_filters = weight_blob->num();
	
	if (debug) {
		printf("Sending weight data\n");
		printf("filter_size: %d\tnum_cacheline_per_filter: %d\tnum_filters: %d\n", filter_size, num_cacheline_per_filter, num_filters);
	}

	printf("Setting number of cachelines per filter\n");
	//how many CLs to store a single filter
	afu.write_csr(CSR_NUM_CL_PER_FILTER, num_cacheline_per_filter);
	
	printf("Setting number of filters\n");
	//total number of filters
	afu.write_csr(CSR_NUM_FILTERS, num_filters);

	printf("Setting number of cachelines per read operation\n");
  // set number of cacheline read per operation
  afu.write_csr(CSR_READ_BUFFER_LINES, num_cacheline_per_filter);
	
	printf("Resetting signal for loading weights to FPGA\n");
	//tell FPGA to store data in weight buffers
	afu.write_csr(CSR_LOAD_WEIGHTS, 0);
	
	printf("Resetting signal for loading images to FPGA\n");
	//tell FPGA to store data in image buffers
	afu.write_csr(CSR_LOAD_IMAGES, 0);
	
	printf("Disabling/enabling AFU\n");
  // disable/enable AFU 
  afu.write_csr(CSR_AFU_EN, 0);
  afu.write_csr(CSR_AFU_EN, 1);
	
	int tid = 0;
  int num_filters_sent = 0;

  afu.time_diff_ns();
  
	while (num_filters_sent != num_filters) {
		if (debug) {
			printf("Copying filter %d to read buffer\n", num_filters_sent);
		}
		//clear workspace in case filters are not aligned with cacheline
		memset( (void *)(pWorkspace + CL(1)), 0, num_cacheline_per_filter * CL(1) );
  	
		//copy weight blob to memory buffer
		const float* weight_blob_data = weight_data;
		//const float* weight_blob_data = weight_blob->cpu_data();
		
		//copy 1 filter of weight data to workspace
		memcpy((void *)(pWorkspace + CL(1)), weight_blob_data + num_filters_sent * num_cacheline_per_filter*CL(1), num_cacheline_per_filter * CL(1) );
  	
		printf("Telling FPGA to read into weight buffers\n");	
		//tell FPGA to store data in weight buffers
		afu.write_csr(CSR_LOAD_WEIGHTS, 1);

		// ring doorbell
  	tid++;
  	printf("Ring doorbell\n");
		//64 is for number of bytes 
		uint32_t doorbell = format_doorbell(tid, 64, 64);
  	afu.write_csr(CSR_DOORBELL, doorbell);

		printf("Waiting for doorbell ack\n");
  	// wait for doorbell ack
  	while (pDSM->afu.doorbell_ack != doorbell) {}
			
  	if (debug) {
  	  printf("Time doorbell = %d\n", pDSM->afu.time_doorbell);
			printf("result1: %x\n", pDSM->afu.score[1]);
			printf("result3: %x\n", pDSM->afu.score[3]);
  	}
		/*
		printf("###################################\n");
		printf("result_id: %x\n", pDSM->afu.score[0]);
		result.i = pDSM->afu.score[1];
		printf("expected: %f\n", result_data[num_cl_sent]);
		printf("result: %f\n", result.f);
		printf("###################################\n");
  	*/
		num_filters_sent++;
	}
	printf("Done sending weight data, signaling FPGA\n");
	//tell FPGA to store data in weight buffers
	afu.write_csr(CSR_LOAD_WEIGHTS, 0);
  
	long total_ns = afu.time_diff_ns();

  // report stats
  printf("Total Time = %'ld ns (%0.3f s)\n", total_ns, total_ns / 1e9);

	return 0;
}


int 
caffe_connector(float *in_data, float *weight_data, float *result_data) {
	// start AAL Runtime, acquire Service, and start SPL Transaction
  AFU afu(AFU_DSM_SIZE, AFU_WORKSPACE_SIZE, debug);


  // check if AAL/AFU is initialized
  if (!afu.is_ready()) {
    printf("\nError initializing AAL/AFU.\n");
    return -1;
  }
  else {
    printf("Connected to AFU\n");
  }

  pDSM = (volatile AFU_DSM *)afu.AFUDSMVirt();
  btVirtAddr pWorkspace = afu.OneLargeVirt();

  printf("AFU ID = %016lx %016lx\n", pDSM->afu.afu_id[1], pDSM->afu.afu_id[0]);
  
  // send workspace address to AFU
  afu.write_csr_64(CSR_READ_BUFFER_BASE, (bt64bitCSR)pWorkspace);
  
	// send write buffer address to AFU
  afu.write_csr_64(CSR_WRITE_BUFFER_BASE, (bt64bitCSR)(pWorkspace + MB(100)));
	
	
	printf("Clearing doorbell\n");
  // clear doorbell
  afu.write_csr(CSR_DOORBELL, 0);
	
  printf("Resetting PLL\n");
	// clear PLL reset
  afu.write_csr(CSR_PLL_RESET, 0);
	
	//send_weight_data(afu, pDSM, pWorkspace, weight_data);
	//number of floats per filter
	int filter_size = 128;
	//number of cachelines needed to store a single filter
	int num_cacheline_per_filter = (int)ceil( (filter_size * sizeof(float)) / 64.0);
	//int num_cacheline_per_filter = (int)ceil( (weight_blob->count(1) * sizeof(float)) / 64.0);
	//total number of filters
	int num_filters = 64;
	//int num_filters = weight_blob->num();
	int max_weight_buffer_addr = (int)ceil( (num_filters * num_cacheline_per_filter) / 16.0);

	if (debug) {
		printf("Sending weight data\n");
		printf("filter_size: %d\tnum_cacheline_per_filter: %d\tnum_filters: %d\n", filter_size, num_cacheline_per_filter, num_filters);
	}

	printf("Setting number of cachelines per filter\n");
	//how many CLs to store a single filter
	afu.write_csr(CSR_NUM_CL_PER_FILTER, num_cacheline_per_filter);
	
	printf("Setting number of filters\n");
	//total number of filters
	afu.write_csr(CSR_NUM_FILTERS, num_filters);

	printf("Setting number of cachelines per read operation\n");
  // set number of cacheline read per operation
  afu.write_csr(CSR_READ_BUFFER_LINES, num_cacheline_per_filter);
	
	printf("Setting max weight buffer address\n");
  // 
  afu.write_csr(CSR_MAX_WEIGHT_BUFFER_ADDR, max_weight_buffer_addr);
	
	printf("Resetting signal for loading weights to FPGA\n");
	//tell FPGA to store data in weight buffers
	afu.write_csr(CSR_LOAD_WEIGHTS, 0);
	
	printf("Resetting signal for loading images to FPGA\n");
	//tell FPGA to store data in image buffers
	afu.write_csr(CSR_LOAD_IMAGES, 0);
	
	printf("Disabling/enabling AFU\n");
  // disable/enable AFU 
  afu.write_csr(CSR_AFU_EN, 0);
  afu.write_csr(CSR_AFU_EN, 1);
	
	int tid = 0;
  int num_filters_sent = 0;

  afu.time_diff_ns();
  
	while (num_filters_sent != num_filters) {
		if (debug) {
			printf("Copying filter %d to read buffer\n", num_filters_sent);
		}
		//clear workspace in case filters are not aligned with cacheline
		memset( (void *)(pWorkspace + CL(1)), 0, num_cacheline_per_filter * CL(1) );
  	
		//copy weight blob to memory buffer
		const float* weight_blob_data = weight_data;
		//const float* weight_blob_data = weight_blob->cpu_data();
		
		//copy 1 filter of weight data to workspace
		memcpy((void *)(pWorkspace + CL(1)), weight_blob_data + num_filters_sent * num_cacheline_per_filter*CL(1), num_cacheline_per_filter * CL(1) );
  
		if (num_filters_sent == 0) {
			printf("Telling FPGA to read into weight buffers\n");	
			//tell FPGA to store data in weight buffers
			afu.write_csr(CSR_LOAD_WEIGHTS, 1);
		}

		// ring doorbell
  	printf("Ring doorbell\n");
  	tid++;
		//64 is for number of bytes 
		uint32_t doorbell = format_doorbell(tid, 64, 64);
  	printf("Doorbell: %x\n", doorbell);
		afu.write_csr(CSR_DOORBELL, doorbell);

		printf("Waiting for doorbell ack\n");
  	// wait for doorbell ack
  	while (pDSM->afu.doorbell_ack != doorbell) {}
			
  	if (debug) {
  	  printf("Time doorbell = %d\n", pDSM->afu.time_doorbell);
			printf("result1: %x\n", pDSM->afu.score[1]);
			printf("result3: %x\n", pDSM->afu.score[3]);
  	}
		/*
		printf("###################################\n");
		printf("result_id: %x\n", pDSM->afu.score[0]);
		result.i = pDSM->afu.score[1];
		printf("expected: %f\n", result_data[num_cl_sent]);
		printf("result: %f\n", result.f);
		printf("###################################\n");
  	*/
		num_filters_sent++;
	}
	printf("Done sending weight data, signaling FPGA\n");
	//tell FPGA to store data in weight buffers
	afu.write_csr(CSR_LOAD_WEIGHTS, 0);
  
	long total_ns = afu.time_diff_ns();

  // report stats
  printf("Total Time = %'ld ns (%0.3f s)\n", total_ns, total_ns / 1e9);

	printf("Setting number of cachelines per read operation for image data\n");
  // set number of cacheline read per operation
  afu.write_csr(CSR_READ_BUFFER_LINES, 1);

	tid = 0;

	int num_cl_sent = 0;
  
	while (1) {
		float_bits result;
    
		if (num_cl_sent == 8) {
      break;
    }
		
		//printf("\n\nworkspace address: %p\n\n", (void *)(pWorkspace));
		
		printf("Copying test input data to buffer\n");
    //copy 64 bytes test datafloats to memory buffer
		memcpy((void *)(pWorkspace + CL(1)), in_data + num_cl_sent*16*sizeof(float), 16*sizeof(float));
		//printf("in_data address: %p\n", (void *)(pWorkspace) + CL(1));
		/*
		for (int i = 0; i < 16; i++) {
			float x;
			memcpy(&x, (void*)(pWorkspace + CL(1) + i*4), sizeof(float));
			printf("i: %d\t%f\n", i, x);
		}
		*/
		if (num_cl_sent == 0) {
			printf("Signaling FPGA to load images\n");
			//tell FPGA to store data in image buffers
			afu.write_csr(CSR_LOAD_IMAGES, 1);
		}

    // ring doorbell
    printf("Ring doorbell\n");
		//64 is for number of bytes 
		uint32_t doorbell = format_doorbell(tid, 64, 64);
    afu.write_csr(CSR_DOORBELL, doorbell);
    tid++;

		printf("Waiting for doorbell ack\n");
    // wait for doorbell ack
    while (pDSM->afu.doorbell_ack != doorbell) {}

		printf("Waiting on valid data from accelerator\n");
		//wait until accel pipeline is filled and has written valid data
		while (pDSM->afu.valid != 0xffffffff) {}

		float res[num_filters][num_cacheline_per_filter];
		memcpy((void *)(res), (pWorkspace + MB(100)), num_filters * num_cacheline_per_filter * sizeof(float) );
		printf("res[0] = %f\n", res[0]);
	
		printf("Summing up results\n");
		for (int i = 0; i < num_filters; i++) {
			float filter_sum = 0.0;
			for (int j = 0; j < num_cacheline_per_filter; j++) {
				filter_sum += res[i][j];
			}
			printf("filter %d sum: %f\n", i, filter_sum);
		}

    if (debug) {
      printf("Time doorbell = %d\n", pDSM->afu.time_doorbell);
			printf("filter ID: %x\n", pDSM->afu.score[0]);
			result.i = pDSM->afu.score[1];
			printf("result: %f\n", result.f);
    }
		/*
		printf("###################################\n");
		printf("result_id: %x\n", pDSM->afu.score[0]);
		result.i = pDSM->afu.score[1];
		printf("expected: %f\n", result_data[num_cl_sent]);
		printf("result: %f\n", result.f);
		printf("###################################\n");
		
		printf("result_id: %x\n", pDSM->afu.score[2]);
		result.i = pDSM->afu.score[3];
		printf("result: %f\n", result.f);
		printf("###################################\n");
		*/
		num_cl_sent++;
  }
		
	printf("Signaling FPGA done sending images\n");
	//tell FPGA to store data in weight buffers
//	afu.write_csr(CSR_LOAD_IMAGES, 0);

	/*
	while (1) {
		float_bits result;
			printf("filter ID: %x\n", pDSM->afu.score[0]);
			result.i = pDSM->afu.score[1];
			printf("result: %f\n", result.f);
	}
	*/
	total_ns = afu.time_diff_ns();

  // report stats
  printf("Total Time = %'ld ns (%0.3f s)\n", total_ns, total_ns / 1e9);
  
  // afu object is destroyed
  // stop SPL Transaction, release Service, and stop Runtime
  return 0;
}


int 
main(int argc, char *argv[]) {
	int num_cl = 2560;
  float *test_data, *weight_data, *result_data;
	test_data = new float[16*num_cl];
	weight_data = new float[16*num_cl];
	result_data = new float[8*num_cl];
	//seed random num gen
	srand(time(NULL));
	
	//fill test data and weight data
	for (int i = 0; i < 16*num_cl; i++) {
		test_data[i] = (float)(i); 
		weight_data[i] = (float)(i); 
//		test_data[i] = (float) (rand() / 100.0); 
//		weight_data[i] = (float) (rand() / 100.0); 
	}
	//calculate expected result data
	for (int i = 0; i < num_cl; i = i++) {
		result_data[i] = 0.0;
		for (int j = 0; j < 16; j++) {
			result_data[i] += (test_data[i*16+j] * weight_data[i*16+j]);
		}
	}
	
	caffe_connector(test_data, weight_data, result_data);

	delete [] test_data;
	delete [] weight_data;
	delete [] result_data;

	return 0;
}
