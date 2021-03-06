;;
;; COGS 502 Symbols and Programming
;; METU Informatics
;;
;; Umut Ozge
;; https://github.com/umutozge/symbols-and-programming 

;; Sample solutions for programming exercises

;;
;; Question 
;;
;; Define a procedure that takes three numbers and gives back the second largest of them. 
;; 

(defun seclarge (x y z)
  (if (<= x y)
    (if (<= y z)
      y
      (if (< x z)
        z
        x))
    (if (<= x z)
      x
      (if (> z y)
        z
        y))))

;;
;; Question 
;; 
;; Define a procedure that takes three numbers and gives back the sum of the squares of the larger two. 
;; 

(defun sqr (x) (* x x))

(defun sql2 (x y z) 
  (+ (sqr (max x y z))
     (sqr (seclarge x y z))))

;;
;; Question 
;; 
;; Define a procedure that halves a given number until the result becomes less than 1 -- solve the problem by making your procedure call itself.
;;

(defun halver (n)
  (cond ((< n 1) n)
        (t (halver (/ n 2)))))

;;
;; Question
;; 
;; Rewrite (AND X Y Z W) by using COND (Touretzky 1990).
;;

; (cond (X (cond (Y (cond (Z (cond (W))))))))

;;
;; Question
;; 
;; Write COND statements equivalent to:
;; (NOT U), (OR X Y Z) (Winston and Horn 1984).
;;

; (NOT U): 
; (cond (U nil)
;       (t))

; (OR X Y Z):
; (cond (X) (Y) (Z)) 


;; Question
;; 
;; The following definition is meant to mimic the behavior of IF using
;; AND and OR.
;; 
;; (defun custom-if (test succ fail) ; wrong!
;;      (or (and test succ) fail))
;; 
;; But it is unsatisfactory in one case, what is it?  Define a better procedure
;; which avoids this failure (Touretzky 1990).
;; 

; Take for instance (custom-if 3 (< 5 4) 8), this incorrectly would return 8 instead of NIL. 
; Here is a correct version

(defun custom-if (test succ fail)
  (or (and test succ) (and (not test) fail)))


;; 
;; Question
;; 
;; Define a procedure that multiplies two integers using only addition as a
;; primitive arithmetic operation. Assume that the first operand will always be
;; greater than or equal to 0.
;; 

; version 1

(defun multiply1 (x y)
  "does not work for x < 0"
  (cond ((zerop x) 0)
        (t (+ y (multiply1 (- x 1) y)))))


; version 2

(defun mult (x y pro)
  (if (zerop x)
    pro
    (mult (- x 1) y (+ pro y))))

(defun multiply2 (x y)
  "does not work for x < 0"
  (mult x y 0))

; you can also write version 2 using &optional

(defun multiply3 (x y &optional (pro 0))
  "does not work for x < 0"
  (if (zerop x)
    pro
    (multiply3 (- x 1) y (+ pro y))))

;; 
;; Question
;; 
;; Define a procedure that multiplies two integers using only addition as a
;; primitive arithmetic operation. It should work for positive and negative
;; integers. 
;; 

(defun multiply4 (x y &optional (pro 0))
  (cond ((< x 0) (- (multiply4 (- x) y)))
        ((zerop x) pro)
        (t (multiply4 (- x 1) y (+ pro y)))))


;; 
;; Question
;; 
;; Define a procedure \Verb+COLL+ that implements the function computing a
;; Collatz' sequence. 
;; 


; a version that prints the computed numbers

(defun coll (n)
  (if (= 1 n)
    t
    (if (evenp n)
      (coll (print (/ n 2)))
      (coll (print (+ (* 3 n) 1))))))

;; 
;; Question
;; 
;; Define a procedure that takes two integers, say $x$ and $y$, and returns the
;; sum of all the integers in the range including and between $x$ and $y$. 
;; 

; without accumulator

(defun sumrange (x y)
  "assumes x <= y"
  (if (= x y)
    y
    (+ x (sumrange (+ x 1) y))))

; with accumulator

(defun sumr (x y &optional (sum 0))
  "assumes x <= y"
  (if (= x y)
    (+ sum y)
    (sumr (+ x 1) y (+ x sum))))

