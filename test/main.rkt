#lang racket

(require "../languages/toy-lang.rkt"
         #;"./languages/sound-lang.rkt")

;The three things you'd want to do with
;a visual language (after defining it.)

;FOR STUDENTS:
;Write with it
(launch toy-lang-1)


;FOR TEACHERS:
;Print its identifiers
(tangeable-tiles toy-lang-1)


;FOR CURRICULUM DEVELOPERS
;Write in the non visual form,
;  but display in the visual form
(typeset-code toy-lang-1
              (rotate
               (above (green circle)
                      (red circle)
                      (blue circle))))

