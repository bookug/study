#lang racket

;; this is the basic definition of Y combinator, to implement recursive callings in program langauge, maybe endless

(define Y (lambda (f) ((lambda (x) (f (x x))) (lambda (x) (f (x x))))))
;Y f = f (Y f) = f (f (Y f))
;(Y +)