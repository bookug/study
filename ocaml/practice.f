(*=============================================================================
# Filename: practice.f
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-04-27 12:40
# Description: learn and practice ocaml 
=============================================================================*)



(*
TITLE: The Core Language
*)

(*variable-name must start with a lowercase letter*)
(*generally, older one won't be changed, except special cases like array'*)

"sb"^"007";;    (*string in ocaml is not character-array, but a basic type*)

(*
int: + - * / mod
float: +. -. *. /. **
float_of_int, int_of_float
*)
let pi = 4.0 *. atan 1.0;;  (*atan is a function inserted in ocaml*)

let square x = x *. x;; 

square (sin pi) +. square (cos pi);;

let rec fib n = (*rec is used to indicate that this is a recursive function*)     
if n < 2 then n else fib (n-1) + fib (n-2);;

fib 10;;

let l = ["is"; "a"; "tale"; "told"; "etc."];;   
List.hd l;;
List.tl l;;
(*all elements are the same type in list, but not must in tuple*)
(3, "sb", 'a', 1.7, false);;
"Life"::l;; (*::, before it must be an element, not sub-list*)

let rec sort lst =  (*polymorphism, can be applied to any type, 'a'*)
    match lst with
    [] -> []
    | head::tail -> insert head (sort tail)
and insert elt lst = 
    match lst with
    [] -> [elt]
    | head::tail -> if elt <= head then elt::lst else head::insert elt tail;;

sort l;;

sort [3.14;2.718];;

(*function can be element in function-languages*)
let deriv f dx = function x -> (f (x +. dx) -. f x) /. dx;;

let sin' = deriv sin 1e-6;;

sin' pi;;

(*functional or high-order functions*)
let compose f g = function x -> f (g x);;

let cos2 = compose square cos;;

List.map (function n -> n * 2 + 1) [0;1;2;3;4];;

let rec map f l = 
    match l with
    [] -> []
    | hd::tl -> f hd :: map f tl;;

(*User-defined data structures include records and variants*)
type ratio = {num:int; denom:int};;

let add_ratio r1 r2 =
    {num = r1.num * r2.denom + r2.num * r1.denom; 
     denom = r1.denom * r2.denom};;
add_ratio {num=1; denom=3} {num=2; denom=5};;

type number = Int of int | Float of float | Error;;

type sign = Positive | Negative;;

let sign_int n = if n >= 0 then Positive else Negative;;

let add_num n1 n2 = 
    match (n1, n2) with
    (Int i1, Int i2) -> (* Check for overflow of integer addition *)
    if sign_int i1 = sign_int i2 && sign_int (i1 + i2) <> sign_int i1
    then Float(float i1 +. float i2) else Int(i1 + i2)
    | (Int i1, Float f2) -> Float(float i1 +. f2)
    | (Float f1, Int i2) -> Float(f1 +. float i2)
    | (Float f1, Float f2) -> Float(f1 +. f2)
    | (Error, _) -> Error
    | (_, Error) -> Error;;

add_num (Int 123) (Float 3.14159);;

(*The most common usage of variant types is to describe recursive data structures*)
type 'a btree = Empty | Node of 'a * 'a btree * 'a btree;;

let rec search x btree =
    match btree with
    Empty -> false
    | Node(y, left, right) -> 
    if x = y then true else
    if x < y then search x left else search x right;;

let rec insert x btree = 
    match btree with
    Empty -> Node(x, Empty, Empty)
    | Node(y, left, right) ->
    if x <= y then Node(y, insert x left, right) else Node(y, left, insert x right);;

(*Imperative features*)
let add_vect v1 v2 =
    let len = min (Array.length v1) (Array.length v2) in
    let res = Array.make len 0.0 in 
    for i = 0 to len - 1 do
    res.(i) <- v1.(i) +. v2.(i)
    done;
    res;;

add_vect [| 1.0;2.0 |] [| 3.0;4.0 |];;

(*Record fields can also be modified by assignment, provided they are declared
mutable in the definition of the record type*)
type mutable_point = { mutable x: float; mutable y: float };;

let translate p dx dy = 
    p.x <- p.x +. dx; p.y <- p.y +. dy;;

