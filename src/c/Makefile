PLATFORM := $(shell uname -s)
ifeq "$(PLATFORM)" "Darwin"
libkstr: libkstr.dylab
CC := clang
else
libkstr: libkstr.so
CC := gcc
endif

libkstr.dylab: kstring.c
	$(CC) kstring.c -dynamiclib -o libkstr.dylab 

libkstr.so: kstring.c
	$(CC) kstring.c -o libkstr.so -fpic -shared





