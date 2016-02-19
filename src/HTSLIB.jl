module HTSLIB

using Logging
@Logging.configure(level=DEBUG)

@linux_only const libhts = "libhts.so" #Libdl.find_library(["libhts.so"],[joinpath(dirname(dirname(@__FILE__)),"deps/usr/lib")])
@osx_only const libhts = Libdl.find_library(["libhts.dylib"],[joinpath(dirname(dirname(@__FILE__)),"deps/usr/lib")])

import Base.open

export open,sam_open,bam_open

include("bam/bam.jl")
include("user/bam.jl")
include("user/sam.jl")
include("user/query.jl")
include("utils/utils.jl")

end
