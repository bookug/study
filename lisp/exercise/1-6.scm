;#lang racket

;;is this ok to replace the 'if' phrase marked as special in scheme?
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(new-if (= 2 3) 0 5)
(new-if (= 1 1) 0 5)

;;out of memory when running, why? why is it different from original 'if'?
;;The reason is due to the recursion and the applicative way, which requires
;;to eval the result of each arg first, endless recursion because we cannot eval the sqrt-iter directly...
;;While in normal mode, if is used to decide the jump first, guess or another sqrt-iter, will not endless
;;because each time the guess is improved, and each time it is compared first!
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (sqr guess) x)) 0.001))

;;always guess from 1, this is too naive
(define (sqrt x) (sqrt-iter 1.0 x))

(sqrt 9)
