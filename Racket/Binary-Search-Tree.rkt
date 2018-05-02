#lang racket
; Thomson Kneeland ;: Programming Assignment 2
; CS 313

; Insert node in a binary search tree
; The tree is represented as a list (root left-subtree right-subtree))
; where the left-subtree and right subtree are binary search trees (also represented as lists)
; empty tree is represented by an empty list
(define (insert x binary-search-tree)
  {cond
    [(empty? binary-search-tree) (list x '() '())]
    [else
      {let
         ( [root (first binary-search-tree)]
           [left-subtree (first (rest binary-search-tree))]
           [right-subtree (first (rest (rest binary-search-tree)))]
         )
         (cond
           [(<= x root) (list root (insert x left-subtree) right-subtree)]
           [(> x root) (list root left-subtree (insert x right-subtree))]
         )
      }
    ]
  }
)

;Build a binary search tree from a list of numbers by inserting each number into the tree
;Note the use of reverse so that the numbers are inserted in the correct order using recursion
(define (build-BST number-list)
  {letrec
      [ (build (lambda (num-list binary-search-tree)
                 {cond
                   [(empty? num-list) binary-search-tree]
                   [else (insert (first num-list) (build (rest num-list) binary-search-tree))]
                 }
              )
         )
       ]
      (build (reverse number-list) '())
   }
)

;(insert '20 '(25 (12 () ()) (37 () ())))
;(insert '23 (insert '20 '(25 () ())))

; Find the minimum value in a binary search tree
(define (find-min binary-search-tree)
  {cond
    [(empty? binary-search-tree) "ERROR: Empty Tree"]
    [else
      {let
        ( [root (first binary-search-tree)]
          [left-subtree (first (rest binary-search-tree))]
        )
        (cond
           [(empty? left-subtree) root]
           [else (find-min left-subtree)]
        )
      }
    ]
 }
)

; search function: search binary tree for value x and return true or false
(define (search binary-search-tree x)
  (cond [(empty? binary-search-tree) #f]  ; if tree empty, done
        [(equal? (car binary-search-tree) x) #t]  ; value found ; replace car
        [else
         {let
             ( [root (first binary-search-tree)]
           [left-subtree (first (rest binary-search-tree))]
           [right-subtree (first (rest (rest binary-search-tree)))]
         )
           (cond
           [(< x root) (search left-subtree x)]
           [(> x root) (search right-subtree x)]
         )
          }
         ]
        )
  )

; TEST CASES for binary-search-tree  = SUCCESS
(search (build-BST '(42 27 2 57 12 22 6 64 35 60 89 52 313)) 52) ; #t
(search (build-BST '(42 27 2 57 12 22 6 64 35 60 89 52 313)) 2)   ; minimum of tree  #t
(search (build-BST '(42 27 2 57 12 22 6 64 35 60 89 52 313)) 313)  ; maximum of tree  #t
(search (build-BST '(42 27 2 57 12 22 6 64 35 60 89 52 313)) 8)   ; #f
(search (build-BST '(0 1 2 34 35 18 9 128 60 89 52 313)) 89)  ;#t
(search (build-BST '(42 27 2 12 3 98 6 64 35 42 1 8 12)) 5)  ;#f
         
; Find the maximum value in a binary search tree
(define (find-max binary-search-tree)
  {cond
    [(empty? binary-search-tree) "ERROR: Empty Tree"]
    [else
      {let
        ( [root (first binary-search-tree)]
          [right-subtree (first(rest(rest binary-search-tree)))]
        )
        (cond
           [(empty? right-subtree) root]
           [else (find-max right-subtree)]
        )
      }
    ]
 }
)

;TEST CASES FOR find-max function WORKS
;(find-max(build-BST '(4 8 5 7 6)))
;(find-max(build-BST '(25 12 20 37)))


;Delete-Node function incomplete and not included
