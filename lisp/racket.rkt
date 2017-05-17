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

(car (cons 1 2))
(cdr (cons 1 2))
(pair? empty)
(pair? (cons 1 2))
(pair? (list 1 2 3))
(cons (list 2 3) 1)
(cons 1 (list 2 3))
;; In general, the rule for printing a pair is as follows: use the dot notation unless the dot is immediately followed by an open parenthesis. In that case, remove the dot, the open parenthesis, and the matching close parenthesis. Thus, '(0 . (1 . 2)) becomes '(0 1 . 2), and '(1 . (2 . (3 . ()))) becomes '(1 2 3).
(quote (0 . (1 . 2)))
(quote ())
(quote ((1 2 3) 5 ("a" "b" "c")))
(symbol? (quote map))
(symbol? map)
(procedure? map)
(string->symbol "map")
(symbol->string (quote map))
(symbol? (car (quote (road map))))
(quote (road map))
(quote 42)
(quote "on the record")

;; vector: constant time of visiting
#("a" "b" "c")
#(name (that tune))
#4(baldwin bruce)
(vector-ref #("a" "b" "c") 1)
(vector-ref #(name (that tune)) 1)
(list->vector (map string-titlecase
                     (vector->list #("three" "blind" "mice"))))

;; input and output
;(define out (open-output-file "data.txt"))
;(display "hello" out)
;(close-output-port out)
(define in (open-input-file "data.txt"))
(read-line in)
(close-input-port in)
;; If a file exists already, then open-output-file raises an exception by default. Supply an option like #:exists 'truncate or #:exists 'update to re-write or update the file
(define out2 (open-output-file "data.txt" #:exists 'truncate))
(display "howdy" out2)
(close-output-port out2)
(call-with-output-file "data.txt"
                          #:exists 'truncate
                          (lambda (out)
                            (display "hello" out)))
(call-with-input-file "data.txt"
                        (lambda (in)
                          (read-line in)))
;; string
(define p (open-output-string))
(display "hello" p)
(get-output-string p)
(read-line (open-input-string "goodbye\nfarewell"))

;; TCP Connections
(define server (tcp-listen 12345))
(define-values (c-in c-out) (tcp-connect "localhost" 12345))
(define-values (s-in s-out) (tcp-accept server))
(display "hello\n" c-out)
(close-output-port c-out)
(read-line s-in)
(read-line s-in)
;; Process Pipes
(define-values (pp stdout stdin stderr)
    (subprocess #f #f #f "/usr/bin/wc" "-w"))
(display "a b c\n" stdin)
;(close-output-port stdin)
(read-line stdout)
(close-input-port stdout)
(close-input-port stderr)
;; Internal Pipes
(define-values (in3 out3) (make-pipe))
(display "garbage" out3)
(close-output-port out3)
(read-line in3)
;; Internal Pipes(in Racket instead of OS)
(define-values (in4 out4) (make-pipe))
(display "garbage" out4)
(close-output-port out4)
(read-line in4)

;; Pattern Matching
(match 2
    [1 'one]
    [2 'two]
    [3 'three])
(match #f
    [#t 'yes]
    [#f 'no])
(match "apple"
    ['apple 'symbol]
    ["apple" 'string]
    [#f 'boolean])
(match '(1 2)
    [(list 0 1) 'one]
    [(list 1 2) 'two])
(match '(1 . 2)
    [(list 1 2) 'list]
    [(cons 1 2) 'pair])
(match #(1 2)
    [(list 1 2) 'list]
    [(vector 1 2) 'vector])
(struct shoe (size color))
(struct hat (size style))
;; racket/macth
(match (hat 23 'bowler)
   [(shoe 10 'white) "bottom"]
   [(hat 23 'bowler) "top"])
(match '(1)
    [(list x) (+ x 1)]
    [(list x y) (+ x y)])
(match '(1 2)
    [(list x) (+ x 1)]
    [(list x y) (+ x y)])
(match (hat 23 'bowler)
    [(shoe sz col) sz]
    [(hat sz stl) sz])
(match (hat 11 'cowboy)
    [(shoe sz 'black) 'a-good-shoe]
    [(hat sz 'bowler) 'a-good-hat]
    [_ 'something-else])
(match '(1 1 1)
    [(list 1 ...) 'ones]
    [_ 'other])
(match '(1 1 2)
    [(list 1 ...) 'ones]
    [_ 'other])
(match '(1 2 3 4)
    [(list 1 x ... 4) x])
(match (list (hat 23 'bowler) (hat 22 'pork-pie))
    [(list (hat sz styl) ...) (apply + sz)])
(match '((! 1) (! 2 2) (! 3 3 3))
    [(list (list '! x ...) ...) x])
(match `{with {x 1} {+ x 1}}
    [`{with {,id ,rhs} ,body}
     `{{lambda {,id} ,body} ,rhs}])
(match-let ([(list x y z) '(1 2 3)])
    (list z y x))

;; Classes and Objects: https://docs.racket-lang.org/guide/classes.html
(class object%
  (init size)                ; initialization argument
 
  (define current-size size) ; field
 
  (super-new)                ; superclass initialization
 
  (define/public (get-size)
    current-size)
 
  (define/public (grow amt)
    (set! current-size (+ amt current-size)))
 
  (define/public (eat other-fish)
    (grow (send other-fish get-size))))
   ; (new (class object% (init size) ....) [size 10])
;(define fish% (class object% (init size) ....))
;(define charlie (new fish% [size 10]))




;; The Power of EVAL
;; https://docs.racket-lang.org/guide/eval.html
;; To Use PlaneT
;; https://docs.racket-lang.org/planet/Developing_Packages_for_PLaneT.html
