

strptr(p::Ptr{UInt8},st::Int64,ed::Int64) = stringfrompointer(p,st,ed)
function stringfrompointer(p::Ptr{UInt8},st::Int64,ed::Int64)
    len = ed-st+1
    @assert len>0
    data = Array{UInt8,1}(len)
    for i in st:ed
        data[i-st+1] = unsafe_load(p,i)
    end
    ASCIIString(data)
end
