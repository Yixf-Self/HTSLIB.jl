#=
sios = HTSLIB.open("/home/guo/haplox/Github/HTSLIB/test/data/100_sort.bam","rb","bam")

@show sios.handle
@show convert(Ptr{HTSLIB.HTSFile},sios.handle)
htsfl = unsafe_load(convert(Ptr{HTSLIB.HTSFile},sios.handle))
@show bytestring(htsfl.fn)

pidx = HTSLIB.sam_index_load(sios,"/home/guo/haplox/Github/HTSLIB/test/data/100_sort.bam")
phdr = sios.phdr
@show pidx,phdr

iters  = HTSLIB.sam_itr_querys(pidx,phdr,"chr1:65432520-65432550")
@show iters

b = HTSLIB.bam_init1()
i = 0
while HTSLIB.sam_itr_next!(sios.handle,iters,b)
    i+=1

    
end
=#
bios = HTSLIB.open("data/100_sort.bam","rb","bam")
htsfl = unsafe_load(convert(Ptr{HTSLIB.HTSFile},bios.handle))
pidx = HTSLIB.sam_index_load(bios,"data/100_sort.bam")
iters = HTSLIB.sam_itr_querys(pidx,bios.phdr,"chr1:65432520-65432550")
precord = HTSLIB.bam_init1()
while HTSLIB.sam_itr_next!(bios.handle,iters,precord)
    HTSLIB.sam_format!(bios.phdr,precord,bios.pkstr)
    kstr = HTSLIB.strptr(bios.pkstr)
    println(kstr)
end
