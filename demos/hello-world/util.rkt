#lang racket 

(require racket/gui)

(provide nice)

(define-syntax-rule (nice any ...)
  (begin 
    (message-box "nice" "NICE JOB!")
    any ...))
