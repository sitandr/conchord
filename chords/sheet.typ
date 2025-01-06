#import "../gen/gen.typ": default-tuning
#import "smart-chord.typ": smart-chord, red-missing-fifth
#import "draw-chord.typ": get-chordgram-width-scale

#let overchord(text, styling: strong, align: start, height: 1em, width: -0.25em) = box(place(align, styling([#text <chord>])), height: 1em + height, width: width)

#let _notes = ("A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#")
#let _chord-root-regex = regex("[A-G][#♯b♭]?")
#let _pm = (
  "#": 1,
  "♯": 1,
  "b": -1,
  "♭": -1
)

#let shift-chord-tonality(chord, tonality) = {
  let match = chord.match(_chord-root-regex).text
  let base = _notes.position(e => e == match.at(0))
  let delta = if match.len() == 1 {0} else {_pm.at(match.at(1))}
  let new = calc.rem(base + delta + tonality, 12)
  chord.replace(_chord-root-regex, _notes.at(new))
}

/// get tonality by element with location or real location
#let get-tonality(loc) = {
  if type(loc) != location {
    loc = loc.location()
  }
  query(selector(<tonality>).before(chord.location())).at(0, default: (value: 0)).value
}

#let auto-tonality-chord(name, ..args) = {
  context smart-chord(shift-chord-tonality(name, get-tonality(here())), ..args)
}

#let change-tonality(tonality-shift) = {
  [#metadata(tonality-shift) <tonality>]
}

// inspired by soxfox42's chordify
/// use `#show: chordify` in your document to allow 
#let chordify(doc, squarechords: true, line-chord: overchord, heading-reset-tonality: none) = {
  show "[[": if squarechords { "[" } else { "[[" }
  show "]]": if squarechords { "]" } else { "]]" }
  let chord-regex = regex("\\[([^\[\]]+?)\\]")
  show chord-regex: it => if squarechords {
    line-chord(it.text.match(chord-regex).captures.at(0))
  } else {
    it
  }
  show <chord>: c => if get-tonality(c) == 0 {c} else {shift-chord-tonality(c.text, get-tonality(c))}

  if heading-reset-tonality != none {
    show heading(level: heading-reset-tonality): it => it + change-tonality(0)
  }
  doc
}

/// Utility function
/// Selects all things inside current "chapter"
#let inside-level-selector(select, heading-level) = {
  if heading-level == none {
    select
  } else {
    let last-heading = query(selector(heading.where(level: heading-level)).before(here()))
    let next-headers = query(selector(heading.where(level: heading-level)).after(here()))
    let base-selector = if last-heading.len() == 0 {
      select
    }
    else {
      select.after(last-heading.at(-1).location())
    }
    if next-headers.len() == 0 {
      base-selector
    } else {
      base-selector.before(next-headers.at(0).location())
    }
  }
}

/// Render all chords of current song.
/// - Set `header-level` to set headings that separate the different songs.
///   If none, all chords in document will be rendered.   
#let chordlib(chordgen: red-missing-fifth, tuning: default-tuning, exclude: (), switch: (:), at: (:), scale-l: 1pt, heading-level: none) = context {
  // select fitting chord
  let chords-selector = inside-level-selector(selector(<chord>), heading-level)
  let rendered = ()
  for (i, c) in query(chords-selector)
      .map(c => shift-chord-tonality(c.text.trim(), get-tonality(c)))
      .dedup()
      .enumerate() {
    if c in exclude {
      continue
    }
    let n = switch.at(c, default: 0)
    let at = at.at(c, default: none)
    box(align(center+horizon, smart-chord(c, chordgen: chordgen, n: n, at: at, scale-l: scale-l)), width: get-chordgram-width-scale(tuning.split().len()) * scale-l, height: 80* scale-l)
  }
}

#let sized-chordlib(N: 2, width: 130pt, ..args) = {
  let scale = get-chordgram-width-scale(args.named().at("tuning", default: default-tuning).split().len())
  block(stroke: gray + 0.2pt, inset: 1em, width: width + 2em, chordlib(..args, scale-l: width / N / scale))
}

