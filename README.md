# HTSLIB

[![Build Status](https://travis-ci.org/OpenGene/HTSLIB.jl.svg?branch=master)](https://travis-ci.org/OpenGene/HTSLIB.jl)
[![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)]()
[![Documentation Status](http://readthedocs.org/projects/htslibjl/badge/?version=latest)](http://htslibjl.readthedocs.org/en/latest/?badge=latest)
[![HTSLIB](http://pkg.julialang.org/badges/HTSLIB_0.4.svg)](http://pkg.julialang.org/?pkg=HTSLIB)
[![HTSLIB](http://pkg.julialang.org/badges/HTSLIB_0.5.svg)](http://pkg.julialang.org/?pkg=HTSLIB)

HTSLIB.jl is a julia wrapper for [htslib](https://github.com/samtools/htslib) for accessing common high-throughput sequencing data file formats.

This package is under active development. Welcome for everyone to give me advices.



### Installation

	Pkg.add("HTSLIB")
	Pkg.checkout("HTSLIB") #optional
	Pkg.test("HTSLIB")

### Examples
**query reads given the target interval**
```Julia

	using HTSLIB

	bios = open("data/100_sort.bam","rb","bam")
	htsfl = unsafe_load(convert(Ptr{HTSLIB.HTSFile},bios.handle))
	pidx = HTSLIB.sam_index_load(bios,"data/100_sort.bam")
	iters = HTSLIB.sam_itr_querys(pidx,bios.phdr,"chr1:6543250-6542550")
	precord = HTSLIB.bam_init1()
	while HTSLIB.sam_itr_next!(bios.handle,iters,precord)
		HTSLIB.sam_format!(bios.phdr,precord,bios.pkstr)
		kstr = HTSLIB.strptr(bios.pkstr)
		print(kstr)
	end
	close(bios)
	
```

**read a bam file**
```Julia

	using HTSLIB
	data = HTSLIB.readlines("data/100.bam")
	#OR
	bios = open("data/100.bam","r","bam") # bam_open("data/100.bam","r")
	while !eof(bios)
		line = readline(bios)
		#code of processing line
	end
	close(bios)
	
```
**write a bam file**
```Julia

	using HTSLIB
	fw = open("data/test_write.bam","wb","bam")
	fr = open("data/100.bam","rb","bam")
	
	fw.phdr = HTSLIB.sam_hdr_parse(HTSLIB.strptr(fr.phdr))

	writelines(fw,data)
	#OR
	HTSLIB.sam_hdr_write(fw.handle,fw.phdr)
	for line in data
		writeline(fw,line)
    end

	close(fw)
	close(fr)
```
**read a sam file**

```Julia

	using HTSLIB
	data = readlines("data/100.sam")
```
**write a bam file with a header of a sam file**

```Julia

	using HTSLIB
	fw = open("data/test_write.bam","wb","bam")
	fr = open("data/100.bam","rb","sam")
	
	header = unsafe_load(fr.phdr)
	newheader = deepcopy(header)
	phdr = convert(Ptr{HTSLIB.Header}, pointer_from_objref(newheader))
	fw.phdr = phdr

	writelines(fw,data)

	close(fw)
	close(fr)
	
```
