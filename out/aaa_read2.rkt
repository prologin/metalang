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
(define mread-char (lambda ()
  (let ([ out last-char])
    (block
      (next-char)
      out
    ))))
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
                                                      (let ([b t_])
                                                      (list '() b))
                                                      )) (mread-int)))) '())])
tab)
)
(define (read_char_line n)
  ;toto
  (let ([tab (array_init_withenv n (lambda (i) 
                                     (lambda (_) ((lambda (t_) 
                                                    (let ([a t_])
                                                    (list '() a))) (mread-char)))) '())])
(block
  (mread-blank)
  tab
  ))
)
(define main
  (let ([len (read_int 'nil)])
  (block
    (display len)
    (display "=len\n")
    (let ([tab (read_int_line len)])
    (let ([q 0])
    (let ([r (- len 1)])
    (letrec ([p (lambda (i) 
                  (if (<= i r)
                  (block
                    (display i)
                    (display "=>")
                    (display (vector-ref tab i))
                    (display " ")
                    (p (+ i 1))
                    )
                  (block
                    (display "\n")
                    (let ([tab2 (read_int_line len)])
                    (let ([m 0])
                    (let ([o (- len 1)])
                    (letrec ([l (lambda (i_) 
                                  (if (<= i_ o)
                                  (block
                                    (display i_)
                                    (display "==>")
                                    (display (vector-ref tab2 i_))
                                    (display " ")
                                    (l (+ i_ 1))
                                    )
                                  (let ([strlen (read_int 'nil)])
                                  (block
                                    (display strlen)
                                    (display "=strlen\n")
                                    (let ([tab4 (read_char_line strlen)])
                                    (let ([h 0])
                                    (let ([k (- strlen 1)])
                                    (letrec ([g (lambda (i3) 
                                                  (if (<= i3 k)
                                                  (let ([tmpc (vector-ref tab4 i3)])
                                                  (let ([c (char->integer tmpc)])
                                                  (block
                                                    (display tmpc)
                                                    (display ":")
                                                    (display c)
                                                    (display " ")
                                                    (let ([c (if (not (eq? tmpc #\Space))
                                                             (let ([c (+ (remainder (+ (- c (char->integer #\a)) 13) 26) (char->integer #\a))])
                                                             c)
                                                             c)])
                                                    (block
                                                      (vector-set! tab4 i3 (integer->char c))
                                                      (g (+ i3 1))
                                                      ))
                                                    )))
                                                  (let ([e 0])
                                                  (let ([f (- strlen 1)])
                                                  (letrec ([d (lambda (j) 
                                                                (if (<= j f)
                                                                (block
                                                                  (display (vector-ref tab4 j))
                                                                  (d (+ j 1))
                                                                  )
                                                                '()))])
                                                  (d e))))))])
                                    (g h)))))
                                  ))))])
                    (l m)))))
      )))])
    (p q)))))
))
)
