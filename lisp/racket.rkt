#lang racket

1/2
1+2i
(sqrt 16)
(sqrt -16)
(>= 2 1)
(number? "c'est une number")
(number? 1)


"Hello, \"world"
"λx:(μα.α→α).xx"

(string-append "rope" "twine" "yarn")
(substring "corduroys" 0 4)
(string-length "shoelace")
(string? "Ceci n'est pas une string.")
(string? 1)
(equal? 6 "half dozen")
(equal? "half dozen" "half dozen")
(define x "a")
(define y "a")
(eq? x y)

(define (reply s)
  (if (string? s)
      (if (equal? "hello" (substring s 0 5))
          "hi!"
          "huh?")
      "huh?"))
(define (reply2 s)
  (if (if (string? s)
          (equal? "hello" (substring s 0 5))
          #f)
      "hi!"
      "huh?"))
(define (reply3 s)
  (if (and (string? s)
           (>= (string-length s) 5)
           (equal? "hello" (substring s 0 5)))
      "hi!"
      "huh?"))
(define (reply-more s)
  (if (equal? "hello" (substring s 0 5))
      "hi!"
      (if (equal? "goodbye" (substring s 0 7))
          "bye!"
          (if (equal? "?" (substring s (- (string-length s) 1)))
              "I don't know"
              "huh?"))))
(define (reply-more2 s)
  (cond
   [(equal? "hello" (substring s 0 5))
    "hi!"]
   [(equal? "goodbye" (substring s 0 7))
    "bye!"]
   [(equal? "?" (substring s (- (string-length s) 1)))
    "I don't know"]
   [else "huh?"]))

(define (double v)
  ((if (string? v) string-append +) v v))
(double "mnah")
(double 5)

(list "a" 1 1+2i)
(length (list "hop" "skip" "jump"))
(list-ref (list "hop" "skip" "jump") 0)
(list-ref (list "hop" "skip" "jump") 1)
(append (list "hop" "skip") (list "jump"))
(reverse (list "hop" "skip" "jump"))
(member "fall" (list "hop" "skip" "jump"))

(map sqrt (list 1 4 9 16))
(map (lambda (i)
         (string-append i "!"))
       (list "peanuts" "popcorn" "crackerjack"))
; this seems like the combination of map and reduce
(andmap string? (list "a" "b" "c"))
(ormap number? (list "a" "b" 6))
; multiway map
(map (lambda (s n) (substring s 0 n))
       (list "peanuts" "popcorn" "crackerjack")
       (list 6 3 7))
(filter string? (list "a" "b" 6))
(filter positive? (list 1 -2 6 7 0))
(foldl (lambda (elem v)
           (+ v (* elem elem)))
         0
         '(1 2 3))
;; list is built from car, cdr and cons
(first (list 1 2 3))
(rest (list 1 2 3))
empty
(cons "head" empty)
(cons "dead" (cons "head" empty))
(empty? empty)
(empty? (cons "head" empty))
(cons? empty)
(cons? (cons "head" empty))
(define (my-length lst)
  (cond
   [(empty? lst) 0]
   [else (+ 1 (my-length (rest lst)))]))
(define (my-map f lst)
  (cond
   [(empty? lst) empty]
   [else (cons (f (first lst))
               (my-map f (rest lst)))]))
(my-map string-upcase (list "ready" "set" "go"))
; to run in constant space
(define (my-length2 lst)
  ; local function iter:
  (define (iter lst len)
    (cond
     [(empty? lst) len]
     [else (iter (rest lst) (+ len 1))]))
  ; body of my-length calls iter:
  (iter lst 0))
(define (my-map2 f lst)
  (define (iter lst backward-result)
    (cond
     [(empty? lst) (reverse backward-result)]
     [else (iter (rest lst)
                 (cons (f (first lst))
                       backward-result))]))
  (iter lst empty))
; for simplicity, write below
(define (my-map3 f lst)
  (for/list ([i lst])
    (f i)))
;how to transform this into tail-recursion / iteration
; this assumes that teh list is sort on order
(define (remove-dups l)
  (cond
   [(empty? l) empty]
   [(empty? (rest l)) l]
   [else
    (let ([i (first l)])
      (if (equal? i (first (rest l)))
          (remove-dups (rest l))
          (cons i (remove-dups (rest l)))))]))
