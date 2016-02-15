libhts =  "libhts.so"
if !in(libhts,readdir("/usr/local/lib"))
    cmd = `git clone https://github.com/samtools/htslib.git`
    if !sucess(cmd) error("git clone htslib failed") end
    if !(sucess(`autoconf`) && sucess(`./configure`) && sucess(`make`) && sucess(`sudo make install`))
        error("install htslib failed")
    end
    if !sucess(`sudo cp libhts.so /usr/local/lib`) error("sudo cp libhts.so /usr/local/lib failed") end
end
