;;quick-sort program using racket
;;http://www.tuicool.com/articles/VneMVrz

#lang racket

(define (quick-sort array)
  (cond
    [(empty? array) empty]
    ;the basic idea is divide and recursive
    [else (append
           (quick-sort (filter (lambda (x) (< x (first array))) array)) ;array is a closure here
           (filter (lambda (x) (= x (first array))) array)
           (quick-sort (filter (lambda (x) (> x (first array))) array)))]))

(quick-sort '(1 3 2 5 3 4 5 0 9 82 4))