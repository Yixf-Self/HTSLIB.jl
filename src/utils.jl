
function get_pointer(str::ASCIIString)
    convert(Ptr{Int8}, pointer(str))
end

function get_pointer(kstr::KStr)
    convert(Ptr{KStr}, pointer_from_objref(kstr))
end

strptr(kstr::KStr) = strptr(kstr.s,1,kstr.l)
strptr(p::Ptr{Int8},st::Integer,ed::Integer) = stringfrompointer(convert(Ptr{UInt8},p),Int64(st),Int64(ed))
strptr(p::Ptr{UInt8},st::Integer,ed::Integer) = stringfrompointer(p,Int64(st),Int64(ed))
function stringfrompointer(p::Ptr{UInt8},st::Int64,ed::Int64)
    len = ed-st+1
    @assert len>0
    data = Array{UInt8,1}(len)
    for i in st:ed
        data[i-st+1] = unsafe_load(p,i)
    end
    ASCIIString(data)
end
