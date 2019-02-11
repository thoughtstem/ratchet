#lang racket

(provide tangeable-tiles)

(require pict
         "../gui/basic-editor.rkt")



(define (tangeable-tiles lang)
  (define mappings (visual-language-mappings lang))
  
  (define tile-picts
    (map (compose pict->tile
                  identifier-mapping-picture)
         mappings))

  (define letter-picts
    (map (compose (curryr colorize "white")
                  text
                  identifier-mapping-letter/long)
         mappings))

  (define zipped
    (map list
         letter-picts
         tile-picts))

  (map (curry apply place-letter) zipped))



(define (identifier-mapping-letter/long im)
  (~a
   (identifier-mapping-main im)
   "("
   (identifier-mapping-letter im)
   ")"))

(define (place-letter letter tile)
  (vl-append tile
                  (ct-superimpose
                   (colorize (filled-rectangle 70 15) "black")
                   (scale-to-fit letter
                                 60 15))))

(define (pict->tile p)
  (frame #:color "black" #:line-width 10
   (inset
    (cc-superimpose
     (colorize (filled-rectangle 50 50) "white")
     (scale-to-fit p
                   50 50))
    10)))