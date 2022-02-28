;;; done by https://github.com/fraking00 , https://github.com/AndreaD148
;;; URI CLASS
(defclass uri ()
  ((u-scheme :initarg :scheme
             :accessor s-g-uri-scheme) ;; accessor in getrter and setter
   (u-userinfo :initarg :userinfo
               :accessor s-g-uri-userinfo)
   (u-host :initarg :host
           :accessor s-g-uri-host)
   (u-port :initarg :port
           :accessor s-g-uri-port)
   (u-path :initarg :path
           :accessor s-g-uri-path)
   (u-query :initarg :query
            :accessor s-g-uri-query)
   (u-fragment :initarg :fragment
               :accessor s-g-uri-fragment))
  (:default-initargs
   :scheme NIL
   :userinfo NIL
   :host NIL
   :port 80
   :path NIL
   :query NIL
   :fragment NIL))


(defmethod uri-scheme ((my-uri uri))
  (s-g-uri-scheme my-uri))


(defmethod uri-userinfo ((my-uri uri))
  (s-g-uri-userinfo my-uri))


(defmethod uri-host ((my-uri uri))
  (s-g-uri-host my-uri))


(defmethod uri-port ((my-uri uri))
  (s-g-uri-port my-uri))


(defmethod uri-path ((my-uri uri))
  (s-g-uri-path my-uri))


(defmethod uri-query ((my-uri uri))
  (s-g-uri-query my-uri))


(defmethod uri-fragment ((my-uri uri))
  (s-g-uri-fragment my-uri))



(defun uri-display (my-uri &optional (my-stream *standard-output*))
  (if (stringp my-stream)
      (progn
        (with-open-file
         (file my-stream
               :direction :output
               :if-does-not-exist :create
               :if-exists :append)
         (format file "Scheme   : ~t ~A ~%" (uri-scheme my-uri))
         (format file "Userinfo : ~t ~A ~%" (uri-userinfo my-uri))
         (format file "Host     : ~t ~A ~%" (uri-host my-uri))
         (format file "Port     : ~t ~A ~%" (uri-port my-uri))
         (format file "Path     : ~t ~A ~%" (uri-path my-uri))
         (format file "Query    : ~t ~A ~%" (uri-query my-uri))
         (format file "Fragment : ~t ~A ~%" (uri-fragment my-uri))
         T
         ))
    (progn
      (format T "Scheme   : ~t ~A ~%" (uri-scheme my-uri))
      (format T "Userinfo : ~t ~A ~%" (uri-userinfo my-uri))
      (format T "Host     : ~t ~A ~%" (uri-host my-uri))
      (format T "Port     : ~t ~A ~%" (uri-port my-uri))
      (format T "Path     : ~t ~A ~%" (uri-path my-uri))
      (format T "Query    : ~t ~A ~%" (uri-query my-uri))
      (format T "Fragment : ~t ~A ~%" (uri-fragment my-uri))
      T
      ))
  )


