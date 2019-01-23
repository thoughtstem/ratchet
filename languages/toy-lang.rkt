#lang racket

(provide (all-from-out "../visual-language-maker/main.rkt"))

(require "../visual-language-maker/main.rkt"
         "./base-lang.rkt"
         "./icons.rkt"
         (prefix-in p: pict))

(define-visual-language toy-lang-0
  "./base-lang.rkt"
  [define  w dictionary-icon]
  [square  s square-icon]
  [bigger  b bigger-icon]
  [rotate  r rotate-icon]
  [red     d red-fish-icon]
  [green   g green-fish-icon]
  [blue    l blue-fish-icon])

(define-visual-language toy-lang-1
  "./base-lang.rkt"
  [define  w dictionary-icon]
  [circle  c circle-icon]
  [square  s square-icon]
  [bigger  b bigger-icon]
  [smaller m smaller-icon]
  [rotate  r rotate-icon]
  [above   a above-icon]
  [beside  e beside-icon]
  [overlay o overlay-icon]
  [red     d red-fish-icon]
  [green   g green-fish-icon]
  [blue    l blue-fish-icon]
  [jack-o-lantern j jack-o-lantern-icon]
  [random-dude    q question-mark-icon])



