#lang racket
(define (quick-sort array)
  (cond
    [(empty? array) empty]                                                    ; 快排的思想是分治+递归
    [else (append 
           (quick-sort (filter (lambda (x) (< x (first array))) array))       ; 这里的 array 就是闭包   
           (filter (lambda (x) (= x (first array))) array)
           (quick-sort (filter (lambda (x) (> x (first array))) array)))]))

(quick-sort '(1 3 2 5 3 4 5 0 9 82 4))
;; 运行结果 '(0 1 2 3 3 4 4 5 5 9 82)
