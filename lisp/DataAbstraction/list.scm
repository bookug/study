#lang racket
;; Hierarchical Data and the Closure Property

;(load "../util.scm")

;; two ways to combine 1, 2, 3, 4 using pairs
(cons (cons 1 2) (cons 3 4))
(cons (cons 1 (cons 2 3)) 4)

;; The ability to create pairs whose elements are pairs is the essence of list structure's importance as a
;; representational tool. We refer to this ability as the closure property of cons. In general, an operation for
;; combining data objects satisfies the closure property if the results of combining things with that operation
;; can themselves be combined using the same operation.
;; Closure is the key to power in any means of
;; combination because it permits us to create hierarchical structures -- structures made up of parts, which
;; themselves are made up of parts, and so on.

;; represent sequences
(define nil (list))
(cons 1 (cons 2 (cons 3 (cons 4 nil))))
;; Such a sequence of pairs, formed by nested conses, is called a list, and Scheme provides a primitive called
;; list to help in constructing lists
(define one-through-four (list 1 2 3 4))
'(1 2 3 4)
;; Be careful not to confuse the expression (list 1 2 3 4) with the list (1 2 3 4), which is the result
;; obtained when the expression is evaluated. Attempting to evaluate the expression (1 2 3 4) will signal
;; an error when the interpreter tries to apply the procedure 1 to arguments 2, 3, and 4.
;;
;; (car one-through-four)
;; 1
;; (cdr one-through-four)
;; (2 3 4)
;; (car (cdr one-through-four))
;; 2
;; (cons 10 one-through-four)
;; (10 1 2 3 4)
;; (cons 5 one-through-four)
;; (5 1 2 3 4)
;; The value of nil, used to terminate the chain of pairs, can be thought of as a sequence of no elements, the
;; empty list. The word nil is a contraction of the Latin word nihil, which means ``nothing.''
(define (list-ref items n)
  (if (= n 0)
      (car items)
	  (list-ref (cdr items) (- n 1))))
(define squares (list 1 4 9 16 25))
(list-ref squares 3)
(define (length items)
  (if (null? items)
      0
	  (+ 1 (length (cdr items)))))
(define odds (list 1 3 5 7))
(length odds)
;; another version of length, in iterative way
;(define (length items)
;  (define (length-iter a count)
;    (if (null? a)
;	    count
;		(length-iter (cdr a) (+ 1 count))))
;  (length-iter items 0))

(define (append list1 list2)
  (if (null? list1)
      list2
	  (cons (car list1) (append (cdr list1) list2))))
(append squares odds)
(append odds squares)

(define (last-pair listx)
  (define (iter l r)
    (if (null? l) r (iter (cdr l) (car l))))
  (if (null? listx) (error "empty list") (iter listx 0)))
(last-pair (list 23 72 149 34))

(define (reverse listx)
  (if (null? listx) nil (append (reverse (cdr listx)) (list (car listx)))))
(reverse (list 18 7 5 4))

;; Consider the change-counting program of section 1.2.2. It would be nice to be able to easily
;; change the currency used by the program, so that we could compute the number of ways to change a British
;; pound, for example. As the program is written, the knowledge of the currency is distributed partly into the
;; procedure first-denomination and partly into the procedure count-change (which knows that
;; there are five kinds of U.S. coins). It would be nicer to be able to supply a list of coins to be used for
;; making change.
;; We want to rewrite the procedure cc so that its second argument is a list of the values of the coins to use
;; rather than an integer specifying which coins to use. We could then have lists that defined each kind of
;; currency:
(define (no-more? listx) (null? listx))
(define (first-denomination listx) (car listx))
(define (except-first-denomination listx) (cdr listx))
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
		(else (+ (cc amount (except-first-denomination coin-values))
			     (cc (- amount (first-denomination coin-values)) coin-values)))))
