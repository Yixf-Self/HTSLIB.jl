libhts =  "libhts.so"
if !in(libhts, readdir("/usr/local/lib"))
    cmd = `git clone https://github.com/samtools/htslib.git`
    dir = dirname(@__FILE__())
    @show dir
    cd(dir) do
        if !isdir("htslib")
            success(cmd) || error("git clone htslib failed")
        end
        success(`autoconf`) || error("htslib autoconf failed")
        success(`./configure`) || error("htslib configure failed")
        success(`make`) || error("htslib make failed")
        success(`sudo make install`) || error("sudo make install")
        success(`sudo cp libhts.so /usr/local/lib`) || error("sudo cp libhts.so /usr/local/lib failed")
    end
end
