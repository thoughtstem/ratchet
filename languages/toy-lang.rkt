#lang racket

(require "../visual-languages.rkt"
         "./base-lang.rkt"
         (prefix-in p: pict))


(define-visual-language toy-lang-0
  "./base-lang.rkt"
  [define  w (p:bitmap "./images/define.png")]
  [square  s (p:filled-rectangle 10 10)]
  [bigger  b (p:bitmap "./images/bigger.png")]
  [rotate  r (p:bitmap "./images/rotate.png")]
  [red     d (p:standard-fish 15 10
                              #:direction 'right
                              #:color "red")]
  [green   g (p:standard-fish 15 10
                              #:direction 'right
                              #:color "green")]
  [blue    l (p:standard-fish 15 10
                              #:direction 'right
                              #:color "blue")])

(define-visual-language toy-lang-1
  "./base-lang.rkt"
  [define  w (p:bitmap "./images/define.png")]
  [circle  c (p:filled-ellipse 10 10)]
  [square  s (p:filled-rectangle 10 10)]
  [bigger  b (p:bitmap "./images/bigger.png")]
  [smaller m (p:hc-append (p:arrow 5 pi) (p:arrow 5 pi))]
  [rotate  r (p:bitmap "./images/rotate.png")]
  [above   a (p:bitmap "./images/above.png")]
  [beside  e (p:rotate (p:bitmap "./images/above.png")
                       (/ pi 2))]
  [overlay o (p:bitmap "./images/overlay.png")]
  [red     d (p:standard-fish 15 10
                              #:direction 'right
                              #:color "red")]
  [green   g (p:standard-fish 15 10
                              #:direction 'right
                              #:color "green")]
  [blue    l (p:standard-fish 15 10
                              #:direction 'right
                              #:color "blue")]
  [jack-o-lantern j (p:jack-o-lantern 10)]
  [random-dude    q (p:text "?")])



