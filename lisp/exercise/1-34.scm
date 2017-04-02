
(load "../util.scm")

(define (f g) (g 2))

(define ans (f sqr))
(display ans)
(newline)

(define ans (f (lambda (z) (* z (+ z 1)))))
(display ans)
(newline)

;; below will be exapnded to (f 2) -> (2 2)
;(define ans (f f))

