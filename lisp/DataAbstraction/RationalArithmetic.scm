(load "../util.scm")

;; Abstraction Barriers
;; Rational numbers in problem domain: Programs that use rational numbers
;; Rational numbers as numerators and denominators: add-rat sub-rat ...
;; Rational numbers as pairs: make-rat numer denom
;; However pairs are implemented: cons car cdr

(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
			   (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
			   (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

;; Now we have the operations on rational numbers defined in terms of the selector and constructor
;; procedures numer, denom, and make-rat. But we haven't yet defined these. What we need is some way
;; to glue together a numerator and a denominator to form a rational number.
;;
;; To enable us to implement the concrete level of our data abstraction, our language provides a compound
;; structure called a pair, which can be constructed with the primitive procedure cons.
(define x (cons 1 2))
(car x)
;; 1
(cdr x)
;; 2
(define y (cons 3 4))
(define z (cons x y))
(car (car z))
(car (cdr z))

;; Pairs offer a natural way to complete the rational-number system. Simply represent a rational number as a
;; pair of two integers: a numerator and a denominator.
(define (make-rat n d) (cons n d))
(define (numer x) (car x))
(define (denom x) (cdr x))

(define (print-rat x) 
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

(define one-half (make-rat 1 2))
(print-rat one-half)
(define one-third (make-rat 1 3))
(print-rat (add-rat one-half one-third))
(print-rat (mul-rat one-half one-third))
(print-rat (add-rat one-third one-third))
;; 6/9
;; As the final example shows, our rational-number implementation does not reduce rational numbers to
;; lowest terms. We can remedy this by changing make-rat.
;; It is really better to reduce the rational number when constructing
(define (make-rat n d) 
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))
(print-rat (add-rat one-third one-third))

;; a better version of make-rat that handles both positive and negative arguments.
;; Make-rat should normalize the sign so that if the rational number is positive, both the numerator and
;; denominator are positive, and if the rational number is negative, only the numerator is negative.
(define (make-rat n d)
  (let ((sign (or (and (positive? n) (negative? d)) (and (negative? n) (positive? d)))) (pn (abs n)) (pd (abs d)))
    (let ((pg (gcd pn pd)))
	  (let ((n1 (/ pn pg)) (d1 (/ pd pg)))
	    (cons (if sign (- 0 n1) n1) d1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (make-segment start-point end-point) (cons start-point end-point))
(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (print-rectangle r)
  (print-point (left-down r))
  (print-point (right-down r))
  (print-point (right-up r))
  (print-point (left-up r))
  (newline))

;; represent a rectangle using its LeftDown point and RightUp point
(define (make-rectangle leftdown-point rightup-point) (cons leftdown-point rightup-point))
(define (left-down r) (car r))
(define (right-up r) (cdr r))
(define (left-up r) (make-point (car (left-down r)) (cdr (right-up r))))
(define (right-down r) (make-point (car (right-up r)) (cdr (left-down r))))
(define (width r) (- (x-point (right-up r)) (x-point (left-down r))))
(define (height r) (- (y-point (right-up r)) (y-point (left-down r))))

(define (perimeter-of-rectangle r) 
  (let ((ld (left-down r)) (ru (right-up r)))
    (* 2 (+ (- (x-point ru) (x-point ld)) (- (y-point ru) (y-point ld))))))

(define (area-of-rectangle r) 
  (let ((ld (left-down r)) (ru (right-up r)))
    (* (- (x-point ru) (x-point ld)) (- (y-point ru) (y-point ld)))))

;; generally, we can acquire the perimeter and area of a rectangle using its width and height
(define (perimeter-of-rectangle r) (* 2 (+ (width r) (height r))))
(define (area-of-rectangle r) (* (width r) (height r)))

;; here is a different representation for rectangles, but the operations for perimeter and area do not change
;; represent a rectangle using its LeftDown pont and w, h
(define (make-rectangle leftdown-point w h) (cons leftdown-point (cons w h)))
(define (left-down r) (car r))
(define (right-up r)
  (let ((ld (left-down r)) (wh (cdr r)))
    (make-point (+ (car ld) (car wh)) (+ (cdr ld) (cdr wh)))))
(define (left-up r) 
  (let ((ld (left-down r)) (wh (cdr r)))
    (make-point (car ld) (+ (cdr ld) (cdr wh)))))
(define (right-down r)
  (let ((ld (left-down r)) (wh (cdr r)))
    (make-point (+ (car ld) (car wh)) (cdr ld))))
(define (width r) (car (cdr r)))
(define (height r) (cdr (cdr r)))

;; The point of exhibiting the procedural representation of pairs is not that our language works this way
;; (Scheme, and Lisp systems in general, implement pairs directly, for efficiency reasons) but that it could
;; work this way. The procedural representation, although obscure, is a perfectly adequate way to represent
;; pairs, since it fulfills the only conditions that pairs need to fulfill. This example also demonstrates that the
;; ability to manipulate procedures as objects automatically provides the ability to represent compound data.
;; This may seem a curiosity now, but procedural representations of data will play a central role in our
;; programming repertoire. This style of programming is often called message passing, and we will be using
;; it as a basic tool in chapter 3 when we address the issues of modeling and simulation.
(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
	      ((= m 1) y)
		  (else (error "Argument not 0 or 1 -- CONS" m))))
  dispatch)
(define (car z) (z 0))
(define (cdr z) (z 1))

;; Here is an alternative procedural representation of pairs
(define (cons x y) (lambda (m) (m x y)))
(define (car z) (z (lambda (p q) p)))
(define (cdr z) (z (lambda (p q) q)))

;; we can represent pairs of nonnegative integers using only numbers and arithmetic
;; operations if we represent the pair a and b as the integer that is the product (2^a)*(3^b)
(define (cons a b) (* (expt 2 a) (expt 3 b)))
;; BETTER?: log2 may not compute the integer result
(define (car z) 
  (if (= (remainder z 3) 0) (car (/ z 3)) (log2 z)))
(define (cdr z)
  (if (= (remainder z 2) 0) (cdr (/ z 2)) (log3 z)))
;; a better version should be like this:
(define (car z)
  (if (= 0 (remainder z 2)) (+ 1 (car (/ z 2))) 0))
(define (cdr z)
  (if (= 0 (remainder z 3)) (+ 1 (cdr (/ z 3))) 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; In case representing pairs as procedures wasn't mind-boggling enough, consider that, in a
;; language that can manipulate procedures, we can get by without numbers (at least insofar as nonnegative
;; integers are concerned) by implementing 0 and the operation of adding 1 as
(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n) (lambda (f) (lambda (x) (f ((n f) x)))))
;; This representation is known as Church numerals, after its inventor, Alonzo Church, the logician who
;; invented the lambda calculus.
;; we can define one and two directly(not in terms of zero and add-1)
(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))
;; a direct definition of the addition procedure +(not in terms of repeated application of add-1)
(define (+ a b)
  (lambda (f) (lambda (x) ((a f) ((b f) x)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extended Exercise: Interval Arithmetic

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
    (+ (upper-bound x) (upper-bound y))))
(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
		(p2 (* (lower-bound x) (upper-bound y)))
		(p3 (* (upper-bound x) (lower-bound y)))
		(p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4))))
(define (div-interval x y)
  (mul-interval x (make-interval (/ 1.0 (upper-bound y)) (/ 1.0 (lower-bound y)))))
(define (make-interval l u) (cons l u))
(define (upper-bound z) (cdr z))
(define (lower-bound z) (car z))
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y)) (- (upper-bound x) (lower-bound y))))
;; The width of an interval is half of the difference between its upper and lower bounds. The
;; width is a measure of the uncertainty of the number specified by the interval. For some arithmetic
;; operations the width of the result of combining two intervals is a function only of the widths of the
;; argument intervals, whereas for others the width of the combination is not a function of the widths of the
;; argument intervals. 
;; The width of the sum (or difference) of two intervals is a function only of the
;; widths of the intervals being added or subtracted. (w3 = w1 + w2)
;; However, this is not true for multiplication or division. For example:
;; (1, 2) * (2, 3) = (2, 6) (2, 4) / (1, 2) = (1, 4)

;; Ben Bitdiddle, an expert systems programmer, looks over Alyssa's shoulder and comments
;; that it is not clear what it means to divide by an interval that spans zero. Modify Alyssa's code to check for
;; this condition and to signal an error if it occurs.
(define (div-interval x y)
  (let ((l (lower-bound y)) (u (upper-bound y)))
    (if (> (* l u) 0)
      (mul-interval x (make-interval (/ 1.0 (upper-bound y)) (/ 1.0 (lower-bound y))))
	  (error "divided by 0 in DIV-INTERVAL" l u))))

;; In passing, Ben also cryptically comments: By testing the signs of the endpoints of the
;; intervals, it is possible to break mul-interval into nine cases, only one of which requires more than
;; two multiplications.
(define (mul-interval x y)
  (let ((xl (lower-bound x)) (xu (upper-bound x)) (yl (lower-bound y)) (yu (upper-bound y)))
    (cond ((<= (* xl xu) 0) 
		    (cond ((<= (* yl yu) 0) 
				    (let ((p1 (* xl yu)) (p2 (* xu yl)) (p3 (* xl yl)) (p4 (* xu yu)))
					  (make-interval (min p1 p2) (max p3 p4))))
			      ((and (< yl 0) (< yu 0)) (make-interval (* xu yl) (* xl yl)))
				  ((and (> yl 0) (> yu 0)) (make-interval (* xl yu) (* xu yu)))))
	      ((and (< xl 0) (< xu 0))
		    (cond ((<= (* yl yu) 0) (make-interval (* xl yu) (* xl yl)))
			      ((and (< yl 0) (< yu 0)) (make-interval (* xu yu) (* xl yl)))
				  ((and (> yl 0) (> yu 0)) (make-interval (* xl yu) (* xu yl)))))
		  ((and (> xl 0) (> xu 0))
		    (cond ((<= (* yl yu) 0) (make-interval (* yl xu) (* xu yu)))
			      ((and (< yl 0) (< yu 0)) (make-interval (* yl xu) (* xl yu)))
				  ((and (> yl 0) (> yu 0)) (make-interval (* xl yl) (* xu yu))))))))

;; there is another way to represent the interval bound
(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

;; we can also use percentage to represent it
(define (make-center-percent c p)
  (define w (/ (* c p) 100))
  (make-interval (- c w) (+ c w)))
(define (percent i)
  (/ (width i) 100 (center i)))

;; under the assumption of small percentage tolerances there is a simple formula
;; for the approximate percentage tolerance of the product of two intervals in terms of the tolerances of the
;; factors. You may simplify the problem by assuming that all numbers are positive.
(define (mul-interval x y)
  (define px (percent x))
  (define py (percent y))
  (make-center-percent (* (center x) (center y)) (+ px py (* px py))))

;; Notice that (R1*R2)/(R1+R2) can be written in 1/((1/R1)+(1/R2))
;; Lem complains that Alyssa's program gives different answers for the two ways of computing. This is a
;; serious complaint.
(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))
(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
	              (add-interval (div-interval one r1)
				                (div-interval one r2)))))

