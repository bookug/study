;#lang racket

(expt 3 2)

;O(n) time, O(n) space
(define (expt2 b n)
  (if (= n 0)
      1
      (* b (expt2 b (- n 1)))))

(define (expt3 b n)
  (expt-iter b n 1))

;O(n) time, O(1) space
(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b
                 (- counter 1)
                 (* b product))))

;we can do better to improve the efficiency
;O(logn) both in time and space
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (sqr (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))

;the iterative version

(define (fast2 b n)
  (iter b n 1))

;NOTICE: b^n = (b^(n/2))^2 = (b^2)^(n/2)
(define (iter b n a) 
  (cond ((= n 0) a)
        ((even? n) (iter (sqr b) (/ n 2) a))
        ((odd? n) (iter (sqr b) (/ (- n 1) 2) (* a b)))))

(fast2 2 10)

;the exponentation algorithms are based on repeated multiplication
;of course, we can also perform interger multiplication by means of repeated addition
(define (mul a b)
  (if (= b 0)
      0
      (+ a (mul a (- b 1)))))

;provide some primitive functions
(define (double x) (* 2 x))
(define (halve x) (/ x 2))

(define (mul2 a b)
  (define (mul-iter a b c)
    (cond ((= b 1) (+ c a))
          ((even? b) (mul-iter (double a) (halve b) c))
          (else (mul-iter (double a) (halve (- b 1)) (+ c a)))))
  (mul-iter a b 0))

(mul2 3 5)
(mul 1 100)

;a clever algorithm to compute Fibonacci numbers in a logarithmic number of steps
(define (fib n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   ;find p' and q', then T(p',q') = T(p,q) ^ 2 <=> twice T(p,q)
                   (+ (sqr q) (sqr p))
                   (+ (sqr q) (* 2 p q))
                   (/ count 2)))
        ;this just do once T(p,q)
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))
(fib 3)
(fib 7)
