sios = HTSLIB.open("/home/guo/haplox/Github/HTSLIB/test/data/100_sort.bam","rb","bam")

htsfl = unsafe_load(convert(Ptr{HTSLIB.HTSFile},sios.handle))
@show htsfl
@show bytestring(htsfl.fn)
#=
pidx = HTSLIB.sam_index_load(sios,"/home/guo/haplox/Github/HTSLIB/test/data/100_sort.bam")
phdr = sios.phdr
@show pidx,phdr

iters  = HTSLIB.sam_itr_querys(pidx,phdr,"chr1:65432520-65432550")
@show iters

b = HTSLIB.bam_init1()
while HTSLIB.sam_itr_next!(sios.handle,iters,b)
    @show sios
    @show b
end
=#