let mypoint = { x = 0.0; y = 0.0 };;

translate mypoint 1.0 2.0;;

mypoint;;

(*in-place insertion sort over arrays*)
let insertion_sort a =
    for i = 1 to Array.length a - 1 do
        let val_i = a.(i) in
        let j = ref i in
        while !j > 0 && val_i < a.(!j - 1) do
            a.(!j) <- a.(!j - 1);   (*need semicolon between two phases*)
            (*use reference to assign*)
            j := !j - 1     (*semicolon is not needed here, next phase is done*)
        done;
        a.(!j) <- val_i
    done;;

(*References are also useful to write functions that maintain a current state
between two calls to the function*)
let current_rand = ref 0;;
let random () =
    current_rand := !current_rand * 25713 + 1345;
    !current_rand;;

(*there is nothing magical with references: they are implemented as a
single-field mutable record*)
type 'a ref = { mutable contents: 'a };;

let (!) r = r.contents;;

let (:=) r newval = r.contents <- newval;;

(*In some special cases, you may need to store a polymorphic function in a data
structure, keeping its polymorphism. Without user-provided type annotations, this is not 
allowed, as polymorphism is only introduced on a global level. However, you can give 
explicitly polymorphic types to record fields.*)
type idref = { mutable id: 'a. 'a -> 'a };;     (*'*)

let r = {id = fun x -> x};;

let g s = (s.id 1, s.id true);;

r.id <- (fun x -> print_string "called id\n"; x);;

g r;;

(*OCaml provides exceptions for signalling and handling exceptional conditions*)
exception Empty_List;;

let head l = 
    match l with 
    [] -> raise Empty_List
    | hd :: tl -> hd;;

head [1;2];;

head [];;

List.assoc 1 [(0, "zero"); (1, "one")];;

List.assoc 2 [(0, "zero"); (1, "one")];;

let name_of_binary_digit digit =
    try
        List.assoc digit [0, "zero"; 1, "one"]
    with Not_found ->
        "not a binary digit";;

name_of_binary_digit 0;;

name_of_binary_digit (-1);;

let temporarily_set_reference ref newval funct =
    let oldval = !ref in
    try
        ref := newval;
        let res = funct () in
        ref := oldval;
        res
    with x -> ref := oldval; raise x;;

(*Symbolic processing of expressions*)
type expression =
    Const of float
    | Var of string
    | Sum of expression * expression (* e1 + e2 *)
    | Diff of expression * expression (* e1 - e2 *)
    | Prod of expression * expression (* e1 * e2 *)
    | Quot of expression * expression (* e1 / e2 *)
    ;;

exception Unbound_variable of string;;

let rec eval env exp =
    match exp with
    Const c -> c
    | Var v -> (try List.assoc v env with Not_found -> raise (Unbound_variable v))
    | Sum(f, g) -> eval env f +. eval env g
    | Diff(f, g) -> eval env f -. eval env g
    | Prod(f, g) -> eval env f *. eval env g
    | Quot(f, g) -> eval env f /. eval env g
    ;;

eval [("x", 1.0); ("y", 3.14)] (Prod(Sum(Var "x", Const 2.0), Var "y"));;

let rec deriv exp dv =
    match exp with
    Const c -> Const 0.0
    | Var v -> if v == dv then Const 1.0 else Const 0.0
    | Sum(f, g) -> Sum(deriv f dv, deriv g dv)
    | Diff(f, g) -> Diff(deriv f dv, deriv g dv)
    | Prod(f, g) -> Sum(Prod(deriv f dv, g), Prod(f, deriv g dv))
    | Quot(f, g) -> Quot(Diff(Prod(deriv f dv, g), Prod(f, deriv g dv)), Prod(g, g))
    ;;

deriv (Quot(Const 1.0, Var "x")) "x";;

