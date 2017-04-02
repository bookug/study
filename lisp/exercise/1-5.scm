;#lang racket

;;to determine whether the interpreter is using applicative-order or normal-order evaluation
;;normal order: fully expand and then reduce
;;applicative order: evaluate the arguments and then apply(this is the default way that the interpreter uses)

(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

;;ok if using normal order due to conditional jump; endless loop if using applicative order
;;evaluation the (p) will cause error, but expanding will not(stop when the same)
(test 0 (p))
