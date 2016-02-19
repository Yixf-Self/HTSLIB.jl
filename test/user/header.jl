info("Test read header info")

f = HTSLIB.sam_open(joinpath(Pkg.dir("HTSLIB"),"test/data/100.sam"),"r")
phdr = f.phdr
#@show HTSLIB.strptr(phdr) 
HTSLIB.close(f)

info("succefully read header info")
