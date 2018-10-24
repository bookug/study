CC = g++
NVCC = nvcc -arch=sm_35 -lcudadevrt -rdc=true -G --ptxas-options=-v -lcurand
#NVCC = nvcc -arch=sm_35 -lcudadevrt -rdc=true -G -Xcompiler -rdynamic -lineinfo
#CFLAGS = -g -c #-fprofile-arcs -ftest-coverage -coverage #-pg
#EXEFLAG = -g #-fprofile-arcs -ftest-coverage -coverage #-pg #-O2
#NVCC = nvcc -arch=sm_35 -lcudadevrt -rdc=true 
#CFLAGS = -c #-fprofile-arcs -ftest-coverage -coverage #-pg
CFLAGS = -c -O2 #-fprofile-arcs -ftest-coverage -coverage #-pg
EXEFLAG = -O2 #-fprofile-arcs -ftest-coverage -coverage #-pg #-O2

all: test.exe memory.exe

test.exe: test.cu Util.h Util.cpp
	$(NVCC) $(EXEFLAG) -o test.exe test.cu Util.cpp

memory.exe: memory.cu Util.h Util.cpp
	$(NVCC) $(EXEFLAG) -o memory.exe memory.cu Util.cpp

