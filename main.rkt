#lang racket

(provide (all-from-out "./visual-language-maker/main.rkt"))

(require "./visual-language-maker/main.rkt"
         syntax/parse/define)

(provide define-ratchet-lang)

(define-syntax (define-ratchet-lang stx)
  (define-splicing-syntax-class 
    maybe-wrapper
    (pattern (~seq #:wrapper w))
    (pattern (~seq)
             #:with w #'begin))


  (syntax-parse stx
    [(_ (_provide provides ...)
        (_require requires ...)
        wrapper:maybe-wrapper
        [id letter icon] ...)

     #`(begin
         (module reader syntax/module-reader
           #,(syntax-source stx))

         (provide provides ...)
         (require requires ...)

         (module ratchet racket 
           (require requires ...)
           (require ratchet ratchet/util)


           (define-visual-language 
             #:wrapper wrapper.w
             [id letter icon] ...)))]))

