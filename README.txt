SDPA Windows MSYS + TDM-GCC Mingw targeting both 32 and 64 bit on windows
Copyright (C) 2004-2011 SDPA Project
http://sdpa.sourceforge.net/

This project provide a MSYS + TDM-GCC Mingw build from SDPA sources on windows.
Current version based on SDPA 7.3.9
Maintenance by kaienfr

==INDEX==
1. Compilation
2. Usage
3. License
========

== 1. Compilation from source ==

[1] To compile the files from the source package, you need to install
MSYS: http://sourceforge.net/projects/mingw/files/MSYS/Base/msys-core/msys-1.0.11/
TDM-GCC Mingw 32 or 64 bit: http://tdm-gcc.tdragon.net/download
You need also to install the mingw's extensions:
automake: http://sourceforge.net/projects/mingw/files/MinGW/Extension/automake/
autoconf: http://sourceforge.net/projects/mingw/files/MinGW/Extension/autoconf/
PS: set your mingw (32 or 64 bit) as default gcc toolchain of MSYS in /etc/fstab or via command
$ mount path/of/your/mingw  /mingw

[2] Compile with make command.
(32bit Windows) $ make BIT=32 sdpa
(64bit Windows) $ make BIT=64 sdpa
This will automatically compile OpenBLAS, then compile SDPA.

[3] (Option) for SDPA-M [Matlab environment].

This step must be executed after 'make sdpa' is finished
successfully.

First you need to copy the header and libraries files from
Windows-version Matlab.
Copy 
$MATLAB_ROOT\extern\include directory  
under
matlab-root/ 
directory as 
matlab-root/include directory

Copy 
(32bit Windows) $MATLAB_ROOT\bin\win32\libmex.dll and $MATLAB_ROOT\bin\win32\libmx.dll
(64bit Windows) $MATLAB_ROOT\bin\win64\libmex.dll and $MATLAB_ROOT\bin\win64\libmx.dll
to matlab-extern/ 
directory as
(32bit Windows) matlab-root/win32/libmx.dll and matlab-root/win32/libmex.dll
(64bit Windows) matlab-root/win64/libmx.dll and matlab-root/win64/libmex.dll

The command 
$ make sdpam-checkfiles
is prepaered to check whether the files are copied
into appropriate directory.

Then 
(32bit Windows) $ make BIT=32 sdpam
(64bit Windows) $ make BIT=64 sdpam

== 2. Usage ==
[1] To use from command line, execute command prompt and
    move to this directory. Then
    $ sdpa
    will display help message.
    An example can be solved by
    $ sdpa example1.dat-s example1.result
[2] To use from Matlab environment, add this directory
    to Matlab path. Then follow the SDPA-M manual
    https://sourceforge.net/projects/sdpa/files/sdpa-m/sdpamManual.pdf
    An example can be solved by
    >>> [mDIM,nBLOCK,bLOCKsTRUCT,c,F]=read_data('example1.dat-s');
    >>> [objVal,x,X,Y,INFO]=sdpam(mDIM,nBLOCK,bLOCKsTRUCT,c,F);
    Each command is briefly introduced in CommandList.txt.

Note:
   SDPA-sparse format files are usually prepared in Unix environments.
   To convert Unix-type newline files to Windows-type newline files,
   use the following command in the command prompt.
   $ more < example1.dat-s > example1.windows.dat-s
   If the file is large, my may try 
   $ perl -p -e 's/\n/\r\n/' example1.dat-s > example1.windows.dat-s
   could be much faster.
   Then the Windows-type newline file 'example1.windows.dat-s' will be
   available.

== 3. License ==

This binary is distributed under GNU General Public License v2.
More details of GPLv2 can be found in the file COPYING of this directory.

The source file of each package is available at the web page
of each package.

[1] SDPA 
http://sdpa.sourceforge.net/
SDPA is distributed under  GNU General Public License v2.

[2] OpenBLAS
https://github.com/xianyi/OpenBLAS
OpenBLAS is an open source code based on GotoBLAS 
and supported by ICSAS.
Copyright (c) 2011, Lab of Parallel Software and Computational Science,ICSAS

[3] MinGW
http://www.mingw.org/
MinGW is distributed under  GNU General Public License v2.
(This notice is from the web page of MinGW)
This library is distributed in the hope that it will be useful,
but WITHOUT WARRANTY OF ANY KIND;
without even the implied warranties of MERCHANTABILITY
or of FITNESS FOR A PARTICULAR PURPOSE.

