(*OCaml code can also be compiled separately and executed non-interactively using the batch compilers ocamlc and ocamlopt.
The source code must be put in a file with extension .ml. It consists of a sequence of phrases, which will be evaluated at 
runtime in their order of appearance in the source file. Unlike in interactive mode, types and values are not printed automatically; 
the program must call printing functions explicitly to produce some output.*) 

let rec fib n =
    if n < 2 then n else fib (n-1) + fib (n-2);;

let main () = 
    let arg = int_of_string Sys.argv.(1) in 
    print_int (fib arg);
    print_newline ();   (*function must be called with args, even none. Otherwise, meaning function-type*)
    exit 0;;

main ();;

(*
The program above is compiled and executed with the following shell commands:
$ ocamlc fib.ml -o fib
$ ./fib 10
*)

