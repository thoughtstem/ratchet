#lang racket

#;(
(require "../visual-languages.rkt"
         rsound
         (prefix-in p: pict))

(define fart (rs-read "./languages/fart.wav") )

(module my-sound racket
  (provide (all-from-out rsound)
           fart)
  (require rsound)


  ;Immature yes.  But this is a language for
  ;  little kids, so....
  (define fart (rs-read "./languages/fart.wav") ))

(define-visual-language sound-lang-1
  'my-sound
  [play      p (p:text "PLAY")]
  [rs-append a (p:text "APPEND")]
  [ding      d (p:text "DING")]
  [fart      f (p:text "FART")])
)
