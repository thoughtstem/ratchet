#lang racket

;Basically provides a
(provide define-visual-language
         (struct-out visual-language)
         (struct-out identifier-mapping))

(struct visual-language (ns mappings wrapper) #:transparent )
(struct identifier-mapping (main letter picture) #:transparent)

(require pict)

;Gross duplication...  Consolodate before adding more cruft...
(define-syntax (define-visual-language stx)
  (syntax-case stx ()
    [(define-visual-language lang-id module-path [identifier l pict] ...)
     #'(begin
         (provide (all-from-out ratchet)
                  (rename-out [lang-id vis-lang])
                  lang-id
                  identifier ...)

         (require module-path)

	 (define-namespace-anchor a)
	 (define ns (namespace-anchor->namespace a))

         (define lang-id
           (visual-language ns
                            (list
                              (identifier-mapping 'identifier 'l (scale-to-fit pict 20 20))
                              ...)
                            'begin ))
)]
    [(define-visual-language #:wrapper wrapper lang-id module-path [identifier l pict] ...)
     #'(begin
         (provide (all-from-out ratchet)
                  (rename-out [lang-id vis-lang])
                  lang-id
                  identifier ...)

         (require module-path)

	 (define-namespace-anchor a)
	 (define ns (namespace-anchor->namespace a))

         (define lang-id
           (visual-language ns
                            (list
                              (identifier-mapping 'identifier 'l (scale-to-fit pict 20 20))
                              ...)
                            'wrapper ))
)]
    ))
