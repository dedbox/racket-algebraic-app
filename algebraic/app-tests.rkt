#lang algebraic/racket/base

(module+ test
  (require algebraic/app
           algebraic/class
           algebraic/class/applicative/box
           algebraic/class/functor/box
           rackunit)

  (with-instances (BoxApplicative BoxFunctor)
    (check = (unbox (+ <$> pure 1)) 1)
    (check = (unbox (>>* + <$> pure 1 <*> pure 2)) 3)
    (check = (unbox (>>* (>>* +) <$> pure 1 <*> pure 2 <*> pure 3)) 6)
    (check = (unbox (>>* + <$> pure 1 <*>~ pure 2 <*> pure 3)) 6)
    (check = (unbox (+ <$>~ pure 1 <*>~ pure 2 <*> pure 3)) 6)))
