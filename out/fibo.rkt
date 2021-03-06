#lang racket
(require racket/block)
(define last-char 0)
(define next-char (lambda () (set! last-char (read-char (current-input-port)))))
(next-char)
(define mread-int (lambda ()
  (if (eq? #\- last-char)
  (block
    (next-char) (- 0 (mread-int)))
    (letrec ([w (lambda (out)
      (if (eof-object? last-char)
        out
        (if (and last-char (>= (char->integer last-char) (char->integer #\0)) (<= (char->integer last-char) (char->integer #\9)))
          (let ([out (+ (* 10 out) (- (char->integer last-char) (char->integer #\0)))])
            (block
              (next-char)
              (w out)
          ))
        out
      )))]) (w 0)))))
(define mread-blank (lambda ()
  (if (or (eq? last-char #\NewLine) (eq? last-char #\Space) ) (block (next-char) (mread-blank)) '())
))

(define (fibo0 a b i)
  (let ([out0 0])
  (let ([a2 a])
  (let ([b2 b])
  (letrec ([c (lambda (j a2 b2 out0) (if (<= j (+ i 1))
                                     (let ([out0 (+ out0 a2)])
                                     (let ([tmp b2])
                                     (let ([b2 (+ b2 a2)])
                                     (let ([a2 tmp])
                                     (c (+ j 1) a2 b2 out0)))))
                                     out0))])
    (c 0 a2 b2 out0)))))
)

(define main
  ((lambda (a) 
     (block
       (mread-blank)
       ((lambda (b) 
          (block
            (mread-blank)
            ((lambda (i) 
               (display (fibo0 a b i))) (mread-int))
          )) (mread-int))
  )) (mread-int))
)

