#lang racket

(provide basic-input-editor)

(require racket/gui framework pict
         "../basic-editor.rkt")

(define (basic-input-editor parent vis-lang)
  (define top-panel (new horizontal-panel%
                         [parent parent]
                         [alignment '(center center)]))

  (define top-left-panel (new vertical-panel%
                              [parent top-panel]
                              [alignment '(center center)]))


  (for ([m (in-list (visual-language-mappings vis-lang))])
    (show-mapping top-left-panel m))
  
  (define the-editor (new (visual-language-editor vis-lang)))

  (define input-canvas (new editor-canvas% [parent top-panel]))
  (send input-canvas set-editor the-editor)

  the-editor)



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


