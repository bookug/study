#lang slideshow

;; HELP: https://docs.racket-lang.org/slideshow/index.html

(slide
 #:title "How to Say Hello"
 (t "Hello World!"))

(slide
 #:title "How to Say Hello"
 (t "Hello World!")
 (t "Goodbye Dlrow!"))

(slide
 #:title "How to Say Hello"
 (item "If you want to create an example, you"
      "can always do something with" (bt "Hello World!"))
 (item "It's a bit silly, but a follow-up example"
       "could be" (bt "Goodbye Dlrow!")))

(define (slide-n n)
  (slide
   #:title "How to Generalize Slides"
   (item "This is slide number" (number->string n))))
(slide-n 1)
(slide-n 2)
(slide-n 3)

(slide
 #:title "Example"
 (item "First step")
 'next
 (item "Second step")
 'next
 'alts
 (list (list (item "Tentative third step")
             'next
             (item "This isn't working... back up"))
       (list (item "Third step that works")))
 'next
 (item "Fourth step"))