(defun string-to-list (my-string)
  (if (stringp my-string)
      (coerce my-string 'list)))


(defun string-to-ascii (my-string)
  (if (stringp my-string)
      (mapcar (lambda (c)
                (char-code c)) (coerce my-string 'list))))

(defun ascii-to-string (ascii-list)
  (if (listp ascii-list)
      (mapcar (lambda (c)
                (code-char c)) ascii-list)))

(defun list-of-char-to-string (list-of-char)
  (if (listp list-of-char)
      (mapcar (lambda (c)
                (string c)) list-of-char)))

(defun my-concat (my-list)
  (if (listp my-list)
      (cond ((null my-list) NIL)
            ((= (length my-list) 1) (car my-list))
            (T (concatenate 'string (car my-list)
                            (my-concat (cdr my-list)))))))



(defun get-last-element (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1) (car l))
            (T
             (get-last-element (cdr l))))))


;;; funzione che controlla se il parametro è un colon o meno
(defun colonp (c)
  (if (= c 58)
      -1
    c))


;;; funzione che controlla se il parametro è uno slash o meno
(defun slashp (c)
  (if (= c 47)
      -2
    c))

;;; funzione che controlla se il parametro è un question mark o meno
(defun qmarkp (qmark)
  (if (= qmark 63)
      -3
    qmark))

;;; funzione che controlla se il parametro è un hash o meno
(defun hashp (hash)
  (if (= hash 35)
      -4
    hash))

;;; funzione che controlla se il parametro è un at o meno
(defun atp (at)
  (if (= at 64)
      -5
    at))


;;; funzione che controlla se il parametro è uno dot o meno
(defun dotp (dot)
  (if (= dot 46)
      -6
    dot))


(defun identificatorp (char-id)
  (if (and (not (= char-id -1))
           (and (not (= char-id -2))
                (and (not (= char-id -3))
                     (and (not (= char-id -4))
                          (not (= char-id -5))))))
      char-id
    32))


(defun host-identificator (char-id)
  (if (and (not (= char-id -1))
           (and (not (= char-id -2))
                (and (not (= char-id -3))
                     (and (not (= char-id -4))
                          (and (not (= char-id -5))
                               (not (= char-id -6)))))))
      char-id
    32))


(defun zos-alphanumeric (char-id)
  (if (or (and (< char-id 58) (> char-id 47))
          (and (< char-id 91) (> char-id 64))
          (and (< char-id 123) (> char-id 96)))
      char-id
    32
    ))

(defun id44-alphanumeric (char-id)
  (if (or (and (< char-id 58) (> char-id 47))
          (and (< char-id 91) (> char-id 64))
          (and (< char-id 123) (> char-id 96))
          (= char-id -6))
      char-id
    32
    ))



(defun digit (num)
  (if (and (<= num 57) (>= num 48))
      num
    32))



(defun query (que)
  (if (not (= que -4))
      que
    32))

(defun fragment (frag)
  (if (< frag 127)
      frag
    32))


(defun check-identificator (id)
  (if (listp id)
      (remove 32 (mapcar 'identificatorp id))))


(defun check-host-identificator (id)
  (if (listp id)
      (remove 32 (mapcar 'host-identificator id))))


(defun check-num (number)
  (if (listp number)
      (remove 32 (mapcar 'digit  number))))


(defun check-query (que)
  (if (listp que)
      (remove 32 (mapcar 'query que))))


(defun check-fragment (frag)
  (if (listp frag)
      (remove 32 (mapcar 'fragment frag))))


(defun check-zos-alpha (zos)
  (if (listp zos)
      (remove 32 (mapcar 'zos-alphanumeric zos))))



(defun check-id44-zos-alpha (id)
  (if (listp id)
      (remove 32 (mapcar 'id44-alphanumeric id))))


;;; schemep mi ritorna T se scheme è valido, NIL altrimenti
(defun schemep (scheme-list)
  (if (listp scheme-list)
      (if (equal scheme-list (check-identificator scheme-list))
          T
        NIL)))


;;; userinfop mi ritorna T se userinfo è valido, NIL altrimenti
(defun userinfop (userinfo)
  (if (listp userinfo)
      (if (equal userinfo (check-identificator userinfo))
          T
        NIL)))


;;; portp mi ritorna T se port è valido, NIL altrimenti
(defun portp (port)
  (if (listp port)
      (if (equal port (check-num port))
          T
        NIL)
    NIL))


;;; queryp mi ritorna T se query è valido, NIL altrimenti
(defun queryp (query)
  (if (listp query)
      (if (equal query (check-query query))
          T
        NIL)
    NIL))


;;; fragmentp mi ritorna T se fragment è valido, NIL altrimenti
(defun fragmentp (fragment)
  (if (listp fragment)
      (if (equal fragment (check-fragment fragment))
          T
        NIL)
    NIL))


;;; nilp mi ritorna T se contiene un nil, NIL altrimenti
(defun nilp (list)
  (if (listp list)
      (cond ((null list) NIL)
            ((= (length list) 1) (null (car list)))
            (T (or (null (car list)) (nilp (cdr list)))))))


(defun transform-word (word)
  (if (stringp word)
      (mapcar 'dotp
              (mapcar 'slashp
                      (mapcar 'atp
                              (mapcar 'qmarkp
                                      (mapcar 'hashp
                                              (mapcar 'colonp
                                                      (string-to-ascii word))))
                              )))))




(defun positive-nums (l)
  (if (listp l)
      (if (null l)
          0
        (if (> (car l) 0)
            (+ (positive-nums (cdr l)) 1)
          (positive-nums (cdr l))))))


(defun negative-nums (l)
  (if (listp l)
      (if (null l)
          0
        (if (< (car l) 0)
            (+ (negative-nums (cdr l)) 1)
          (negative-nums (cdr l))))))

(defun check-ip-length (ip)
  (if (stringp ip)
      (= (length (mapcar 'dotp (string-to-ascii ip))) 15)))



(defun check-positive-num (ip)
  (if (stringp ip)
      (= (positive-nums (mapcar 'dotp (string-to-ascii ip))) 12)))

(defun check-negative-nums (ip)
  (if (stringp ip)
      (= (negative-nums (mapcar 'dotp (string-to-ascii ip))) 3)))

(defun ipp (ip)
  (if (stringp ip)
      (and (check-ip-length ip)
           (and (check-positive-num ip) (check-negative-nums ip)))))



(defun get-last-element (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1) (car l))
            (T (get-last-element (cdr l))))))

(defun hostp (host)
  (if (listp host)
      (if (not (null host))
          (if (and (equal host (check-identificator host))
                   (> (get-last-element host) 0))
              T
            NIL)
        NIL)
    NIL))


(defun path-id (char-id)
  (if (and (not (= char-id -4))
           (and (and (not (= char-id -1))
                     (and (not (= char-id -3))
                          (not (= char-id -5))))))
      char-id
    32))



(defun check-path-id (path)
  (if (listp path)
      (remove 32 (mapcar 'path-id path))))



(defun pathp (path)
  (if (listp path)
      (if (equal path (check-path-id path))
          T
        NIL)
    NIL))



(defun news-hostp (host)
  (if (listp host)
      (if (not (null host))
          (if (and (equal host (check-identificator host))
                   (> (get-last-element host) 0))
              T
            NIL)
        NIL)
    NIL))

(defun tel-or-fax-uinfop (userinfo)
  (if (listp userinfo)
      (if (not (null userinfo))
          (if (equal userinfo (check-identificator userinfo))
              T
            NIL)
        NIL)
    NIL))


;;; l is for list and s for separator
(defun is-there-any (l s)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (= (car l) s)
                 T
               NIL))
            (T
             (if (= (car l) s)
                 T
               (is-there-any (cdr l) s))))))


(defun get-scheme (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (= (car l) -1)
                 NIL
               (list (car l))))
            (T
             (if (is-there-any l -1)
                 (if (= (car l) -1)
                     NIL
                   (append (list (car l))
                           (get-scheme (cdr l))))
               NIL)))))



(defun get-userinfo (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (or (= (car l) -5)
                     (= (car l) -1)
                     (= (car l) -2))
                 NIL
               (list (car l))))
            (T
             (if (or (= (car l) -5)
                     (= (car l) -1)
                     (= (car l) -2))
                 NIL
               (append (list (car l)) (get-userinfo (cdr l))))))))


(defun get-host (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (or (= (car l) -1) (= (car l) -2))
                 NIL
               (list (car l))))
            (T
             (if (or (= (car l) -1) (= (car l) -2))
                 NIL
               (append (list (car l)) (get-host (cdr l))))))))


(defun get-port (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (= (car l) -2)
                 NIL
               (list (car l))))
            (T
             (if (= (car l) -2)
                 NIL
               (append (list (car l)) (get-port (cdr l))))))))




(defun get-path (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (or (= (car l) -3)
                     (= (car l) -4))
                 NIL
               (list (car l))))
            (T
             (if (or (is-there-any l -3)
                     (is-there-any l -4))
                 (if (or (= (car l) -3)
                         (= (car l) -4))
                     NIL
                   (append (list (car l))
                           (get-path (cdr l))))
               (append (list (car l))
                       (get-path (cdr l))))))))

(defun get-query (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (= (car l) -4)
                 NIL
               (list (car l))))
            (T
             (if (is-there-any l -4)
                 (if (= (car l) -4)
                     NIL
                   (append (list (car l))
                           (get-path (cdr l))))
               (append (list (car l))
                       (get-path (cdr l))))))))

(defun get-fragment (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1) (list (car l)))
            (T (append (list (car l)) (get-fragment (cdr l)))))))



(defun get-id44 (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (or (= (car l) 40)
                     (= (car l) -3)
                     (= (car l) -4))
                 NIL
               (list (car l))))
            (T
             (if (or (= (car l) 40)
                     (= (car l) -3)
                     (= (car l) -4))
                 NIL
               (append (list (car l))
                       (get-id44 (cdr l))))))))


(defun get-id8 (l)
  (if (listp l)
      (cond ((null l) NIL)
            ((= (length l) 1)
             (if (or (= ( car l) -3)
                     (= (car l) -4))
                 NIL
               (list (car l))))
            (T
             (if (or (= ( car l) -3)
                     (= (car l) -4))
                 NIL
               (append (list (car l))
                       (get-id8 (cdr l))))))))



(defun check-initial-zos-char (c)
  (if (or (and (< c 91) (> c 64))
          (and (< c 123) (> c 96)))
      T
    NIL))


(defun idp (id)
  (if (listp id)
      (if (and (equal id (check-zos-alpha id))
               (check-initial-zos-char (car id)))
          T
        NIL)
    NIL))


(defun id44p (id)
  (if (listp id)
      (if (and (equal id (check-id44-zos-alpha id))
               (<= (length id) 44)
               (check-initial-zos-char (car id))
               (not (= (get-last-element (last id)) -6))
               )
          T
        NIL)
    NIL))


(defun get-internal-id8 (id8)
  (if (listp id8)
      (if (and (not (null id8))
               (not (= (car id8) 41)))
          (append (list (car id8))
                  (get-internal-id8 (cdr id8))))))

(defun id8p (id)
  (let ((internal))
    (if (listp id)
        (progn
          (setf internal
                (get-internal-id8 id))
          (if (and (idp internal)
                   (<= (length internal) 8))
              T
            NIL
            ))
      NIL)))



(defun transform-ascii (ch)
  (if (= ch -1)
      58
    (if (= ch -2)
        47
      (if (= ch -3)
          63
        (if (= ch -4)
            35
          (if (= ch -5)
              64
            (if (= ch -6)
                46
              ch)))))))

(defun adj-list (l)
  (if (listp l)
      (mapcar 'transform-ascii l)))

(defun scheme-passed (input-list)
  (if (not (= (car input-list) -1))
      (scheme-passed (cdr input-list))
    (cdr input-list)))




(defun userinfo-passed (input-list)
  (if (and (not (null (cdr input-list)))
           (not (= (car input-list) -5)))
      (userinfo-passed (cdr input-list))
    input-list))


(defun host-passed (input-list)
  (if (and (not (null (cdr input-list)))
           (not (= (car input-list) -1))
           (not (= (car input-list) -2)))
      (host-passed (cdr input-list))
    (progn
      (if (null input-list)
          (error 'on-empty :message "Empty authority")
        input-list))
    ))


(defun port-passed (input-list)
  (if (and (not (null (cdr input-list)))
           (not (= (car input-list) -2)))
      (port-passed (cdr input-list))
    input-list))

(defun path-passed (input-list)
  (if (and (not (null (cdr input-list)))
           (not(= (car input-list) -3))
           (not (= (car input-list) -4)))
      (path-passed (cdr input-list))
    input-list))

(defun query-passed (input-list)
  (if (and (not (null (cdr input-list)))
           (not (= (car input-list) -4)))
      (query-passed (cdr input-list))
    input-list))


(defun id44-passed (input-list)
  (if (and (not (null (cdr input-list)))
           (not (= (car input-list) 40))
           (not (= (car input-list) -3))
           (not (= (car input-list) -4)))
      (id44-passed (cdr input-list))
    input-list))


(defun id8-passed (input-list)
  (if (and (not (null input-list))
           (not (= (car input-list) 41)))
      (id8-passed (cdr input-list))
    input-list))



(defun get-string (l)
  (if (listp l)
      (cond ((null l) NIL)
            (T
             (my-concat (list-of-char-to-string
                         (ascii-to-string
                          (adj-list
                           l))))))))


(define-condition on-empty (error)
  ((message :initarg :message :reader message)))

(define-condition on-invalid-char (error)
  ((message :initarg :message :reader message)))



(defun parse-fragment (uri-list uri-i)
  (let ((fragment-list))
    (if (null uri-list)
        (progn
          (error 'on-empty :message "Empty fragment, but hash is present")
          )
      (progn
        (setf fragment-list (get-fragment uri-list))
        (if (fragmentp fragment-list)
            (progn
              (setf (s-g-uri-fragment uri-i)
                    (get-string fragment-list))))))))


(defun parse-from-query (uri-list uri-i)
  (let ((query-list)
        (aux-list))
    (if (not (null uri-list))
        (progn
          (setf query-list (get-query uri-list))
          (if (null query-list)
              (progn
                (error 'on-empty :message "Empty query but ? is present")
                )
            (progn
              (setf query-list (get-query uri-list))
              (if (queryp query-list)
                  (progn
                    (setf aux-list (query-passed uri-list))
                    (setf (s-g-uri-query uri-i)
                          (get-string query-list))
                    (if (= (car aux-list) -4)
                        (parse-fragment (cdr aux-list) uri-i))
                    )))))
      (progn
        (error 'on-empty :message "Empty query but ? is present")
        ))))

;; uri-i è uri-instance
(defun parse-from-path (uri-list uri-i)
  (let ((path-list)
        (aux-list))
    (setf path-list (get-path uri-list))
    (if (pathp path-list)
        (progn
          (setf aux-list (path-passed uri-list))
          (setf (s-g-uri-path uri-i)
                (get-string path-list))
          (if (not (= (car aux-list) -2))
              (if (= (car aux-list) -3)
                  (progn
                    (parse-from-query (cdr aux-list) uri-i)
                    )
                (if (= (car aux-list) -4)
                    (progn
                      (parse-fragment (cdr aux-list) uri-i)
                      )))
            (if (= (car aux-list) -2)
                (progn
                  (error 'on-invalid-char :message "Invalid path")
                  NIL
                  )
              )
            )
          )
      (progn
        (error 'on-invalid-char :message "Invalid path")
        NIL))
    ))






(defun parse-from-zos-path (uri-list uri-i)
  (let ((path-list)
        (id44-list)
        (id8-list)
        (aux-list))
    (if (and (is-there-any uri-list 40)
             (is-there-any uri-list 41))
        (progn
          (setf id44-list (get-id44 uri-list))
          (if (id44p id44-list)
              (progn
                (setf aux-list (id44-passed uri-list))
                (setf id8-list (get-id8 (cdr aux-list)))
                (if (not (= (car id8-list) 41))
                    (if (id8p id8-list)
                        (progn
                          (setf path-list
                                (append (append id44-list (list 40))
                                        id8-list))
                          (setf (s-g-uri-path uri-i)
                                (get-string path-list))
                          (setf aux-list (id8-passed aux-list))
                          (if (> (length aux-list) 1)
                              (if (= (second aux-list) -3)
                                  (parse-from-query
                                   (cdr (cdr aux-list))
                                   uri-i)
                                (if (= (second aux-list) -4)
                                    (parse-fragment
                                     (cdr (cdr aux-list))
                                     uri-i)
                                  (error 'on-invalid-char
                                         :message "Invalid char"))
                                )
                            )
                          )
                      (error 'on-invalid-char :message "invalid id8"))
                  (error 'on-invalid-char :message "empty id8")
                  )
                )
            (error 'on-invalid-char :message "invalid id44")
            )
          )
      (progn
        ;; andrebbe messo il controllo. Se è presente solo una
        ;; delle due parentesi si va in errore
        (if (or (and (is-there-any uri-list 40)
                     (not (is-there-any uri-list 41)))
                (and (is-there-any uri-list 41)
                     (not (is-there-any uri-list 40))))
            ;; se c'è una sola parentesi
            (error 'on-invalid-char
                   :message "Only one bracket is present")
          (progn
            (setf id44-list (get-id44 uri-list))
            (if (id44p id44-list)
                (progn
                  (setf path-list id44-list)
                  (setf (s-g-uri-path uri-i)
                        (get-string path-list))
                  (setf aux-list
                        (id44-passed uri-list))
                  (if (= (car aux-list) -3)
                      (progn
                        (parse-from-query
                         (cdr aux-list)
                         uri-i
                         )
                        )
                    (if (= (car aux-list) -4)
                        (progn
                          (parse-fragment
                           (cdr aux-list)
                           uri-i)))
                    ))
              (error 'on-invalid-char :message "Invalid id44"))
            )
          )
        ))
    )
  )



(defun parse-from-port (uri-list uri-i)
  (let ((port-list)
        (aux-list))
    (setf port-list (get-port uri-list))
    (if (portp port-list)
        (progn
          (setf (s-g-uri-port uri-i)
                (parse-integer
                 (get-string port-list)))
          (setf aux-list (port-passed uri-list))
          (if (equalp (uri-scheme uri-i) "zos")
              (if (= (car aux-list) -2)
                  (if (= (length aux-list) 1)
                      (error 'on-empty
                             :message "zos path is required")
                    (if (and (not (= (second aux-list) -3))
                             (not (= (second aux-list) -4)))
                        (progn
                          ;; zos path
                          (parse-from-zos-path
                           (cdr aux-list)
                           uri-i)
                          )
                      (error 'on-empty "path is required"))))
            (if (= (car aux-list) -2)
                (if (= (length aux-list) 1)
                    T
                  (if (and (not (= (second aux-list) -3))
                           (not (= (second aux-list) -4)))
                      (parse-from-path
                       (cdr aux-list)
                       uri-i)
                    (if (= (second aux-list) -3)
                        (parse-from-query
                         (cdr (cdr aux-list))
                         uri-i)
                      (if (= (second aux-list) -4)
                          (parse-fragment
                           (cdr (cdr aux-list))
                           uri-i)))
                    ))))
          )
      (error 'on-invalid-char :message "Invalid Port"))))




(defun parse-from-host (uri-list uri-i)
  (let ((userinfo-list)
        (host-list)
        (aux-list))
    (setf userinfo-list (get-userinfo uri-list))
    (setf host-list (get-host uri-list))
    (if (not (equal userinfo-list host-list))
        (progn
          ;; siamo nel caso con anche userinfo
          (if (userinfop userinfo-list)
              (progn
                ;; userinfo valido
                (setf (s-g-uri-userinfo uri-i)
                      (get-string userinfo-list))
                (setf aux-list (userinfo-passed uri-list))
                (setf host-list (get-host (cdr aux-list)))
                (if (hostp host-list)
                    (progn
                      ;; caso in cui host è valido
                      (setf (s-g-uri-host uri-i)
                            (get-string host-list))
                      (setf aux-list (host-passed aux-list))
                      ;; adesso potremmo dividere le casistiche
                      ;; in: si zos, no zos
                      (if (equalp (uri-scheme uri-i) "zos")
                          ;; divisione per lunghezza aux
                          (if (= (length aux-list) 1)
                              ;; gestione errori singolo carattere
                              (if (= (car aux-list) -1)
                                  (error 'on-empty
                                         :message "Port is required")
                                (if (= (car aux-list) -2)
                                    (error 'on-empty
                                           :message "Zos is required")))
                            (if (> (length aux-list) 1)
                                (if (= (car aux-list) -2)
                                    (if (and (not (= (second aux-list) -3))
                                             (not (= (second aux-list) -4)))
                                        (parse-from-zos-path
                                         (cdr aux-list)
                                         uri-i)
                                      (error 'on-invalid-char
                                             :message "Invalid char"))
                                  (if (= (car aux-list) -1)
                                      (parse-from-port
                                       (cdr aux-list)
                                       uri-i)))
                              )
                            )
                        (progn
                          ;; non siamo in zos
                          (if (= (length aux-list) 1)
                              (if (= (car aux-list) -1)
                                  (error 'on-empty
                                         :message "Port is required"))
                            (if (> (length aux-list) 1)
                                ;; devo fare i vari casi
                                (if (= (car aux-list) -1)
                                    (parse-from-port
                                     (cdr aux-list)
                                     uri-i)
                                  (if (= (car aux-list) -2)
                                      (if (and (not (= (second aux-list) -3))
                                               (not (= (second aux-list) -4)))
                                          ;; siamo in path
                                          (parse-from-path
                                           (cdr aux-list)
                                           uri-i)
                                        (if (= (second aux-list) -3)
                                            ;; query case
                                            (parse-from-query
                                             (cdr (cdr aux-list))
                                             uri-i)
                                          (if (= (second aux-list) -4)
                                              (parse-fragment
                                               (cdr (cdr aux-list))
                                               uri-i))
                                          )
                                        )))
                              )))
                        )
                      )
                  (error 'on-invalid-char :message "Invalid Host"))
                )
            (error 'on-invalid-char :message "Invalid Userinfo"))
          )
      (progn
        ;; siamo con userinfo e host uguali
        ;; avendo già settato host list
        ;; posso fare il controllo se sia valida o meno
        (if (hostp host-list)
            (progn
              (setf (s-g-uri-host uri-i)
                    (get-string host-list))
              ;; settiamo auxlist e partiamo con i controlli
              (setf aux-list (host-passed uri-list))
              (if (equalp (uri-scheme uri-i) "zos")
                  ;; siamo in zos
                  (if (= (length aux-list) 1)
                      (if (= (car aux-list) -1)
                          (error 'on-empty
                                 :message "Port is required")
                        (if (= (car aux-list) -2)
                            (error 'on-empty
                                   :message "Zos is required")))
                    (if (> (length aux-list) 1)
                        (if (= (car aux-list) -1)
                            (parse-from-port
                             (cdr aux-list)
                             uri-i)
                          (if (= (car aux-list) -2)
                              (if (and (not (= (second aux-list) -3))
                                       (not (= (second aux-list) -4)))
                                  (parse-from-zos-path
                                   (cdr aux-list)
                                   uri-i)
                                (error 'on-invalid-char
                                       :message "Invalid char"))
                            )))
                    )
                (progn
                  (if (= (length aux-list) 1)
                      (if (= (car aux-list) -1)
                          (error 'on-empty
                                 :message "Port is required")
                        )
                    (if (> (length aux-list) 1)
                        (if (= (car aux-list) -1)
                            (parse-from-port
                             (cdr aux-list)
                             uri-i)
                          (if (= (car aux-list) -2)
                              (if (and (not (= (second aux-list) -3))
                                       (not (= (second aux-list) -4)))
                                  (parse-from-path
                                   (cdr aux-list)
                                   uri-i)
                                (if (= (second aux-list) -3)
                                    (parse-from-query
                                     (cdr (cdr aux-list))
                                     uri-i)
                                  (if (= (second aux-list) -4)
                                      (parse-fragment
                                       (cdr (cdr aux-list))
                                       uri-i)))))))))
                )
              )
          (error 'on-invalid-char :message "Invalid host"))
        )
      )

    )
  )


(defun parse-mail-to (uri-list uri-i)
  (let ((host-list)
        (userinfo-list)
        (aux-list))
    (setf host-list (get-host uri-list))
    (setf userinfo-list (get-userinfo uri-list))
    (if (not (equal host-list userinfo-list))
        (progn
          (if (userinfop userinfo-list)
              (progn
                (setf (s-g-uri-userinfo uri-i)
                      (get-string userinfo-list))
                (setf aux-list (userinfo-passed uri-list))
                (setf host-list
                      (get-host
                       (cdr aux-list)))
                (if (hostp host-list)
                    (progn
                      (setf (s-g-uri-host uri-i)
                            (get-string host-list)))
                  (error 'on-invalid-char :message "Invalid host"))
                )
            (error 'on-invalid-char :message "Invalid userinfo")
            )
          )
      (progn
        (if (userinfop userinfo-list)
            (progn
              (setf (s-g-uri-userinfo uri-i)
                    (get-string
                     userinfo-list)))
          (error 'on-invalid-char :message "Invalid userinfo"))
        )
      )
    ))






(defun parse-news-host (uri-list uri-i)
  (let ((host-list))
    (setf host-list uri-list)
    (if (news-hostp host-list)
        (setf (s-g-uri-host uri-i)
              (get-string host-list))
      (progn
        (error 'on-invalid-char :message "Invalid Host"))))
  )


(defun parse-tel-or-fax-uinfo (uri-list uri-i)
  (let ((uinfo-list))
    (setf uinfo-list uri-list)
    (if (tel-or-fax-uinfop uinfo-list)
        (setf (s-g-uri-userinfo uri-i)
              (get-string uinfo-list))
      (error 'on-invalid-char :message "Invalid userinfo"))))




(defun uri-parse-aux (uri-list)
  (let ((my-uri (make-instance 'uri))
        (scheme-list)
        (aux-list NIL))
    (if (listp uri-list)
        (progn
          (if (null (get-scheme uri-list))
              (progn
                (error 'on-empty :message "Empty list"))
            (progn
              (setf scheme-list (get-scheme uri-list))
              (if (schemep scheme-list)
                  (progn
                    (setf (s-g-uri-scheme my-uri)
                          (get-string scheme-list))
                    (setf aux-list
                          (scheme-passed uri-list))
                    (if (= (length aux-list) 0)
                        my-uri
                      (if (< (length aux-list) 2)
                          (if (= (car aux-list) -2)
                              (if (equalp (uri-scheme my-uri) "zos")
                                  (error 'on-invalid-char
                                         :message "zos path expected"))
                            (if (equalp (uri-scheme my-uri) "news")
                                (progn
                                  (parse-news-host
                                   aux-list
                                   my-uri))
                              (if (or (equalp (uri-scheme my-uri) "tel")
                                      (equalp (uri-scheme my-uri) "fax"))
                                  (progn
                                    (parse-tel-or-fax-uinfo
                                     aux-list
                                     my-uri))
                                (if (equalp (uri-scheme my-uri) "mailto")
                                    (progn
                                      (parse-mail-to
                                       aux-list
                                       my-uri))
                                  (error 'on-invalid-char
                                         :message "Invalid Char"))))
                            )
                        (if (>= (length aux-list) 2)
                            (progn
                              (if (not (= (car aux-list) -2))
                                  (if (equalp (uri-scheme my-uri) "news")
                                      (progn
                                        (parse-news-host
                                         aux-list
                                         my-uri)
                                        )
                                    (if (or (equalp (uri-scheme my-uri) "tel")
                                            (equalp (uri-scheme my-uri) "fax"))
                                        (progn
                                          (parse-tel-or-fax-uinfo
                                           aux-list
                                           my-uri))
                                      (if (equalp (uri-scheme my-uri) "mailto")
                                          (progn
                                            (parse-mail-to
                                             aux-list
                                             my-uri)
                                            )
                                        (error 'on-invalid-char
                                               :message "Invalid Char")
                                        )
                                      )
                                    )
                                (if (and (= (car aux-list) -2)
                                         (= (second aux-list) -2))
                                    (progn
                                      (parse-from-host
                                       (cdr (cdr  aux-list))
                                       my-uri))
                                  (if (and (= (car aux-list) -2)
                                           (not (=
                                                 (second aux-list)
                                                 -2)))
                                      (if (equalp
                                           (uri-scheme my-uri)
                                           "zos")
                                          (progn
                                            ;; zos case
                                            (parse-from-zos-path
                                             (cdr aux-list)
                                             my-uri)
                                            )
                                        (progn
                                          (if (and
                                               (not (= (second aux-list)
                                                       -3))
                                               (not (= (second aux-list)
                                                       -4)))
                                              (if (= (second aux-list) -3)
                                                  (progn
                                                    (parse-from-query
                                                     (cdr (cdr aux-list))
                                                     my-uri)
                                                    )
                                                (if (= (second aux-list) -4)
                                                    (progn
                                                      (parse-fragment
                                                       (cdr
                                                        (cdr
                                                         aux-list))
                                                       my-uri)
                                                      ))
                                                ))
                                          (parse-from-path
                                           (cdr aux-list)
                                           my-uri)
                                          )
                                        )
                                    ))
                                )
                              ))))
                    )
                (error 'on-invalid-char "Error!"))))
          my-uri
          ))))

(defun uri-parse (uri-string)
  (if (stringp uri-string)
      (uri-parse-aux (transform-word uri-string))))
