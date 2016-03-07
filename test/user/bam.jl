
info("Test read bam file")
data = HTSLIB.readlines("data/100.bam")
bios = HTSLIB.open("data/100.bam","rb","bam")
while !HTSLIB.eof(bios)
    line = HTSLIB.readline(bios)
end
#@show data
info("Read bam successfully")


info("Test write bam file")

fw = HTSLIB.open("data/test_write.bam","wb","bam")
fr = HTSLIB.open("data/100.bam","rb","bam")

fw.phdr = HTSLIB.sam_hdr_parse(HTSLIB.strptr(fr.phdr))

HTSLIB.writelines(fw,data)

HTSLIB.close(fw)
HTSLIB.close(fr)

info("writelines success")


