type BGZF
    box::Int32
    cache_size::Int32
    block_length::Int32
    block_offset::Int32
    block_address::Int64
    uncompressed_address::Int64
    uncompressed_block::Ptr{Void}
    compressed_block::Ptr{Void}
    cache::Ptr{Void}
    fp::Ptr{Void}
    mt::Ptr{Void}
    idx::Ptr{Void}
    idx_build_otf::Int32
    gz_stream::Ptr{Void}
end

type Bam_hdr_t
    n_targets::Int32
    ignore_sam_err::Int32
    l_text::UInt32
    target_len::UInt32
    cigar_tab::Ptr{Int8}
    target_name::Ptr{Ptr{Char}}
    text::Ptr{Char}
    sdict::Ptr{Void}
end

type Bam1_core_t
    tid::Int32
    pos::Int32
    box1::UInt32
    box2::UInt32
    l_qseq::Int32
    mtid::Int32
    mpos::Int32
    isize::Int32
end


type Bam1_t
    core::Bam1_core_t
    l_data::Int32
    m_data::Int32
    data::Ptr{UInt8}
    id::UInt64
end

type KStr
    l::Csize_t
    m::Csize_t
    s::Ptr{Cchar}
end

function get_ptr_of_null_kstr(num::Int64)
    @fncall(:get_ptr_of_kstr, Ptr{KStr}, (Int64,), num)
end

function kstrToASCII(kstr::KStr)
    strptr(kstr.s, 1, kstr.l)
end

function kstrToASCII(pkstr::Ptr{KStr})
    kstr = unsafe_load(pkstr)
    kstrToASCII(kstr)
end
