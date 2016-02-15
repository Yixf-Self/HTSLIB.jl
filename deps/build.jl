using BinDeps

libhts_detected = false
function detecthts()
    false
end

if !detechts()
    
    # install zlib

    # build libhts
    
    hts = library_dependency("hts", aliases=["libhts"], runtime=true, os=:Unix)

    _prefix = joinpath(BinDeps.depsdir(HTSLIB),"usr")
    _srcdir = joinpath(BinDeps.depsdir(HTSLIB),"src")
    _htsdir = joinpath(_srcdir,"htslib")
    _libdir = joinpath(_prefix, "lib")

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
