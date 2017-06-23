#lang racket

;; NOTICE: literature programming is suggested due to its readability

(define (area-of-disk r)
  (* r r))

;; The design recipe: A complete example, we should design to handle problems in steps below
;; http://www.htdp.org/2003-09-26/Book/curriculum-Z-H-5.html

;; Contract: area-of-ring : number number  ->  number

;; Purpose: to compute the area of a ring whose radius is
;; outer and whose hole has a radius of inner

;; Example: (area-of-ring 5 3) should produce 50.24

;; Definition: [refines the header]
(define (area-of-ring outer inner)
  (- (area-of-disk outer)
     (area-of-disk inner)))
  
;; Tests:
(area-of-ring 5 3) 
;; expected value
50.24

