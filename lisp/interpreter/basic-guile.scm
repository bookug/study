; http://www.yinwang.org/blog-cn/2012/08/01/interpreter
; C version: https://zhuanlan.zhihu.com/p/20802519?refer=xiaochi
; C++　version: https://zhuanlan.zhihu.com/p/20834306

; if/cond can be used here, but pattern matching is suggested
(define tree-sum
  (lambda (exp)
    (match exp
      [(? number? x) x]    ;a number x?
      [`(,e1 ,e2)          ; a binary tree?
       (let ([v1 (tree-sum e1)]
             [v2 (tree-sum e2)])
         (+ v1 v2))])))

; unit test
(tree-sum '(1 2))
(tree-sum '(1 (2 3)))
(tree-sum '((1 2) 3))
(tree-sum '((1 2) (3 4)))



;; A calculator
;; an interpreter of arithmetic expression, is nothing more than a extended tree-traversal algorithm
;  '(* (+ 1 2) (+ 3 4))
; '((1 2) (3 4))
(define calc
  (lambda (exp)
    (match exp
      [(? number? x) x]
      [`(,op ,e1 ,e2)
       (let ([v1 (calc e1)]
             [v2 (calc e2)])
         (match op
           ['+ (+ v1 v2)]
           ['- (- v1 v2)]
           ['* (* v1 v2)]
           ['/ (/ v1 v2)]))])))

;; unit test
(calc '(+ 1 2))
(calc '(* 2 3))
(calc '(* (+ 1 2) (+ 3 4)))


;; A small program R2
;; variable, function and call, binding, arithmetic

; operations on environment
; Scheme Association list: ((x . 1) (y . 2) (z . 5)) alist of tuples (key value)
; the environment can be viewed as a stack, we search sequentially from top to bottom
(define env0 '())   ;empty environment
; extension: map x to v and transform env to a new environment
(define ext-env
  (lambda (x v env)
    (cons `(,x . ,v) env)))
; search: the value of x in env, #f if not found
(define lookup
  (lambda (x env)
    (let ([p (assq x env)])
      (cond
        [(not p) #f]
        [else (cdr p)]))))

;NOTICE: environment is immutable, generate new one in inner layer
;TODO: use more efficient data structure for environment like balanced tree or hash table, maybe functions

;NOTICE: we use lexical scoping(scheme) instead of dynamic scoping(Emacs Lisp), so function should be in closure
; the struct of a closure: function definition and its environment
(struct Closure (f env))

; the recursive definition of interpreter: ars (exp, env)
(define interp
  (lambda (exp env)
    (match exp
      [(? symbol? x)                             ;variable
       (let ([v (lookup x env)])
         (cond
           [(not v)
            (error "undefinied variable" x)]
           [else v]))]
      [(? number? x) x]                          ;number
      [`(lambda (,x) ,e)                         ;function
       (Closure exp env)]
      [`(let ([,x ,e1]) ,e2)                     ;binding
       (let ([v1 (interp e1 env)])
         (interp e2 (ext-env x v1 env)))]
      [`(,e1 ,e2)                                ;call
       (let ([v1 (interp e1 env)]
             [v2 (interp e2 env)])
         (match v1
           [(Closure `(lambda (,x) ,e) env-save)
            ; if we use env instead of env-save below, then it is dynamic scoping
            (interp e (ext-env x v2 env-save))]))] 
      [`(,op ,e1 ,e2)                              ;arithmetic expression
       (let ([v1 (interp e1 env)]
             [v2 (interp e2 env)])
         (match op
           ['+ (+ v1 v2)]
           ['- (- v1 v2)]
           ['* (* v1 v2)]
           ['/ (/ v1 v2)]))])))

; the user inetrface of interpreter
(define r2
  (lambda (exp)
    (interp exp env0)))

; unit test
(r2 '(+ 1 2))
(r2 '(* 2 3))
(r2 '(* 2 (+ 3 4)))
(r2 '(* (+ 1 2) (+ 3 4)))
(r2 '((lambda (x) (* 2 x)) 3))
(r2
'(let ([x 2])
   (let ([f (lambda (y) (* x y))])
     (f 3))))

;; dynamic scoping: no need to use closure
;(define interp2
;  (lambda (exp env)
;    (match exp                                          
;      ... ...
;      [`(lambda (,x) ,e)                          
;       exp]
;      ... ...
;      [`(,e1 ,e2)                                       
;       (let ([v1 (interp e1 env)]
;             [v2 (interp e2 env)])
;         (match v1
;           [`(lambda (,x) ,e)                     
;            (interp e (ext-env x v2 env))]))]
;      ... ...
;)))
; below can see the difference of lexical scoping and dynamic scoping
(display "to check scoping")
(r2
'(let ([x 2])
   (let ([f (lambda (y) (* x y))])
     (let ([x 4])
       (f 3)))))



;; TODO:
;; 1. let and function only support a parameter, more parameters can be supported by nested ones
;; 2. data structures: array, recursion, set!, string, self-defined structs...
;; 3. invalid pattern detection
;; 4. inefficient data structure like association list
;; 5. garbage collection: how to find the memory lost
;; 6. ambiguity of S-expression: (,op ,e1 ,e2)   (+ 1 2) (let ([x 1]) (* x 2)) need a parser: S-expression->Racket struct
;; 7. (let ([x e1]) e2) is equivlent to ((lambda (x) e2) e1), but why not consider scoping in let binding?









