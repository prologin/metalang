#lang racket
(require racket/block)

(define (abs_ n)
  (if (> n 0)
  n
  (- n))
)

(define main
  (printf "~a~a" (* (abs_ (+ 5 2)) 3) (* 3 (abs_ (+ 5 2))))
)

