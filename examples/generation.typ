#import "../lib.typ": n-best, get-chords, red-missing-fifth
#set page(height: auto, width: 42em, margin: 1em)


= `Am`
#for c in n-best(get-chords("Am")) {
  box(red-missing-fifth(c))
}

= `Cmaj7/E`
#for c in n-best(get-chords("Cmaj7")) {
  box(red-missing-fifth(c))
}

= Bas, `E`: 
#for c in n-best(get-chords("E", tuning: "E A D G")) {
  box(red-missing-fifth(c))
}

= DADGAD tuning, `Em`: 
#for c in n-best(get-chords("Em", tuning: "D A D G A D")) {
  box(red-missing-fifth(c))
}
