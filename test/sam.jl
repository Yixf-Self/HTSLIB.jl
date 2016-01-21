
const SAM_FL = "data/test.sam"

fp = HTSLIB.sam_open(SAM_FL,"r")
@test typeof(fp) == Ptr{Void}

header = HTSLIB.sam_hdr_read(fp)
aln = HTSLIB.bam_init1()
HTSLIB.sam_read1()

@test HTSLIB.sam_close(fp) == 0

