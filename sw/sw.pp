#include "AFU.hpp"
#include "afu_csr.h"
#include "afu_dsm.h"

#define AFU_DSM_SIZE CL(4)
#define AFU_WORKSPACE_SIZE MB(1)
#define AFU_DEBUG 0

volatile AFU_DSM *pDSM = NULL;
FILE *fp_check = NULL;
int pass = 0;
int fail = 0;
int debug = 0;

inline int
check_result(AFU &afu, int &id) {

  uint32_t result = pDSM->afu.score[id & 0x3];

  int expected_id = id & 0x7fff;
  int found = (result >> 16) & 0x7fff;

  if (found == expected_id) {
    result &= 0xffff;

    if (fp_check) {
      uint32_t expected;
      fread(&expected, sizeof(expected), 1, fp_check);

      if (result != expected) {
        printf("ERROR: expected %d, found %d\n", expected, result);
        fail++;
      }
      else {
        printf("PASS: expected %d, found %d\n", expected, result);
        pass++;
      }
    }
    else if (debug) {
      printf("score %d = %d\n", id, result);
    }

    id++;
    return 1;
  }

  return 0;
}

inline uint32_t
format_doorbell(int tid, int num_bytes_s, int num_bytes_t) {
  uint32_t doorbell = 1 << 31;
  doorbell |= (tid % (1 << 15)) << 16;
  doorbell |= ((num_bytes_s >> 6) + 2) << 8; // extra +1 CL for control data
  doorbell |= (num_bytes_t >> 6) + 1;
  return doorbell;
}

int 
main(int argc, char *argv[]) {

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
	
	printf("Setting number of cacheline per read operation\n");
  // set number of cacheline read per operation
  afu.write_csr(CSR_READ_BUFFER_LINES, 16);
	
	printf("Clearing doorbell\n");
  // clear doorbell
  afu.write_csr(CSR_DOORBELL, 0);
	
	printf("Clearing PLL reset\n");
  // clear PLL reset
  afu.write_csr(CSR_PLL_RESET, 0);
	
	printf("Disabling/enabling AFU\n");
  // disable/enable AFU 
  afu.write_csr(CSR_AFU_EN, 0);
  afu.write_csr(CSR_AFU_EN, 1);
	
	printf("Programming AFU variables\n");
  // program AFU variables
  afu.write_csr(CSR_MATCH, 10);
  afu.write_csr(CSR_MISMATCH, -5);
  afu.write_csr(CSR_ALPHA, 10);
  afu.write_csr(CSR_BETA, 8);
	
	printf("Opening data files\n");
  // open data files
  FILE *fp = fopen("/home/blhill/code/fpga/smith-waterman/test/sw.bin", "rb");
  fp_check = fopen("/home/blhill/code/fpga/smith-waterman/test/sw.check.bin", "rb");

  int tid = 0;
  int result_id = 1;

  afu.time_diff_ns();
  long total_cells = 0;
  int total_alignments = 0;

  int base_s = CL(1);
  int base_t = CL(256);
	printf("Entering while loop\n");
  while (1) {
    uint32_t len_s;
    uint32_t len_t;
		printf("Reading data\n");
    // read length of s
    size_t items = fread(&len_s, sizeof(len_s), 1, fp);
		printf("items: %d\n", items);
    // test for end of file
    if (items == 0) {
      break;
    }

    // copy sequences to memory buffer
    memcpy((void *)(pWorkspace), &len_s, 4);

    int num_bytes_s = (len_s >> 2) + (len_s % 4 > 0);
    fread((void *)(pWorkspace + base_s), sizeof(uint8_t), num_bytes_s, fp);

    fread(&len_t, sizeof(len_t), 1, fp);
    memcpy((void *)(pWorkspace + 4), &len_t, 4);

    int num_bytes_t = (len_t >> 2) + (len_t % 4 > 0);
    fread((void *)(pWorkspace + base_t), sizeof(uint8_t), num_bytes_t, fp);

    // update stats
    total_cells += len_s * len_t;
    total_alignments++;

    // ring doorbell
    tid++;
    uint32_t doorbell = format_doorbell(tid, num_bytes_s, num_bytes_t);
    printf("tid: %d\tnum_bytes_s: %d\tnum_bytes_t: %d\n", tid, num_bytes_s, num_bytes_t);
		printf("doorbell: %08x\n", doorbell);
		afu.write_csr(CSR_DOORBELL, doorbell);

		printf("Waiting for doorbell to ack\n");
    // wait for doorbell ack
    while (pDSM->afu.doorbell_ack != doorbell) {}
		printf("Doorbell ack received, checking result\n");
    if (debug) {
      printf("Time doorbell = %d\n", pDSM->afu.time_doorbell);
    }
		printf("Total alignments: %d\n", total_alignments);
    check_result(afu, result_id);
  }
  
  fclose(fp);

  // check last result
  while (!check_result(afu, result_id)) {}

  long total_ns = afu.time_diff_ns();

  // report stats
  printf("Total Alignments = %'d\n", total_alignments);
  printf("Total Cells = %'ld\n", total_cells);
  printf("Total Time = %'ld ns (%0.3f s)\n", total_ns, total_ns / 1e9);
  printf("Sustained Performance = %.3f GCUPS\n", 1.0 * total_cells / total_ns);
  
  // report test results
  if (fp_check) {
    fclose(fp_check);
    printf("Passed %d tests.\n", pass);
    printf("Failed %d tests.\n", fail);

    if (fail == 0 && pass == (total_alignments - 1)) {
      printf("+++ TEST PASSED +++\n");
    }
    else {
      printf("--- TEST FAILED ---\n");
    }
  }
  
  // afu object is destroyed
  // stop SPL Transaction, release Service, and stop Runtime
  return 0;
}
