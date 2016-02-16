libhts_detected = false
function detecthts()
    false
end

using BinDeps
@BinDeps.setup
if !detecthts()
    
    # install zlib

    # build libhts
    
    hts = library_dependency("hts", aliases=["libhts","libhts.so"])#, runtime=true, os=:Unix)

    _prefix = joinpath(BinDeps.depsdir(hts),"usr")
    _srcdir = joinpath(BinDeps.depsdir(hts),"src")
    _htsdir = joinpath(_srcdir,"htslib")
    _libdir = joinpath(_prefix, "lib")

    provides(Sources, Dict(URI("http://zlib.net/zlib-1.2.7.tar.gz") => zlib))
    
    provides(BuildProcess,
             (@build_steps begin
                CreateDirectory(_srcdir)
                CreateDirectory(_libdir)
                @build_steps begin
                  ChangeDirectory(_srcdir)
                  `rm -rf htslib`
                  `git clone https://github.com/samtools/htslib`
                   FileRule(joinpath(_libdir, "libhts.so"), @build_steps begin
                     ChangeDirectory(_htsdir)
                     `autoconf`
                     `./configure`
                     `make`
                     `cp libhts.so $_libdir`
                   end)
                end
             end), hts)
    
    info("install begins")
    @BinDeps.install Dict(:hts => :hts)

end
