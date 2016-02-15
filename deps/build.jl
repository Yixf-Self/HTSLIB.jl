libhts =  "libhts.so"
if !in(libhts,readdir("/usr/local/lib"))
    cmd = `git clone https://github.com/samtools/htslib.git`
    if !success(cmd) error("git clone htslib failed") end
    if !success(`autoconf`) error("htslib autoconf failed") end
    if !success(`./configure`) error("htslib configure failed") end
    if !success(`make`) error("htslib make failed") end
    if !success(`sudo make install`) error("sudo make install") end
    if !success(`sudo cp libhts.so /usr/local/lib`) error("sudo cp libhts.so /usr/local/lib failed") end
end
