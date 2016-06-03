struct AFU_DSM {

  struct DSM_AFU_ID {
    btUnsigned64bitInt afu_id[2];
    btUnsigned32bitInt doorbell_ack;
    btUnsigned32bitInt valid;
    btUnsigned32bitInt score[4];
    btUnsigned32bitInt txid;
    btUnsigned32bitInt update_ack;
    btUnsigned32bitInt time_doorbell;
    char rsvd[8];
    //    char rsvd[6*8];
  } afu;

  // new cache line

  struct DSM_CL_DOORBELL {
    btUnsigned32bitInt ack;
    btUnsigned32bitInt time_doorbell;
    btUnsigned32bitInt time_ack;
    char rsvd[52];
  } doorbell;

  // new cache line : array of 2

  struct DSM_CL_RESULT {
    btUnsigned32bitInt score;
    btUnsigned32bitInt tid;
    btUnsigned32bitInt time_start;
    btUnsigned32bitInt time_doorbell;
    char rsvd[48];
  } result[2];

};

#define IS_CACHELINE(a) CASSERT(sizeof(a) == 64)

IS_CACHELINE(AFU_DSM::DSM_AFU_ID);
IS_CACHELINE(AFU_DSM::DSM_CL_DOORBELL);
IS_CACHELINE(AFU_DSM::DSM_CL_RESULT);
