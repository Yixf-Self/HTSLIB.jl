### BAM APIs

### bam header
function bam_hdr_init()
    @fncall(:bam_hdr_init, Ptr{Bam_hdr_t},())
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
    @fncall(:bam_init1, Ptr{Bam1_t},())
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

function bam_itr_destroy(iter::Ptr{Hts_itr_t})
    @fncall(:hts_itr_destroy,Void,(Ptr{Hts_itr_t},), iter)
end

function bam_itr_queryi(idx::Ptr{Hts_idx_t},tid::Cint,bg::Cint,ed::Cint)
    @fncall(:sam_itr_queryi, Ptr{Hts_itr_t}, (Ptr{Hts_idx_t}, Cint, Cint, Cint), idx, tid, bg, ed)
end

function bam_itr_querys(idx::Ptr{Hts_idx_t}, hdr::Ptr{Bam_hdr_t}, region::Ptr{Cchar})
    @fncall(:sam_itr_querys, Ptr{HTs_itr_t}, (Ptr{Hts_idx_t},Ptr{Bam_hdr_t},Ptr{Cchar}), idx, hdr, region)
end

function bam_itr_next(htsfp::Ptr{Htsfile}, itr::Ptr{Hts_itr_t}, r::Ptr{Void})
    bgzf = unsafe_load(unsafe_load(htsfp).fp).bgzf
    @fncall(:hts_itr_next, Cint, (Ptr{BGZF}, Ptr{Hts_itr_t}, Ptr{Void}, Ptr{Void}), bgzf, itr, r, C_NULL)
end

function sam_index_load(fp::Ptr{HtsFile}, fn::Ptr{Cchar})
    @fncall(:sam_index_load, Ptr{Hts_idx_t}, (Ptr{HtsFile}, Ptr{Cchar}), fp, fn)
end

function sam_index_load2(fp::Ptr{HtsFile}, fn::Ptr{Cchar}, fnidx::Ptr{Cchar})
    @fncall(:sam_index_load2, Ptr{Hts_idx_t}, (Ptr{HtsFile}, Ptr{Cchar}, Ptr{Cchar}), fp, fn, fnidx)
end

function sam_index_build(fn::Ptr{Cchar}, min_shift::Cint)
    @fncall(:sam_index_build, Cint, (Ptr{Cchar}, Cint), fn, min_shift)
end

function sam_index_build2(fn::Ptr{Cchar}, fnidx::Ptr{Cchar}, min_shift::Cint)
    @fncall(:sam_index_build2, Cint, (Ptr{Cchar}, Ptr{Cchar}, Cint), fn, fnidx, min_shift)
end

function sam_itr_destroy(iter)
    bam_itr_destroy(iter)
end

function sam_itr_queryi(idx::Ptr{Hts_idx_t}, tid::Cint, bg::Cint, ed::Cint)
    @fncall(:sam_itr_queryi, Ptr{Hts_itr_t}, (Ptr{Hts_idx_t}, Cint, Cint, Cint), idx, tid, bg, ed)
end

function sam_itr_querys(idx::Ptr{Hts_idx_t},hdr::Ptr{Bam_hdr_t},region::Ptr{Cchar})
    @fncall(:sam_itr_querys, Ptr{Hts_itr_t}, (Ptr{Hts_idx_t}, Ptr{Bam_hdr_t}, Ptr{Cchar}), idx, hdr, region))
end

function sam_itr_next(htsfp::Ptr{HtsFile},itr::Ptr{Hts_itr_t},r::Cint)
    bam_itr_next(htsfp, itr, r)
end

function sam_open(fn::Ptr{Cchar}, mode::Ptr{Cchar})
    @fncall(:hts_open, Ptr{HtsFile}, Ptr{Cchar}, Ptr{Cchar}), fn, mode)
end

function sam_open_format(fn::Ptr{Cchar}, mode::Ptr{Cchar}, format::Ptr{Cchar})
    @fncall(:hts_open_format, Ptr{Cchar}, (Ptr{Char}),Ptr{Char},Ptr{Char}), fn, mode, format)
end

