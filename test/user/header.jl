info("Test read header info")

f = HTSLIB.sam_open("/home/guo/haplox/Github/HTSLIB/test/data/100.sam","r")
phdr = f.phdr
@show HTSLIB.strptr(phdr) 
HTSLIB.close(f)

info("succefully read header info")
