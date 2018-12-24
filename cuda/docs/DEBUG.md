
Invalid Memory access

cuda-gdb 

after run into error,    info locals and see more

---

gpu core dump

https://docs.nvidia.com/cuda/cuda-gdb/#gpu-coredump

after dump/exception in gdb, using info locals

---

in case of optimized output, not using optimizing options when debugging

---

If using quote in C++, then in gdb it will be reference and you need to see the contents using (*p)

