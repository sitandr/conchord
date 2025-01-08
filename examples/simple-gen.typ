#import "../lib.typ": smart-chord
#set page(height: auto, width: auto, margin: 1em)

#box(smart-chord("Am"))
// at what fret to play the chord
#box(smart-chord("Am", at: 5))
// what variant number to select
#box(smart-chord("Am", n: 4))
// what tuning to use
#box(smart-chord("Am", tuning: "G C E A")) // ukulele
