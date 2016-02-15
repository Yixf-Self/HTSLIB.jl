Installation Guide
==================


Manunal Installation
--------------------

- install htslib
  install htslib according to `samtools/htslib https://github.com/samtools/htslib`_.
  copy ``libhts.so`` to ```/usr/local/lib``.
  ``sudo cp libhts.so /usr/local/lib``

- install HTSLIB.jl
  ``Pkg.clone("https://github.com/OpenGene/HTSLIB.jl.git")``
  
- test HTSLIB.jl
  ``Pkg.test("HTSLIB")``
