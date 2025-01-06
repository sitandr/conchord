#import "draw-chord.typ": new-chordgen
#import "../gen/gen.typ": default-tuning, get-chord

#let simple-auto-chord = new-chordgen(string-number: auto)
#let red-auto-chord = new-chordgen(string-number: auto, colors: (hold: red.darken(20%)))

/// Chords with missing perfect fifth will be red
#let red-missing-fifth(tabs, name: "", scale-l: 1pt) = {
  if tabs.at(-1) == "?" {
    red-auto-chord(tabs.slice(0, -1), name: name, scale-l: scale-l)
  } else {
    simple-auto-chord(tabs, name: name, scale-l: scale-l)
  }
}

#let smart-chord(name,
  chordgen: red-missing-fifth,
  n: 0, tuning: default-tuning, at: none, scale-l: 1pt) = {
  chordgen(get-chord(name, n: n, tuning: tuning, at: at), name: name, scale-l: scale-l)
}
