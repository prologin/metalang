
(si::use-fast-links nil)
(defun array_init (len fun)
  (let ((out (make-array len)) (i 0))
    (while (not (= i len))
      (progn
        (setf (aref out i) (funcall fun i))
        (setq i (+ 1 i ))))
        out
    ))(let ((last-char 0)))
(defun next-char () (setq last-char (read-char *standard-input* nil)))
(next-char)
(defun mread-int ()
  (if (eq #\- last-char)
  (progn (next-char) (- 0 (mread-int)))
  (let ((out 0))
    (progn
      (while (and last-char (>= (char-int last-char) (char-int #\0)) (<= (char-int last-char) (char-int #\9)))
        (progn
          (setq out (+ (* 10 out) (- (char-int last-char) (char-int #\0))))
          (next-char)
        )
      )
      out
    ))))
(defun mread-blank () (progn
  (while (or (eq last-char #\NewLine) (eq last-char #\Space) ) (next-char))
))

(defun max2_ (a b)
(if
  (> a b)
  (return-from max2_ a)
  (return-from max2_ b)))

(defun read_int_matrix (x y)
(progn
  (let
   ((tab (array_init
            y
            (function (lambda (z)
            (block lambda_1
              (let
               ((d (array_init
                      x
                      (function (lambda (e)
                      (block lambda_2
                        (let ((f (mread-int )))
                          (mread-blank)
                          (return-from lambda_2 f)
                        )))
                      ))))
              (return-from lambda_1 d)
              )))
            ))))
  (return-from read_int_matrix tab)
  )))

(defun find_ (n m x y dx dy)
(if
  (or (or (or (< x 0) (= x 20)) (< y 0)) (= y 20))
  (return-from find_ (- 0 1))
  (if
    (= n 0)
    (return-from find_ 1)
    (return-from find_ (* (aref (aref m y) x) (find_ (- n 1) m (+ x dx) (+ y dy) dx dy))))))

(defstruct (tuple_int_int (:type list) :named)
  tuple_int_int_field_0
  tuple_int_int_field_1
  )

(progn
  (let
   ((directions (array_init
                   8
                   (function (lambda (i)
                   (block lambda_3
                     (if
                       (= i 0)
                       (progn
                         (let ((v (make-tuple_int_int :tuple_int_int_field_0 0
                                                      :tuple_int_int_field_1 1)))
                         (return-from lambda_3 v)
                       ))
                     (if
                       (= i 1)
                       (progn
                         (let ((u (make-tuple_int_int :tuple_int_int_field_0 1
                                                      :tuple_int_int_field_1 0)))
                         (return-from lambda_3 u)
                       ))
                       (if
                         (= i 2)
                         (progn
                           (let ((s (make-tuple_int_int :tuple_int_int_field_0 0
                                                        :tuple_int_int_field_1 (- 0 1))))
                           (return-from lambda_3 s)
                         ))
                         (if
                           (= i 3)
                           (progn
                             (let ((r (make-tuple_int_int :tuple_int_int_field_0 (- 0 1)
                                                          :tuple_int_int_field_1 0)))
                             (return-from lambda_3 r)
                           ))
                           (if
                             (= i 4)
                             (progn
                               (let ((q (make-tuple_int_int :tuple_int_int_field_0 1
                                                            :tuple_int_int_field_1 1)))
                               (return-from lambda_3 q)
                             ))
                             (if
                               (= i 5)
                               (progn
                                 (let ((p (make-tuple_int_int :tuple_int_int_field_0 1
                                                              :tuple_int_int_field_1 (- 0 1))))
                                 (return-from lambda_3 p)
                               ))
                               (if
                                 (= i 6)
                                 (progn
                                   (let ((o (make-tuple_int_int :tuple_int_int_field_0 (- 0 1)
                                                                :tuple_int_int_field_1 1)))
                                   (return-from lambda_3 o)
                                 ))
                                 (progn
                                   (let ((l (make-tuple_int_int :tuple_int_int_field_0 (- 0 1)
                                                                :tuple_int_int_field_1 (- 0 1))))
                                   (return-from lambda_3 l)
                                 )))))))))
))
))))
(let ((max_ 0))
  (let ((m (read_int_matrix 20 20)))
    (do
      ((j 0 (+ 1 j)))
      ((> j 7))
      (progn
        (let ((k (aref directions j)))
          (let ((dx (tuple_int_int-tuple_int_int_field_0 k)))
            (let ((dy (tuple_int_int-tuple_int_int_field_1 k)))
              (do
                ((x 0 (+ 1 x)))
                ((> x 19))
                (do
                  ((y 0 (+ 1 y)))
                  ((> y 19))
                  (progn
                    (let ((h (find_ 4 m x y dx dy)))
                      (let ((g (max2_ max_ h)))
                        (setq max_ g)
                      )))
                  )
              )
            ))))
    )
    (princ max_)
    (princ "
")
  ))))


