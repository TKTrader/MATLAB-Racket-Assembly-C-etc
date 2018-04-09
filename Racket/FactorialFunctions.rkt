#lang racket

; Thomson Kneeland
; various functions implementing factorial and sum of factorials

; "factorial" function
; program computes n factorial
; (factorial 6) = 720
(define (factorial n)
  (cond
    [(<= n 1) 1] ; <= prevents negative values causing infinite loop
    [else (* n (factorial (- n 1)))]
    )
  )

; "factorial-sum" function
; function finds sum of factorials 1!+2!+...+n!
; (factorial-sum 6) = 873
(define (factorial-sum q)
  (cond
    [(= q 1) 1] ; base case
    [else (+ (factorial q) (factorial-sum(- q 1)))]
    )
  )

; "factorial-sum-1" function
; function also calculates sum of factorials 1!+2!+...+n!
; but employs letrec and a lambda expression to define factorial function
; lambda function named "fact" to avoid any issues with original
; factorial function
; (factorial-sum-1 6) = 873
(define (factorial-sum-1 p)
  (letrec
      ([fact (lambda (x)
                        (cond
                          [(= x 1) 1]
                          [else (* x (fact (- x 1)))]
                          )
                    )
        ]
       )
    (cond
      [(= p 1) 1]
      [else (+ (fact p) (factorial-sum-1(- p 1)))]
      )
    )
  )

  