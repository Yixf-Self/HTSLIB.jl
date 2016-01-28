module HTSLIB




export sam_open,
       sam_hdr_read,
       Bam1_t,bam_init1,
       sam_read1!



include("utils/utils.jl")
include("bam/bam.jl")
include("user/bam.jl")
include("user/sam.jl")

end
