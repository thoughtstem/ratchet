#lang info

(define scribblings 
  '(("scribblings/manual.scrbl" (multi-page))))

(define deps '("lang-file"))

(define drracket-tool-names (list "Tool Name"))
(define drracket-tools (list (list "tools/main.rkt")))

(define compile-omit-paths '("demos"))
(define test-omit-paths '("demos"))
