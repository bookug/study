;#lang racket

;tree recursion is usually highly inefficient, but often easy to specify and understand
;one can get the best of both worlds by designing a smart compiler that could transform
;tree-recursive procedures into more efficient procedures that compute the same result

;too many duplicate computations in this function
;the steps num is equal to the leaves in the recursion tree, which is also fib(n)
;In addition, fib(n) is the closet interger to t^n/sqrt(5)
;t=(1+sqrt(5))/2 close to 1.6180, t^2 = t+1, the golden ratio
;we can prove that fib(n) = ((1+sqrt(5))/2 - (1-sqrt(5))/2) / sqrt(5)
(define (fib1 n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib1 (- n 1))
                 (fib1 (- n 2))))))

(define (fib2 n) (fib-iter 1 0 n))
(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

;O(2^(max(m,n))) steps required, the best one should be O(m*n)
(define (count-change amount)
  (cc amount 5))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount (- kinds-of-coins 1))
                 (cc (- amount (first-denomination kinds-of-coins)) kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))
(count-change 100)

