# HTSLIB

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
```
**write a bam file**
```Julia

	fw = HTSLIB.open("data/test_write.bam","wb","bam")
	fr = HTSLIB.open("data/100.bam","rb","bam")

	fw.phdr = HTSLIB.sam_hdr_parse(HTSLIB.strptr(fr.phdr))

	HTSLIB.writelines(fw,data)

	HTSLIB.close(fw)
	HTSLIB.close(fr)
```
**read a bam file**

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
