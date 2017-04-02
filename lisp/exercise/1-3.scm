;#lang racket



(define (g x y) (+ (sqr x) (sqr y)))

(define (f x y z)
  (cond ((less x y z) (g y z))
        ((less y x z) (g x z))
        (else (g x y))))

;;(f 1 2 3)

(define (less x y z) (and (< x y) (< x z)))

(f 3 5 4)