(cc 100 us-coins)
;; NOTICE: the order of the list coin-values do not affect the answer produced by cc, 
;; because our procedure considers all the case

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The procedures +, *, and list take arbitrary numbers of arguments. One way to define
;; such procedures is to use define with dotted-tail notation. In a procedure definition, a parameter list that
;; has a dot before the last parameter name indicates that, when the procedure is called, the initial parameters
;; (if any) will have as values the initial arguments, as usual, but the final parameter's value will be a list of
;; any remaining arguments. For instance, given the definition
;; (define (f x y . z) <body>)
;; (f 1 2 3 4 5 6)
;; x is 1, y is 2, z is the (3 4 5 6)

;; takes one or more integers and returns a list of
;; all the arguments that have the same even-odd parity as the first argument
(define (same-parity x . z)
  (define sign (remainder x 2))
  (define (rf l)
      (if (null? l) nil 
		            (let ((t (car l)) (next (rf (cdr l))))
					  (if (= (remainder t 2) sign) (cons t next) next))))
  (if (null? z) x (cons x (rf z))))
(same-parity 1 2 3 4 5 6 7 )
;; 1 3 5 7
(same-parity 2 3 4 5 6 7)
;; 2 4 6

;; mapping over lists
;; One extremely useful operation is to apply some transformation to each element in a list and generate thelist 
;; of results. For instance, the following procedure scales each number in a list by a given factor:
(define (scale-list items factor)
  (if (null? items)
      nil
	  (cons (* (car items) factor)
	        (scale-list (cdr items) factor))))
(scale-list (list 1 2 3 4 5) 10)
(define (map proc items)
  (if (null? items)
      nil
	  (cons (proc (car items)) 
	        (map proc (cdr items)))))
(map abs (list -10 2.5 -11.6 17))
(map (lambda (x) (* x x)) (list 1 2 3 4))
;; a new definition of scale-list using map
;(define (scale-list items factor)
;  (map (lambda (x) (* x factor)) items))
;;
;;Map is an important construct, not only because it captures a common pattern, but because it establishes a
;;higher level of abstraction in dealing with lists. In the original definition of scale-list, the recursive
;;structure of the program draws attention to the element-by-element processing of the list. Defining scale-
;;list in terms of map suppresses that level of detail and emphasizes that scaling transforms a list of
;;elements to a list of results. The difference between the two definitions is not that the computer is
;;performing a different process (it isn't) but that we think about the process differently. In effect, map helps
;;establish an abstraction barrier that isolates the implementation of procedures that transform lists from the
;;details of how the elements of the list are extracted and combined.

;;two different definitions of square-list
;(define (square-list items)
;  (if (null? items)
;      nil
;	  (cons (sqr (car items)) (square-list (cdr items)))))
;(define (square-list items)
;  (map sqr items))
;; Louis Reasoner tries to rewrite the first square-list procedure of exercise 2.21 so that
;; it evolves an iterative process
(define (square x) (* x x))
(define (square-list items)
 (define (iter things answer)
  (if (null? things)
   answer
   (iter (cdr things)
	(cons (square (car things))
	 answer))))
 (iter items nil))
(square-list (list 1 2 3 4))
;; Unfortunately, defining square-list this way produces the answer list in the reverse order of the one
;; desired. Louis then tries to fix his bug by interchanging the arguments to cons:
;(define (square-list items)
; (define (iter things answer)
;  (if (null? things)
;   answer
;   (iter (cdr things)
;	(cons answer
;	 (square (car things))))))
; (iter items nil))
;;
;; this does not work either, because we need to ensure the b is a list when using (cons a b) to produce a list
;; however, (square (car things)) is just a number, We can modify it as follows:
;(define (square-list items)
;  (define (iter things answer)
;    (if (null? things) answer
;	                   (iter (cdr things) (append answer (list (sqr (car things)))))))
;  (iter items nil))

;; The procedure for-each is similar to map. It takes as arguments a procedure and a list of
;; elements. However, rather than forming a list of the results, for-each just applies the procedure to each
;; of the elements in turn, from left to right. The values returned by applying the procedure to the elements are
;; not used at all -- for-each is used with procedures that perform an action, such as printing.
;; The value returned by the call to for-each (not illustrated above) can be something arbitrary, such as true
(define (for-each proc items)
  (cond
    ((not (null? items))
    (proc (car items)) 
	 (for-each proc (cdr items)))))
(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))










