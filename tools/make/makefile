# invoke via
# 	make all --dir tools/make
#	-s for less make specific output

# https://stackoverflow.com/a/12099167

DIRPATH := ../../../../dist
SHELL := /bin/bash  # default is /sh, which causes ./bash.sh scripts to fail

prep:
	echo $(SHELL)
ifeq ($(OS),Windows_NT)
	cmd /c IF not exist ..\..\dist ( mkdir ..\..\dist )
else
	mkdir $(DIRPATH)
endif


build: prep
	where.exe g++
	g++ main.cpp \
		./lib/lib.cpp -I./lib \
		\
		-o ../../dist/main

all: build
	../../dist/main
