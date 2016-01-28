
typealias SamIOStream BamIOStream

@doc """ sam file name must endwith bam
""" ->
function sam_open(fname::AbstractString, mode::AbstractString)
    split(fname,".")[end] == "sam" || info("file name doesn't endwith sam")
    
    sam_fl = hts_open(fname,mode)
    if mode == "r"
        phdr = sam_hdr_read(bam_fl) #header info
    else
        info("Not sure in sam_open")
        phdr = sam_hdr_init()
    end
    prec = bam_init1()
    kstr = KString(0,0,C_NULL)
    pkstr = convert(Ptr{KString}, pointer_from_objref(kstr))
    
    SamIOStream(fname,sam_fl,phdr,prec,pkstr)
end

function sam_hdr_read(sios::SamIOStream)
    sam_hdr_read(sios.handle)
end

function sam_hdr_parse(sios::SamIOStream)
    header = unsafe_load(sios.phdr)
    l_text = header.l_text
    text = header.text
    warn("sam_hdr_parse not sure its usage")
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
        sios.eof = true
    elseif ret == -1
        sios.eof = true
        #info("error occured in sam read ")
    end
    pkstr = sios.pkstr
    sam_format!(phdr,prec,pkstr)

    strptr(pkstr)
end

@doc """ eof(bios) -> Bool
         Tests whether an Bam I/O stream is at end-of-file.
""" ->
function eof(sios::SamIOStream)
    sios.eof
end

@doc """ read all the records from a bam file
""" ->
function readlines(fname::AbstractString)
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

@doc """ write a record to a SamIOStream
""" ->
function writeline(bios::SamIOStream, str::ASCIIString)
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
    #may be header need close but not find function now
    bam_destroy1(sios.precord)
    bam_hdr_destroy(sios.phdr)
    sam_close(sios.handle)
end
