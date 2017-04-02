;#lang racket

;how to check the primality of an integer n, one with the order of growth O(sqrt(n)),
;and a probabilistic algorithm with order of growth O(logn)

(load "util.scm")

(display true)
(newline)
(display (sqr 10))
(newline)
;(display (runtime))

;search for divisors(larger than 1)
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (sqr test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b) (= (remainder b a) 0))
;we can tets whether a number is prime as follows: n is prime if and only if
;n is its owna nd smallest divisor
(define (prime? n) (= n (smallest-divisor n)))

(display (smallest-divisor 199))
(display (smallest-divisor 1999))
(display (smallest-divisor 19999))

;Below tells a way to see the time of running
(define (timed-prime-test n)
  (newline)
  (display n)
  ;(start-prime-test n (runtime)))
  (start-prime-test n 0))
(define (start-prime-test n start-time)
  (if (prime? n)
      ;(report-prime (- (runtime) start-time)) false))
      (report-prime (- 100 start-time)) false))
(define (report-prime elapsed-time)
  (newline)
  (display " *** ")
  (display elapsed-time))
  true

;; search the num smallest primes larger than bound
(define (search-for-primes bound num)
  (define (iter now left)
   (cond ((= left 0) (newline) (display "end"))
	     ((timed-prime-test now) (search-for-primes (+ now 2) (- left 1)))
		 (else (search-for-primes (+ now 2) left))))
  (if (even? bound) (iter (+ bound 1) num) (iter (+ bound 2) num)))

;; the time should be almost sqrt(n)
(newline)
(display "this is for search-for-primes")
(define count 3)
(search-for-primes 10000 count)
;(search-for-primes 100000 count)
;(search-for-primes 1000000 count)
(newline)

;; BETTER: no need to test 2,3,4,5,6... but 2,3,5,7,9
;; halve the number of test steps
(define (next n) (if (= n 2) 3 (+ n 2)))
(define (smallest-divisor2 n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (sqr test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

;the Fermat test
;Fermat's Little Theorem:If n is a prime number and (a, n)=1, then a^n= a (mod n)
;we can just use a<n here, if n is not prime, generally most of the numbers a<n will not
;satisfy the above relation
;Given a number n, pick a random number a<n and compute the remainder of a^n modulo n.
;If the result is not equal to a mod n, then n is certainly not prime. Else,
;then chances are good that n is prime. Next, pick another random a and test again.
;By trying more and more values of a, we can increase our confidence in the result.
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
		 ;; NOTICE: do not use (* a b) here, lower to O(n)
         (remainder (sqr (expmod base (/ exp 2) m)) m))
        (else (remainder (* base (expmod base (- exp 1) m)) m))))
(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))
(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))
(fast-prime? 105 10)

;; NOTICE:this is not good due to higher computation cost
;(define (expmod base exp m) (remainder (fast-expt base exp) m))

;NOTICE: there do exist numbers that fool the Fermat test, not prime and yet have the property that
;a^n is congruent to a modulo n for all integers a<n
;Such numbers are extremely rare, so the Fermat test is quite reliable in practice.
;
;Numbers that fool the Fermat test are called Carmichael numbers, and little is known about them other than that they are extremely rare.
;There are 255 Carmichael numbers below 100,000,000. The smallest few are 561, 1105, 1729, 2465, 2821, and 6601. In testing primality of
;very large numbers chosen at random, the chance of stumbling upon a value that fools the Fermat test is less than the chance that
;cosmicradiation will cause the computer to make an error in carrying out a ``correct'' algorithm. Considering an algorithm to be
;inadequate for the first reason but not for the second illustrates the difference between mathematics and engineering.

(define (check-fool n)
  (display n)
  (define (iter a) 
    (cond ((< a n) (if (!= (expmod a n n) a) (display "not valid!"))  (iter (+ a 1)))
	      (else (newline) (display "end") (newline))))
  (iter 2))

(check-fool 561)
(check-fool 1105)
(check-fool 1729)
(check-fool 2465)
(check-fool 2821)
(check-fool 6601)

;; One variant of the Fermat test that cannot be fooled is called the Miller-Rabin test.
;; This starts from an alternate form of Fermat's Little Theorem, which states that if n is a
;; prime number and a is any positive integer less than n, then a raised to the (n - 1)st power is congruent to 1
;; modulo n. To test the primality of a number n by the Miller-Rabin test, we pick a random number a<n and
;; raise a to the (n - 1)st power modulo n using the expmod procedure. However, whenever we perform the squaring step in expmod, 
;; we check to see if we have discovered a nontrivial square root of 1 modulo n,
;; that is, a number not equal to 1 or n - 1 whose square is equal to 1 modulo n. It is possible to prove that if
;; such a nontrivial square root of 1 exists, then n is not prime. It is also possible to prove that if n is an odd
;; number that is not prime, then, for at least half the numbers a<n, computing a^(n-1) in this way will reveal a
;; nontrivial square root of 1 modulo n. (This is why the Miller-Rabin test cannot be fooled.) 
(define (expmod2 base exp m)
  (cond ((= exp 0) 1)
        ((even? exp) (let ((old (expmod2 base (/ exp 2) m)))
			           (if (= old 0) 
						 0 
						 (let ((new (remainder (sqr old) m)))
						   (if (and (!= old 1) (!= old (- m 1)) (= (remainder new m) 1)) 0 new)))))
        (else (remainder (* base (expmod2 base (- exp 1) m)) m))))
;; NOTICE: 0 is used as a signal here
(define (fermat-test2 n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (if (even? n) #f (try-it (+ 1 (random (- n 1))))))
(define (fast-prime?2 n times)
  (cond ((= times 0) true)
        ((fermat-test2 n) (fast-prime?2 n (- times 1)))
        (else false)))

(display (fast-prime?2 561 20))
(display (fast-prime?2 6601 20))
(newline)

