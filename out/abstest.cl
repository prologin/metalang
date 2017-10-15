(defun abs_ (n)
(progn
  (if
    (> n 0)
    (return-from abs_ n)
    (return-from abs_ (- 0 n)))
))
(progn
  (format t "~D~D" (* (abs_ (+ 5 2)) 3) (* 3 (abs_ (+ 5 2))))
)

