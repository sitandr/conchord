#let conchord_gen = plugin("conchord_gen.wasm")

#let n-best(arr, n: 18) = {
  arr.slice(0, calc.min(n, arr.len()))
}

#let get-chords(name, tuning: "E A D G B E", at: none) = {
  let at = if at == none {255} else {at}
  str(conchord_gen.get_chords(bytes(tuning), bytes(name), bytes((at,)))).split(";")
}

#let get-chord(name, n: 0, tuning: "E A D G B E", at: none) = {
  get-chords(name, tuning, at: at).at(n)
}
