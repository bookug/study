;; the abstraction is the structure, likely in procedure and data
;; we can use procedure to imitate the data structure and function, so does the reversed case

(define (linear-combination a b x y) 
  (+ (* a x) (* b y)))

;; add and mul are not the primitive procedures + and * but rather more complex things that will
;; perform the appropriate operations for whatever kinds of data we pass in as the arguments a, b, x, and y.
;; The key point is that the only thing linear-combination should need to know about a, b, x, and y
;; is that the procedures add and mul will perform the appropriate manipulations. From the perspective of
;; the procedure linear-combination, it is irrelevant what a, b, x, and y are and even more irrelevant
;; how they might happen to be represented in terms of more primitive data. This same example shows why
;; it is important that our programming language provide the ability to manipulate compound objects
;; directly: Without this, there is no way for a procedure such as linear-combination to pass its
;; arguments along to add and mul without having to know their detailed structure
(define (linear-combination a b x y)
  (add (mul a x) (mul b y))

