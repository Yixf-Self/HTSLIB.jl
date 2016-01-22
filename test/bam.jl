const bam_fl = "data/test.bam"

fp = sam_open(bam_fl,"r")

bamheader = sam_hdr_read(fp)

record = bam_init1()

while true
    r = sam_read1!(fp,bamheader,record)
    @show unsafe_load(record)
    @show unsafe_load(record).core
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
