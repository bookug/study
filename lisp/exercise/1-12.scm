;#lang racket

;below is called Pascal's triangle, which is used to draw C(n, m)
;     1
;   1   1
;  1  2  1
; 1  3  3  1
;1  4  6  4 1
;the numbers at the edge of the triangle ar eall 1, and each number inside is the sum of the two above it

;count from top->down, left->right
(define (f h w)  ;the height and width of the position, 0<=w<=h 
  (cond ((or (= w 0) (= w h)) 1)
        (else (+ (f (- h 1) (- w 1)) (f (- h 1) w)))))
(f 4 2)




