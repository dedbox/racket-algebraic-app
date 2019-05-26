#lang algebraic/racket/base

(require algebraic/class/applicative
         algebraic/class/functor
         k-infix/define)

(provide (rename-out [algebraic-app #%app])
         (all-from-out algebraic/class/applicative
                       algebraic/class/functor))

;; (define-$* algebraic-app
;;   ;; the prelude
;;   ;; (.. 9 right 9 "function composition")
;;   ;; (++ 5 right 5 "list append")

;;   ;; base class members
;;   (<$>  4 left 4 "functor map")
;;   ;; (<*   4 left 4 "functor constant")
;;   (<*>  4 left 4 "functor application")
;;   ;; ( *>  4 left 4 "functor application sequence")
;;   ;; (<**> 4 left 4 "flipped functor application")
;;   )

(begin-for-syntax
  (require algebraic/class/applicative
           algebraic/class/functor
           k-infix/custom)

  (define prelude-app
    ($* (.. 9 right 9 "function composition")
        (++ 5 right 5 "list append")))

  (define base-app
    ($* (<$>  4 left 4 "functor map")
        (<$>~ 4 left 4 "functor map")
        (<*>  4 left 4 "functor application")
        (<*>~ 4 left 4 "lazy functor application")))

  (define inline-app ($* #:parsers (prelude-app base-app))))

(define-syntax (algebraic-app stx)
  (syntax-case stx ()
    [(_ f x ...) (inline-app #'(f x ...))]))

;;; ----------------------------------------------------------------------------

(module+ test
  (require algebraic/class
           algebraic/class/applicative/box
           algebraic/class/functor/box
           rackunit)

  (with-instances (BoxApplicative
                   BoxFunctor)

    (check = (unbox (algebraic-app + <$> pure 1)) 1)
    (check = (unbox (algebraic-app >>* + <$> pure 1 <*> pure 2)) 3)
    (check = (unbox (algebraic-app >>* (>>* +) <$> pure 1 <*> pure 2 <*> pure 3)) 6)
    (check = (unbox (algebraic-app >>* + <$> pure 1 <*>~ pure 2 <*> pure 3)) 6)
    (check = (unbox (algebraic-app + <$>~ pure 1 <*>~ pure 2 <*> pure 3)) 6)))
