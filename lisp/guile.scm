#! /usr/bin/guile -s 
!#

;; /usr/bin/guile -e main -s

;; no static types, all when running

(define key "Bookug Lobert")
(set! key 3.74)

(display "Hello, world!")
(newline)

;; use extensions
(load-extension "./libguile-bessel" "init_bessel")
(j0 2)

;; use modules
(use-modules (ice-9 popen))
(use-modules (ice-9 rdelim))
(define p (open-input-pipe "ls -l"))
(read-line p)
(read-line p)

(+ 1 2)
#i1.2
3+4i
;; compute natural logarithm
(log 10000)

(begin (display 1) (newline) 'hooray)

;; generate a list
(iota 10)

(define (factorial n)
 (if (zero? n) 1 (* n (factorial (- n 1)))))

;(display (factorial (string->number (cadr (command-line))))
(newline)

;; look in /etc/passwd
(getpwnam "root")

;; scheme is properly tail recursive, meaning that tail calls or recursions do not consume stack space or other resources
(define (foo n)
 (display n)
 (newline)
 (foo (+ n 1)))
;(foo 1)

(display '(1 2 3))
(newline)

(define (main args)
  (map (lambda (arg) (display arg) (display " "))
       (cdr args)
  (newline)))

