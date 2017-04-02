;;usage and notifications of racket(scheme)

#lang racket

;;three different ways of defining functions
(define (f1 a b) (+ a b))
(f1 1 2)
;(f1 1)
(define f2 (lambda (a b) (+ a b)))
(f1 2 3)
;(f1 2)
;below is the most normal, original and formal
(define f3 (lambda (a) (lambda (b) (+ a b))))
(f3 3)
;(f3 4 5)
((f3 4) 5)

