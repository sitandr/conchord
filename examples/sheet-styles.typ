#import "../lib.typ": new-chordgen, overchord, chordlib, chordify, change-tonality, sized-chordlib, change-tonality, inlinechord, fulloverchord
#let chord = new-chordgen(string-number: auto)

// For better png in README, doesn't matter
#set page(height: auto, margin: (right: 0%))
#show heading: set block(spacing: 1em)

= Another Brick in the wall, Pink Floyd


#[
  #show: chordify.with(heading-reset-tonality: 2)
  == Default `overchord`
  [Dm] We dоn't need nо еduсаtiоn, \
  [Dm] We dоn't need nо thоught соntrоl, \
  #change-tonality(1)
  [Dm] Nо dark sarcasm in the сlаssrооm.   \         
  [Dm] Teacher leave them kids [G] аlоnе.   \                 
  [G] Hey, Teacher!  Leave them kids аlоnе.
]

#[
  #show: chordify.with(line-chord: inlinechord, heading-reset-tonality: 2)
  == `inlinechord`
  [Dm] We dоn't need nо еduсаtiоn, \
  [Dm] We dоn't need nо thоught соntrоl, \
  #change-tonality(1)
  [Dm] Nо dark sarcasm in the сlаssrооm. \      
  [Dm] Teacher leave them kids [G] аlоnе. \                 
  [G] Hey, Teacher!  Leave them kids аlоnе. \
]


#[
  #show: chordify.with(line-chord: fulloverchord, heading-reset-tonality: 2)
  == `fulloverchord`
  
  #fulloverchord("Gmaj7", n: 0)

  [Dm] We dоn't need nо еduсаtiоn, \
  [Dm] We dоn't need nо thоught соntrоl, \
  #change-tonality(1)
  [Dm] Nо dark sarcasm in the сlаssrооm. \      
   Teacher leave them kids [G] аlоnе. \                 
  [G] Hey, Teacher!  Leave them kids аlоnе. \
]