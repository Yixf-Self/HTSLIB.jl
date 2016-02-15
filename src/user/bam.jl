
type BamIOStream <: IO
    name::AbstractString
    handle::Ptr{Void}
    phdr::Ptr{Header}
    precord::Ptr{Record}
    pkstr::Ptr{KString}
    eof::Bool
    function BamIOStream(name::AbstractString,handle::Ptr{Void},phdr::Ptr{Header},
                         prec::Ptr{Record},pkstr::Ptr{KString})
        new(name,handle,phdr,prec,pkstr,false)
    end
end

@doc """ general file open function
""" ->
function open(fname::AbstractString,mode::AbstractString,ty::AbstractString)
    fname = realpath(fname)
    ty == "bam" ? bam_open(fname,mode) :
    ty == "sam" ? sam_open(fname,mode) : open(fname,mode)
end

@doc """ bam file name must endwith bam
""" ->
function bam_open(fname::AbstractString, mode::AbstractString)
    split(fname,".")[end] == "bam" || info("file name doesn't endwith bam")
    fname = realpath(fname)
    bam_fl = hts_open(fname, mode)
    if mode == "rb"
        # bam_hdr_read(bam_fl->fp.bgzf)
        phdr = sam_hdr_read(bam_fl) #header info
    else
        phdr = bam_hdr_init()
    end
    prec = bam_init1()
    kstr = KString(0,0,C_NULL)
    pkstr = convert(Ptr{KString}, pointer_from_objref(kstr))
    
    BamIOStream(fname,bam_fl,phdr,prec,pkstr)
end

function bam_hdr_read!(bios::BamIOStream)
    bios.phdr = bam_hdr_read(bios.handle)
end

@doc """ read a record from a bam iostream
""" ->
function readline(bios::BamIOStream)
    handle = bios.handle
    phdr = bios.phdr
    prec = bios.precord
    ret = sam_read!(handle,phdr,prec)
    if ret == 0
        bios.eof = true
    elseif ret == -1
        bios.eof = false
        info("error occured in sam read ")
    end
    pkstr = bios.pkstr
    sam_format!(phdr,prec,pkstr)

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
    fname = realpath(fname)
    bios = bam_open(fname,"rb")
    data = readlines(bios)
    close(bios)
    data
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

@doc """ write a record to a BamIOStream
""" ->
function writeline(bios::BamIOStream, str::ASCIIString)
#    error("Wait for hdr function finished")
    kstr = KString(str)
    pkstr = convert(Ptr{KString}, pointer_from_objref(kstr))
    handle = bios.handle
    phdr = bios.phdr
    prec = bios.precord
    #sam_parse1(pkstr, phdr, prec)
    sam_write1(handle,phdr,prec)
end

@doc """ write all the records in strs to a BamIOStream
""" ->
function writelines(bios::BamIOStream, strs::Array{ASCIIString,1})
    #sam_hdr_write will use bam_hdr_write
    #sam_hdr_write(bios.handle,bios.phdr)
    for str in strs
        writeline(bios, str)
    end
end

@doc """ close a BamIOStream
""" ->
function close(bios::BamIOStream)
    #may be header need close but not find function now
    bam_destroy1(bios.precord)
    bam_hdr_destroy(bios.phdr)
    info("prec,pdhr closedd")
    sam_close(bios.handle)
end
