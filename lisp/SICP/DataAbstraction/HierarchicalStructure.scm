#lang racket

;; Recursion is a natural tool for dealing with tree structures, since we can often reduce operations on trees to
;; operations on their branches, which reduce in turn to operations on the branches of the branches, and so on,
;; until we reach the leaves of the tree.

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define x (cons (list 1 2) (list 3 4)))
(length x)
(count-leaves x)
(define y (list x x))
(length y)
(count-leaves y)
(define z (cons x x))
(length z)
(count-leaves z)

(define x1 (list 1 2 3))
(define y1 (list 4 5 6))
(append x1 y1)
(cons x1 y1)
(list x1 y1)

(define nil (list))

(define (reverse listx)
  (if (null? listx) nil
      (append (reverse (cdr listx)) (list (car listx)))))

(define (deep-reverse listx)
  (cond ((null? listx) nil)
        ((pair? listx) (append (list (reverse (car (cdr listx)))) (list (reverse (car listx)))))
        (else (list listx))))

(define qq (list (list 1 2) (list 3 4)))
qq
(reverse qq)
(deep-reverse qq)

(define (fringe x)
  (if (not (null? x))
      (if (pair? x)
          (append (fringe (car x)) (fringe (cdr x)))
          (list x))
      nil))
(fringe '(1 2))
(fringe qq)
(fringe (list qq qq))

