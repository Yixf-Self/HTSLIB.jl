
@doc """ bgzf_open() return BGZF *  handle
""" ->
function bgzf_open(path::AbstractString, mode::AbstractString)
    ccall((:bgzf_open, "libhts"),Ptr{Void},(Cstring, Cstring), path, mode)
end

@doc """
""" ->
function bam_init1()
    ccall((:bam_init1,"libhts"), Ptr{Void}, ())
end

@doc """ bam read 
""" ->
function bam_read1(fp::Ptr{Void},b::Ptr{Void})
    ccall((:bam_read1, "libhts"), Int32, (Ptr{Void}, Ptr{Void}),fp,b)
end

@doc """ data flow
""" ->
function flow()
    fp = bgzf_open(BAM_FL, "r")
    b  = bam_init1()
    bam_read1(fp, b)
    
end
