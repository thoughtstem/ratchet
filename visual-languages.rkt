#lang racket

(require racket/gui framework pict)

(provide define-visual-language
         (struct-out visual-language)
         launch)

(define (fileify key bm)
  (define f (make-temporary-file (~a "~a-" key ".png")))
  (send bm save-file f 'png)
  f)

(struct visual-language (editor mappings))

(define-syntax (define-visual-language stx)
  (syntax-case stx ()
    [(define-visual-language lang-id module-path [identifier l pict] ...)
     #'(begin
         (provide (all-from-out module-path)
                  lang-id
                  launch
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
                             (list 'identifier 'l pict)
                             ...))))]))





;For the default launcher function.  Move to another file when it gets too long

(define (show-mapping panel m)
  ;Consider putting m (an image snip) onto "panel" (a pasteboard%).
  ;  Better than canvases on panels, right?
  ;Maybe, but can the snip contain the label?  Snips within snips?
  ;  Nah... Going to need some way of associating snips with each other on the pasteboard.
  
  (new canvas%
       [parent panel]
       [paint-callback
        (lambda (canvas dc)
          (send dc draw-text   (~a "(" (second m) ") " (first m)) 25 10)
          (send dc draw-bitmap (pict->bitmap (scale-to-fit (third m) 20 20)) 0 10))]))

(define (launch vis-lang) ;Takes an editor for a visual language
  (define the-editor (new (visual-language-editor vis-lang)))

  (define output-editor% racket:text%)

  (define f (new frame%
                 [label "Simple Edit"]
                 [width 200]
                 [height 200]))
  
  (define top-panel (new horizontal-panel%
                         [parent f]
                         [alignment '(center center)]))

  (define top-left-panel (new vertical-panel%
                              [parent top-panel]
                              [alignment '(center center)]))


  (for ([m (in-list (visual-language-mappings vis-lang))])
    (show-mapping top-left-panel m))
  
  (define input-canvas (new editor-canvas% [parent top-panel]))
  (send input-canvas set-editor the-editor)

  (define output-editor (new output-editor%))
  (define output-canvas (new editor-canvas% [parent f]))
  (send output-canvas set-editor output-editor)

  (define run-button
    (new button%
         [parent f]
         [label "RUN"]
         [callback
          (thunk*
           (define result
             (send the-editor run-code))
           (cond
             [(pict? result)
              (send output-editor
                    do-edit-operation
                    'select-all)
              (send output-editor
                    clear)
              (send output-editor
                    insert-image
                    (let ()
                      (define f (make-temporary-file))
                      (define bm (pict->bitmap result))
                      (send bm save-file f 'png)
                      f))]
             [else (displayln result)]))]))
  
  (send f show #t))