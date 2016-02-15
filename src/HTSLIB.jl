module HTSLIB

const libhts = Libdl.find_library(["libhts.so"],[joinpath(Pkg.dir("HTSLIB"),"deps/usr/lib")])



include("utils/utils.jl")
include("bam/bam.jl")
include("user/bam.jl")
include("user/sam.jl")
include("user/query.jl")

end
