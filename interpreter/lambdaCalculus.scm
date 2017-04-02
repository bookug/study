;wangyin: http://yinwang0.lofter.com/post/183ec2_47c086

#lang racket

;;env0, ent-env and lookup are basic operations for environment
;empty environment
(define env0 '())
;extend the env, map x to v and get a new environment
(define ext-env
  (lambda (x v env)
    (cons `(, x .,v) env)))
;search the value of x in env
(define lookup
  (lambda (x env)
    (let ([p (assq x env)])
      (cond [(not p) x]
            [else (cdr p)]))))

;;the structure definition of closure, including a function and an environment
(struct Closure (f env))

;;define teh interpreter recursively
;;5 cases in total: variable, function, calling, numerical, expressions
(define interp1
  (lambda (exp env)
    (match exp
      [(? symbol? x) (lookup x env)]
      [(? number? x) x]
      [`(lambda (,x),e) (Closure exp env)]
      [`(,e1 ,e2) (let ([v1 (interp1 e1 env)] [v2 (interp1 e2 env)])
                    (match v1
                      [(Closure `(lambda (,x),e) env1) (interp1 e (ext-env x v2 env1))]))]
      [`(,op ,e1 ,e2) (let ([v1 (interp1 e1 env)] [v2 (interp1 e2 env)])
                        (match op
                          ['+ (+ v1 v2)]
                          ['- (- v1 v2)]
                          ['* (* v1 v2)]
                          ['/ (/ v1 v2)]))])))

;;interface of the interpreter
(define interp (lambda (exp) (interp1 exp env0)))
       
;;test cases
(interp '(+ 1 2))
(interp '(* 2 3))
(interp '(* 2 (+ 3 4)))
(interp '(* (+ 1 2) (+ 3 4)))
(interp '(((lambda (x) (lambda (y) (* x y))) 2) 3))
(interp '((lambda (x) (* 2 x)) 3))
(interp '((lambda (y) (((lambda (y) (lambda (x) (* y 2))) 3) 0)) 4))
;(interp '(1 2))

  