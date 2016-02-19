# HTSLIB
HTSLIB.jl is a julia wrapper for [htslib](https://github.com/samtools/htslib) for accessing common high-throughput sequencing data file formats.

This package is under active development. Welcome for everyone to give me advices.

Linux, OSX: [![Build Status](https://travis-ci.org/OpenGene/HTSLIB.jl.svg?branch=master)](https://travis-ci.org/OpenGene/HTSLIB.jl)
[![Documentation Status](http://readthedocs.org/projects/htslibjl/badge/?version=latest)](http://htslibjl.readthedocs.org/en/latest/?badge=latest)

### Installation

	Pkg.add("HTSLIB")
	Pkg.checkout("HTSLIB") #optional
	Pkg.test("HTSLIB")

### Examples
**query reads in the target interval**
```Julia
	
	bios = HTSLIB.open("data/100_sort.bam","rb","bam")
	htsfl = unsafe_load(convert(Ptr{HTSLIB.HTSFile},bios.handle))
	pidx = HTSLIB.sam_index_load(bios,"data/100_sort.bam")
	iters = HTSLIB.sam_itr_querys(pidx,bios.phdr,"chr1:6543250-6542550")
	precord = HTSLIB.bam_init1()
	while HTSLIB.sam_itr_next!(bios.handle,iters,precord)
		HTSLIB.sam_format!(bios.phdr,precord,bios.pkstr)
		kstr = HTSLIB.strptr(bios.pkstr)
		print(kstr)
	end
	
```

**read a bam file**
```Julia

	HTSLIB.readlines("data/100.bam")
	#OR
	bios = HTSLIB.open("data/100.bam","r","bam") #OR HTSLIB.bam_open("data/100.bam","r")
	while !HTSLIB.eof(bios)
		line = HTSLIB.readline(bios)
		#code of processing line
	end
	close(bios)
	
```
**write a bam file**
```Julia

	fw = HTSLIB.open("data/test_write.bam","wb","bam")
	fr = HTSLIB.open("data/100.bam","rb","bam")
	
	fw.phdr = HTSLIB.sam_hdr_parse(HTSLIB.strptr(fr.phdr))

	HTSLIB.writelines(fw,data)
	#OR
	HTSLIB.sam_hdr_write(fw.handle,fw.phdr)
	for line in data
		writeline(fw,line)
    end

	HTSLIB.close(fw)
	HTSLIB.close(fr)
```
**read a sam file**

```Julia

	HTSLIB.readlines("data/100.sam")
```
**write a bam file with a header of a sam file**

```Julia

	fw = HTSLIB.open("data/test_write.bam","wb","bam")
	fr = HTSLIB.open("data/100.bam","rb","sam")
	
	header = unsafe_load(fr.phdr)
	newheader = deepcopy(header)
	phdr = convert(Ptr{HTSLIB.Header}, pointer_from_objref(newheader))
	fw.phdr = phdr

	HTSLIB.writelines(fw,data)

	HTSLIB.close(fw)
	HTSLIB.close(fr)
	
```
