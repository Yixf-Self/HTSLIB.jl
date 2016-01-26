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

function bam_hdr_init()
    #return bam_hdr_t *
    ccall((:bam_hdr_init,"libhts"),Ptr{Void},())
end
@doc """ input: BGZF *fp
         output: bam_hdr_t*
""" ->
function bam_hdr_read(bam_hdl::Ptr{Void})
    ccall((:sam_hdr_read,"libhts"),Ptr{Void},(Ptr{Void},),bam_hdl)
end
@doc """ input:  BGZF *fp
                 const bam_hdr_t *h
         output: int
""" ->
function bam_hdr_write(fp,h)
    ccall((:bam_hdr_write,"libhts"),Cint,(Ptr{Void},Ptr{Void}),fp,h)
end
@doc """ void bam_hdr_destroy(bam_hdr_t *h)
""" ->
function bam_hdr_destroy(h)
    ccall((:bam_hdr_destroy,"libhts"),Void,(Ptr{Void},),h)
end
@doc """ int bam_name2id(bam_hdr_t *h,const char*ref)
""" ->
function bam_name2id(h::Ptr{Void},ref::Ptr{Cchar})
    ccall((:bam_name2id,"libhts"),Cint,(Ptr{Void},Ptr{Cchar}),h,ref)
end
@doc """ bam_hdr_t* bam_hdr_dup(const bam_hdr_t *h0)
""" ->
function bam_hdr_dup(h0)
    ccall((:bam_hdr_dup,"libhts"),Ptr{Void},(Ptr{Void},),h0)
end
@doc """ bam1_t* bam_init1(void)
""" ->
function bam_init()
    ccall((:bam_init1,"libhts"),Ptr{Record},())
end
@doc """ void bam_destroy1(bam1_t *b)
""" ->
function bam_destroy1(b::Ptr{Record})
    ccall((:bam_destroy1,"libhts"),Void,(Ptr{Record},),b)
end
@doc """ int bam_read1(BGZF *fp, bam1_t *b)
""" ->
function bam_read(fp,b)
    ccall((:bam_read1,"libhts"),Cint,(Ptr{Void},Ptr{Record}),fp,b)
end
@doc """ int bam_write1(BGZF *fp, const bam1_t *b)
""" ->
function bam_write(fp,b)
    ccall((:bam_write,"libhts"),Cint,(Ptr{Void},Ptr{Record},fp,b))
end
@doc """ bam1_t *bam_copy1(bam1_t *bdst, const bam1_t *bsrc)
""" ->
function bam_copy(bdst,bsrc)
    ccall((:bam_copy1,"libhts"),Ptr{Record},(Ptr{Record},Ptr{Record}),bdst,bsrc)
end
@doc """ bam1_t *bam_dup1(const bam1_t *bsrc)
""" ->
function bam_dup(bsrc)
    ccall((:bam_dup1,"libhts"),Ptr{Record},(Ptr{Record},),bsrc)
end
@doc """ int bam_cigar2qlen(int n_cigar, const uint32_t *cigar)
""" ->
function bam_cigar2qlen(n_cigar::Cint,cigar::Ptr{UInt32})
    ccall((:bam_cigar2qlen,"libhts"),Ptr{Record},(Cint,Ptr{UInt32}),n_cigar,cigar)
end
@doc """ int bam_cigar2rlen(int n_cigar, const uint32_t *cigar)
""" ->
function bam_cigar2rlen(n_cigar::Cint,cigar::Ptr{UInt32})
    ccall((:bam_cigar2rlen,"libhts"),Ptr{Record},(Cint,Ptr{UInt32}),n_cigar,cigar)
end
@doc """ int32_t bam_endpos(const bam1_t *b)
""" ->
function bam_endpos(b)
    ccall((:bam_endpos,"libhts"),Int32,(Ptr{Record},),b)
end
@doc """ int bam_str2flag(const char *str)
""" ->
function bam_str2flag(str::Ptr{Cchar})
    ccall((:bam_str2flag,"libhts"),Cint,(Ptr{Cchar},),str)
end
@doc """ char *bam_flag2str(int flag)
""" ->
function bam_flag2str(flag::Cint)
    ccall((:bam_flag2str,"libhts"),Ptr{Cchar},(Cint,),flag)
end

##############################################
###      BAM/CRAM indexing                 ###
##############################################
#=
    // These BAM iterator functions work only on BAM files.  To work with either
    // BAM or CRAM files use the sam_index_load() & sam_itr_*() functions.
    #define bam_itr_destroy(iter) hts_itr_destroy(iter)
    #define bam_itr_queryi(idx, tid, beg, end) sam_itr_queryi(idx, tid, beg, end)
    #define bam_itr_querys(idx, hdr, region) sam_itr_querys(idx, hdr, region)
    #define bam_itr_next(htsfp, itr, r) hts_itr_next((htsfp)->fp.bgzf, (itr), (r), 0)
