;#lang racket

;;combinations whose operations are compound expressions
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

(a-plus-abs-b 1 2)
(a-plus-abs-b 3 -1)
(a-plus-abs-b -7 5)
