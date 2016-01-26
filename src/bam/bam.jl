immutable Record
    tid::Int32 # chromosome ID defined by bam_hdr_t
    pos::Int32 # 0-based leftmost coordinate
    bin::UInt16 # bin calculated by bam_reg2bin
    qual::UInt8 # mapping quality
    l_qname::UInt8 #length of the query name
    flag::UInt16 # bitwise flag
    n_cigar::UInt16 # number of CIGAR operations
    l_qseq::Int32 # length of the query sequence (read)
    mtid::Int32 # chrosome ID of next read in template
    mpos::Int32 # 0-based of next read in template, defined by bam_hdr_t
    isize::Int32 # ??? template length ???
    
    l_data::Int32 #current length of data
    m_data::Int32 # maximum length of data
    data::Ptr{Cuchar} # qname-cigar-seq-qual-aux how to load them all?
    id::UInt64   # BAM_ID ???
end

const cigarstring = "MIDNSHPX="
const seq_nt16_str = "=ACMGRSVTWYHKDBN"
const seq_nt16_table = UInt8[
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
     1, 2, 4, 8, 15,15,15,15, 15,15,15,15, 15, 0,15,15, #0 for "="
    15, 1,14, 2, 13,15,15, 4, 11,15,15,12, 15, 3,15,15,
    15,15, 5, 6,  8,15, 7, 9, 15,10,15,15, 15,15,15,15,
    15, 1,14, 2, 13,15,15, 4, 11,15,15,12, 15, 3,15,15,
    15,15, 5, 6,  8,15, 7, 9, 15,10,15,15, 15,15,15,15,

    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
    15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15
]



function bam_get_cigar(rec::Record)
    n_cigar = rec.n_cigar
    p = convert(Ptr{UInt32}, (rec.data + rec.l_qname))
    s = ""
    for i in 1:n_cigar
        tmp = unsafe_load(p,i)
        l4 = tmp & 0b1111
        h28 = tmp >> 4
        s = string(s,h28,cigarstring[l4+1])
    end
    s
end
function bam_seqi(s,i)
    (unsafe_load(s,(i-1)>>1+1) >> ((~(i-1)&1)<<2)) & 0xf
end
function bam_get_seq(rec::Record)
    pseq = rec.data + rec.n_cigar<<2 + rec.l_qname
    s = ""
    for i in 1:rec.l_qseq
        s =string(s, seq_nt16_str[bam_seqi(pseq, i)+1])
    end
    s
end
function bam_get_qual(rec::Record)
    len_qual = (rec.l_qseq+1)>>1
    p = rec.data + rec.n_cigar<<2 + rec.l_qname + (rec.l_qseq+1)>>1
    data = Array{UInt8,1}(len_qual)
    for i = 1:len_qual
        data[i] = unsafe_load(p,i) + 33
    end
    ASCIIString(data)
end
function bam_get_l_aux(rec::Record)
    p = rec.l_data - rec.n_cigar<<2 - rec.l_qname - rec.l_qseq - (rec.l_qseq + 1)>>1
end
function bam_get_aux(rec::Record)
    p = rec.data + rec.n_cigar<<2 + rec.l_qname + (rec.l_qseq+1)>>1 + rec.l_qseq
    len_aux = bam_get_l_aux(rec)
    data = Array{UInt8,1}(len_aux)
    for i = 1:len_aux
        data[i] = unsafe_load(p,i)
    end
    ASCIIString(data)
end

@doc """ Qname   Flag Chr Pos Mapq Cigar Rnext Pnext TLEN SEQ    QUAL AUX
         l_qname                   n_cigar                l_qseq l_qseq l_data-others 
""" ->
function show(io::IO, rec::Record)
    st_qname = 1
    ed_qname = Int64(rec.l_qname)
    qname = stringfrompointer(rec.data,1,ed_qname)
    print(io,qname,"\t")
    flag = Int64(rec.flag)
    print(io,flag,"\t")
    chr = rec.tid
    print(io,chr,"\t")
    pos = rec.pos+1
    print(io,pos,"\t")
    mapq = Int64(rec.qual)
    print(io,mapq,"\t")
    st_cigar = ed_qname + 1
    ed_cigar = st_cigar + rec.n_cigar
    cigar = bam_get_cigar(rec)
    print(io,cigar,"\t")
    rnext = rec.mtid
    print(io,rnext,"\t")
    pnext = rec.mpos + 1 
    print(io,pnext,"\t")
    tlen = rec.isize
    print(io,tlen,"\t")
    st_seq = ed_cigar + 1
    ed_seq = st_seq + rec.l_qseq
    seq = bam_get_seq(rec)
    print(io,seq,"\t")
    st_qual = ed_seq + 1
    ed_qual = st_qual + rec.l_qseq
    qual = bam_get_qual(rec)
    print(io,qual,"\t")
    st_aux = ed_qual + 1
    ed_aux = rec.l_data-1
    aux = bam_get_aux(rec)
    print(io,aux,"\n")
end
function bam_open{T<:AbstractString}(fn::T,mode::T)
    ccall((:hts_open,"libhts"),Ptr{Void},(Cstring,Cstring),fn,mode)
end
function bam_init()
    ccall((:bam_init1,"libhts"),Ptr{Record},())
end
function bam_read!(bam_hdl::Ptr{Void},bam_hdr_hdl::Ptr{Void},b::Ptr{Record})
    ccall((:sam_read1,"libhts"),Cint,(Ptr{Void},Ptr{Void},Ptr{Record}),bam_hdl,bam_hdr_hdl,b)
end

type KString
    l::Csize_t
    m::Csize_t
    s::Ptr{Cchar}
    function KString(l,m,s)
        new(l,m,s)
    end
end
function show(io::IO,ks::KString)
    data = Array{UInt8,1}(ks.l)
    for i = 1:ks.l
        data[i] = unsafe_load(ks.s,i)
    end
    print(io,ASCIIString(data))
end
function sam_format!(h::Ptr{Void},b::Ptr{Record},pstr::Ptr{KString})
    ccall((:sam_format1,"libhts"),Cint,(Ptr{Void},Ptr{Record},Ptr{KString}),h,b,pstr)
end
function sam_parse!(pks,h,b)
    ccall((:sam_parse1,"libhts"),Cint,(Ptr{KString},Ptr{Void},Ptr{Record}),pks,h,b)
end
function bam_write(out,h,b)
    error("Not implemented!")
end
function bam_close()
end
function bam_hdr_read(bam_hdl::Ptr{Void})
    ccall((:sam_hdr_read,"libhts"),Ptr{Void},(Ptr{Void},),bam_hdl)
end
function bam_write()
end
