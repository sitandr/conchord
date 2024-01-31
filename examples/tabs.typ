#set page(height: auto, width: 60em, margin: 1em)

#import "../lib.typ": tabs, new-chordgen

#let chord = new-chordgen(scale-length: 0.6pt)

#let ending(n) = {
    rect(stroke: (left: black, top: black), inset: 0.2em, n + h(3em))
    v(0.5em)
}

#rect(tabs.new(eval-scope: (chord: chord, ending: ending), tabs.gen[```
2/4 2/4-3 2/4-2 2/4-3 |
2/4-2 2/4-3 2/4 2/4 2/4 |
2/4-2 p 0/2-3 3/2-2 
|:

##
  chord("022000", name: "Em")
##south

0/1+0/6 0/1 0/1-3 2/1 | 3/1+3/5-2 3/1 3/1-3 5/1 | 2/1+0/4-2 2/1 0/1-3 3/2-3 | \ \
2/4 2/4-3 2/4-2 2/4-3 |
2/4-2 2/4-3 2/4 2/4 2/4 |
2/4-2 p 0/2-3 3/2-2 
|:

##
  chord("022000", name: "Em")
##south

0/1+0/6 0/1 0/1-3 2/1 | 3/1+3/5-2 3/1 3/1-3 5/1 | 2/1+0/4-2 2/1 0/1-3 3/2-3 | \ 
3/2-2 `5/2-3 p-2 0/2-3 3/2 | | ## [...] ##west p-4. | | 7/1-3 0/1-2 p-3 0/1 3/1 

##
    ending[1.]
##west

|
2/1-3
2/1
3/1 0/1 2/1-2 p-3 0/2-3 3/2-3 
##
  ending[2.]
##west
|
2/1-2 2/1 0/1-3 3/2 :| 0/6-2 | ^0/6-2 ||
\
1/1 2/1 2/2 2/2 2/3 2/3 4/4 | 4/4 4/4 4/4 4/4 4/4 2/3  2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/3 2/2 2/3 2/4 \
10/1-3 10/1-3 10/1-3 10/1-4 10/1-4 10/1-4 10/1-4 10/1-4 10/1-1
\
1/3bfullr+2/5-2 1/2b1/2-1 p-2
```]), inset: 0em)


Not a lot customization is available yet, but something is already possible:

#show raw: set text(red, font: "Comic Sans MS")

#tabs.new(tabs.gen(s-num: 5, "0/1+2/5-1 ^0/1+`3/5-2.."), scale-length: 0.2cm, one-beat-length: 12, s-num: 5)

