
(load "util.scm")

;; linear recursion
(define (sum term a next b)
  (if (> a b)
      0
	  (+ (term a) 
	     (sum term (next a) next b))))

;; an iterative version
(define (sum2 term a next b)
  (define (iter a result)
    (if (> a b)
	    result
		(iter (next a) (+ b (term a)))))
  (iter a 0))

(define (inc n) (+ n 1))
(define (sum-cubes a b) (sum cube a inc b))
(sum-cubes 1 10)

;(define (identity x) x)
(define (sum-integers a b) (sum identity a inc b))
(sum-integers 1 10)

(define (pi-sum a b)
  (define (pi-term x) (/ 1.0 (* x (+ x 2))))
  (define (pi-next x) (+ x 4))
  (sum pi-term a pi-next b))

;; the approximation of pi
(* 8 (pi-sum 1 1000))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))
;; the exact value is 1/4
(display (integral cube 0 1 0.01))
(newline)
(display (integral cube 0 1 0.001))
(newline)

;; Simpson's Rule is a more accurate method of numerical integration
;; the integral of a function f between a and b is approximated as:
;; h/3 * (y(0) + 4y(1) + 2y(2) + 4y(3) + 2y(4) +...+ 2y(n-2) + 4y(n-1) + y(n))
;; where h=(b-a)/n, for some even integer n, and y(k)=f(a+kh)
;; You can increase the accuracy of teh approximation by increasing n.
(define (simpson-integral f a b n)
  (define h (/ (- b a) n))
  ;(define (add x) (+ x h))
  (define (g k) 
    (define t (f (+ a (* k h))))
    (cond ((or (= k 0) (= k n)) t)
	      ((= k (- n 1)) (* 4 t))
		  ((even? k) (* 2 t))
		  (else (* 4 t))))
  (* (sum g 0 inc n)
     (/ h 3.0)))

(display (simpson-integral cube 0 1 100))
(newline)
(display (simpson-integral cube 0 1 1000))
(newline)

;; We can also define other high order procedure abstractions
(define (product term a next b)
  (if (> a b)
      1
	  (* (term a) 
	     (product term (next a) next b))))

;; this is an iterative one
(define (product2 term a next b)
  (define (iter a result)
    (if (> a b)
	    result
		(iter (next a) (* b (term a)))))
  (iter a 1))

(define (factorial n)
  (product identity 1 inc n))
(display (factorial 4))

(newline)
(display pi)
(newline)
;; another formula to compute approximation of pi
;; pi/4 = 2 * 4 * 4 * 6 * 6 * 8...
;;        ------------------------
;;        3 * 3 * 5 * 5 * 7 * 7...
(define (inc2 x) (+ x 2))
(display (* 4 (/ (* 2 20 (sqr (product identity 4 inc2 18))) (sqr (product identity 3 inc2 19)))))
(newline)	

;; sum and product are both special cases of a more general notion
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
	  (combiner (term a)
	            (accumulate combiner null-value term (next a) next b))))

(define (accumulate2 combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
	    null-value
		(iter (next a) (combiner (term a) result))))
  (iter a null-value))

(define (sum3 term a next b)
  (accumulate + 0 term a next b))
(define (product3 term a next b)
  (accumulate * 1 term a next b))

;; an even more general version of accumulate by introducing the notion of a filter on the terms to be combined
(define (filtered-accumulate combiner null-value term a next b filter)
  (define t (term a))
  (cond ((> a b) null-value)
	    ((filter t) combiner t (filtered-accumulate combiner null-value term (next a) next b filter))
		(else (filtered-accumulate combiner null-value term (next a) next b filter))))

;; the sum of the squares of the prime numbers in the interval a to b
(define (special-sum a b)
  (filtered-accumulate + 0 sqr a inc b prime?))

;; the product of all the positive integers less than n that are relatively prime to n
(define (special-product n)
  (define (relatively-prime i) (= (gcd i n) 1))
  (filtered-accumulate * 1 identity 1 inc (- n 1) relatively-prime))

