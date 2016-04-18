abstract BamIO <: IO

type BamIOS <: BamIO
    bgzf::Ptr{BGZF}
    h::Ptr{Bam_hdr_t}
    b::Ptr{Bam1_t}
    kstr::Ptr{KStr}
end

function bam_open{T<:DirectIndexString}(path::T, mode::Union{ASCIIString,Char})
    @assert isfile(path)
    bai_path = string(path,".bai")
    @assert isfile(bai_path)

    ppath = get_pointer(path)
    pmode = get_pointer(mode)
    bgzf_is_bgzf(ppath)
    bgzf = bgzf_open(ppath, pmode)
    h = bam_hdr_read(bgzf)
    b = bam_init1()
    
    kstr = get_pointer(KStr())
    BamIOS(bgzf, h, b, kstr)
end

function eof(bios::BamIOS)
    bgzf_eof(bios.bgzf)
end

function close(bios::BamIOS)
    bam_hdr_destroy(bios.h)
    bam_destroy1(bios.b)
    bgzf_close(bios.bgzf)
end

function readline(bios::BamIOS)
    bam_read1!(bios.bgzf, bios.b)
    sam_format1!(bios.h, bios.b, bios.kstr)
    str = kstrToASCII(bios.kstr)
    str = deepcopy(str)
    split(str,"\t")
end

function readlines(bios::BamIOS)
    @show bios
    i = 0
    while !eof(bios)
        i += 1
        i % 1000_000 == 0 && info(i)
        line = readline(bios)
        i % 1000_000 ==0 && println(line)
    end
end

function test_file(file)
    bios = bam_open(file,"rb")
    readlines(bios)
    close(bios)
end

function tests()
    test_file("/home/guo/haplox/private/DarkVC/data/test_Bams/test.bam")
    test_file("/home/guo/haplox/private/DarkVC/data/test_Bams/test2.bam")
end
