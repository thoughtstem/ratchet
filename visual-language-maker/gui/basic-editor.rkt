#lang racket

(require racket/gui framework pict )

;Basically provides a
(provide define-visual-language
         (struct-out visual-language)
         (struct-out identifier-mapping))

(define (fileify key bm)
  (define f (make-temporary-file (~a "~a-" key ".png")))
  (send bm save-file f 'png)
  f)

(struct visual-language (editor mappings))
(struct identifier-mapping (main letter picture))

(define-syntax (define-visual-language stx)
  (syntax-case stx ()
    [(define-visual-language lang-id module-path [identifier l pict] ...)
     #'(begin
         (provide (all-from-out module-path)
                  lang-id
                  l ...)
         
         (require (rename-in module-path
                             [identifier l]
                             ...)
                  racket/gui)


         (define-namespace-anchor a)
         (define ns (namespace-anchor->namespace a))

         (require file/convertible)
        

         (define picts->bitmaps
           (make-hash
            (list
             [cons 'pict
                   (pict->bitmap (scale-to-fit pict 20 20))]
             ... )))

         (define bytes->letter
           (make-hash
            (list (cons (convert (pict->bitmap (scale-to-fit pict 20 20))
                                 'png-bytes)
                        'l)
                  ...)))


         (define (bitmap->letter b)
           (define bytes (convert b 'png-bytes))
          
           (hash-ref bytes->letter bytes))
       
         (define visual-editor%
           (class racket:text%
             (super-new)

            
             (define/override (on-char ke)
               (define ke-l (~a (send ke get-key-code)))

               (cond [(string=? (~a 'l) ke-l)
                      (send this insert-image
                            (fileify 'l (hash-ref picts->bitmaps 'pict)))]
                     ...
                     [else (super on-char ke)]))

             (define/public (get-snips (current (send this find-first-snip))
                                       (ret '()))
               (if (not current)
                   (reverse ret)
                   (send this get-snips
                         (send current next)
                         (cons current ret))))

             (define/public (get-code)
 
               (define (snip->string s)
                 (cond [(is-a? s image-snip%)   (bitmap->letter
                                                 (send s get-bitmap))]
                       [(is-a? s string-snip%)  (send s get-text
                                                      0
                                                      (send s get-count))]
                       [else (error (~a "What's that? " s))]))
              
               (define snips (send this get-snips))
               (apply ~a
                      (map snip->string snips)))

             (define/public (run-code)
               (define code
                 (~a "(begin "
                     (send this get-code)
                     ")"))

               (displayln code)
               
               (eval
                (read
                 (open-input-string code))
                ns))))

         (define lang-id
           (visual-language visual-editor%
                            (list
                             (identifier-mapping 'identifier 'l pict)
                             ...))))]))