;; 
;; Question
;; 
;; Define a procedure that gives the Fibonacci number of given integer.
;; 

; no accumulator

(defun fib (n)
  "assumes n is a non-negative integer"
  (if (< n 2)
    n
    (+ (fib (- n 1)) (fib (- n 2)))))

; with accumulator

; version 1
; where n itself is used as a counter
(defun fibo (n &optional (oneback 1) (twoback 0))
  "assumes n is a non-negative integer"
  (cond ((zerop n) twoback)
        ((= 1 n) oneback)
        (t (fibo (- n 1) (+ oneback twoback) oneback))))

; version 2
; where a counter different from n is used

(defun fiboc (n &optional (oneback 1) (twoback 0) (counter 2))
  "assumes n is a non-negative integer"
  (cond ((< n 2) n)
        ((= counter n) (+ oneback twoback))
        (t (fiboc n (+ oneback twoback) oneback (+ counter 1)))))

;;
;; Question
;;
;; Square roots by Newton's method
;;

(defun square (x) (* x x))

(defun update-guess (x guess)
  (/ (+ (/ x guess) guess) 2))

(defun close-enough? (x y)
  (< (abs (- x y)) 0.000001))

(defun sqroot (x &optional (guess 1.0))
  (if (close-enough? x (square guess))
    guess
    (sqroot x (update-guess x guess))))


;;
;; Question
;;
;; Define a procedure AFTER-FIRST that takes two lists and inserts all the
;; elements in the second list after the first element of the first list. Given
;; (A D E) and (B C), it should return (A B C D E).
;;

(defun after-first (lst1 lst2)
  (cons (car lst1) (append lst2 (cdr lst1))))


;; 
;; Question 
;;
;; Define a procedure that gives the last element of a list or gives NIL if the
;; list is empty. Name your procedure LASTT in order not to clash
;; with LISP’s built-in LAST.
;; 

; first define a procedure SINGLETONP that checks whether its argument is a
; single-element list or not. 

(defun singletonp (xs)
  (and (consp xs) (null (cdr xs))))

; now use SINGLETONP to define LASTT

(defun lastt (xs)
  (cond ((endp xs) nil)
        ((singletonp xs) (car xs))
        (t (lastt (cdr xs)))))

;; 
;; Question
;; 
;; Define a procedure that checks whether a given list of symbols is a palindrome.  Use CAR and your solution LASTT 
;; 

;; for this question you need to be able remove the first and last element of a list. There are many ways to do this.
;; here is one:

(defun strip (xs)
  (reverse (cdr (reverse (cdr xs)))))

(defun palind (xs)
  (cond ((or (endp xs) (singletonp xs)) t)
        (t (if (equal (car xs) (lastt xs))
             (palind (strip xs))
             nil))))




;;
;; Question
;;
;; Define your own version of \Verb+NTH+.
;;

(defun mynth (n lst)
  "When this returns NIL, there is no way to tell whether the index got out of range or NIL was an element."
  (if (zerop n)
    (car lst)
    (mynth (- n 1) (cdr lst))))


;;
;; Question
;;
;; Define a function MULTI-MEMBER that checks if its first argument occurs more
;; than once in the second.
;;

; with MEMBER

(defun multi-member (x lst)
  "Checks if its first argument occurs more than once in the second"
  (cond ((endp lst) nil)
        ((equal x (car lst)) (member x (cdr lst)))
        (t (multi-member x (cdr lst))))) 

; without MEMBER

(defun multi-member (x lst &optional seen-before?)
  "Checks if its first argument occurs more than once in the second"
  (cond ((endp lst) nil)
        ((equal x (car lst)) (if seen-before?
                               t
                               (multi-member x (cdr lst) t)))
        (t (multi-member x (cdr lst) seen-before?))))


;;
;; Question
;;
;; Define your own procedure APPEND2 that appends two list arguments into a
;; third list. You are not allowed to use APPEND, LIST and REVERSE -- use just
;; CONS.
;;

(defun app (lstA lstB)
  (if lstA
    (cons (car lstA) (app (cdr lstA) lstB))
    lstB))

;;
;; Question
;; 
;; Define a procedure HOW-MANY? that counts the top-level occurrences of an item in a list.
;;

