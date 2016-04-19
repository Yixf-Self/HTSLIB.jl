
### bam header
function bam_hdr_init()
    @fncall(:bam_hdr_init, Ptr{Bam_hdr_t})
end

function bam_hdr_read(fp::Ptr{BGZF})
    @fncall(:bam_hdr_read,Ptr{Bam_hdr_t},(Ptr{BGZF},),fp)
end

function bam_hdr_write(fp::Ptr{BGZF}, h::Ptr{Bam_hdr_t})
    @fncall(:bam_hdr_write, Int32, (Ptr{BGZF}, Ptr{Bam_hdr_t}), fp, h)
end

function bam_hdr_destroy(h::Ptr{Bam_hdr_t})
    @fncall(:bam_hdr_destroy, Void, (Ptr{Bam_hdr_t},), h)
end

function bam_name2id(h::Ptr{Bam_hdr_t}, ref::Ptr{Char})
    @fncall(:bam_name2id, Int32, (Ptr{Bam_hdr_t},Ptr{Char}), h, ref)
end

function bam_hdr_dup(h0::Ptr{Bam_hdr_t})
    @fncall(:bam_hdr_dup, Ptr{Bam_hdr_t}, (Ptr{Bam_hdr_t},), h0)
end

### bgzf

function bgzf_is_bgzf(fn::Ptr{Cchar})
    flag = @fncall(:bgzf_is_bgzf, Int32, (Ptr{Cchar},), fn)
    if flag == 0
        error("fn is not BGZF, OR I/O error")
    end
    true
end

function bgzf_open(path::Ptr{Cchar}, mode::Ptr{Cchar})
    @fncall(:bgzf_open, Ptr{BGZF}, (Ptr{Cchar},Ptr{Cchar}), path, mode)
end

function bgzf_close(fp::Ptr{BGZF})
    @fncall(:bgzf_close, Int32, (Ptr{BGZF},), fp)
end

function bgzf_eof(fp::Ptr{BGZF})
    error("return flag error")
    flag = @fncall(:bgzf_check_EOF, Int32, (Ptr{BGZF},), fp)
    info("bgzf_eof $flag")
    if flag == 2
        error("bgzf isn't seekable")
    end
    if flag == -1
        error("on error")
    end
    if flag == 0
        return false
    end
    if flag == 1
        return true
    end
end

function bgzf_getline!(fp::Ptr{BGZF}, delim::Int32, str::Ptr{KStr})
    @fncall(:bgzf_getline, Int32, (Ptr{BGZF}, Int32, Ptr{KStr}), fp, delim, str)
end

### bam records
function bam_init1()
    @fncall(:bam_init1, Ptr{Bam1_t})
end

function bam_destroy1(b::Ptr{Bam1_t})
    @fncall(:bam_destroy1, Void, (Ptr{Bam1_t},), b)
end

function bam_read1!(fp::Ptr{BGZF},b::Ptr{Bam1_t})
    @fncall(:bam_read1, Int32, (Ptr{BGZF},Ptr{Bam1_t}), fp, b)
end

function bam_write1(fp::Ptr{BGZF},b::Ptr{Bam1_t})
    @fncall(:bam_write1, Int32, (Ptr{BGZF},Ptr{Bam1_t}), fp, b)
end

function bam_copy1(bdst::Ptr{Bam1_t}, bsrc::Ptr{Bam1_t})
    @fncall(:bam_copy1, Ptr{Bam1_t}, (Ptr{Bam1_t},Ptr{Bam1_t}), bdst, bsrc)
end

function bam_dup1(bsrc::Ptr{Bam1_t})
    @fncall(:bam_dup1, Ptr{Bam1_t},(Ptr{Bam1_t},),bsrc)
end

function bam_cigar2qlen(n_cigar::Int32, cigar::Ptr{UInt32})
    @fncall(:bam_cigar2qlen, Int32, (Int32, Ptr{UInt32}), n_cigar,cigar)
end

function bam_cigar2rlen(n_cigar::Int32, cigar::Ptr{UInt32})
    @fncall(:bam_cigar2rlen, Int32, (Int32, Ptr{UInt32}), n_cigar,cigar)
end

function bam_endpos(b::Ptr{Bam1_t})
    @fncall(:bam_endpos, Int32, (Ptr{Bam1_t},), b)
end

function bam_str2flag(str::Ptr{Cchar})
    @fncall(:bam_str2flag, Int32, (Ptr{Cchar},), str)
end

function bam_flag2str(flag::Int32)
    @fncall(:bam_flag2str, Ptr{Cchar}, (Int32,), flag)
end

function bam_itr_destroy(iter)
#    @fncall(:hts_itr_destroy,)
end

function bam_itr_queryi()
end

function bam_itr_querys()
end

function bam_itr_next()
end

# hts_idx_t
#function sam_index_load()
#    @fncall(:sam_index_load, )
#end

### sam file
function sam_format1!(h::Ptr{Bam_hdr_t}, b::Ptr{Bam1_t}, kstr::Ptr{KStr})
    @fncall(:sam_format1,Cint,(Ptr{Bam_hdr_t},Ptr{Bam1_t},Ptr{KStr}), h, b, kstr)
end
