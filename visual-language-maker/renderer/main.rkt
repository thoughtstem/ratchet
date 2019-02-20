#lang racket

(provide typeset-code
         convert-syntax
         convert-syntax-string
         (rename-out [render render-syntax]))


(require (for-syntax racket/list)
         lang-file/read-lang-file
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

(define (convert-syntax-string lang str)
  ;At least hide this crap in Ratchet...
  (define stx
    (rest
     (syntax-e
      ((curryr list-ref 3)
       (syntax-e (read-lang-module (open-input-string str)))))))
  
   (map (curry convert-syntax lang) stx))

(define (syntax->pict lang stx)
  (define mappings (visual-language-mappings lang))

  (define m (findf (λ(m) (eq? (identifier-mapping-main m)
                              (syntax->datum stx)))
                   mappings))

   (if m
       (let [(bm
	       (pict->bitmap
	         (scale-to-fit
		   (identifier-mapping-picture m)
		   200 200)))]

	   (scale-to-fit (bitmap bm) 20 20))
       stx
   ))


(define (render converted-stx)
  (if (list? converted-stx)
      (apply (curry vl-append 20) (map render converted-stx))
      ((curryr scale 2)
        (p:typeset-code
        (datum->syntax converted-stx converted-stx))))
)