=#
@doc """ #define bam_itr_destroy(iter) hts_itr_destroy(iter)
         void hts_itr_destroy(hts_itr_t *iter)
""" ->
function bam_itr_destroy(iter) 
    ccall((:hts_itr_destroy,"libhts"),Void,(Ptr{Void},),iter)
end

@doc """ #define bam_itr_queryi(idx, tid, beg, end) sam_itr_queryi(idx, tid, beg, end)
         hts_itr_t *sam_itr_queryi(const hts_idx_t *idx, int tid, int beg, int end)
""" ->
function bam_itr_queryi(idx::Ptr{Void}, tid::Cint, beg::Cint, ed::Cint)
    ccall((:sam_itr_queryi,"libhts"), (idx, tid, beg, ed))
end
@doc """ #define bam_itr_querys(idx, hdr, region) sam_itr_querys(idx, hdr, region)
         hts_itr_t *sam_itr_querys(const hts_idx_t *idx, bam_hdr_t *hdr, const char *region)
""" ->
function bam_itr_querys(idx, hdr, region::Ptr{Cchar})
    ccall((:sam_itr_querys,"libhts"),Ptr{Void},(Ptr{Void},Ptr{Void},Ptr{Cchar}),idx, hdr, region)
end

@doc """ #define bam_itr_next(htsfp, itr, r) hts_itr_next((htsfp)->fp.bgzf, (itr), (r), 0)
         int hts_itr_next(BGZF *fp, hts_itr_t *iter, void *r, void *data)
""" ->
function bam_itr_next(bgzf, itr, r)
    ccall((:hts_itr_next,"libhts"),Cint,(Ptr{Void},Ptr{Void},Ptr{Void},Ptr{Void}),bgzf, itr, r, C_NULL)
end

@doc """
// Load/build .csi or .bai BAM index file.  Does not work with CRAM.
// It is recommended to use the sam_index_* functions below instead.
#define bam_index_load(fn) hts_idx_load((fn), HTS_FMT_BAI)
hts_idx_t *hts_idx_load(const char *fn, int fmt);
""" ->
function bam_index_load(fn)
    ccall((:hts_idx_load,"libhts"),Ptr{Void},(Ptr{Cchar},Cint),fn,1)
end

@doc """
// Load/build .csi or .bai BAM index file.  Does not work with CRAM.
// It is recommended to use the sam_index_* functions below instead.
#define bam_index_build(fn, min_shift) (sam_index_build((fn), (min_shift)))
int sam_index_build(const char *fn, int min_shift)
""" ->
function bam_index_build(fn, min_shift)
    ccall((:sam_index_build,"libhts"),Cint,(Ptr{Cchar},Cint),fn,min_shift)
end

@doc """
/// Load a BAM (.csi or .bai) or CRAM (.crai) index file
/** @param fp  File handle of the data file whose index is being opened
    @param fn  BAM/CRAM/etc filename to search alongside for the index file
    @return  The index, or NULL if an error occurred.
*/
hts_idx_t *sam_index_load(htsFile *fp, const char *fn);
""" ->
function sam_index_load(htsFile *fp, const char *fn)
    ccall((:sam_index_load,"libhts"),Ptr{Void},(Ptr{Void},Ptr{Cchar}),fp,fn)
end

@doc """
/// Load a specific BAM (.csi or .bai) or CRAM (.crai) index file
/** @param fp     File handle of the data file whose index is being opened
    @param fn     BAM/CRAM/etc data file filename
    @param fnidx  Index filename, or NULL to search alongside @a fn
    @return  The index, or NULL if an error occurred.
*/
hts_idx_t *sam_index_load2(htsFile *fp, const char *fn, const char *fnidx);
""" ->
function sam_index_load2(fp, fn::Ptr{Cchar}, fnidx::Ptr{Cchar});
    ccall((:sam_index_load2,"libhts"), Ptr{Void},(Ptr{Void},Ptr{Cchar},Ptr{Cchar}),fp,fn,fnidx)
end
@doc """
/// Generate and save an index file
/** @param fn        Input BAM/etc filename, to which .csi/etc will be added
    @param min_shift Positive to generate CSI, or 0 to generate BAI
    @return  0 if successful, or negative if an error occurred (usually -1; or
             -2: opening fn failed; -3: format not indexable)
*/
int sam_index_build(const char *fn, int min_shift);
""" ->
function sam_index_build(fn::Ptr{Cchar}, min_shift::Cint);
    ccall((:sam_index_build,"libhts"),Cint,(Ptr{Cchar},Cint),fn,  min_shift)
