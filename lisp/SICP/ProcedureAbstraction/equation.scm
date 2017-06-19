;; procedures as general methods

;; find roots of equations by by the half-interval method
(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
	    mid-point
		(let ((test-value (f midpoint)))
		  (cond ((positve? test-value) (search f neg-point midpoint))
		        ((negative? test-value) (search f midpoint pos-point))
				(else midpoint))))))

(define (close-enough? x y) (< (abs (- x y)) 0.001))

(define (half-interval-method f a b)
  (let ((a-value (f a))
		(b-value (f b)))
    (cond ((and (negative? a-value) (positve? b-value)) (search f a b))
	      ((and (negative? b-value) (positve? a-value)) (search f b a))
		  (else (error "values are not of opposite sign" a b)))))

(half-interval-method sin 2.0 4.0)
(half-interval-method (lambda (x) (- (* x x x) (* 2 x) 3)) 1.0 2.0)

;; find fixed points of functions: f(x)=x
;; for some f, we can locate a fixed point by beginning with an initial guess and applying f repeatedly
;; until the value does not change very much
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

(fixed-point cos 1.0)
(fixed-point (lambda (y) (+ (sin y) (cos y))) 1.0)

;; compute sqrt(x): y^2=x y=x/y
;; Unfortunately, this fixed-point search does not converge. Consider an initial guess y 1 . The next guess is y 2
;; = x/y 1 and the next guess is y 3 = x/y 2 = x/(x/y 1 ) = y 1 . This results in an infinite loop in which the two
;; guesses y 1 and y 2 repeat over and over, oscillating about the answer.
(define (sqrt x)
  (fixed-point (lambda (y) (/ x y)) 1.0))

(define (average-damp f) (lambda (x) (/ (+ x (f x)) 2)))

;; One way to control such oscillations is to prevent the guesses from changing so much. Since the answer is
;; always between our guess y and x/y, we can make a new guess that is not as far from y as x/y by averaging
;; y with x/y, so that the next guess after y is (1/2)(y + x/y) instead of x/y.
;; Note that y=(1/2)(y+x/y) is a simple transformation of the equation y=x/y
;; This approach of averaging successive
;; approximations to a solution, a technique we that we call average damping, often aids the convergence of
;; fixed-point searches.
(define (sqrt x)
  (fixed-point ((average-damp (lambda (y) (/ x y))) 1.0)))

;; Unfortunately, the process does not work for fourth roots -- a single average damp is not enough 
;; to make a fixed-point search for y=x/y^3 converge. 
;; On the other hand, if we average damp twice (i.e., use the average damp of the average
;; damp of y=x/y^3) the fixed-point search does converge. 
;; Do some experiments to determine how many average damps are required to compute nth roots as a fixed-point 
;; search based upon repeated average damping of y=x/y^(n-1).
(load "lambda.scm")
;; Here's a first attempt at an nth-root procedure, which works when n is 2 or 3.
;; (define (nth-root x n)
;;   (fixed-point
;;     (average-damp
;;       (lambda (y) (/ x (expt y (- n 1)))))
;;     1.0))
;;
;; > (nth-root 100 2)
;; 10.0
;; > (nth-root 1000 3)
;; 10.000002544054729
;;
;; The same procedure does not work for fourth roots. Try running nth-root with the following parameters and you'll see that the procedure never finishes.
;;
;; > (nth-root 10000 4)
;; This is because the fixed-point search for y → x / y3 doesn't converge when only one average damp is used. We can fix this by damping the average twice.
;;
;; (define (nth-root x n)
;;   (fixed-point
;;        ((repeated average-damp 2)
;;                (lambda (y) (/ x (expt y (- n 1)))))
;;                     1.0))
;; We'll need to run the new procedure several times to find out where average damping twice fails to converge. The code above works for finding nth roots when n is less than 8.
;; > (nth-root 10000 4)
;; 10.0
;; > (nth-root 100000 5)
;; 9.99999869212542
;; > (nth-root 1000000 6)
;; 9.999996858149522
;; > (nth-root 10000000 7)
;; 9.9999964240619
;; Let's increase the repetitions of average-damp one more time and see if we can spot a pattern.
;; (define (nth-root x n)
;;   (fixed-point
;;        ((repeated average-damp 3)
;;                (lambda (y) (/ x (expt y (- n 1)))))
;;                     1.0))
;;
;;                     > (nth-root 256 8)
;;                     2.0000000000039666
;;                     > (nth-root 512 9)
;;                     1.9999997106840102
;;                     > (nth-root 1024 10)
;;                     2.000001183010332
;;                     > (nth-root 2048 11)
;;                     1.999997600654736
;;                     > (nth-root 4096 12)
;;                     1.9999976914703093
;;                     > (nth-root 8192 13)
;;                     2.0000029085658984
;;                     > (nth-root 16384 14)
;;                     1.9999963265447058
;;                     > (nth-root 32768 15)
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
;;
;; In order to calculate the number of average damps from n, we just need to take the log2 of n then floor the result. 
;; Since Scheme only has a log procedure that finds logarithms in base e, we have to implement log2 by ourseleves.
(define (nth-root x n)
  (fixed-point 
    ((repeated average-damp (floor (log2 n)))
	 (lambda (y) (/ x (expt y (- n 1)))))
	1.0))

