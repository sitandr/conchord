#import "../lib.typ": centered-chords as cc
// For better png in README, doesn't matter
#set page(width: auto, height: auto, margin: 1em)

#let bl = block.with(stroke: gray, inset: 1em)

Center-aligned:\ 
#bl[
  #cc[A][Why] do #cc[B][birds] #cc[C][D][suddenly] #cc[E\#/D][appear]
]

Left-aligned:
#bl[
  #cc(align: left)[A][Left-aligned chord] \
  // cases like this could be set up with wrapping-align
  #cc(align: left)[Asus2(b5)][Same]
] 

Right-aligned:
#bl[
  #cc(align: right)[A][Right-aligned chord] \
  // cases like this could be set up with wrapping-align
  #cc(align: right)[Asus2(b5)][Same]
] 
