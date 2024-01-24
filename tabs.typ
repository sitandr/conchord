#import "@preview/cetz:0.2.0": canvas, draw

#let new(
  tabs,
  extra: none,
  eval-scope: none,
  scale: 0.3cm,
  s-num: 6,
  one-beat-length: 8,
  line-spacing: 2,
) = {
  let sign(x) = if x > 0 { 1 } else if x == 0 { 0 } else { -1 }
  layout(
    size => {
      let width = size.width / scale * 0.95

      canvas(
        length: scale,
        {
          import draw: *

          let draw-lines(y, x: width) = {
            // TODO: use on-layer
            {
              on-layer(-1, {
                for i in range(s-num) {
                  line((0, -(y + i)), (x, -(y + i)), stroke: gray)
                }
              })
            }
          }

          let draw-bar(x, y, width: 1.0) = {
            on-layer(-1,
            line((x, -y), (x, -y - s-num + 1), stroke: width * 1.2pt + gray)
            )
          }

          let x = 0
          let y = 0

          let queque = ()

          queque.push(draw-bar(0, 0))
          let last-string-x = (-1.5,) * 6
          let last-tab-x = (0,) * 6
          let last-sign = none

          let bar-index = 0
          while bar-index < tabs.len() {
            let bar = tabs.at(bar-index)
            bar-index += 1

            if bar.len() > 0 {
              if (last-sign == "\\" or last-sign == none) {
                if bar.at(0) != "||" { x += 1. } else { x -= 0.5 }
              }
              
            }
            let note-index = 0
            while note-index < bar.len() {
              let n = bar.at(note-index)
              note-index += 1

              // have to make a break
              if x >= width {
                x = width
                queque.push({
                  draw-lines(y)
                  draw-bar(x, y)
                  last-string-x = (-1.5,) * 6
                  x = 1.0
                  y += s-num + line-spacing
                  draw-bar(0.0, y)

                  // can remove one note
                  if note-index > 1 {
                    let _ = queque.pop()
                    note-index -= 2
                  }
                })
                last-sign = "\\"
              }

              if n == "\\" {
                queque.push({
                  if last-sign != "||" and last-sign != "|" {
                      draw-bar(x, y)
                      x += 0.5
                  }
                  else {
                      x -= 0.5
                  }

                  draw-lines(y, x: x - 0.5)
                  last-string-x = (-1.5,) * 6
                  y += s-num + line-spacing
                  x = 0.0
                  draw-bar(x, y)
                  x -= 0.5
                  last-sign = "\\"
                })
                continue
              }

              if n == "<" {
                x -= 0.5
                continue
              }
              if n == ">" {
                x += 0.5
                continue
              }

              if n == ":" {
                queque.push({
                  if last-sign == none { x -= 1 / 1 }
                  circle((x, -y - 1.5), radius: 0.2, fill: gray, stroke: gray)
                  circle((x, -y - 3.5), radius: 0.2, fill: gray, stroke: gray)
                  last-sign = ":"
                  x += 0.5
                })
                continue
              }

              if n == "||" {
                queque.push({
                  x += 0.5
                  draw-bar(x, y, width: 4)
                  x += 0.5
                  last-sign = "||"
                })
                continue
              }

              if n == "|" {
                queque.push({
                  if last-sign == "|" {x -= 0.5}
                  draw-bar(x, y)
                  x += 0.5
                  last-sign = "|"
                })
                continue
              }

              if type(n) == array and n.at(0) == "##" {
                queque.push({
                  content((x, -y + 1), eval(n.at(1), scope: eval-scope))
                })
                continue
              }

              if n.len() == 1 {
                panic(n)
              }

              let frets = n.notes

              // pause
              if frets.len() == 0 {
                x += one-beat-length * calc.pow(2, -n.duration)
                continue
              }

              for fret in frets {
                let n-y = fret.string
                queque.push({
                  if fret.connect == "^" {
                    let y = - (y + n-y - 1)
                      
                      bezier-through(
                        (last-string-x.at(n-y - 1) + 0.3, y - 0.5),
                        ((x + last-string-x.at(n-y - 1)) / 2 + 0.3, y - 1.0),
                        (x + 0.3, y - 0.5),
                        stroke: luma(50%),
                      )
                  }
                  else if fret.connect == "`" {
                      let y = - (y + n-y - 1)
                      let dy = fret.fret - last-tab-x.at(n-y - 1)
                      dy = sign(dy) * 0.2

                      line(
                        (last-string-x.at(n-y - 1) + 0.6, y - dy),
                        (x, y + dy),
                        stroke: luma(50%),
                      )
                  }

                  content(
                    (x, - (y + n-y - 1)),
                    {
                      let nlen = str(fret.fret).len()
                      let size = if n.duration * nlen >= 5 {
                        1/calc.pow(2, n.duration - 3.5)/nlen
                      } else {1}
                      set text(size: size * 1em)
                      raw(str(fret.fret))
                    },
                    anchor: "west"
                  )

                  if fret.bend != none {
                    bezier((x + 0.5, - (y + n-y - 1)), (x+1.5, - (y - 1)), (x+1.5, - y - n-y + 1), mark: (length: 0.7, end: (symbol: ">", fill: black, length: 0.5, angle: 30deg, flex: false)))
                    content(
                      (x + 1.5, -y + 1.2),
                      raw(str(fret.bend)),
                      anchor: "south"
                    )
                  }
                })
                last-string-x.at(n-y - 1) = x
                last-tab-x.at(n-y - 1) = fret.fret
                last-sign = "n"
              }
              x += one-beat-length * calc.pow(2, -n.duration)
            }
            x += 0.5
          }

          if last-sign == "||" {x -= 1.0}
          else if last-sign == "|" {x -= 0.5}

          queque.push({
            draw-lines(y, x: x)
            draw-bar(x, y)
            extra
          })

          for i in queque {i}
        },
      )
    },
  )
}

