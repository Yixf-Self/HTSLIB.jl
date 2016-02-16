#libhts_detected = false
function detecthts()
    false
end

using BinDeps
@BinDeps.setup
if !detecthts()
    
    # install zlib
    #zlib = library_dependency("zlib", aliases = ["libzlib","zlib1","libzlib.so"])
    #provides(Sources, Dict(URI("http://zlib.net/zlib-1.2.8.tar.gz") => zlib))
    
    # Build libhts
    hts = library_dependency("hts", aliases=["libhts","libhts.so","libhts.dylib"])#, runtime=true, os=:Unix)
    autoconf = library_dependency("autoconf",os=:Darwin)
    @osx_only begin
        if Pkg.installed("Homebrew") === nothing
            error("Homebrew package not installed, please run Pkg.add(\"Homebrew\")")
        end
        using Homebrew
        provides( Homebrew.HB, "autoconfig", autoconf, os = :Darwin )
        @BinDeps.install Dict(:autoconf => :autoconf)
    end
    
    _prefix = joinpath(BinDeps.depsdir(hts),"usr")
    _srcdir = joinpath(BinDeps.depsdir(hts),"src")
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
                     @linux_only `cp libhts.so $_libdir`
                     @osx_only `cp libhts.dylib $_libdir`
                   end)
                end
             end), hts)
    
    info("install begins")
    @BinDeps.install Dict(:hts => :hts)

end
