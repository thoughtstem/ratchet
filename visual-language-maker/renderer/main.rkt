#lang racket

(provide typeset-code)

(require (for-syntax racket/list)
         pict
         (prefix-in p: pict/code)
         "../tangeables/main.rkt"
         "../base.rkt")





;Takes normal syntax and replaces identifiers
; with images, according to lang's mappings
(define-syntax-rule (typeset-code lang stx)
  (render
   (convert-syntax lang
                   #'stx)))


(define (convert-syntax lang stx)
  (define expansion (syntax-e stx))

  (datum->syntax stx
                 (if (list? expansion)
      
                     (map (λ(e) (convert-syntax lang e))
                          expansion)

                     (syntax->pict lang stx))
                 stx))

(define (syntax->pict lang stx)
  (define mappings (visual-language-mappings lang))

  (define m (findf (λ(m) (eq? (identifier-mapping-main m)
                              (syntax->datum stx)))
                   mappings))

  (scale-to-fit
   (identifier-mapping-picture m)
   20 20)
  )


(define (render converted-stx)
  (p:typeset-code
   (datum->syntax converted-stx converted-stx)))








