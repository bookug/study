;#lang racket

;to compute sine value, use two rules:
;1. sinx is close to x if x is sufficiently small
;2. trigonometric identity: sinr = 3 * sin(r/3) - 4 * (sin(r/3)) ^ 3

(define (cube x) (* x x x))

(define (p x) (- (* 3 x) (* 4 (cube x))))

;the time/space complexity are both O(loga)
(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))

(sine 1)
(sin 1)
