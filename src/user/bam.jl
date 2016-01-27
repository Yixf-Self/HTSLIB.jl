
type BamIOStream <: IO
    name::AbstractString
    handle::Ptr{Void}
    hdr_handle::Ptr{Void}
    precord::Ptr{Record}
    pkstr::Ptr{KString}
    eof::Bool
    function BamIOStream(name::AbstractString,handle::Ptr{Void},hdr_handle::Ptr{Void},
                         prec::Ptr{Record},pkstr::Ptr{KString})
        new(name,handle,hdr_handle,prec,pkstr,false)
    end
end

@doc """ general file open function
""" ->
function open(fname::AbstractString,mode::AbstractString,ty::AbstractString)
    ty == "bam" ? bam_open(fname,mode) : open(fname,mode)
end

@doc """ bam file name must endwith bam
""" ->
function bam_open(fname::AbstractString, mode::AbstractString)
    split(fname,".")[end] == "bam" || info("file name doesn't endwith bam")
    
    bam_fl = hts_open(fname,mode)
    hdr_handle = sam_hdr_read(bam_fl) #header info
    prec = bam_init1()
    kstr = KString(0,0,C_NULL)
    pkstr = convert(Ptr{KString}, pointer_from_objref(kstr))
    
    BamIOStream(fname,bam_fl,hdr_handle,prec,pkstr)
end

@doc """ read a record from a bam iostream
""" ->
function readline(bios::BamIOStream)
    handle = bios.handle
    hdr_handle = bios.hdr_handle
    prec = bios.precord
    ret = sam_read!(handle,hdr_handle,prec)
    if ret == 0
        bios.eof = true
    elseif ret == -1
        bios.eof = true
        #info("error occured in sam read ")
    end
    pkstr = bios.pkstr
    sam_format!(hdr_handle,prec,pkstr)

    strptr(pkstr)
end

@doc """ eof(bios) -> Bool
         Tests whether an Bam I/O stream is at end-of-file.
""" ->
function eof(bios::BamIOStream)
    bios.eof
end

@doc """ read all the records from a bam file
""" ->
function readlines(fname::AbstractString)
    bios = bam_open(fname,"r")
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
        if i > size
            resize!(data,2*size)
            size = 2*size
        end
        line = readline(bios)
        data[i] = line
    end
    data[1:i]
end

@doc """
""" ->
function write()
    
    
end

@doc """ close a BamIOStream
""" ->
function close(bios::BamIOStream)
    #may be header need close but not find function now
    sam_close(bios.handle)
end
