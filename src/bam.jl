
# what is the difference between Ref{Cint} and Ptr{Cint}

type BinQualLqname
    bin::UInt16
    qual::UInt8
    l_qname::UInt8
end

type FlagNCigar
    flag::UInt16
    n_cigar::UInt16
end

type Bam1_core_t
    tid::Int32
    pos::Int32
    bin_qual_lqname::BinQualLqname
    #bin::UInt16
    #qual::UInt8
    #l_qname::UInt8
    flag_ncigar::FlagNCigar
#   flag::UInt16
#   n_cigar::UInt16
    l_qseq::Int32
    mtid::Int32
    mpos::Int32
    isize::Int32
end

type Bam1_t
    core::Ptr{Bam1_core_t}
    l_data::Int32
    m_data::Int32
    data::Ptr{Cuchar}#Ref{UInt8}
    id::UInt64
end

type Bins
    n::Cint
    m::Cint
    a::Ptr{Cint}
end

typealias bins Bins

type hts_itr_t
    
end
type hts_idx_t
end
type KString
    l::Csize_t
    m::Csize_t
    s::Ptr{Char}
end
type BGZF
    
end
type Cram_fd

end
type HFile

end

type samFile
    dummy5::UInt32
    lineno::Int64
    line::KString
    fn::Ptr{Cchar}
    fn_aux::Ptr{Cchar}
    fp
    format
end

type bam_hdr_t
end


function sam_open(fn,mode)
    ccall((:hts_open,"libhts"),Ptr{Void},(Cstring,Cstring),fn,mode)
end
function sam_hdr_read(samFile)
    ccall((:sam_hdr_read,"libhts"),Ptr{Void},(Ptr{Void},),samFile)
end
function sam_index_load()
end
function sam_itr_querys()

end
function bam_init1()
    ccall((:bam_init1,"libhts"), Ptr{Bam1_t}, ())
end
function sam_read1!(samfile,bamheader,b)
    record = ccall((:sam_read1,"libhts"),Cint,(Ptr{Void},Ptr{Void},Ptr{Bam1_t}),samfile,bamheader,b)
#    re = unsafe_load(record)

end

function sam_itr_next()

end

function hts_itr_destroy()

end
function bam_destroy1()

end
function bam_hdr_destroy()
end
function sam_close()
    
end
