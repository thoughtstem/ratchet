#lang racket
(require ratchet)

(define-ratchet-lang 
  (provide 
    (all-from-out racket)
    (all-from-out 2htdp/image))
  (require 
    racket
    (only-in 2htdp/image circle)
    hello-world/util)
  #:wrapper nice 
  [circle c (circle 10 'solid 'red)])
