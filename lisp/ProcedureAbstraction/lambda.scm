;; constructing procedures using lambda
;; generally, lambda is used to create procedures in teh same way as define, except that
;; no name is specified

(load "util.scm")

(lambda (x) (+ x 4))

(lambda (x) (/ 1.0 (* x (+ x 2))))

(define mul7 (lambda (x) (* x 7)))

((lambda (x y z) (+ x y (sqr z))) 1 2 3)

;; use let to bring convenience
(define (f x y)
  (define (f-helper a b)
    (+ (* x (sqr a))
	   (* y b)
	   (* a b)))
  (f-helper (+ 1 (* x y))
            (- 1 y)))

(define (f x y)
  ((lambda (a b) 
	  (+ (* x (sqr a))
	     (* y b)
		 (* a b)))
   (+ 1 (* x y))
   (- 1 y)))

(define (f x y)
  (let ((a (+ 1 (* x y)))
		(b (- 1 y)))
    (+ (* x (sqr a))
	   (* y b)
	   (* a b))))

;; let allows one to bind variables as locally as possible to where they are used
(define x 5)
;; the answer should be 38
(+ (let ((x 3)) (+ x (* x 10))) 
   x)

;; the variables' values are computed outside the let
(define x 2)
;; teh answer should be 12
(let ((x 3) (y (+ x 2))) (* x y))

;; Procedures as Returned Values
(define (average-damp f) (lambda (x) (average x (f x))))

((average-damp sqr) 10)

(load "equation.scm")

(define (sqrt x) 
  (fixed-point (average-damp (lambda (y) (/ x y))) 1.0))

(define (cube-root x)
  (fixed-point (average-damp (lambda (y) (/ x (sqr y)))) 1.0))

;; Newton's method
;; a solution of g(x)=0 is a fixed point of the function x=x-g(x)/Dg(x)
;; Dg(x) = (g(x+dx) - g(x)) / dx
(define (deriv g)
  (lambda (x) (/ (- (g (+ x dx)) (g x))
     dx)))
(define dx 0.00001)

((deriv cube) 5)
(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))
(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))
(define (sqrt x)
  (newtons-method (lambda (y) (- (sqr y) x))
                  1.0))

;; abstractions and first-class procedures
;; Lisp, unlike other common programming languages, awards procedures full first-class status. This poses
;; challenges for efficient implementation, but the resulting gain in expressive power is enormous.
(define (fixed-point-of-transform g transform guess)
  (fixed-point (transform g) guess))

(define (sqrt x)
 (fixed-point-of-transform (lambda (y) (/ x y))
  average-damp
  1.0))

(define (sqrt x)
 (fixed-point-of-transform (lambda (y) (- (square y) x))
  newton-transform
  1.0))

(define (cubic a b c) (lambda (x) (+ (cube x) (* a (sqr x)) (* b x) c)))
(newtons-method (cubic 1 2 3) 1)

(define (double-f f) (lambda (x) (f (f x))))
(double inc)
;; the answer should be 13
(((double (double double)) inc) 5)

(define (compose f g) (lambda (x) (f (g x))))
;; the answer should be 49
((compose sqr inc) 6)

(define (repeated f times) 
  (if (= times 1) f (compose f (repeated f (- times 1)))))
;; the answer should be 625
((repeated sqr 2) 5)

;; The idea of smoothing a function is an important concept in signal processing. If f is a
;; function and dx is some small number, then the smoothed version of f is the function whose value at a point
;; x is the average of f(x - dx), f(x), and f(x + dx). 
;; It is sometimes valuable to repeatedly smooth a function (that is, smooth the smoothed function, and so on) 
;; to obtained the n-fold smoothed function.
(define (smooth f) (lambda (x) (/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3)))
(define (repeatedly-smooth f times) (repeated (smooth f) times))

