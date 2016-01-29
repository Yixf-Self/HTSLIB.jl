
info("Test read sam file")
data = HTSLIB.readlines("data/100.sam")
#@show data
info("Read sam successfully")


info("Test write sam file")

fw = HTSLIB.open("data/test_write.sam","w","sam")
fr = HTSLIB.open("data/100.sam","r","sam")

header = unsafe_load(fr.phdr)
newheader = deepcopy(header)

phdr = convert(Ptr{HTSLIB.Header}, pointer_from_objref(newheader))

#ss = HTSLIB.strptr(fw.phdr)

fw.phdr = phdr

HTSLIB.writelines(fw,data)

HTSLIB.close(fw)
HTSLIB.close(fr)

info("writelines(fw,data) success")

