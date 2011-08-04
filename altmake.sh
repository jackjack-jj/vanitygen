#!/bin/sh
if [ $# -lt 2 ]
then
	echo 'arg1 = amdsdk/include'
	echo 'arg2 = amdsdk/lib/x86(_64?)'
	exit
fi
mkdir CL -p
cp $1'/CL/cl.h' CL
sed -i 's#<CL/cl.h>#"CL/cl.h"#' oclvanitygen.c
cp $1'/CL/cl_platform.h' CL
sed -i 's#<CL/cl_platform.h>#"cl_platform.h"#' CL/cl.h
sed -i 's#$(LIBS) -L.* -lOpenCL.*#$(LIBS) -L'$2' -lOpenCL#' Makefile
sed -i 's#$(LIBS) -lOpenCL.*#$(LIBS) -L'$2' -lOpenCL#' Makefile
export LD_LIBRARY_PATH=$2:$LD_LIBRARY_PATH
make oclvanitygen
sed -i 's#"CL/cl.h"#<CL/cl.h>#' oclvanitygen.c
sed -i 's#$(LIBS) -L.* -lOpenCL.*#$(LIBS) -lOpenCL#' Makefile
rm CL -R
