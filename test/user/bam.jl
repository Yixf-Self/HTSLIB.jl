
data = HTSLIB.readlines("data/100.bam")

info("HTSLIB.readlines(\"data/100.bam\")  read successfully ")
@show data

fw = HTSLIB.open("data/test_write.bam","wb","bam")
fr = HTSLIB.open("data/100.bam","rb","bam")

fw.phdr = deepcopy(fr.phdr)
HTSLIB.writelines(fw,data)
info("writelines(fw,data) success")
HTSLIB.close(fw)
HTSLIB.close(fr)

