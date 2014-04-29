# Build with MSYS + TDM-GCC Mingw targeting 32 and 64 bit windows
# For 32-bit sdpa: make BIT=32 sdpa
# For 64-bit sdpa: make BIT=64 sdpa
# For building sdpam, copy extern/include folder, libmx.dll and  libmex.dll into matlab-root folder, then make sdpam as the same as sdpa.
# For compiling both sdpa and sdpam: make BIT=32 or 64
# Get clean sources: make clean
# Build test: make test
# Clean test: make testclean

# SDPA version
SDPA_VERSION=7.3.9

# bit (32 or 64)
# BIT=64
BIT = 32

# Directories
BASE_DIR=$(shell pwd)
SDPA_WIN_DIR=sdpa7-windows$(BIT)
SDPAM_WIN_DIR=sdpam7-windows$(BIT)

ifeq ($(BIT),64)
PTHREAD_DIR=/mingw/x86_64-w64-mingw32
else
PTHREAD_DIR=/mingw
endif

all: OpenBLAS sdpa sdpam

OpenBLAS: OpenBLAS/libopenblas.a

OpenBLAS/libopenblas.a:
	@if [ ! -d OpenBLAS ]; then \
		git clone https://github.com/xianyi/OpenBLAS.git ; \
	fi
	(cd OpenBLAS; \
	 make \
		CC=gcc \
		FC=gfortran \
		BINARY=${BIT} \
		libs netlib;  \
	make PREFIX=install install; )

sdpa: sdpa-binary sdpa-copy

sdpa-copy:
	rm -rf $(SDPA_WIN_DIR)
	rm -f $(SDPA_WIN_DIR).zip
	mkdir -p $(SDPA_WIN_DIR)
	mkdir -p $(SDPA_WIN_DIR)/matlab-root
	cp sdpa7/COPYING $(SDPA_WIN_DIR)/
	cp -r sdpa7-src $(SDPA_WIN_DIR)/
	cp sdpa-install$(BIT)/bin/sdpa.exe $(SDPA_WIN_DIR)/
	cp sdpa-install$(BIT)/share/sdpa/param.sdpa $(SDPA_WIN_DIR)/
	cp OpenBLAS/libopenblas.a sdpa-install$(BIT)/lib/
	cp `find sdpa-install$(BIT) | grep dat-s$$` $(SDPA_WIN_DIR)/
	(cd $(SDPA_WIN_DIR)/; for i in *.dat-s; do sed -i -e 's/$$/\r/' $$i; done)
	cp Makefile README.txt $(SDPA_WIN_DIR)/
	cp -r sdpa-install$(BIT)/include $(SDPA_WIN_DIR)
	cp sdpa-install$(BIT)/share/sdpa/mumps/build/include/* $(SDPA_WIN_DIR)/include/
	cp -r sdpa-install$(BIT)/lib $(SDPA_WIN_DIR)
	cp sdpa-install$(BIT)/share/sdpa/mumps/build/lib/* $(SDPA_WIN_DIR)/lib/
	cp sdpa-install$(BIT)/share/sdpa/mumps/build/libseq/* $(SDPA_WIN_DIR)/lib/
	zip -r $(SDPA_WIN_DIR).zip $(SDPA_WIN_DIR)

sdpa-binary: OpenBLAS
	(rm -rf sdpa7; \
	 cp -r sdpa7-src sdpa7; \
	 cd sdpa7; \
	 autoreconf -i; \
	 CFLAGS=-static CXXFLAGS=-static FFLAGS=-static FCFLAGS=-static \
	./configure --prefix=${BASE_DIR}/sdpa-install$(BIT) \
	--with-blas=${BASE_DIR}/OpenBLAS/libopenblas.a \
	--with-lapack=${BASE_DIR}/OpenBLAS/libopenblas.a \
	--with-pthread-include=-I$(PTHREAD_DIR)/include \
	--with-pthread-libs=$(PTHREAD_DIR)/lib/libpthread.a \
	--with-mumps-libs=NO_MUMPS ; \
	make; \
	make install; )
	cp sdpa7/sdpa.exe .

clean:
	rm -rf sdpa7
	rm -rf OpenBLAS

sdpam: sdpam-checkfiles sdpam-binary sdpam-copy

sdpam-checkfiles:
	@echo "Checking Matlab header and library files."
	@echo "If failed, read README.txt."
	@if [ ! -f matlab-root/include/mex.h ]; then echo "Cannot find mex.h in matlab-root/include/ "; exit 1; fi
	@if [ ! -f matlab-root/include/matrix.h ]; then echo "Cannot find mex.h in matlab-root/include/ "; exit 1; fi
	@if [ ! -f matlab-root/win$(BIT)/libmx.dll ]; then echo "Cannot find libmx.dll in matlab-root/win$(BIT)"; exit 1; fi
	@if [ ! -f matlab-root/win$(BIT)/libmex.dll ]; then echo "Cannot find libmex.dll in matlab-root/win$(BIT)"; exit 1; fi
	@echo "All check passed successfully."

sdpam-binary:
	(cd sdpa-install$(BIT)/share/sdpa/mex/; \
	 make MEX="$(CROSS)-g++ -shared -static" \
	 COMPILE_ENVIRONMENT=octave \
	 PRINTF_INT_STYLE=-DPRINTF_INT_STYLE=\\\"%zd\\\" \
	 OUTPUT_FORMAT="-o \$$@.mexw$(BIT)" \
	 MATLAB_INCLUDE="-I$(BASE_DIR)/matlab-root/include" \
	 MATLAB_LIBS="$(BASE_DIR)/matlab-root/win$(BIT)/libmx.dll $(BASE_DIR)/matlab-root/win$(BIT)/libmex.dll";)

sdpam-copy:
	rm -rf $(SDPAM_WIN_DIR)
	rm -f $(SDPAM_WIN_DIR).zip
	cp -r $(SDPA_WIN_DIR) $(SDPAM_WIN_DIR)
	cp sdpa-install$(BIT)/share/sdpa/mex/*.m $(SDPAM_WIN_DIR)/
	cp sdpa-install$(BIT)/share/sdpa/mex/CommandList.txt $(SDPAM_WIN_DIR)/
	cp sdpa-install$(BIT)/share/sdpa/mex/mex*.mexw$(BIT) $(SDPAM_WIN_DIR)/
	zip -r $(SDPAM_WIN_DIR).zip $(SDPAM_WIN_DIR)

test:
	(cd sdpa-install$(BIT)/share/sdpa/libexample; \
	make; )

testclean:
	(cd sdpa-install$(BIT)/share/sdpa/libexample; \
	make distclean; )
	