
#f = HTSLIB.open("../data/100.sam","r","sam")

f = HTSLIB.sam_open("/home/guo/haplox/Github/HTSLIB/test/data/100.sam","r")
#phdr = HTSLIB.sam_hdr_read(f)

phdr = f.phdr
@show HTSLIB.strptr(phdr)


#@show f
