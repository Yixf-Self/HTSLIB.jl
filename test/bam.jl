const bam_fl = "data/test.bam"

fp = HTSLIB.bam_open(bam_fl,"r")

bamheader = HTSLIB.bam_hdr_read(fp)

record = HTSLIB.bam_init1()
ks = HTSLIB.KString(0,0,C_NULL)
while true
    r = HTSLIB.bam_read!(fp,bamheader,record)
    pks = convert(Ptr{HTSLIB.KString},pointer_from_objref(ks))
    HTSLIB.sam_format!(bamheader,record,pks)
    HTSLIB.show(STDOUT,ks)
    #@show unsafe_load(ks.s,1)
    #@show ks
    #HTSLIB.show(STDOUT,unsafe_load(record))
    sleep(2)
end

#=
info("next load record.core")
sleep(2)
@show unsafe_load(unsafe_load(record).core)
@show unsafe_load(record).data
info("next load record.data")
sleep(2)
@show unsafe_load(unsafe_load(record).data)
#sleep(2)
#end
=#
