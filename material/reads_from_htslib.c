#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <math.h>
#include <inttypes.h>
#include <stdbool.h>
#include <assert.h>
#include "htslib/sam.h"
#include "htslib/faidx.h"
#include "htslib/kstring.h"
#include "htslib/khash.h"
//#include "samtools.h"


int main(int argc, char** argv){

  //hts_itr_t *iter = NULL;
  //  hts_idx_t *idx  = NULL;
  samFile *in = NULL;
  bam1_t *b = NULL;
  bam_hdr_t *header = NULL;

  //  if (argc!=3) return -1;
  printf("sizeof off_t is %d\n",(int)sizeof(off_t));
  printf("sizeof htsFile is %d\n",(int)sizeof(htsFile));
  printf("sizeof htsFormat is %d\n",(int)sizeof(htsFormat));
  printf("sizeof union is %d\n",(int)sizeof(    union {
    BGZF *bgzf;
    struct cram_fd *cram;
    struct hFILE *hfile;
    void *voidp;
  }));
  printf("sizeof kstring_t is %d\n",(int)sizeof(kstring_t));
  const char* bam_fl = "test.bam";
  
  in = sam_open(bam_fl,"r");
  if (in==NULL) return -1;
  printf("%s\n","sam_open passed");

  header = sam_hdr_read(in);
  if (header == NULL) {
    return -1;
  }
  else{
    // printf("header->text %s\t",header->text);
    printf("%s\n","sam_hdr_read passed");
  }
  
  /*
  idx = sam_index_load(in, bam_fl);
  if (idx == NULL) {
    printf("bam file name is %s\t",bam_fl);
    printf("in->format.format %d\t",in->format.format);
    printf("%s\n","sam_index_load failed");
    return -1;
  }
  printf("%s\n","sam_index_load passed");
  
  iter = sam_itr_querys(idx,header,"chr1:96676-1914348"); //idx, sam_itr_querys
  if (iter == NULL) return -1;
  printf("%s\n","sam_itr_querys passed");
  
  printf("%s\n","bam_init1 passed");
  */
  /*  
  while (sam_itr_next(in,iter,b) >= 0){
    fputs("DO STUFF\n",stdout);
  }
  */
  b = bam_init1();
  int r = 0;
  while ((r = sam_read1(in,header,b)) >= 0){
    printf("length of current data %d\n",b->l_data);
    int i;
    //   for(i=0;i<b->l_data;i++)
    //      printf("%s",b->data[i]);
    printf("\n");
    printf("%s\n",bam_aux2Z(bam_get_aux(b)));
    printf("\n");
    break;
  }

  //  hts_itr_destroy(iter);
  bam_destroy1(b);
  bam_hdr_destroy(header);
  sam_close(in);

  return 0;
}

