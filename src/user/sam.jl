
typealias SamIOStream BamIOStream

@doc """ sam file name must endwith bam
""" ->
function sam_open(fname::AbstractString, mode::AbstractString)
    @show fname
    fname = realpath(fname)
  #  split(fname,".")[end] == "sam" || info("file name doesn't endwith sam")
    
    sam_fl = hts_open(fname,mode)
    if mode == "r"
        phdr = sam_hdr_read(sam_fl) #header info
    else
        phdr = bam_hdr_init()
    end
    prec = bam_init1()
    kstr = KString(0,0,C_NULL)
    pkstr = convert(Ptr{KString}, pointer_from_objref(kstr))
    SamIOStream(fname,sam_fl,phdr,prec,pkstr)
end

function sam_hdr_parse(str::AbstractString)
    l_text = Int32(length(str))
    str = string(str,'\0')
    text = convert(Cstring, pointer(str))
    sam_hdr_parse(l_text,text)
end

@doc """ read a record from a sam iostream
""" ->
function readline(sios::SamIOStream)
    handle = sios.handle
    phdr = sios.phdr
    prec = sios.precord
    ret = sam_read!(handle,phdr,prec)
    if ret == 0
        sios.eof = false
    elseif ret == -1
        sios.eof = true
    end
    pkstr = sios.pkstr
    sam_format!(phdr,prec,pkstr)

    strptr(pkstr)
end

@doc """ eof(sios) -> Bool
         Tests whether an Bam I/O stream is at end-of-file.
""" ->
function eof(sios::SamIOStream)
    sios.eof
end

@doc """ read all the records from a bam file
""" ->
function readlines(fname::AbstractString)
    info("In the sam open")
    sios = sam_open(fname,"r")
    data = readlines(sios)
    close(sios)
    data
end

@doc """ read all the records from a SamIOStream
""" ->
function readlines(sios::SamIOStream)
    size = 256
    data = Array{ASCIIString,1}(size)
    i = 0
    while !eof(sios)
        i += 1
        if i > size
            resize!(data,2*size)
            size = 2*size
        end
        line = readline(sios)
        data[i] = line
    end
    data[1:i]
end

@doc """ write a record to a SamIOStream
""" ->
function writeline(sios::SamIOStream, str::ASCIIString)
#    error("Wait for hdr function finished")
    kstr = KString(str)
    pkstr = convert(Ptr{KString}, pointer_from_objref(kstr))
    handle = sios.handle
    phdr = sios.phdr
    prec = sios.precord
    sam_parse1(pkstr, phdr, prec)
    sam_write1(handle,phdr,prec)
end

@doc """ write all the records in strs to a SamIOStream
""" ->
function writelines(sios::SamIOStream, strs::Array{ASCIIString,1})
    sam_hdr_write(sios.handle,sios.phdr)
    for str in strs
        writeline(sios, str)
    end
end

@doc """ close a SamIOStream
""" ->
function close(sios::SamIOStream)
    bam_destroy1(sios.precord)
#    bam_hdr_destroy(sios.phdr) # not yet to find why freed already
    sam_close(sios.handle)
end
