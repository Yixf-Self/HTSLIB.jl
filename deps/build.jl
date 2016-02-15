libhts =  "libhts.so"
if !in(libhts,readdir("/usr/local/lib"))
    cmd = `git clone https://github.com/samtools/htslib.git`
    if !success(cmd) error("git clone htslib failed") end
    if !(success(`autoconf`) && success(`./configure`) && success(`make`) && success(`sudo make install`))
        error("install htslib failed")
    end
    if !success(`sudo cp libhts.so /usr/local/lib`) error("sudo cp libhts.so /usr/local/lib failed") end
end
