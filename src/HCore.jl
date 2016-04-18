module HCore

const LIBHTS = "/haplox/users/guo/Github/htslib/libhts.so"

macro fncall(fn, return_type)
    f = eval(fn)
    quote
        ccall(($(Meta.quot(f)), $LIBHTS), $return_type,
              ())
    end
end
    
macro fncall(fn, return_type, argtypes, args...)
    f = eval(fn)
    args = map(esc, args)
    quote
        ccall(($(Meta.quot(f)), $LIBHTS), $return_type,
              $argtypes, $(args...))
    end
end


include("core.jl")
include("fp.jl")

end
