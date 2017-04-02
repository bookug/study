(load "util.scm")
(define (average-damp f) (lambda (x) (/ (+ x (f x)) 2)))
(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (/ (abs (- v1 v2)) v2) tolerance))
  (define (try guess)
    (let ((next (f guess)))
	  (if (close-enough? guess next)
	      next
		  (try next))))
  (try first-guess))

(define (compose f g) (lambda (x) (f (g x))))
(define (repeated f times) 
  (if (= times 1) f (compose f (repeated f (- times 1)))))

;; Here's a first attempt at an nth-root procedure, which works when n is 2 or 3.
(define (nth-root x n)
   (fixed-point
	 (average-damp
	   (lambda (y) (/ x (expt y (- n 1)))))
	 1.0))
(display (nth-root 100 2))
(newline)
;; 10.0
(display (nth-root 1000 3))
(newline)
;; 10.000002544054729
;;
;; The same procedure does not work for fourth roots. Try running nth-root with the following parameters and you'll see that the procedure never finishes.
;;
;(nth-root 10000 4)
;(nth-root 256 4)
;; This is because the fixed-point search for y → x / y3 doesn't converge when only one average damp is used. We can fix this by damping the average twice.
(define (nth-root2 x n)
   (fixed-point
		((repeated average-damp 2)
				(lambda (y) (/ x (expt y (- n 1)))))
					 1.0))
;; We'll need to run the new procedure several times to find out where average damping twice fails to converge. The code above works for finding nth roots when n is less than 8.
(display (nth-root2 10000 4))
(newline)
;; 10.0
(display (nth-root2 100000 5))
(newline)
;; 9.99999869212542
(display (nth-root2 1000000 6))
(newline)
;; 9.999996858149522
(display (nth-root2 10000000 7))
(newline)
;; 9.9999964240619
;; Let's increase the repetitions of average-damp one more time and see if we can spot a pattern.
(define (nth-root3 x n)
  (fixed-point
	((repeated average-damp 3)
			(lambda (y) (/ x (expt y (- n 1)))))
				 1.0))
;;
(nth-root3 256 8)
;;                     2.0000000000039666
(nth-root3 512 9)
;;                     1.9999997106840102
(nth-root3 1024 10)
;;                     2.000001183010332
(nth-root3 2048 11)
;;                     1.999997600654736
(nth-root3 4096 12)
;;                     1.9999976914703093
(nth-root3 8192 13)
;;                     2.0000029085658984
(nth-root3 16384 14)
;;                     1.9999963265447058
(nth-root3 32768 15)
;;                     2.0000040951543023
;; When we average damp 3 times, the nth-root procedure converges for n up to 15. That worked longer than I expected, but it gives us enough information to see the pattern. When n (roughly) doubles, we need to increase the number of average damps by one.
;;
;; maximum n: 3, 7, 15
;; average damps: 1, 2, 3
;;
;; Where a is the number of average damps, we can say
;; Nmax = 2^(a+1) - 1
;; We can test this by checking to see that by increasing the number of average damps to four, our nth-root procedure works for values of n up to 31.
;; (define (nth-root x n)
;;   (fixed-point
;;         ((repeated average-damp 4)
;;                  (lambda (y) (/ x (expt y (- n 1)))))
;;                        1.0))
;;
;;                        > (nth-root 2147483648 31)
;;                        1.9999951809750391
;; Just as expected, the procedure fails to converge if we run it with n = 32. I'm convinced that this is the right pattern.

