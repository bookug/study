;; first we need to know continuation
;; http://blog.sina.com.cn/s/blog_4dff871201018wtz.html

(define (test element cc)
  (if (zero? element)
	  (cc 'found-zero) ;non-local exit
	  ;(void)))
	  3))
(define (search-zero test lst)
  (call/cc (lambda (return) 
			 (for-each (lambda (element)
						  (test element return)
						  ;(printf "~a~%" element)) ;print
						  (display element))
			           lst)
			 #f)))
(search-zero test '(-3 -2 - 1 0 1 2 3))

(define (generate-one-element-at-a-time lst)
  ;;hand the next item from a-list to "return" or an end-of-list marker
  (define (control-state return)
    (for-each
	  (lambda (element)
	    (call/cc 
		  (lambda (resume-here) 
		    ;;grab the current continuation
			(set! control-state resume-here) ;;!!!
		    (return element))))
	  lst)
	(return 'end))
  (define (generator)
    (call/cc control-state))
  ;;return the generator
  generator)
(define generate-digit
  (generate-one-element-at-a-time '(0 1 2)))
(display (generate-digit))
(display (generate-digit))
(display (generate-digit))
(display (generate-digit))
(display (generate-digit))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; then we need to learn the cps
;; http://blog.sina.com.cn/s/blog_698213630101bj0q.html

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; finally we use scheme to do the cps transform
;; http://tieba.baidu.com/p/2714253120
;; http://www.zhihu.com/question/27581940




