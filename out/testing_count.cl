
(defun array_init (len fun)
  (let ((out (make-array len)))
    (progn
      (loop for i from 0 to (- len 1) do
        (setf (aref out i) (funcall fun i)))
      out
    )))

(progn
  (let
   ((tab (array_init
            40
            (function (lambda (i)
            (block lambda_1
              (return-from lambda_1 (* i i))
            ))
            ))))
  (format t "~D~%" (length tab)))
  
)