let print_expr exp =
    (*Local function definitions*)
    let open_paren prec op_prec =
         if prec > op_prec then print_string "(" in 
    let close_paren prec op_prec =
        if prec > op_prec then print_string ")" in
    let rec print prec exp =    (* prec is the current precedence *)
        match exp with
        Const c -> print_float c
        | Var v -> print_string v
        | Sum(f, g) -> 
            open_paren prec 0;
            print 0 f; print_string " + "; print 0 g;
            close_paren prec 0
        | Diff(f, g) ->
            open_paren prec 0;
            print 0 f; print_string " - "; print 1 g;
            close_paren prec 0
        | Prod(f, g) ->
            open_paren prec 2;
            print 2 f; print_string " * "; print 2 g;
            close_paren prec 2
        | Quot(f, g) ->
            open_paren prec 2;
            print 2 f; print_string " / "; print 3 g;
            close_paren prec 2
    in print 0 exp;;

let e = Sum(Prod(Const 2.0, Var "x"), Const 1.0);;

print_expr e; print_newline ();;

print_expr (deriv e "x"); print_newline ();;



(*
TITLE: The Module System
*)

(*a structure packaging together a type of priority queues and their operations*)
module PrioQueue =
    struct
        type priority = int
        type 'a queue = Empty | Node of priority * 'a * 'a queue * 'a queue
        let empty = Empty
        let rec insert queue prio elt =
            match queue with
            Empty -> Node(prio, elt, Empty, Empty)
            | Node(p, e, left, right) ->
                if prio <= p
                then Node(prio, elt, insert right p e, left)
                else Node(p, e, insert right prio elt, left)
        exception Queue_is_empty
        let rec remove_top = function
            Empty -> raise Queue_is_empty
            | Node(prio, elt, left, Empty) -> left
            | Node(prio, elt, Empty, right) -> right
            | Node(prio, elt, (Node(lprio, lelt, _, _) as left), (Node(rprio, rlet, _, _) as right)) -> 
            if lprio <= rprio
            then Node(lprio, lelt, remove_top left, right)
            else Node(rprio, relt, left, remove_top right)
        let extract = fucntion
            Empty -> raise Queue_is_empty
            | Node(prio, elt, _, _) as queue -> (prio, elt, remove_top queue)
    end;;

PrioQueue.insert PrioQueue.empty 1 "hello";;

(*Restricting the PrioQueue structure by this signature results in another view
of the PrioQueue structure where the remove_top function is not accessible and 
the actual representation of priority queues is hidden*)

module type PRIOQUEUE = 
    sig 
        type priority = int     (*still concrete*)
        type 'a queue           (*now abstract*)
        val empty: 'a queue
        val insert: 'a queue -> int -> 'a -> 'a queue
        val extract: 'a queue -> int * 'a * 'a queue 
        exception Queue_is_empty
    end;;

module AbstractPrioQueue = (PrioQueue : PRIOQUEUE);;

AbstractPrioQueue.insert AbstractPrioQueue.empty 1 "hello";;

AbstractPrioQueue.remove_top;;      (*ERROR!!!*)

(*The restriction can also be performed during the definition of the structure, as in
module PrioQueue = (struct ... end : PRIOQUEUE);;
An alternate syntax is provided for the above:
module PrioQueue : PRIOQUEUE = struct ... end;;*)

(*Functors are functions from structures to structures*)
type comparison = Less | Equal | Greater;;
module type ORDERED_TYPE =
    sig
        type t
        val compare: t -> t -> comparison
    end;;
module Set =
    functor (Elt: ORDERED_TYPE) ->
        struct 
            type element = Elt.t
                type set = element list
                let empty = []
                let rec add x s =
                match s with
                    [] -> [x]
                    | hd::tl -> 
                        match Elt.compare x hd with
                            Equal -> s      (*x is already in s*)
                            | Less -> x::s    (*x is smaller than all elements of s*)
                            | Greater -> hd::add x tl
                let rec member x s =
                    match s with
                        [] -> false
                        | hd::tl -> 
                            match Elt.compare x hd with
                                Equal -> true
                                | Less -> false
                                | Greater -> member x tl
        end;;

(*By applying the Set functor to a structure implementing an ordered
type, we obtain set operations for this type*)

module OrderedString =
    struct 
        type t = string
        let compare x y = if x = y then Equal else if x < y then Less else Greater
    end;;

module StringSet = Set(OrderedString);;

StringSet.member "bar" (StringSet.add "foo" StringSet.empty);;




