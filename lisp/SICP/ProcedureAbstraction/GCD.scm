;#lang racket

;to find out the Greatest Common Divisors, you can fact and search for common factors
;however, below is a more efficient version

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(gcd 69 78)
(gcd 16 24)


;the fact that the number of steps required by Euclid's Algorithm has logarithmic growth bears
;an interesting relation to the Fibonacci numbers
;If the process takes k steps, then the smaller one n >= Fib(k) close to ((1+sqrt(5))/2)^k/sqrt(5)
;Therefore the number of steps k grows as the logarithm(to the base (1+sqrt(5))/2) of n

;4 remainder operations are actually performed in the applicative-order evaluation
;if using normal order evaluation, the operations num is too large!
(gcd 206 40)

