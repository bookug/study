all: exe0 exe1 exe2
exe0: dijkstra0.c
	icc -mmic dijkstra0.c -o exe0
	scp exe0 mic0:
exe1: dijkstra1.c
	icc -mmic -openmp dijkstra1.c -o exe1
	scp exe1 mic0:
exe2: dijkstra2.c
	icc -mmic -openmp dijkstra2.c -o exe2
	scp exe2 mic0:
.PHONY: clean
clean:
	rm -f *.o exe*

