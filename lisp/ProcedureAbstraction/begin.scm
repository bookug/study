;#lang racket

;(define v 10)
;(load "test.scm")
;there are many ways to define the square method
;(define (square x) (* x x ))
;(define (square x) (exp (double (log x))))
;(define (double x) (+ x x))
(display "Hello World!")
(newline)

;;number
5
-7
2.0
2/3
17/3
3.141592653
#i1.4142135623731

;pi

;;arithmetic
(+ 5 5)
(+ -3 2)
(- 7 8)
(* 3 4)
(/ 8 12)
(quotient 12 8)
(* (+ 2 2) (/ (* (+ 3 5) (/ 30 10)) 2))
;;advanced
(sqrt 100)
(sqrt 7)
(sqrt -1)
(expt 2 3)
(remainder 100 8)
(log 100000000000000000000000000000000000000000000)  ;;the natural logarithm
(sin 1)
;(sqr 1.7)
(max 1 2)
(min 1.2 0.8)
(tan 0)
;(tan pi)
;(print "this is random")
(random 2)   ;random n : 0 ~ n-1
(newline)

;;variable and program
(define (area-of-disk r)
  (* 3.14 (* r r)))
(area-of-disk 5)
(define (area-of-ring outer inner)
  (- (area-of-disk outer)
     (area-of-disk inner)))

(area-of-ring 5 3)

;;several exercises here
(define (Fahrenheit->Celsius tmp) (* (/ 5 9) (- tmp 32)))
;;use teachpack convert.ss to check, which includes convert-gui, convert-repl and convert-file
;;(convert-gui Fahrenheit->Celsius)
;;(convert-repl Fahrenheit->Celsius)
;;(convert-file "in.dat" Fahrenheit->Celsius "out.dat")
(Fahrenheit->Celsius 32)
(Fahrenheit->Celsius 212)
(Fahrenheit->Celsius -40)
(define (dollar->euro d) (* 1.17 d))
(define (triangle side height) (* 1/2 side height))
(define (convert3 ones tens hundreds) (+ ones (* 10 tens) (* 100 hundreds)))
(convert3 1 2 3)
(define (f0 n) (+ (/ n 3) 2))
(define (f1 n) (+ (* n n) 10))
(define (f2 n) (+ 20 (* 1/2 n n)))
(define (f3 n) (- 2 (/ 1 n)))
(define (wage h) (* 12 h))
(define (tax w) (* 0.15 w))
(define (netpay h) (- (wage h) (tax (wage h))))
(define (sum-of-coins pennies nickels dimes quarters)
  (+ (* pennies 1) (* nickels 5) (* dimes 10) (* quarters 25)))
(define (total-profit customers)
  (- (* 5 customers) (+ 20 (* .50 customers))))

;;errors
;;(+ (10) 20)
;;(10 + 20)
;;(+ +)
;;(define (f 1) (+ x 10))
;;(define (g x) + x 10)
;;(define h(x) (+ x 10))
;;not all legal Scheme expressions have a result
;;(/ 1 0)
;;(f0 5 8)
;;(+ 5 (/ 1 0))
;;(sin 10 20)
;;(somef 10)
;;(define (somef x) (sin x x))
;;(somef 10)
;;(somef 10 20)
;;NOTICE: logical errors not triger any error messages but the result is incorrect

;;the development of a program requires at least the following four activities:
;; Contract: area-of-ring : number number  ->  number
;; Purpose: to compute the area of a ring whose radius is
;; outer and whose hole has a radius of inner
;; Example: (area-of-ring 5 3) should produce 50.24
;; Definition: [refines the header]
;;(define (area-of-ring outer inner)
;;  (- (area-of-disk outer)
;;     (area-of-disk inner)))
;; Tests:
;;(area-of-ring 5 3) 
;; expected value
;;50.24

