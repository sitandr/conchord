#import "tabs/tabs.typ"
#import "gen/gen.typ": get-chord, get-chords, n-best
#import "draw-chord.typ": *

#let simple-auto-chord = new-chordgen(string-number: auto)
#let red-auto-chord = new-chordgen(string-number: auto, colors: (hold: red.darken(20%)))

/// Chords with missing perfect fifth will be red
#let red-missing-fifth(tabs, name: "") = {
  if tabs.at(-1) == "?" {
    red-auto-chord(tabs.slice(0, -1))
  } else {
    simple-auto-chord(tabs)
  }
}

#let smart-chord(name,
  chordgen: red-missing-fifth,
  n: 0, tuning: "E A D G B E", at: none) = {
  chordgen(get-chord(name, n: n, tuning: tuning, at: at))
}

#let overchord(body, align: start, height: 1em, width: -0.25em) = box(place(align, body), height: 1em + height, width: width)