; no accumulator

(defun how-many? (item lst)
  (cond ((endp lst) 0)
		((equal item (car lst)) (+ 1 (how-many? item (cdr lst))))
		(t (how-many? item (cdr lst)))))

; with accumulator

(defun how-many? (item lst &optional (counter 0))
  (if lst 
    (how-many?
      item
      (cdr lst)
      (+ counter 
         (if (equal (car lst) item) 1 0)))
    counter))

;;
;; Question
;; 
;; The built-in REVERSE reverses a list. Define your own version of reverse.
;;

; no accumulator

(defun revers (lst)
  (if lst
    (append (revers (cdr lst)) (list (car lst)))))

; with accumulator

(defun revers (lst &optional acc)
  (if lst
    (revers (cdr lst) (cons (car lst) acc))
    acc))


;;
;; Question
;; 
;; Define a predicate that tells whether its argument is a dotted list or not.
;;

(defun dotted (lst)
  (if (consp lst)
    (if (atom (cdr lst))
      t
      (dotted (cdr lst)))))


;;
;; Question
;; 
;; Define a recursive procedure D-HOW-MANY? that counts all not only top-level
;; occurrences of an item in a list.
;; For instance (D-HOW-MANY? 'A '((A B) (C (A X)) A)) should return 3.
;;

; with accumulator

(defun d-how-many? (x lst &optional (counter 0))
  (cond ((endp lst) counter)
        ((equal x (car lst)) (d-how-many? x (cdr lst) (1+ counter)))
        ((listp (car lst)) (d-how-many? x (cdr lst) (d-how-many? x (car lst) counter)))
        (t (d-how-many? x (cdr lst) counter))))

; w/o accumulator

(defun d-how-many? (x lst)
  (cond ((endp lst) 0)
        ((equal x (car lst)) (+
                               1
                               (d-how-many? x (cdr lst))))
        ((listp (car lst)) (+
                             (d-how-many? x (car lst))
                             (d-how-many? x (cdr lst))))
        (t (d-how-many? x (cdr lst)))))

