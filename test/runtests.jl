src = "../src"
if !in(src,LOAD_PATH)
    push!(LOAD_PATH, src)
end
using HTSLIB
using Base.Test

include("sam.jl")
include("bam.jl")