end
@doc """
/// Generate and save an index to a specific file
/** @param fn        Input BAM/CRAM/etc filename
    @param fnidx     Output filename, or NULL to add .bai/.csi/etc to @a fn
    @param min_shift Positive to generate CSI, or 0 to generate BAI
    @return  0 if successful, or negative if an error occurred.
*/
int sam_index_build2(const char *fn, const char *fnidx, int min_shift);
""" ->
function sam_index_build2(fn::Ptr{Cchar}, fnidx::Ptr{Cchar}, min_shift::Cint)
    ccall((:sam_index_build2,"libhts"),Cint,(Ptr{Cchar},Ptr{Cchar},Cint),fn, fnidx, min_shift)
end
@doc """
    #define sam_itr_destroy(iter) hts_itr_destroy(iter)
    void hts_itr_destroy(hts_itr_t *iter)
""" ->
function sam_itr_destroy(iter)
    ccall((:hts_itr_destroy,"libhts"),Void,(Ptr{Void},),iter)
end

@doc """    hts_itr_t *sam_itr_queryi(const hts_idx_t *idx, int tid, int beg, int end);
""" ->
function sam_itr_queryi(idx, tid, beg, ed);
    ccall((:sam_itr_queryi,"libhts"),Ptr{Void},(Ptr{Void},Cint,Cint,Cint), idx, tid, beg, ed)
end
@doc """
    hts_itr_t *sam_itr_querys(const hts_idx_t *idx, bam_hdr_t *hdr, const char *region);
""" ->
function sam_itr_querys(idx, hdr, region::Ptr{Cchar})
    ccall((:sam_itr_querys,"libhts"),Ptr{Void},(Ptr{Void},Ptr{Void},Ptr{Cchar}),idx, hdr, region)
end
@doc """
    #define sam_itr_next(htsfp, itr, r) hts_itr_next((htsfp)->fp.bgzf, (itr), (r), (htsfp))
    int hts_itr_next(BGZF *fp, hts_itr_t *iter, void *r, void *data)
""" ->
function sam_itr_next(bgzf, itr, r)
    ccall((:hts_itr_next,"libhts"),Cint,(Ptr{Void},Ptr{Void},Ptr{Void},Ptr{Void}),bgzf,itr,r,htsfp)
end

#=
    /***************
     *** SAM I/O ***
     ***************/
=#
@doc """
    #define sam_open(fn, mode) (hts_open((fn), (mode)))
    htsFile *hts_open(const char *fn, const char *mode)        
""" ->
function sam_open(fn::Ptr{Cchar}, mode::Ptr{Cchar})
    ccall((:hts_open,"libhts"),Ptr{Void},(Ptr{Cchar},Ptr{Cchar}),fn, mode)
end
@doc """
    #define sam_open_format(fn, mode, fmt) (hts_open_format((fn), (mode), (fmt)))
    htsFile *hts_open_format(const char *fn, const char *mode, const htsFormat *fmt);        
""" ->
function sam_open_format(fn::Ptr{Cchar}, mode::Ptr{Cchar}, fmt)
    ccall((:hts_open_format,"libhts"),Ptr{Void},(Ptr{Cchar},Ptr{Cchar},Ptr{Void}),fn, mode, fmt)
end
@doc """
    #define sam_close(fp) hts_close(fp)
    int hts_close(htsFile *fp)    
""" ->
function sam_close(fp)
    ccall((:hts_close,"libhts"),Cint,(Ptr{Void},),fp)
end
@doc """
    int sam_open_mode(char *mode, const char *fn, const char *format);
""" ->
function sam_open_mode(mode::Ptr{Cchar}, fn::Ptr{Cchar}, format::Ptr{Cchar});
    ccall((:sam_open_mode,"libhts"),Cint,(Ptr{Cchar},Ptr{Cchar},Ptr{Cchar}), mode, fn, format)
end
@doc """
    // A version of sam_open_mode that can handle ,key=value options.
    // The format string is allocated and returned, to be freed by the caller.
    // Prefix should be "r" or "w",
    char *sam_open_mode_opts(const char *fn,
                             const char *mode,
                             const char *format);
""" ->
function sam_open_mode_opts(fn::Ptr{Cchar},mode::Ptr{Cchar},format::Ptr{Cchar})
    ccall((:sam_open_mode_opts,"libhts"),Ptr{Cchar},(Ptr{Cchar},Ptr{Cchar},Ptr{Cchar}),fn,mode,format)
end

