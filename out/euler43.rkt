#lang racket
(require racket/block)

(define main
  ;
  ;The number, 1406357289, is a 0 to 9 pandigital number because it is made up of each of the digits 0 to 9 in some order, but it also has a rather interesting sub-string divisibility property.
  ;
  ;Let d1 be the 1st digit, d2 be the 2nd digit, and so on. In this way, we note the following:
  ;
  ;d2d3d4=406 is divisible by 2
  ;d3d4d5=063 is divisible by 3
  ;d4d5d6=635 is divisible by 5
  ;d5d6d7=357 is divisible by 7
  ;d6d7d8=572 is divisible by 11
  ;d7d8d9=728 is divisible by 13
  ;d8d9d10=289 is divisible by 17
  ;Find the sum of all 0 to 9 pandigital numbers with this property.
  ;
  ;d4 % 2 == 0
  ;(d3 + d4 + d5) % 3 == 0
  ;d6 = 5 ou d6 = 0
  ;(d5 * 100 + d6 * 10 + d7  ) % 7 == 0
  ;(d6 * 100 + d7 * 10 + d8  ) % 11 == 0
  ;(d7 * 100 + d8 * 10 + d9  ) % 13 == 0
  ;(d8 * 100 + d9 * 10 + d10 ) % 17 == 0
  ;
  ;
  ;d4 % 2 == 0
  ;d6 = 5 ou d6 = 0
  ;
  ;(d3 + d4 + d5) % 3 == 0
  ;(d5 * 2 + d6 * 3 + d7) % 7 == 0
  ;
  (let ([allowed (build-vector 10 (lambda (i) 
                                    #t))])
  (letrec ([c (lambda (i6) 
                (if (<= i6 1)
                (let ([d6 (* i6 5)])
                (if (vector-ref allowed d6)
                (block
                  (vector-set! allowed d6 #f)
                  (letrec ([d (lambda (d7) 
                                (if (<= d7 9)
                                (if (vector-ref allowed d7)
                                (block
                                  (vector-set! allowed d7 #f)
                                  (letrec ([e (lambda (d8) 
                                                (if (<= d8 9)
                                                (if (vector-ref allowed d8)
                                                (block
                                                  (vector-set! allowed d8 #f)
                                                  (letrec ([f (lambda (d9) 
                                                                (if (<= d9 9)
                                                                (if (vector-ref allowed d9)
                                                                (block
                                                                  (vector-set! allowed d9 #f)
                                                                  (letrec ([g (lambda (d10) 
                                                                                (if (<= d10 9)
                                                                                (if (and (and (and (vector-ref allowed d10) (eq? (remainder (+ (+ (* d6 100) (* d7 10)) d8) 11) 0)) (eq? (remainder (+ (+ (* d7 100) (* d8 10)) d9) 13) 0)) (eq? (remainder (+ (+ (* d8 100) (* d9 10)) d10) 17) 0))
                                                                                (block
                                                                                (vector-set! allowed d10 #f)
                                                                                (letrec ([h 
                                                                                (lambda (d5) 
                                                                                (if (<= d5 9)
                                                                                (if (vector-ref allowed d5)
                                                                                (block
                                                                                (vector-set! allowed d5 #f)
                                                                                (if (eq? (remainder (+ (+ (* d5 100) (* d6 10)) d7) 7) 0)
                                                                                (letrec ([j 
                                                                                (lambda (i4) 
                                                                                (if (<= i4 4)
                                                                                (let ([d4 (* i4 2)])
                                                                                (if (vector-ref allowed d4)
                                                                                (block
                                                                                (vector-set! allowed d4 #f)
                                                                                (letrec ([k 
                                                                                (lambda (d3) 
                                                                                (if (<= d3 9)
                                                                                (if (vector-ref allowed d3)
                                                                                (block
                                                                                (vector-set! allowed d3 #f)
                                                                                (if (eq? (remainder (+ (+ d3 d4) d5) 3) 0)
                                                                                (letrec ([l 
                                                                                (lambda (d2) 
                                                                                (if (<= d2 9)
                                                                                (if (vector-ref allowed d2)
                                                                                (block
                                                                                (vector-set! allowed d2 #f)
                                                                                (letrec ([m 
                                                                                (lambda (d1) 
                                                                                (if (<= d1 9)
                                                                                (if (vector-ref allowed d1)
                                                                                (block
                                                                                (vector-set! allowed d1 #f)
                                                                                (printf "~a~a~a~a~a~a~a~a~a~a + " d1 d2 d3 d4 d5 d6 d7 d8 d9 d10)
                                                                                (vector-set! allowed d1 #t)
                                                                                (m (+ d1 1))
                                                                                )
                                                                                (m (+ d1 1)))
                                                                                (block
                                                                                (vector-set! allowed d2 #t)
                                                                                (l (+ d2 1))
                                                                                )))])
                                                                                (m 0))
                                                                                )
                                                                                (l (+ d2 1)))
                                                                                '()))])
                                                                                (l 0))
                                                                                '())
                                                                                (vector-set! allowed d3 #t)
                                                                                (k (+ d3 1))
                                                                                )
                                                                                (k (+ d3 1)))
                                                                                (block
                                                                                (vector-set! allowed d4 #t)
                                                                                (j (+ i4 1))
                                                                                )))])
                                                                                (k 0))
                                                                                )
                                                                                (j (+ i4 1))))
                                                                                '()))])
                                                                                (j 0))
                                                                                '())
                                                                                (vector-set! allowed d5 #t)
                                                                                (h (+ d5 1))
                                                                                )
                                                                                (h (+ d5 1)))
                                                                                (block
                                                                                (vector-set! allowed d10 #t)
                                                                                (g (+ d10 1))
                                                                                )))])
                                                                    (h 0))
                                                                  )
                                                                (g (+ d10 1)))
                                                                (block
                                                                  (vector-set! allowed d9 #t)
                                                                  (f (+ d9 1))
                                                                  )))])
                                                  (g 1))
                                                )
                                                (f (+ d9 1)))
                                                (block
                                                  (vector-set! allowed d8 #t)
                                                  (e (+ d8 1))
                                                  )))])
                                (f 0))
                                )
                                (e (+ d8 1)))
                    (block
                      (vector-set! allowed d7 #t)
                      (d (+ d7 1))
                      )))])
                (e 0))
                )
                (d (+ d7 1)))
    (block
      (vector-set! allowed d6 #t)
      (c (+ i6 1))
      )))])
(d 0))
)
(c (+ i6 1))))
(printf "~a\n" 0)))])
(c 0)))
)
