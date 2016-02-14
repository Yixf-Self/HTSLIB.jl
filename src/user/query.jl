
@doc """ sam_index_load will call sam_index_load2 and search the string(fn,".bai")
         for the index file
""" ->
function sam_index_load(sios::SamIOStream,fname::AbstractString)
    fp = sios.handle
    fn = convert(Ptr{Cchar}, pointer(fname))
    pidx = sam_index_load(fp,fn)
end

@doc """ sam_index_build will always build .bai index file
""" ->             
function sam_index_build(fname::AbstractString)
    fn = convert(Ptr{Cchar}, pointer(fname))
    sam_index_build(fn,0)
end

@doc """ query reads in a region
""" ->
function sam_itr_querys(pidx,phdr::Ptr{Header},region::ASCIIString)
    region = string(region,'\0')
    region = convert(Ptr{Cchar},pointer(region))
    ret = sam_itr_querys(pidx,phdr,region)
    if ret == C_NULL
        info("sam_itr_querys return NULL")
    end
    ret
end

@doc """ produce record in the itr
""" -> 
function sam_itr_next!(handle::Ptr{Void}, itr::Ptr{Void}, r::Ptr{Record})
    phtsf = convert(Ptr{HTSFile}, handle)
    htsfile = unsafe_load(phtsf) # may change unsigned bits to signed
    @show htsfile.lineno
    @show htsfile.line
    @show bytestring(htsfile.fn)
    bgzf = htsfile.bgzf
    flag = sam_itr_next(bgzf,itr,r,handle)
    flag >=0 ? true : false
end