#let to-int(s) = {
  if s.matches(regex("^\d+$")).len() != 0 { int(s) } else { panic("Bad number: " + s) }
}

#let parse-note(n, s-num: 6) = {
  if n == "p" {
    return ()
  }

  return n.split("+").map(
    n => {
      let cont = if n.starts-with("^") { "^" } else if n.starts-with("`") { "`" } else { none }
      if cont != none { n = n.slice(1) }
      let bend = n.split("b")
      if bend.len() > 1 {
        n = bend.at(0)
        bend = bend.at(-1)
      }
      else {
        bend = none
      }
      let coords = n.split("/").map(to-int)
      if coords.len() != 2 {
        panic("Specify fret and string numbers separated by `/`: " + n)
      }
      if coords.at(1) > s-num {
        panic("Too large string number: " + n.at(1))
      }
      let res = (fret: coords.at(0), string: coords.at(1))
      res.connect = cont
      res.bend = bend

      return res
    },
  )
}

#let gen(s, s-num: 6) = {
  if type(s) == "content" {
    s = s.text
  }

  let bars = ()
  let cur-bar = ()
  let cur-dur = 2
  let code-mode = false
  let code = ()

  for (n, s,) in s.split(regex("\s+")).zip(s.matches(regex("\s+")) + ("",)) {
    if n == "##" and not code-mode {
      code-mode = true
      continue
    }

    if code-mode {
      if n == "##" {
        code-mode = false
        cur-bar.push(("##", code.join()))
        code = ()
        continue
      }

      code.push(n)
      code.push(s.text)
      continue
    }

    if n == "<" {
      cur-bar.push(n)
      continue
    }

    if n == ":|" {
      cur-bar.push(":")
      cur-bar.push("|")
      cur-bar.push("<")
      cur-bar.push("||")
      bars.push(cur-bar)
      cur-bar = ()
      n = n.slice(2)
      continue
    }

    if n == "|:" {
      cur-bar.push("||")
      cur-bar.push("|")
      cur-bar.push(":")
      bars.push(cur-bar)
      cur-bar = ()
      n = n.slice(2)
      continue
    }

    if n == "||" {
      cur-bar.push("|")
      cur-bar.push("<")
      cur-bar.push("||")
      bars.push(cur-bar)
      cur-bar = ()
      continue
    }

    if n == "|" {
      cur-bar.push("|")
      bars.push(cur-bar)
      cur-bar = ()
      continue
    }

    if n == "\\" {
      //cur-bar.push("|")
      cur-bar.push("\\")
      bars.push(cur-bar)
      cur-bar = ()
      continue
    }

    if n == "" {
      continue
    }

    let note-and-dur = n.split("-")
    if note-and-dur.len() > 2 or note-and-dur == 0 {
      panic("Specify one duration per note")
    }

    if note-and-dur.len() == 2 {
      let dur = note-and-dur.at(1)
      let mul = 1.0
      while dur.ends-with(".") {
        mul += calc.log(1.5) / calc.log(2)
        dur = dur.slice(0, -1)
      }
      cur-dur = to-int(dur) / mul
    }

    cur-bar.push((notes: parse-note(note-and-dur.at(0), s-num: s-num), duration: cur-dur))
  }

  if cur-bar.len() > 0 {bars.push(cur-bar)}
  return bars
}

