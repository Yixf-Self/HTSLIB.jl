#libhts_detected = false
function detecthts()
    false
end

using BinDeps
@BinDeps.setup

function append_code()
    codes = """
    kstring_t * get_ptr_of_kstr(int num){
      char * ch = (char *)malloc(num);
      kstring_t *p = (kstring_t *)malloc(sizeof(kstring_t));
      p->l = 0;
      p->m = num;
      p->s = ch;
      return p;
    };
    """
    open("sam.c","a+") do file
        write(file, codes)
    end
end


if !detecthts()

    hts = library_dependency("hts", aliases=["libhts","libhts.so","libhts.dylib","libhts.dll"])
    _prefix = joinpath(BinDeps.depsdir(hts),"usr")
    _srcdir = joinpath(BinDeps.depsdir(hts),"src")
    _htsdir = joinpath(_srcdir,"htslib-1.3")
    _libdir = joinpath(_prefix, "lib")
    
    provides(BuildProcess,
             (@build_steps begin
              CreateDirectory(_srcdir)
              CreateDirectory(_libdir)
              @build_steps begin
              ChangeDirectory(_srcdir)
              `rm -rf htslib`
              `wget https://github.com/samtools/htslib/releases/download/1.3/htslib-1.3.tar.bz2`
              `tar xvf htslib-1.3.tar.bz2`
               append_code()
              
              @linux_only FileRule(joinpath(_libdir, "libhts.so"), @build_steps begin
                                   ChangeDirectory(_htsdir)
                                   `autoconf`
                                   `./configure`
                                   `make libhts.so`
                                   `cp libhts.so $_libdir`
                                   end)
              @osx_only FileRule(joinpath(_libdir, "libhts.dylib"), @build_steps begin
                                 ChangeDirectory(_htsdir)
                                 `autoconf`
                                 `./configure`
                                 `make libhts.dylib`
                                 `cp libhts.dylib $_libdir`
                                 end)
                  
              end
             end), hts)
    
    @BinDeps.install Dict(:hts => :hts)

end
