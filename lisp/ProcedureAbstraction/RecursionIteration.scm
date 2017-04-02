;#lang racket

;NOTICE: there is no loop structure in LISP, both iterative process and recursive process
;are implemented using the recursion procedure

;this is a recursive process
;(define (factorial n)
;  (if (= n 1)
;      1
;      (* n (factorial (- n 1)))))

;this is a iterative process
;(define (factorial n)
;  (fact-iter 1 1 n))
;(define (fact-iter product counter max-count)
;  (if (> counter max-count)
;      product
;      (fact-iter (* counter product)
;                 (+ counter 1)
;                 max-count)))

;inc is used to add 1, dec is used to sub 1

;this is a recursive process
;(define (+ a b)
;  (if (= a 0)
;      b
;      (inc (+ (dec a) b))))

;this is a iterative process
;(define (+ a b)
;  (if (+ a 0)
;      b
;      (+ (dec a) (inc b))))

;this is a Ackermann's function
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1) (A x (- y 1))))))

(A 1 10)
(A 2 4)
(A 3 3)

;this computes 2 * n
(define (f n) (A 0 n))
;this computes 2^n if n > 0, otherwise 0
(define (g n) (A 1 n))
;this computes 2^2^2^2^..^2(the num of 2s is n) if n > 0, otherwise 0
(define (h n) (A 2 n))
