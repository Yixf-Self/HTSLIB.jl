abstract BamIO <: IO
type BamIOS <: BamIO
    bgzf::Ptr{BGZF}
    h::Ptr{Bam_hdr_t}
    b::Ptr{Bam1_t}
    kstr::Ptr{KStr}
    end_bam::Bool
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
    end_bam = bgzf_eof(bgzf)

    kstr = get_pointer(KStr())
    BamIOS(bgzf, h, b, kstr, end_bam)
end

function close(bios::BamIOS)
    bgzf_destroy1(bios.bam1)
    bgzf_close(bios.bgzf)
end

function readline(bios::BamIOS)
    bam_read1!(bios.bgzf, bios.b)
    sam_format1!(bios.h, bios.b, bios.kstr)
    str = kstrToASCII(bios.kstr)
    split(str,"\t")
end

function test()
    bios = bam_open("/home/guo/haplox/private/DarkVC/data/test_Bams/test2.bam","rb")
    i = 0
    while i< 150
        line = readline(bios)
        @show line
        i+=1
    end
end
