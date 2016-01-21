module HTSLIB

# package code goes here

export sam_open,
       sam_close


include("sam.jl")
include("bam.jl")


end # module