;; to compute the golden ratio x=1+1/x
(define golden-ratio (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0))

;; print the sequence of approximations it generates
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
	  ((display guess) (newline) (display next) (newline) (newline) 
	   (if (close-enough? guess next)
	      next
		  (try next))))
  (try first-guess))

;; compute the root of x^x=1000 by finding a fixed point of x=log(1000)/log(x)
;; NOTICE: not start from 1 because log(1)=0
(define log-ans (fixed-point (lambda (x) (/ (log 1000) (log x))) 1.1))

;; an infinite continued fraction is an expression of the form:
;; f = N1 / (D1 + N2 / (D2 + N3 / (D3 + ...)))
;; If all Ni and Di is 1, then it is just the golden ratio
;; One way to approximate an infinite continued fraction is to truncate the expansion after a given number of terms
;; A so-called k-term finite continued fraction has the form:
;; N1 / (D1 + N2 / (... + Nk / Dk))
;; suppose n and d are procedures of one argument(the term index i) that return the Ni and Di

;; this is a recursive version
(define (cont-frac n d k) 
  (define (rf i)
    (if (> i k) 0 (/ (n i) (+ (d i) (rf (+ i 1))))))
  (rf 1))
;; this is an iterative version
;; we need to reverse the evaluation order here, i.e. from k to 1
(define (cont-frac2 n d k)
  (define (iter i result)
    (if (= i 0) result (iter (- i 1) (/ (n i) (+ (d i) result)))))
  (iter k 0))

;;compute the golden ratio
;;how large to get an approximation that is accurate to 4 decimal places
(define k 10000)
(cont-frac (lambda (i) 1.0) (lambda (i) 1.0) k)

;; In 1737, the Swiss mathematician Leonhard Euler published a memoir De Fractionibus
;; Continuis, which included a continued fraction expansion for e-2, where e is the base of the natural
;; logarithms. In this fraction, the N i are all 1, and the D i are successively 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, ....
(define (appro-e) (+ 2 (cont-frac (lambda (i) 1.0) 
						          (lambda (i) 
								    (cond ((< i 3) i)
									      ((= (remainder i 3) 2) (* 2/3 (+ n 1)))
										  (else 1)))
								  k)))


;; A continued fraction representation of the tangent function was published in 1770 by the
;; German mathematician J.H. Lambert: tan(x) = 
;; x / (1 - (x^2 / (3 - x^2 / (5 - ...))))
;; where x is in radians. Define a procedure (tan-cf x k) that computes an approximation to the tangent
;; function based on Lambert's formula. K specifies the number of terms to compute
(define (tan-cf x k)
  (define y (sqr x))
  (define (rf i) 
    (if (> i k) 0 (/ y (- (+ 1 (* 2 i)) (rf (+ i 1))))))
  (if (= x 0) 0 (/ (rf 1) x)))


;; Several of the numerical methods described in this chapter are instances of an extremely
;; general computational strategy known as iterative improvement. Iterative improvement says that, to
;; compute something, we start with an initial guess for the answer, test if the guess is good enough, and
;; otherwise improve the guess and continue the process using the improved guess as the new guess. Write a
;; procedure iterative-improve that takes two procedures as arguments: a method for telling whether a
;; guess is good enough and a method for improving a guess. Iterative-improve should return as its
;; value a procedure that takes a guess as argument and keeps improving the guess until it is good enough.
(define (close-enough? v1 v2)
  (define tolerance 1e-6)
  (< (/ (abs (- v1 v2)) v2) tolerance))
(define (iterative-improve good-enough? update-guess)
  (lambda (x) (let ((xx (update-guess x))) (if (good-enough? x xx) x ((iterative-improve good-enough? update-guess) xx)))))

(define (sqrt x) ((iterative-improve close-enough? (lambda (y) (average y (/ x y)))) 1.0))
(sqrt 9)

(define (fixed-point f first-guess) ((iterative-improve close-enough? (lambda (x) (f x))) first-guess))