;;
;; Question
;; 
;; Deep-reverse a list. 
;; For instance (reverse0 '(a (b c (x d)) k)) should give (K ((D X) C B) A)
;;

(defun reverse0 (lst &optional acc)
  (cond ((null lst) acc) 
        ((atom lst) lst)
        (t (reverse0
             (cdr lst)
             (cons (reverse0 (car lst)) acc)))))


;;
;; Question
;; 
;; Define a three argument procedure REMOVE-NTH, which removes every nth
;; occurrence of an item from a list.
;;

(defun remove-nth (item n lst &optional (counter 0))
  (cond ((endp lst) nil)
        ((equal (car lst) item)
         (if (= counter (- n 1))
           (remove-nth item n (cdr lst) 0)
           (cons item (remove-nth item n (cdr lst) (+ counter 1)))))
        (t (cons (car lst) (remove-nth item n (cdr lst) counter)))))


;;
;; Question
;;
;; Define a procedure that takes a list of integers and an integer n, and
;; returns the nth largest integer in the list.
;;

; there are many ways to solve this problem; we will start by not caring about efficiency.

; recursively find the maximum of the list and remove it while counting the removals.

(defun nthlarge (n lst)
  (cond ((endp lst) nil)
        ((= n 1) (maxx lst))
        (t (nthlarge 
             (- n 1)
             (remove (maxx lst) lst)))))

; now a bare-hands solution:

(defun bubble (x lst)
  "inserts x in a position in lst such that everything to the left of x is smaller than it"
  (if (endp lst)
    (list x)
    (if (>= x (car lst))
      (cons (car lst)
            (bubble x (cdr lst)))
      (cons x lst))))

(defun nth-large (n lst &optional store)
  (cond 
    ((endp lst) (if (= (length store) n)
                  (car store)))
    (t (nth-large
         n
         (cdr lst)
         (if (< (length store) n)
           (bubble (car lst) store)
           (cdr (bubble (car lst) store)))))))


;;
;; Question
;; 
;; Define a procedure UNIQ that takes a list and removes all the repeated
;; elements in the list keeping only the last occurrence. For instance:
;; (uniq '(a b r a c a d a b r a)) should give (C D B R A).
;; Don’t use REMOVE (built-in or in-house), you may use MEMBER.
;;

(defun uniq (lst)
  (if lst
    (let ((current (car lst)))
      (if (member current (cdr lst))
        (uniq (cdr lst))
        (cons current (uniq (cdr lst)))))))


;;
;; Question
;; 
;; Define a procedure UNIQ that takes a list and removes all the repeated
;; elements in the list keeping only the first occurrence. For instance:
;; (uniq '(a b r a c a d a b r a)) should give (A B R C D).
;; Don’t use REMOVE (built-in or in-house), you may use MEMBER.
;;

(defun uniq (lst &optional acc)
  (if lst 
    (let ((current (car lst)))
      (if (member current acc)
        (uniq (cdr lst) acc)
        (uniq (cdr lst) (append acc (list current)))))
    acc))


;;
;; Question
;;
;; Define a procedure REMLAST which removes the last occurrence of an item from
;; a list. Do not use MEMBER or REVERSE.
;;


(defun remlast (x lst &optional guess backup)
  (cond ((endp lst) guess)
        ((equal x (car lst))
         (remlast
           x
           (cdr lst)
           backup
           (append backup (list x))))
        (t (remlast
             x
             (cdr lst)
             (append guess (list (car lst)))
             (append backup (list (car lst)))))))


;;
;; Question
;;
;; Recursively count non-nil elements in a list.
;;

(defun count-atoms (lst &optional (counter 0))
  (cond ((null lst) counter) ;; note that endp wouldn't work here
        ((atom lst) (+ counter 1))
        (t (count-atoms
              (cdr lst) (count-atoms (car lst) counter)))))

;;
;; Question
;;
;; Bring to front 
;;

(defun bring-to-front (item lst &optional store)
  (cond ((endp lst) store)
        ((equal item (car lst)) 
         (bring-to-front item (cdr lst) (cons item store)))
        (t
          (bring-to-front item (cdr lst) (append store (list (car lst)))))))

;;
;; Question
;;
;; Group repetitions in a list. E.g. (1 2 2 3 4 4) should yield ((1) (2 2) (3) (4 4)).  
;;

(defun group (lst &optional ministore store)
  (if (endp lst)
    (if ministore
      (append store (list ministore))
      store)
    (if ministore
      (if (equal (car lst) (car ministore))
        (group (cdr lst) (cons (car lst) ministore) store)
        (group (cdr lst) (list (car lst)) (append store (list ministore))))
      (group (cdr lst) (list (car lst)) store))))

;;
;; Question
;;
;; Define a recursive  procedure SUBSTITUTE with 3 arguments,
;; say old new exp such that every occurrence of
;; old at the top-level of exp is replaced by new. By
;; 'top-level' we mean the function should not check embedded levels in
;; lists. E.g. (substitute 'x 'k '(x (x y) z)) should return (k
;; (x y) z)

;;
;; Then modify SUBSTITUTE to D-SUBS (for 'deep substitute'), so that it does
;; the replacement for all occurrences of old, no matter how
;; deeply embedded.

; here is the code for deep subs, shallow subs should be obvious looking at this
(defun subs (new old expr)
  "Substitutes new with old in expr"
  (cond ((and (listp expr) (endp expr)) nil)
        ((atom expr) (if (equal old expr)
                              new
                              expr
                              ))
        (t (cons (subs new old (car expr)) (subs new old (cdr expr))))))

; subs using store

(defun subs (new old expr &optional store)
  (cond ((and (listp expr) (endp expr)) store)
		((atom (car expr)) (subs new old (cdr expr)
								 (append store
										 (if (equal old (car expr))
										   (list new)
										   (list (car expr))))))
		(t (subs new old (cdr expr)
				 (append store (list (subs new old (car expr))))))))


;;
;; Question
;;
;; Write LAMBDA expressions that

;; (i) returns the greatest of two integers.

(lambda (m n) (if (> m n) m n))

;; (ii) given two integers,  returns T if one or the other divides the other without remainder.

(lambda (m n) (or (zerop (rem m n)) (zerop (rem n m))))

;; (iii) given a list of integers, returns the mean.

(lambda (xs) (/ (apply #'+ xs) (length lst)))

;; (iv) given a list of integers, returns the sum of their factorials -- use your factorial solution.

(defun factorial (n &optional (product 1))
  (if (<= n 0)
    product
    (factorial (- n 1) (* product n))))

(lambda (xs) (apply #'+ (mapcar #'factorial xs)))


;;
;; Question
;;
;; Define a procedure PAIR-PROD using MAPCAR and LAMBDA, which takes a list of
;; two element lists of integers and returns a list of products of these pairs.
;; E.g.  an input like ((7 8) (1 13) (4 1)) should yield (56 13 4)
;;

(defun pair-prod (xs)
  (mapcar
    #'(lambda (x) (* (car x) (cadr x)))
    xs))



;;
;; Question
;;
;; Define your own REMOVE-IF.
;;

(defun rif (test xs &optional store)
  (if xs
    (if (funcall test (car xs))
      (rif
        test
        (cdr xs)
        store)
      (rif
        test
        (cdr xs)
        (cons (car xs) store)))
    (reverse store)))



;;
;; Question
;;
;; Define a procedure \Verb+APPLIER+ that takes a procedure PROC, an input
;; INPUT and a count CNT and gives the result of applying PROC to INPUT CNT
;; times. For instance, (APPLIER #'CDR '(1 2 3) 2) should give (3)
;;

(defun applier (proc input cnt)
  (if (zerop cnt)
    input
    (applier
      proc
      (funcall proc input)
      (- cnt 1))))


;;
;; Question
;;
;; Define a procedure REPLACE-IF, which takes three arguments: a list LST, an
;; item ITEM and a function TEST, and replaces every element of LST that passes
;; the TEST with ITEM. You may find using keyword arguments useful (see the
;; lecture notes). Make use of MAPCAR, LAMBDA and FUNCALL in your solution.   
;;

;; shorter solution with MAPCAR and LAMBDA (what the question wants)

(defun replace-if (lst item test)
  (mapcar
    #'(lambda (x) (if (funcall test x) item x)) 
    lst))

;; longer solution

(defun replace-if (lst item test &optional store)
  (if lst
    (if (funcall test (car lst))
      (replace-if
        (cdr lst)
        item
        test
        (cons item store))
      (replace-if
        (cdr lst)
        item
        test
        (cons (car lst) store)))
    (reverse store)))




;;
;; Question
;;
;;
;; MAPCAR can work on any number of lists; you only need to be careful to
;; provide a function with the correct number of arguments. For instance
;;
;; (mapcar #'(lambda (x y) (+ x y)) '(1 2 3) '(4 5 6)) gives (5 7 9). Don't
;; worry if lists are not of equal length, MAPCAR goes as far as the shortest
;; list.
;;
;; Define procedures that use MAPCAR and LAMBDA and
;;
;; (i) zip two lists together -- (zip '(a b) '(1 2)) should give
;; ((A 1) (B 2))
;;

(defun zipper (lst1 lst2)
  (mapcar
    #'(lambda (x y) (list x y))
    lst1
    lst2))


;; (ii) take three lists: first two will be lists of integers, and the third is
;; a list of functions. Apply the corresponding function to corresponding
;; arguments.

(defun foo (lst1 lst2 procs)
  (mapcar
    #'(lambda (x y z) (funcall z x y))
    lst1
    lst2
    procs))


;; 
;; Question 
;;
;; Define a procedure NCONT that takes an element X, a list
;; LST and an integer N; and inserts the element to the end of
;; the list. Your procedure should make sure that the returned list is never
;; longer than N. Do NOT use LENGTH, you may use REVERSE
;;


(defun firstn (lst n &optional store)
  (if (or (endp lst) (zerop n))
    (reverse store)
    (firstn (cdr lst) (- n 1) (cons (car lst) store))))

(defun ncont (x lst n)
  (append (reverse (firstn (reverse lst) (- n 1))) (list x)))

;;
;; Question
;;
;; Define a procedure RNTH that takes a list and an integer and returns
;; the nth element from the back. E.g.\ (rnth '(1 2 3 4) 2) should
;; return 3. Do NOT use NTH, LENGTH, REVERSE; you
;; can use NCONT of the previous question.
;;

; long way 
(defun rnth (lst n &optional store)
  (if (endp lst)
    (car store)
    (rnth (cdr lst) n (ncont (car lst) store n))))

; short way

(defun rnth2 (lst n)
  (car (ncont 'x lst (+ n 1))))


;;
;; Question
;;
;; Define a procedure APPEND2 that appends two lists. 
;;
;; Use iterative constructs 
;;

(defun append2 (lstA lstB)
  (dolist (x (reverse lstA) lstB) 
    (push x lstB)))

;;
;; Question
;;
;; Define an iterative procedure UNIQ that takes a list and removes all the
;; repeated elements in the list keeping only the first occurrence. This is the
;; expected behavior:
;;
;; * (uniq '(a b r a c a d a b r a))
;; (A B R C D)
;;
;; Use iterative constructs 
;;

(defun uniq (lst)
  (let ((seen nil))
	(dolist (x lst (reverse seen))
	  (if (not (member x seen))
		(push x seen)))))


;;
;; Question
;;
;; The mean of $n$ numbers is computed by dividing their sum by $n$. A running
;; mean is a mean that gets updated as we encounter more numbers. Observe the
;; following input-output sequences:
;;
;; * (run-mean '(3 5 7 9))
;; (3 4 5 6)

;; The first element 3 is the mean of the list (3), the second element 4 is the
;; mean of (3 5), and so on. Implement RUN-MEAN by using DOTIMES and NTH.
;;
;; Use iterative constructs 
;;

(defun run-mean (lst)
  (let ((store nil)
		(sum 0))
	(dotimes (i (length lst) (reverse store))
	  (incf sum (nth i lst))  ; equivalent to (setf sum (+ sum (nth i lst))) 
	  (push (/ sum (+ i 1)) store))))

;; as (incf sum (nth i lst)), besides updating sum, also returns the new updated value of sum, you can define the same function as:

(defun run-mean2 (lst)
  (let ((store nil)
		(sum 0))
	(dotimes (i (length lst) (reverse store))
	  (push (/ (incf sum (nth i lst)) (+ i 1)) store))))

;;
;; Question
;;
;; Define a procedure SEARCH-POS that takes a list as search item, another list
;; as a search list and returns the list of positions that the search item is
;; found in the search list. As usual, positioning starts with 0. Use DOTIMES.
;; A sample interaction:
;;
;; * (search-pos '(a b) '(a b c d a b a b))
;; (6 4 0) 
;; 
;; * (search-pos '(a a) '(a a a a b a b))
;; (2 1 0)
;;
;; Use iterative constructs 
;;

(defun search-pos (search-item search-list)
  "return the list of positions search-item (a list) matches in search-list"
  (let ((win (make-list(length search-item)))
		(store nil))
	(dotimes (i (length search-list) store)
	  (setf win (append
				  (cdr win)
				  (list (nth i search-list))))
	  (if (equal win search-item)
		(push (- (+ i 1) (length win)) store)))))

;;
;; Question
;;
;; Define a procedure that reverses the elements in a list including its
;; sublists as well.
;; 

(defun reverse0 (lst)
  (let ((result nil))
	(dolist (x lst result)
	  (push (if (listp x) (reverse0 x) x) result))))

;;
;; Question
;;
;; See the PAIRLISTS in lecture notes. Define a procedure that "pairs" an
;; arbitrary number of lists. Here is a sample interaction:
;;
;; * (pairlists '((a b) (= =) (1 2) (+ -) (3 9)))
;; ((A = 1 + 3) (B = 2 - 9))
;;
;; Use iterative constructs 
;;

(defun pairlists (list-of-lists)
  "pairs(!) the lists given in the list-of-lists; assumes they are of equal length -- keeps the original order"
  (let ((len (length (car list-of-lists)))
		(store nil))
	(dotimes (i len (reverse store))
	  (push 
		(reverse
		  (let ((ministore nil))
			(dolist (j list-of-lists ministore)
			  (push (nth i j) ministore))))
		store))))

;; An alternative would be to make the outer iteration over list-of-lists
;; that solution requires a use of setf that we haven't seen so far; namely setf'ing 
;; not a variable but a postion in a list, e.g.\ a car or an nth expression.



