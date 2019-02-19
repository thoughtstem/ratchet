#lang racket

(provide launch)

(require racket/gui framework pict
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
  (new button%
       [parent parent]
       [label "RUN"]
       [callback
        (thunk*
         (define result
           (send input-editor run-code))
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
