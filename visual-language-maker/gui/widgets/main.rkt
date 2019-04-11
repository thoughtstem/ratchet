#lang racket

(provide launch)

(require racket/gui framework pict
         "../../../util.rkt"
         "../../base.rkt"
         "./basic-input-editor.rkt")

(define (launch vis-lang) 

  (define f (basic-frame))

  (define input-editor  (basic-input-editor  f vis-lang))
  (define output-editor (basic-output-editor f))

  (run-code-button f input-editor output-editor)
  
  (send f show #t))


(define (basic-frame)
  (new frame%
       [label "Simple Edit"]
       [width 500]
       [height 500]))


(define (basic-output-editor parent)
  (define output-editor% racket:text%)

  (define output-editor (new output-editor%))
  (define output-canvas (new editor-canvas% [parent parent]))
  (send output-canvas set-editor output-editor)

  output-editor)


(define (run-code-button parent input-editor output-editor)
  (define b
    (new button%
       [parent parent]
       [label "RUN"]
       [callback
        (thunk*
         (send b enable #f)

         (with-handlers ([exn:fail? (lambda (e)  
                                      (send b enable #t)
                                      (raise e))])
                        (define result
                          (send input-editor run-code))
                        (cond
                          ;Ugh.  Why is this so hard to generalize?
                          ;  TODO: Post on the racket mailing list and ask how the interactiosn
                          ;    window works.  We should be able to pipe arbitrary values into
                          ;    a text% editor.  But I can't figure out how yet.
                          [(pict? (sanitize result))
                           (send output-editor
                                 do-edit-operation
                                 'select-all)
                           (send output-editor
                                 clear)
                           (send output-editor
                                 insert-image
                                 (let ()
                                   (define f (make-temporary-file))
                                   (define bm (pict->bitmap (sanitize result)))
                                   (send bm save-file f 'png)
                                   f))]
                          [else (send-to-editor output-editor (sanitize result))])

                        ;Hack...  But I think we don't need it anymore,
                        ;since we allow game-engine games to run to completion before 
                        ;the run button needs to be reenabled.  So it just waits until
                        ;the game is finished before you can launch another one.
                        ;Exactly what we want.
                        ;I'll leave this here for now, in case we need to fall back
                        ;to the hackier solution.
                        
                        #;
                        (if (please-wait? result)
                          (thread
                            (thunk
                              (sleep 20) 
                              (send b enable #t)))

                          (send b enable #t)))
         

          
          
          )]))
  
  b)

(require (only-in 2htdp/image image?))
(define (sanitize r)
  (cond [(list? r)  (map sanitize r)]
        [(image? r) (bitmap r)] ;Convert 2htdp/image to pict.  More straightforward to insert into editors...
        [else r]))

(require wxme)
(define (send-to-editor e r)
  (send e
        do-edit-operation
        'select-all)
  (send e
        clear)
  
  
  (displayln "Sending to editor")

  (define-values (ip op)
    (make-pipe))

  (print r op)

  (close-output-port op)
  (send e insert-port ip)

  
  )



#;
(module+ test
  (require (submod k2/lang/hero/basic ratchet))

  (launch vis-lang))


