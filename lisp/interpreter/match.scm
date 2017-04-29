(let ((l '(hello (world))))
 (match l           ;; <- the input object
        (('hello (who))  ;; <- the pattern
         who)))          ;; <- the expression evaluated upon matching')))
