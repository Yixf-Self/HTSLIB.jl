module HTSLIB

const libhts = Libdl.find_library(["libhts.so"],[joinpath(dirname(dirname(@__FILE__)),"deps/usr/lib")])

include("bam/bam.jl")
include("user/bam.jl")
include("user/sam.jl")
include("user/query.jl")
include("utils/utils.jl")

end
