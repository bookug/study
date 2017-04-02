(define-module (math bessel)
  #:export (j0))

;; NOTICE: place the libguile-bessel.so in /usr/lib64/guile/2.0/extensions/
(load-extension "libguile-bessel" "init_bessel")

