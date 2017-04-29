;; http://www.scheme.com/tspl4/syntax.html

(define-syntax let*
  (syntax-rules ()
    [(_ () b1 b2 ...) (let () b1 b2 ...)]
    [(_ ((i1 e1) (i2 e2) ...) b1 b2 ...)
     (let ([i1 e1])
       (let* ([i2 e2] ...) b1 b2 ...))]))

(let ()
  (define even?
    (lambda (x)
      (or (= x 0) (odd? (- x 1)))))
  (define-syntax odd?
    (syntax-rules ()
      [(_ x) (not (even? x))]))
  (even? 10))

(display "all is well")

