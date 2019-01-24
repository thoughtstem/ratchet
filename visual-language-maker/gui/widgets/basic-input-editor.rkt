#lang racket

(provide basic-input-editor)

(require racket/gui framework pict
         "../basic-editor.rkt")

(define (basic-input-editor parent vis-lang)
  (define top-panel (new horizontal-panel%
                         [parent parent]
                         [alignment '(center center)]
                         [stretchable-width #t]))

  (define legend-canvas
    (new editor-canvas%
         [parent top-panel]
         [min-width 250]
         [stretchable-width #t]))
  
  (define legend  (new pasteboard%))
  
  (send legend-canvas set-editor legend)

  (define mappings (visual-language-mappings vis-lang))

  (for ([m mappings]
        [i (range (length mappings))])
    (show-mapping legend m i))

  (send legend lock #t)
  
  (define the-editor (new (visual-language-editor vis-lang)))
  (define mb (new menu-bar% [parent parent]))
  (define m-edit (new menu% [label "Edit"] [parent mb]))
  (define m-font (new menu% [label "Font"] [parent mb]))
  (append-editor-operation-menu-items m-edit #f)
  (append-editor-font-menu-items m-font)
  (send the-editor set-max-undo-history 100)

  (define input-canvas
    (new editor-canvas%
         [parent top-panel]
         [min-width 250]
         [stretchable-width #t]))
  
  (send input-canvas set-editor the-editor)

  the-editor)



(define (show-mapping panel m mi)
  ;Consider putting m (an image snip) onto "panel" (a pasteboard%).
  ;  Better than canvases on panels, right?
  ;Maybe, but can the snip contain the label?  Snips within snips?
  ;  Nah... Going to need some way of associating snips with each other on the pasteboard.

  (define is (new image-snip%))
  (send is set-bitmap
        (pict->bitmap (scale-to-fit (third m) 20 20)))
  
  (send panel insert
        is
        0 (* 20 mi))

  (send panel insert
        (make-object string-snip% (~a "(" (second m) ") " (first m)))
        40 (* 20 mi))
  )


