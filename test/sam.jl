
const SAM_FL = "data/test.sam"

fp = HTSLIB.sam_open(SAM_FL,"r")
@test typeof(fp) == Ptr{Void}

@show HTSLIB.sam_hdr_read(fp)

@test HTSLIB.sam_close(fp) == 0

