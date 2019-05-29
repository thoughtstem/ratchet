#lang racket

;Basically provides a
(provide define-visual-language
         (struct-out visual-language)
         (struct-out identifier-mapping))

(struct visual-language (ns mappings wrapper) #:transparent )
(struct identifier-mapping (main letter picture original) #:transparent)

(require pict
         racket/draw)

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
                              (identifier-mapping 'identifier 'l

                                                  (inset/clip
                                                   (cc-superimpose
                                                    (filled-rounded-rectangle 28 28 -0.25
                                                                              #:color (make-color 240 240 240)
                                                                              #:border-color "DimGray"
                                                                              #:border-width 2)
                                                    (scale-to-fit pict 20 20)
                                                    ) 2)
                                                  
                                                  ;(cc-superimpose (filled-rectangle 32 32 #:color (make-color 240 240 240))
                                                  ;                (scale-to-fit pict 20 20)
                                                  ;                ;using freeze to crop excess border
                                                  ;                (freeze (frame #:color "white" #:line-width 2
                                                  ;                               (rounded-rectangle 32 32 -0.25 #:border-width 4 #:border-color "white")))
                                                  ;                (rounded-rectangle 28 28 -0.25 #:border-color "DimGray" #:border-width 2))

                                                  pict)
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
                              (identifier-mapping 'identifier 'l

                                                  (inset/clip
                                                   (cc-superimpose
                                                    (filled-rounded-rectangle 28 28 -0.25
                                                                              #:color (make-color 240 240 240)
                                                                              #:border-color "DimGray"
                                                                              #:border-width 2)
                                                    (scale-to-fit pict 20 20)
                                                    ) 2)
                                                  
                                                  ;(cc-superimpose (filled-rectangle 32 32 #:color (make-color 240 240 240))
                                                  ;                (scale-to-fit pict 20 20)
                                                  ;                ;using freeze to crop excess border
                                                  ;                (freeze (frame #:color "white" #:line-width 2
                                                  ;                               (rounded-rectangle 32 32 -0.25 #:border-width 4 #:border-color "white")))
                                                  ;                (rounded-rectangle 28 28 -0.25 #:border-color "DimGray" #:border-width 2))

                                                  pict)
                              ...)
                            'wrapper ))
)]
    ))
