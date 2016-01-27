
type BamIOStream <: IO
    name::AbstractString
    handle::Ptr{Void}
    hdr_handle::Ptr{Void}
    precord::Ptr{Record}
    pkstr::Ptr{KString}
    function BamIOStream(name::AbstractString,handle::Ptr{Void},hdr_handle::Ptr{Void},
                         prec::Ptr{Record},pkstr::Ptr{KString})
        new(name,handle,hdr_handle,prec,kstr)
    end
end

@doc """ bam file name must endwith bam
""" ->
function bam_open(fname::AbstractString, mode::AbstractString)
    split(fname,".")[end] == "bam" || info("file name doesn't endwith bam")
    
    bam_fl = hts_open(fname,mode)
    header_fl = sam_hdr_read(bam_fl)
    prec = bam_init1()
    kstr = KString(0,0,C_NULL)
    pkstr = convert(Ptr{KString}, pointer_from_objref(kstr))
    
    BamIOStream(fname,bam_fl,header_fl,prec,pkstr)
end

@doc """ read a record from a bam iostream
""" ->
function readline(bios::BamIOStream)
    handle = bios.handle
    hdr_handle = bios.hdr_handle
    prec = bios.precord
    sam_read!(handl,hdr_handle,prec)
    pkstr = bios.pkstr
    sam_format!(hdr_handle,prec,pkstr)

    strptr(pkstr)
end

@doc """ eof(bios) -> Bool
         Tests whether an Bam I/O stream is at end-of-file.
""" ->
function eof(bios::BamIOStream)
    true
end

@doc """ read all the records from a bam file
""" ->
function readlines(fname::AbstractString)
    bios = bam_open(fname)
    readlines(bios)
end

@doc """ read all the records from a BamIOStream
""" ->
function readlines(bios::BamIOStream)
    size = 256
    data = Array{ASCIIString,1}(size)
    i = 0
    while !eof(bios)
        i += 1
        if i <= size
            data[i] = readline(bios)
        else
            resize!(data,2*size)
        end
    end
    data[1:i]
end

