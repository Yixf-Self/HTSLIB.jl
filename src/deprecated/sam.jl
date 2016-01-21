abstract Header

type BamHeader <: Header
    n_targets::Int32
    ignore_sam_err::Int32
    l_text::UInt32
    target_len::Array{UInt32,1}
    cigar_tab::Array{Int8,1}
    target_name::Array{ASCIIString,1}
    text::ASCIIString
    sdict::Ptr{Void}
end


@doc """ return  htsFile * file handle
""" ->
function sam_open(fn::AbstractString, mode::AbstractString)
    ccall((:hts_open,"libhts"),Ptr{Void},(Cstring,Cstring),fn,mode)
end
@doc """ not tested
""" ->
function sam_open_format(fn,mode,fmt)
    ccall((:hts_open_format,"libhts"),Ptr{Void},(Cstring,Cstring,Ptr{Void}),fn,mode,fmt)
end
@doc """ close sam file
         fp is htsFile * handle
         return  0 => successfully close file
""" ->
function sam_close(fp::Ptr{Void})
    ccall((:hts_close,"libhts"),Int32,(Ptr{Void},),fp)
end
function sam_open_mode(mode::AbstractString, fn::AbstractString, format::AbstractString)
    ccall((:sam_open_mode,"libhts"),Int32,(Cstring,Cstring,Cstring),mode,fn,format)
end
@doc """ bam_hdr_t *sam_htr_parse(int l_text, const char *text)
""" ->
function sam_hdr_parse(l_text::Int32,text::AbstractString)
    ccall((:sam_hdr_parse,"libhts"),Ptr{Void},(Int32,Cstring),l_text,text)
end
@doc """ bam_hdr_t *sam_hdr_read(samFile *fp)
""" ->
function sam_hdr_read(fp::Ptr{Void})
    ccall((:sam_hdr_read,"libhts"),Ptr{Void},(Ptr{Void},),fp)
end
@doc """ int sam_hdr_write(samFile *fp, const bam_hdr_t *h)
""" ->
function sam_hdr_write(fp,h)
    ccall((:sam_hdr_write,"libhts"),Int32,(Ptr{Void},Ptr{Void}),fp,h)
end
@doc """ int sam_parse1(kstring_t *s, bam_hdr_t *h, bam1_t *b)
""" ->
function sam_parse1(s,h,b)
    ccall((:sam_parse1,"libhts"),Int32,(Ptr{Void},Pr{Void},Ptr{Void}),s,h,b)
end
@doc """ int sam_format1(const bam_hdr_t *h, const bam1_t *b, kstring_t *str)
""" ->
function sam_format1(h,b,str)
    ccall((:sam_format1,"libhts"),Int32,(Ptr{Void},Ptr{Void},Ptr{Void}),h,b,str)
end
@doc """ int sam_read1(samFile *fp, bam_hdr_t *h, bam_1 *b)
""" ->
function sam_read1(fp, h, b)
    ccall((:sam_read1, "libhts"),Int32,(Ptr{Void},Ptr{Void},Ptr{Void}),fp,h,b)
end
@doc """ int sam_write1(samFile *fp,const bam_hdr_t *h, const bam1_t *b)
""" ->
function sam_write1(fp,h,b)
    ccall((:sam_write1,"libhts"),Int32, (Ptr{Void},Ptr{Void},Ptr{Void}),fp,h,b)
end

@doc """ sam file read and write test 
""" ->
function dataflow()
    fp = sam_open(SAM_FL,"r")
    sam_close(fp)
end
