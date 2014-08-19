#lang racket
(require racket/block)
(define array_init_withenv (lambda (len f env)
  (build-vector len (lambda (i)
    (let ([o ((f i) env)])
      (block
        (set! env (car o))
        (cadr o)
      )
    )))))
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

(define (read_int _)
  ;toto
  ((lambda (out_) 
     (block
       (mread-blank)
       out_
       )) (mread-int))
)
(define (read_int_line n)
  ;toto
  (let ([tab (array_init_withenv n (lambda (i) 
                                     (lambda (_) ((lambda (t_) 
                                                    (block
                                                      (mread-blank)
                                                      (let ([h t_])
                                                      (list '() h))
                                                      )) (mread-int)))) '())])
tab)
)
(define (result len tab)
  ;toto
  (let ([tab2 (array_init_withenv len (lambda (i) 
                                        (lambda (_) (let ([a #f])
                                                    (list '() a)))) '())])
  (let ([f 0])
  (let ([g (- len 1)])
  (letrec ([e (lambda (i1) 
                (if (<= i1 g)
                (block
                  (vector-set! tab2 (vector-ref tab i1) #t)
                  (e (+ i1 1))
                  )
                (let ([c 0])
                (let ([d (- len 1)])
                (letrec ([b (lambda (i2) 
                              (if (<= i2 d)
                              (if (not (vector-ref tab2 i2))
                              i2
                              (b (+ i2 1)))
                              (- 1)))])
                (b c))))))])
  (e f)))))
)
(define main
  (let ([len (read_int 'nil)])
  (block
    (display len)
    (display "\n")
    (let ([tab (read_int_line len)])
    (display (result len tab)))
    ))
)
