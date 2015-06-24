count: count.o lexer.o 
	gcc -lfl count.o lexer.o -o count
count.o: count.c
	gcc -c count.c
lexer.o: lexer.c
	gcc -c lexer.c
lexer.c: lexer.l
	flex -t lexer.l > lexer.c
.PHONY: clean
clean:
	rm -f *.o lexer.c

