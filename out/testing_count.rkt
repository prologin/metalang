#lang racket
(require racket/block)

(define main
  (let ([tab (build-vector 40 (lambda (i) 
                                (* i i)))])
  (printf "~a\n" (vector-length tab)))
)

