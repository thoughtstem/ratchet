#lang scribble/manual

@require[@for-label[ratchet
                    racket/base]]

@title{ratchet}
@author{thoughtstem}

@defmodule[ratchet]

@defform[(define-ratchet-lang 
           (provide provides ...) 
           (require requires ...) 
           optional-wrapper
           [identifier letter icon] ...)]{

  This is used to quickly create Ratchet languages that are also Racket #langs and also suitable for inclusion as Racket modules.

  A package with a single @racket[main.rkt] file is all you need.  In @racket[cool-package/main.rkt]:

  @codeblock{
    #lang racket
    (require ratchet)

    (define-ratchet-lang 
      (provide 
        (all-from-out racket)
        (all-from-out 2htdp/image))
      (require 
        racket
        (only-in 2htdp/image circle))

      [circle c (circle 10 'solid 'red)])
  }

   
  This lets you access the provided identifier as a language:

  @nested[#:style 'code-inset]{
  @verbatim{
    #lang cool-package
    
    (circle 40 'solid 'red) 
  }
  }

  Or as a module:

  @codeblock{
    #lang racket
    (require cool-package)
    
    (circle 40 'solid 'red) 
  }

  Or in Ratchet (where you will have a circle in the legend, accessible with the letter @racket[c]).

  The @racket[optional-wrapper] should be preceded by the keyword @racket[#:wrapper].  It gets passed along to @racket[define-visual-language].  A common value is @racket[launch-game-engine], which is defined in @racket[ratchet/util.rkt] -- and implements some hacks that help speed up Ratchet when dealing with 2d games.  However, it can be used to implement any desired wrapper around the user's Ratchet program, i.e. intercepting output before it gets printed in the Ratchet output window.

  See the @racket[ratchet/demos/hello-world] demo for an example.

  The basic syntax is:

  @codeblock{
    #lang racket
    (require ratchet) 

    (define-ratchet-lang 
      (provide 
        (all-from-out racket)
        (all-from-out 2htdp/image))
      (require 
        racket
        (only-in 2htdp/image circle))
      #:wrapper whatever-wrapper-you-want 
      [circle c (circle 10 'solid 'red)])
  }


  The list of tripplets (@racket[identifier], @racket[letter], and @racket[icon]) are as in @racket[define-visual-language].  They will ultimately configure the Ratchet GUI.

  Each identifier must be provided from the given @racket[requires].

 
}

@defform[(define-visual-language #:wrapper wrapper
           [identifier letter icon] ...)]{
  
  Creates a visual language called @racket[vis-lang] and provides it.
         
  Identifiers may be any Racket identifiers that are bound.

  Letters are the keys that will be mapped to those identifiers in the Ratchet GUI.

  Icons are how the identifiers will appear in the Ratchet GUI.

  Note that Ratchet knows to look for visual language definitions by looking at the @racket[ratchet] submodule in whichever module the #lang line indicates.  So you might add the following to a file that is already configured to implement a #lang.

  @codeblock{
    (module ratchet racket 
      (define-visual-language
       ;Tells Ratchet not to do anything special with the user's code when they press run
       #:wrapper begin 
       [+   + big-plus-sign-image] 
       [two 2 big-plus-sign-image]))
  }

}

