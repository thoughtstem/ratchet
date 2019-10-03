#lang racket

(provide launch-for-ratchet please-wait?
         (rename-out 
           [launch-for-ratchet launch-game-engine]))

;Kids keep pressing the Run button a billion times.  This lets us return a message that says to wait -- and also communicates with the Run button to disable itself for 20 seconds.
;It's a hack, but it does work
(define (please-wait? x)
  (and (string? x)
       (string=? x "Please wait....")))

(define-syntax-rule (launch-for-ratchet exp ...)
  (begin
    exp ...
    "Game complete")

  #;
  (begin
    (thread  ;For some reason, running inside a thread makes subsequent runs faster.  Like the game cleans up after itself better in a thread.  But I'm not sure what's being cleaned up.  Physics?  Some other memory with lux or mode-lambda?
      (thunk exp))
    "Please wait....")
  
  )