;; Demonstrate that Lem is right. Investigate the behavior of the system on a variety of
;; arithmetic expressions. Make some intervals A and B, and use them in computing the expressions A/A and
;; A/B. You will get the most insight by using intervals whose width is a small percentage of the center value.
;; Examine the results of the computation in center-percent form
;;
;;A=[2,8] B=[2,8] A/B=[0.25,4] but A/A=[0.25,4] and it should be 1(reintroduce the uncertainty)
;;what two intervals can be called identity?
;;
;; Eva Lu Ator, another user, has also noticed the different intervals computed by different
;; but algebraically equivalent expressions. She says that a formula to compute with intervals using Alyssa's
;; system will produce tighter error bounds if it can be written in such a form that no variable that represents
;; an uncertain number is repeated. Thus, she says, par2 is a ``better'' program for parallel resistances than
;; par1. Is she right? Why?
;;
;;Right because par2 does not introduce the uncertainty
;;
;; Explain, in general, why equivalent algebraic expressions may lead to different answers.
;; Can you devise an interval-arithmetic package that does not have this shortcoming, or is this task
;; impossible? (Warning: This problem is very difficult.)
;;
;;One way is using Monte Carlo method, enum the value of A, so A/A will always be 1
;;(require the zero tolerance)
;;Another explanation:http://wiki.drewhess.com/wiki/SICP_exercise_2.16






