# HTSLIB
HTSLIB.jl is a julia wrapper for [htslib](https://github.com/samtools/htslib) for accessing common high-throughput sequencing data file formats.

This package is under active development. Welcome for everyone to give me advices.

Linux, OSX: [![Build Status](https://travis-ci.org/OpenGene/HTSLIB.jl.svg?branch=master)](https://travis-ci.org/OpenGene/HTSLIB.jl)
[![Documentation Status](http://readthedocs.org/projects/htslibjl/badge/?version=latest)](http://htslibjl.readthedocs.org/en/latest/?badge=latest)

### Installation

	Pkg.clone("https://github.com/OpenGene/HTSLIB.jl.git")
	Pkg.build("HTSLIB")
	Pkg.test("HTSLIB")

### Examples
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
