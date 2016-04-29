module HTSLIB

const debug = true
if !debug
@linux_only const LIBHTS = Libdl.find_library(["libhts.so"],[joinpath(dirname(dirname(@__FILE__)),"deps/usr/lib")])
@linux_only const LIBKSTR = joinpath(dirname(@__FILE__), "c/libkstr.so")
@osx_only const LIBHTS = Libdl.find_library(["libhts.dylib"],[joinpath(dirname(dirname(@__FILE__)),"deps/usr/lib")])
@osx_only const LIBKSTR = joinpath(dirname(@__FILE__), "c/libkstr.dylab")
end

function __init__()
    if !isfile(LIBKSTR)
        if OS_NAME == ":Windows"
            error("Windows is not supported now")
        else
            c_path = joinpath(dirname(@__FILE__),"c")
            cd(c_path) do
                run(`make libkstr`)
            end
        end
    end
end


import Base:readline,eof,write,close

export sam_open,
       bam_open,
       readline,
       eof,
       write,
       close

include("HT.jl")


end