#    typedef htsFile samFile;
@doc """
    bam_hdr_t *sam_hdr_parse(int l_text, const char *text);
""" ->
function sam_hdr_parse(l_text::Cint, text::Ptr{Cchar})
    ccall((:sam_hdr_parse,"libhts"),Ptr{Void},(Cint,Ptr{Cchar}),l_text,text)
end
@doc """
    bam_hdr_t *sam_hdr_read(samFile *fp);
""" ->
function sam_hdr_read(fp::Ptr{Void})
    ccall((:sam_hdr_read,"libhts"),Ptr{Void},(Ptr{Void},),fp)
end
@doc """
    int sam_hdr_write(samFile *fp, const bam_hdr_t *h);
""" ->
function sam_hdr_write(fp::Ptr{Void}, h::Ptr{Void})
    ccall((:sam_hdr_write,"libhts"),Cint,(Ptr{Void},Ptr{Void}), fp,h)
end
@doc """
    int sam_parse1(kstring_t *s, bam_hdr_t *h, bam1_t *b);
""" ->
function sam_parse1(s::Ptr{KString}, h::Ptr{Void}, b::Ptr{Record})
    ccall((:sam_parse1,"libhts"),Cint,(Ptr{KString},Ptr{Void},Ptr{Record}), s, h, b)
end
@doc """
        int sam_format1(const bam_hdr_t *h, const bam1_t *b, kstring_t *str);
""" ->
function sam_format1(h::Ptr{Void}, b::Ptr{Record}, str::Ptr{KString})
    ccall((:sam_format1,"libhts"),Cint,(Ptr{Void},Ptr{Record},Ptr{KString}), h, b, str)
end
@doc """
    int sam_read1(samFile *fp, bam_hdr_t *h, bam1_t *b);
""" ->
function sam_read1(fp, h, b::Ptr{Record})
    ccall((:sam_read1,"libhts"),Cint,(Ptr{Void},Ptr{Void},Ptr{Record}), fp, h,b)
end
@doc """
    int sam_write1(samFile *fp, const bam_hdr_t *h, const bam1_t *b);
""" ->
function sam_write1(fp, h, b::Ptr{Record})
    ccall((:sam_write1,"libhts"),Cint,(Ptr{Void},Ptr{Void},Ptr{Record}),fp, h, b)
end

#=
    /*************************************
     *** Manipulating auxiliary fields ***
     *************************************/
=#
@doc """
    uint8_t *bam_aux_get(const bam1_t *b, const char tag[2]);
""" ->
function bam_aux_get(b,tag::Ptr{Cchar})
    ccall((:bam_aux_get,"libhts"),UInt8,(Ptr{Void},Ptr{Cchar}), b, tag)
end
@doc """
    int32_t bam_aux2i(const uint8_t *s);
""" ->
function bam_aux2i(s::Ptr{UInt8})
    ccall((:bam_aux2i,"libhts"),Int32,(Ptr{UInt8},),s)
end
@doc """
    double bam_aux2f(const uint8_t *s);
""" ->
function bam_aux2f(s::Ptr{UInt8})
    ccall((:bam_aux2f,"libhts"),Cdouble,(Ptr{UInt8},),s)
end
@doc """
    char bam_aux2A(const uint8_t *s);
""" ->
function bam_aux2A(s::Ptr{UInt8})
    ccall((:bam_aux2A,"libhts"),Cchar,(Ptr{UInt8},),s)
end
@doc """
    char *bam_aux2Z(const uint8_t *s);
""" ->
function bam_aux2Z(s::Ptr{UInt8})
    ccall((:bam_aux2Z,"libhts"),Ptr{Cchar},(Ptr{UInt8},),s)
end
@doc """
    void bam_aux_append(bam1_t *b, const char tag[2], char type, int len, uint8_t *data);
""" ->
function bam_aux_append(b::Ptr{Record}, tag::Ptr{Cchar}, tp::Cchar, len::Cint, data::Ptr{UInt8})
    warn("Not sure how to deal with char tag[2]")
    ccall((:bam_aux_append,"libhts"),Void,(Ptr{Record},Ptr{Char},Cchar,Cint,UInt8), b, tag, tp, len, data)
end
@doc """
    int bam_aux_del(bam1_t *b, uint8_t *s);
""" ->
function bam_aux_del(b::Ptr{Record}, s::Ptr{UInt8})
    ccall((:bam_aux_del,"libhts"),Cint,(Ptr{Record},Ptr{UInt8}),b, s);))
end

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

function sam_read!(bam_hdl::Ptr{Void},bam_hdr_hdl::Ptr{Void},b::Ptr{Record})
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

function bam_write()
end
