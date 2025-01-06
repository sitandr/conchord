/// Classic 6-string Guitar
#let default-tuning = "E A D G B E"

#let conchord_gen = plugin("conchord_gen.wasm")

#let n-best(arr, n: 18) = {
  arr.slice(0, calc.min(n, arr.len()))
}

/// Gets all possible chord strings with given tuning (and optionally at given fret)
#let get-chords(name, tuning: default-tuning, at: none) = {
  let at = if at == none {255} else {at}
  str(conchord_gen.get_chords(bytes(tuning), bytes(name), bytes((at,)))).split(";")
}

#let get-chord(name, n: 0, tuning: default-tuning, at: none) = {
  get-chords(name, tuning: tuning, at: at).at(n)
}
