I am hitting around 50% occupancy on my GTX 1080 with 64 register per thread. The bottleneck that is preventing higher occupancy is the number of registers per thread. I could just force a maximum number of threads to be lower than 64 through a compilation flag, but that would lead to leakage into the local memory.

From answers in other forums, the general way to decrease the number of registers used per thread is to:
1) take advantage of the shared memory, since shared memory has higher bandwidth than local memory
2) breakup a big kernel into smaller kernels, where each kernel computes a portion of what the big kernel computed and save the partial output to a global memory.

The general consensus seemed to be that it is hard to predict which values will be in the register because nvcc will heavily optimize the output.

My question is:
1) does using less statically sized local arrays or local variables decrease the use of registers per thread?
2) does decreasing the number of parameters decrease the use of registers per thread?
3) are there any other methods to decrease registers per thread (without leakage) and increase occupancy?

If there were code to be looked at, it would probably make for a more fruitful discussion. Some random thoughts:

(1) Does the code use double-precision computation anywhere (possibly accidentally)? Each DP operand requires two of the GPU's 32-bit registers to store.

(2) The use of thread-local arrays may reduce register usage, but also performance. I have used this to reduce register pressure caused by an infrequently executed code path.

(3) If the code has a lot of single-precision floating-point computation, use of -use-fast-math can often reduce register pressure, but can also have a significant negative impact on accuracy.

(4) Some math functions are fairly expensive in terms of register use, e.g. pow(), and should not be used gratuitously where simpler functions would suffice. Using sinpi(), cospi(), sincospi() instead of sin(), cos(), sincos(), where possible, can often reduce register pressure. 

