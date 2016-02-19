src = "../src"
if !in(src,LOAD_PATH)
    push!(LOAD_PATH, src)
end
using HTSLIB
using Base.Test
using Logging
@Logging.configure(level=DEBUG)

bios = open("data/100.bam","rb","bam")
handle = bios.handle
@debug("handle is $handle")
phts = convert(Ptr{HTSLIB.HTSFile},handle)
@debug("phts is $phts")
htsfl  = unsafe_load(phts)
@show htsfl
@debug("htsFile fn is $(htsfl.fn)")
@show bytestring(htsfl.fn)

#=
for i=0:150
    pkstr = convert(Ptr{HTSLIB.KString}, phts+i)
    kstr = unsafe_load(pkstr)
    @show i,kstr,Int128(kstr.l)
    if i >= 33
        segm = [39,40,41,42,43,55,56,60,64,72,78,79,80,81,100,101,102,103,104]
        if i in segm
            println("$(string(segm)) segment fault")
            continue
        end
        str = try
            HTSLIB.strptr(kstr)
           catch ex
            @show ex
            continue
        end
        info("Great success: $str")
        break
    end
end
#@show HTSLIB.strptr(kstr)
#@show htsfl
=#
