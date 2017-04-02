;#lang racket

(define (f n)
  (cond ((< n 3) n)
        (else (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3)))))))

(f 2)
(f 7)

(define (g n)
  (iter 2 1 0 n))
(define (iter t1 t2 t3 count)
  (if (= count 0)
      t3
      (iter (+ t1 (* 2 t2) (* 3 t3)) t1 t2 (- count 1))))

(g 2)
(g 7)
