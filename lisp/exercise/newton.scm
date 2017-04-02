;#lang racket

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess  x)
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
(sqrt (+ 100 37))
(sqrt (+ (sqrt 2) (sqrt 3)))
(sqr (sqrt 1000))
;inaccurate for very small one due to the compare precision
(sqrt 0.00000000000000000001)
;inaccurate for very large one because the precision is too smaller than the difference between two large numbers
;This will cause endless loop.
;(sqrt 1000000000000000000000000000000000000000000000000000000000000)
;let's improve the method
(define (sqrt-iter2 guess x)
  (if (good-enough?2 guess (improve guess x))
      guess
      (sqrt-iter2 (improve guess  x)
                 x)))
;function overlap isnot allowed
(define (good-enough?2 old-guess new-guess)
  (> 0.01 (/ (abs (- new-guess old-guess)) old-guess)))

;always guess from 1, this is too naive
(define (sqrt2 x) (sqrt-iter2 1.0 x))

;it seems not so efficient?
(sqrt 0.00009)
;(sqrt 0.00000000000000000001)
;(sqrt 1000000000000000000000000000000000000000000000000000000000000)

;(improve guess x) is called duplicate times, we can use let to avoid it
(define (sqrt-iter3 old-guess x)
  (let ((new-guess (improve old-guess x)))
    (if (good-enough?2 old-guess new-guess)
        new-guess
        (sqrt-iter3 new-guess x))))

;eval the cude root using newton method
;y is an approximation to the cube root of x
(define (cube x)
;use internal definitions and block structure here
  (define (cube-iter old-guess) ;no need to include x as parameter now
    (let ((new-guess (improve2 old-guess)))
      (if (good-enough?2 old-guess new-guess)
        new-guess
        (cube-iter new-guess))))
;QUERY: is this formula right?
  (define (improve2 old-guess)
    (/ (+ (/ x (sqr old-guess)) (* 2 old-guess)) 3))
  (cube-iter 1.0))

(cube 8)
(cube 3)

