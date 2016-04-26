src = "../src"
if !in(src,LOAD_PATH)
    push!(LOAD_PATH, src)
end
using HTSLIB
using Base.Test

#=
include("bam.jl")
include("user/bam.jl")
include("user/header.jl")
include("user/sam.jl")
include("user/query.jl")
=#

bios = HTSLIB.bam_open("../data/100.bam","rb")

while !HTSLIB.eof(bios)
    line = HTSLIB.readline(bios)
    println(line)
end


HTSLIB.close(bios)
