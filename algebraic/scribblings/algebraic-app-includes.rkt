#lang racket/base

(require scribble/manual
         (for-syntax racket/base))

(provide (all-defined-out))

(define (rtech . args)
  (apply tech #:doc '(lib "scribblings/reference/reference.scrbl") args))

;;; ----------------------------------------------------------------------------
;;; Evaluators

(define-syntax-rule (module-language-evaluator mod-name)
  (call-with-trusted-sandbox-configuration
   (λ ()
     (parameterize ([sandbox-output       'string]
                    [sandbox-error-output 'string])
       (make-base-eval #:lang mod-name)))))

(define-syntax-rule (algebraic-evaluator)
  (module-language-evaluator 'algebraic/racket/base/lang))

(begin-for-syntax
  (define-syntax-rule (algebraic-example -eval)
    (...
     (λ (stx)
       (syntax-case stx ()
         [(_ expr ...) #'(examples #:eval -eval #:label #f expr ...)]))))

  (define-syntax-rule (algebraic-example/locations -eval)
    (...
     (λ (stx)
       (syntax-case stx ()
         [(_ expr ...) #'(examples #:eval -eval #:label #f
                                   #:preserve-source-locations expr ...)])))))

; -----------------------------------------------------------------------------
; algebraic eval

;; (define algebraic-eval (algebraic-evaluator))
;; (define-syntax example (algebraic-example algebraic-eval))

;; (void (example #:hidden (require racket/function (for-syntax syntax/parse))))

;; (define-simple-macro (algebraic-code str ...)
;;   #:with stx (datum->syntax this-syntax 1)
;;   (typeset-code #:context #'stx
;;                 #:keep-lang-line? #f
;;                 "#lang algebraic/racket/base\n" str ...))

; odds and ends

(define algebraic-mod (racketmodlink algebraic/racket/base "algebraic"))
