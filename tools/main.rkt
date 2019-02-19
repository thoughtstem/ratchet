#lang racket
(require drracket/tool
         racket/class
         racket/gui/base
         racket/unit
         mrlib/switchable-button)


(provide tool@)
 
 
(define tool@
  (unit
    (import drracket:tool^)
    (export drracket:tool-exports^)
  
    (define reverse-button-mixin
      (mixin (drracket:unit:frame<%>) ()
        (super-new)
        (inherit get-button-panel
                 get-definitions-text)
        (inherit register-toolbar-button)
 
        (let ((btn
               (new switchable-button%
                    (label "Ratchet")
                    (callback (λ (button)
                                (launch-editor
                                 (get-definitions-text))))
                    (parent (get-button-panel))
                    (bitmap reverse-content-bitmap))))
          (register-toolbar-button btn #:number 11)
          (send (get-button-panel) change-children
                (λ (l)
                  (cons btn (remq btn l)))))))
 
    (define reverse-content-bitmap
      (let* ((bmp (make-bitmap 16 16))
             (bdc (make-object bitmap-dc% bmp)))
        (send bdc erase)
        (send bdc set-smoothing 'smoothed)
        (send bdc set-pen "black" 1 'transparent)
        (send bdc set-brush "blue" 'solid)
        (send bdc draw-ellipse 2 2 8 8)
        (send bdc set-brush "orange" 'solid)
        (send bdc draw-ellipse 6 6 8 8)
        (send bdc set-bitmap #f)
        bmp))
 
    (define (launch-editor text)
      (define s (send text get-text))
      (define lang-line (string->symbol 
                          (string-replace
                            (first (string-split s "\n"))
                            "#lang " "")))
      
      (define editor (dynamic-require `(submod ,lang-line ratchet) 'vis-lang)) 

      (define launch (dynamic-require 'ratchet/launch 'launch))

      (launch editor)
      )
 
    (define (phase1) (void))
    (define (phase2) (void))
 
    (drracket:get/extend:extend-unit-frame reverse-button-mixin)
    ))
