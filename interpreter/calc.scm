;this is a simple calculator, using pattern-matching in racket

#lang racket

(define calc 
  (lambda (exp)
    (match exp
    [(? number? x) x]
	[`(,op,e1,e2) (let ([v1 (calc e1)] [v2 (calc e2)])
		(match op
		  ['+ (+ v1 v2)]
		  ['- (- v1 v2)]
		  ['* (* v1 v2)]
		  ['/ (/ v1 v2)]))])))