function sam_close(fp::Ptr{HtsFile})
    @fncall(:hts_close, Cint, (Ptr{HtsFile},), fp)
end

function sam_open_mode(mode::Ptr{Cchar}, fn::Ptr{Cchar}, format::Ptr{Char})
    @fncall(:sam_open_mode, Cint, (Ptr{Cchar},Ptr{Cchar},Ptr{Cchar}),mode,fn,format)
end

function sam_hdr_parse(l_text::Cint, text::Ptr{Cchar})
    @fncall(:sam_hdr_parse, Ptr{Bam_hdr_t},(Cint, Ptr{Char}), l_text, text)
end

function sam_hdr_read(fp::Ptr{SamFile})
    @fncall(:sam_hdr_read, Ptr{Bam_hdr_t}, (Ptr{SamFile},), fp)
end

function sam_hdr_write(fp::Ptr{SamFile}, h::Ptr{Bam_hdr_t})
    @fncall(:sam_hdr_write, Cint, (Ptr{SamFile}, Ptr{Bam_hdr_t}), fp, h)
end

function sam_parse1(s::Ptr{KStr}, h::Ptr{Bam_hdr_t}, b::Ptr{Bam1_t})
    @fncall(:sam_parse1, Cint, (Ptr{KStr}, Ptr{Bam_hdr_t}, Ptr{Bam1_t}), s, h, b)
end

function sam_format1!(h::Ptr{Bam_hdr_t}, b::Ptr{Bam1_t}, kstr::Ptr{KStr})
    @fncall(:sam_format1,Cint,(Ptr{Bam_hdr_t},Ptr{Bam1_t},Ptr{KStr}), h, b, kstr)
end

function sam_read1(fp::Ptr{SamFile}, h::Ptr{Bam_hdr_t}, b::Ptr{Bam1_t})
    @fncall(:sam_read1, Cint, (Ptr{SamFile}, Ptr{Bam_hdr_t}, Ptr{Bam1_t}), fp, h, b)
end

function sam_write1(fp::Ptr{SamFile}, h::Ptr{Bam_hdr_t}, b::Ptr{Bam1_t})
    @fncall(:sam_write1, Cint, (Ptr{SamFile}, Ptr{Bam_hdr_t}, Ptr{Bam1_t}), fp, h, b)
end

### Manipulating auxilary fields

function bam_aux_get(b::Ptr{Bam1_t})
    tag = Array{Cchar,1}(2)
    ptag = pointer(tag)
    @fncall(:bam_aux_get, Ptr{UInt8}, (Ptr{Bam1_t}, Ptr{Cchar}), b, ptag)
end

function bam_aux2i(s::Ptr{UInt8})
    @fncall(:bam_aux2i, Int32, (Ptr{UInt8},), s)
end

function bam_aux2f(s::Ptr{UInt8})
    @fncall(:bam_aux2f, Cdouble, (Ptr{UInt8},), s)
end

function bam_aux2A(s::Ptr{UInt8})
    @fncall(:bam_aux2A, Cchar, (Ptr{UInt8},), s)
end

function bam_aux2Z(s::Ptr{UInt8})
    @fncall(:bam_aux2Z, Ptr{Cchar}, (Ptr{UInt8},), s)
end

function bam_aux_append(b::Ptr{Bam1_t}, tag::Array{Cchar,1}, typ::Cchar, len::Cint, data::Ptr{UInt8})
    @assert length(tag) == 2
    ptag = pointer(tag)
    @fncall(:bam_aux_append, Void, (Ptr{Bam1_t}, Ptr{Cchar}, Cchar, Cint, Ptr{UInt8}), b, ptag, typ, len, data)
end

function bam_aux_del(b::Ptr{Bam1_t}, s::Ptr{UInt8})
    @fncall(:bam_aux_del, Cint, (Ptr{Bam1_t}, Ptr{UInt8}), b, s)
end

### Pileup and Mpileup
#typedef int (*bam_plp_auto_f)(void *data, bam1_t *b)

function bam_plp_init(func::Function, data::Ptr{Void} )
    @fncall(:bam_plp_init, Bam_plp_t, )
end


