#lang info

(define scribblings 
  '(("scribblings/manual.scrbl" (multi-page))))

(define deps '("base"
               "draw-lib"
               "drracket-plugin-lib"
               "gui-lib"
               "htdp-lib"
               "pict-lib"
               "pict-snip-lib"
               "wxme-lib"
               "lang-file"))

(define drracket-tool-names (list "Tool Name"))
(define drracket-tools (list (list "tools/main.rkt")))

(define compile-omit-paths '("demos"))
(define test-omit-paths '("demos"))
(define build-deps '("racket-doc"
                     "scribble-lib"))
