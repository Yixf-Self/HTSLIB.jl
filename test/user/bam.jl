
data = HTSLIB.readlines("data/100.bam")

f = HTSLIB.open("data/test_write.bam","w","bam")
HTSLIB.writelines(f,data)
HTSLIB.close(f)
