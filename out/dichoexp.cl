
(si::use-fast-links nil)
(defun quotient (a b) (truncate a b))(defun remainder (a b) (- a (* b (truncate a b))))(let ((last-char 0)))
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

(defun exp0 (a b)
(if
  (= b 0)
  (return-from exp0 1)
  (if
    (= (remainder b 2) 0)
    (progn
      (let ((o (exp0 a (quotient b 2))))
        (return-from exp0 (* o o))
      ))
    (return-from exp0 (* a (exp0 a (- b 1)))))))

(progn
  (let ((a 0))
    (let ((b 0))
      (setq a (mread-int ))
      (mread-blank)
      (setq b (mread-int ))
      (princ (exp0 a b))
    )))


