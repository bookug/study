;;https://en.wikipedia.org/wiki/Church_encoding

#lang racket

;;Church numerals
(define zero (lambda (f) (lambda (x) x)))
(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))
;;methods
(define succ (lambda (n) (lambda (f) (lambda (x) (f ((n f) x))))))
(define plus (lambda (m) (lambda (n) (lambda (f) (lambda (x) ((m f) ((n f) x)))))))
(define mult (lambda (m) (lambda (n) (lambda (f) (m (n f))))))
;;n f x=f^n x -> n m f=m^n f, so exp m n = m^n = n m
(define exp (lambda (m) (lambda (n) (n m))))
;;The predecessor function must return a function that applies its parameter n - 1 times.
;;This is achieved by building a container around f and x, which is initialized in a way that omits the application of the function the first time. 
;;https://en.wikipedia.org/wiki/Church_encoding#Derivation_of_predecessor_function
(define pred (lambda (n) (lambda (f) (lambda (x) (((n (lambda (g) (lambda (h) (h (g f))))) (lambda (u) x)) (lambda (u) u))))))
;;Note that in Church encoding: pred(0)=0 m<n->m-n=0 
(define minus (lambda (m) (lambda (n) ((n pred) m))))
;;Translation with other representations
;;Integer -> Church Integer
(define church (lambda (n) (lambda (f) (lambda (x) (f (((church (- n 1)) f) x))))))
;;Church Integer -> Integer
(define unchurch (lambda (cn) ((cn (+ 1)) 0)))

;;Church Booleans
(define true (lambda (a) (lambda (b) a)))
(define false (lambda (a) (lambda (b) b)))
(define and (lambda (p) (lambda (q) ((p q) p))))
(define or (lambda (p) (lambda (q) ((p p) q))))
;;This is only a correct implementation if the evaluation strategy is applicative order
(define not1 (lambda (p) (lambda (a) (lambda (b) ((p b) a)))))
;;This is only a correct implementation if the evaluation strategy is normal order
(define not2 (lambda (p) ((p false) true)))
;;we use normal order(call-by-value) here
(define not not2)
(define xor (lambda (a) (lambda (b) ((a (not b)) b))))
(define if (lambda (p) (lambda (a) (lambda (b) ((p a) b)))))
;;A predicate is a function that returns a Boolean value
(define IsZero (lambda (n) ((n (lambda (x) false)) true)))
(define LEQ (lambda (m) (lambda (n) (IsZero ((minus m) n)))))
(define EQ (lambda (m) (lambda (n) (and ((LEQ m) n) ((LEQ n) m)))))

;;Church pairs, implementation of cons/car/cdr
(define pair (lambda (x) (lambda (y) (lambda (z) ((z x) y)))))
(define first (lambda (p) (p (lambda (x) (lambda (y) x)))))
(define second (lambda (p) (p (lambda (x) (lambda (y) y)))))

;;List encodings
;;five basic operations:nil isnil cons head tail
;;1. two pairs as a list node
(define nil ((pair true) true))
(define isnil (lambda (z) (first z)))
(define cons (lambda (h) (lambda (t) (pair false (pair h t)))))
(define head (lambda (z) (first (second z))))
(define tail (lambda (z) (second (second z))))
;;2. one pair as a list node
(define cons2 pair)
(define head2 first)
(define tail2 second)
(define nil2 false)
(define isnil2 (lambda (l) ((l (lambda (h) (lambda (t) (lambda (d) false)))) true)))
;;3. represent the list using right fold
(define nil3 (lambda (c) (lambda (n) n)))
(define isnil3 (lambda (l) ((l (lambda (h) (lambda (t) false))) true)))
(define cons3 (lambda (h) (lambda (t) (lambda (c) (lambda (n) ((c h) ((t c) n)))))))
(define head3 (lambda (l) ((l (lambda (h) (lambda (t) h))) false)))
(define tail3 (lambda (l) (lambda (c) (lambda (n) (((l (lambda (h) (lambda (t) (lambda (g) ((g h) (t c)))))) (lambda (t) n)) (lambda (h) (lambda (t) t)))))))

;;advanced topics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Another way of defining pred
(define f (lambda (p) (((second p) ((pair (first p)) false)) (pair ((succ (first p)) false)))))
(define pc0 ((pair (lambda (f) (lambda (x) x))) true))
(define pred2 (lambda (n) (first ((n f) pc0))))
;;Division
;(define divide (lambda (n) ((lambda (f) (lambda (x) x x) (lambda (x) (f (x x)))))
;                 (lambda (c) (lambda (n) (lambda (f) (lambda (x) (lambda (d) (lambda (n) (n (lambda (x) (lambda (a) (lambda (b) b))) (lambda (a) (lambda (b) a)))
;                                                                              d ()))))))))
;
;;Signed numbers
(define convertS (lambda (x) ((pair x) 0)))
(define negS (lambda (x) ((pair (second x)) (first x))))
;
;;Rational and real numbers




















