#lang racket

(define-struct movie (title producer))

(define mv (make-movie "XiYouJi" "YangJie"))
(movie-title mv)
(movie-producer mv)

;; The design recipe for compound data: A complete example
;; Data Analysis & Definitions:
(define-struct student (last first teacher))
;; A student is a structure: (make-student l f t) where f, l, and t are symbols.

;; Contract: subst-teacher : student symbol  ->  student

;; Purpose: to create a student structure with a new 
;; teacher name if the teacher's name matches 'Fritz

;; Examples:
;; (subst-teacher (make-student 'Find 'Matthew 'Fritz) 'Elise)
;; = 
;; (make-student 'Find 'Matthew 'Elise)
;; (subst-teacher (make-student 'Find 'Matthew 'Amanda) 'Elise)
;; = 
;; (make-student 'Find 'Matthew 'Amanda)

;; Template:
;; (define (process-student a-student a-teacher) 
;; ... (student-last a-student) ...
;; ... (student-first a-student) ...
;; ... (student-teacher a-student) ...)

;; Definition: 
(define (subst-teacher a-student a-teacher) 
  (cond
    [(symbol=? (student-teacher a-student) 'Fritz) 
     (make-student (student-last a-student)
                   (student-first a-student)
		   a-teacher)]
    [else a-student]))
  
;; Tests:
(subst-teacher (make-student 'Find 'Matthew 'Fritz) 'Elise)
;; expected value:
(make-student 'Find 'Matthew 'Elise)

(subst-teacher (make-student 'Find 'Matthew 'Amanda) 'Elise)
;; expected value: 
(make-student 'Find 'Matthew 'Amanda)

;; Data Analysis & Definitions:
;; A student is a structure: (make-student l f t) where f, l, and t are symbols.

;; Contract: subst-teacher : student symbol  ->  student

;; Purpose: to create a student structure with a new 
;; teacher name if the teacher's name matches 'Fritz

;; Examples:
;; (subst-teacher (make-student 'Find 'Matthew 'Fritz) 'Elise)
;; = 
;; (make-student 'Find 'Matthew 'Elise)
;; (subst-teacher (make-student 'Find 'Matthew 'Amanda) 'Elise)
;; = 
;; (make-student 'Find 'Matthew 'Amanda)

;; Template:
;; (define (process-student a-student a-teacher) 
;; ... (student-last a-student) ...
;; ... (student-first a-student) ...
;; ... (student-teacher a-student) ...)

;; Definition: 
;(define (subst-teacher a-student a-teacher) 
  ;(cond
    ;[(symbol=? (student-teacher a-student) 'Fritz) 
     ;(make-student (student-last a-student)
                   ;(student-first a-student)
		   ;a-teacher)]
    ;[else a-student]))
  
;; Tests:
(subst-teacher (make-student 'Find 'Matthew 'Fritz) 'Elise)
;; expected value:
(make-student 'Find 'Matthew 'Elise)

(subst-teacher (make-student 'Find 'Matthew 'Amanda) 'Elise)
;; expected value: 
(make-student 'Find 'Matthew 'Amanda)

(define (transfer a-student a-teacher) 
  (make-student (student-last a-student) 
                (student-first a-student)
		a-teacher))

