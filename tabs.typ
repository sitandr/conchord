#import "@preview/cetz:0.2.0": canvas, draw

#let native-scale = scale
#let new(
  tabs,
  extra: none,
  eval-scope: none,
  scale-length: 0.3cm,
  s-num: 6,
  one-beat-length: 8,
  line-spacing: 2,
  enable-scale: true,
  debug-render: float("inf"),
  debug-number: false
) = {
  let sign(x) = if x > 0 { 1 } else if x == 0 { 0 } else { -1 }
  layout(
    size => {
      let width = size.width / scale-length * 0.95

      let calculate-alpha(draft) = {
        let alpha = if draft.var != 0 {
          (width - draft.const)/draft.var
        } else {1}

        if alpha > 3 or alpha < 0.9 {
          1
        }
        else {
          alpha
        }
      }

      canvas(
        length: scale-length,
        {
          import draw: *

          let draw-lines(y, x: width) = {
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
            line((x, -y + 0.06), (x, -y - s-num + 1 - 0.06), stroke: width * 1.2pt + gray)
            )
          }

          let x = 0.0
          let y = 0

          let queque = ()

          queque.push(draw-bar(0, 0))
          let last-string-x = (-1.5,) * 6
          let last-tab-x = (0,) * 6
          let last-sign = "\\"

          let bar-index = 0

          let draft = (enable: true, var: 0, const: 0.0, alpha: 1.0, queque-line-start: 1, bar-start: 0, note-start: float("inf"))

          // for debug purposes
          let counter-lim = 0
          let debug-render = debug-render

          let tabs = tabs
          while bar-index < tabs.len() {
            let bar = tabs.at(bar-index)
            bar-index += 1

            if counter-lim > debug-render {
              break
            }

            if bar.len() > 0 {
              if (last-sign == "\\") {
                if bar.at(0) != "||" { x += 1.; draft.const += 1 } 
                else { x -= 0.5; draft.const -= 0.5 }
              }
            }

            let note-index = 0
            while note-index < bar.len() {
              let n = bar.at(note-index)
              note-index += 1

              if debug-number {
                queque.push(content((x, -y + 1), {
                  set text(size: 0.3em)
                  note-index
                }))
              }

              if debug-number {
                counter-lim += 1
                if counter-lim > debug-render {
                  break
                }
              }

              assert(calc.abs(x - (draft.const + draft.var)) < 0.001, message: "Broken sync between drafting variables and x: " + str(x) +"  " + str(draft.const) + " " + str(draft.var) + " " + repr(n))

              // have to make a break
              if x > width + 0.51 and (not draft.enable or not enable-scale) {
                // reset everything to draft to the last bar
                
                // calculate-alpha(draft) > 1
                if bar-index - draft.bar-start >= 2 and tabs.at(bar-index) != ("\\",) {
                  tabs.insert(bar-index, ("\\",))
                  // jumping into bar end
                  last-sign = "\\"
                  
                  draft = (enable: true, var: 0, bar-start: draft.bar-start, queque-line-start: draft.queque-line-start, alpha: 1.0, note-start: draft.note-start)

                  queque = queque.slice(0, draft.queque-line-start)
                  if draft.note-start == float("inf") {
                    draft.const = -0.5
                    x = -0.5
                  }
                  else {
                    draft.const = 1.0
                    x = 1.0
                  }

                  bar-index = draft.bar-start
                  bar = tabs.at(bar-index)
                  note-index = draft.note-start
                  continue
                }

                x = width - 0.5
                queque.push({
                  draw-lines(y, x: x)
                  draw-bar(x, y)
                  last-string-x = (-1.5,) * 6
                  x = 1.0
                  y += s-num + line-spacing
                  draw-bar(0.0, y)

                  // can remove one note
                  // to move it to the next line
                  if note-index > 1 {
                    let _ = queque.pop()
                    let _ = queque.pop()
                    note-index -= 1
                  }
                })
                last-sign = "\\"
                note-index -= 1
                draft = (enable: true, var: 0, const: 1.0, alpha: 1.0, queque-line-start: queque.len(), bar-start: bar-index, note-start: note-index)
                continue
              }

              // for debug usage
              let ftabs = tabs.map(arr => arr.map(i => {if type(i) != str {"n"} else {i}}).join())

              if n == "\\" {
                if last-sign == "||" {
                  x -= 0.3
                  draft.const -= 0.3
                }
                else if last-sign == "|" {
                  x -= 0.5
                  draft.const -= 0.5
                }
                else {
                  x += 0.5
                  queque.push({draw-bar(x, y)})
                  x += 0.5
                  draft.const += 1.0
                }
                
                if bar-index == draft.bar-start + 1 and bar.len() == 1 {
                  // remove empty line
                  for _ in range(2) {let _ = queque.pop()}
                } else {
                  if bar-index > 0 {
                    if draft.enable and enable-scale {
                      last-sign = "\\"
                      let alpha = calculate-alpha(draft)
                      draft = (enable: false, var: 0, bar-start: draft.bar-start, queque-line-start: draft.queque-line-start, alpha: alpha, note-start: draft.note-start)

                      queque = queque.slice(0, draft.queque-line-start)
                      bar-index = draft.bar-start
                      bar = tabs.at(bar-index - 1)
                      note-index = draft.note-start

                      let i = if note-index == float("inf") {ftabs.at(bar-index).len()} else {int(note-index)}

                      // jumping into bar end
                      if note-index == float("inf") {
                        draft.const = -0.5
                        x = -0.5
                      }
                      else {
                        draft.const = 1.0
                        x = 1.0
                      }
                      continue
                    }
                  }
                  
                  queque.push({
                    draw-lines(y, x: x - 0.5)
                  })
                }

                queque.push({
                  last-string-x = (-1.5,) * 6
                  y += s-num + line-spacing
                  draw-bar(0.0, y)
                  x = -0.5
                  last-sign = "\\"
                })
                draft = (enable: true, var: 0, const: -0.5, alpha: 1.0, queque-line-start: queque.len(), bar-start: bar-index, note-start: float("inf"))
                continue
              }

              if n == "<" {
                draft.const -= 0.5
                x -= 0.5
                continue
              }
              if n == ">" {
                draft.const += 0.5
                x += 0.5
                continue
              }

              if n == ":" {
                queque.push({
                  if last-sign == none { x -= 1; draft.const -= 1 }
                  circle((x, -y - 1.5), radius: 0.2, fill: gray, stroke: gray)
                  circle((x, -y - 3.5), radius: 0.2, fill: gray, stroke: gray)
                  last-sign = ":"
                  x += 0.5
                  draft.const += 0.5
                })
                continue
              }

              if n == "||" {
                queque.push({
                  x += 0.5
                  draw-bar(x, y, width: 4)
                  x += 0.5
                  draft.const += 1.0
                  last-sign = "||"
                })
                continue
              }

              if n == "|" {
                //x -= 1.0
                //draft.const -= 1.0
                queque.push({
                  if last-sign == "|" {
                    x -= 0.5
                    draft.const -= 0.5
                  }
                  draw-bar(x, y)
                  x += 0.5
                  draft.const += 0.5

                  last-sign = "|"
                })
                continue
              }

              if type(n) == array and n.at(0) == "##" {
                queque.push({
                  content((x, -y + 1), eval(n.at(2), scope: eval-scope), anchor: if n.at(1).len() > 0 {n.at(1)} else {none})
                })
                continue
              }

              if n.len() == 1 {
                panic(n)
              }

              let frets = n.notes
              let dx = one-beat-length * calc.pow(2, -n.duration) * draft.alpha
              draft.var += dx
              // pause
              if frets.len() == 0 {
                x += dx
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
                      let available = (scale-length/0.3cm) * (one-beat-length/8) * calc.pow(2, -n.duration)
                      let given = nlen * 0.09
                      
                      let size = if given > available {
                        available/given
                      } else {1}
                      native-scale(raw(str(fret.fret)), x: size * 100%, origin: left)
                    },
                    anchor: "west"
                  )

                  if fret.bend != none {
                    let alpha = if fret.bend-return {0.4} else {0.8}
                    
                    bezier(
                      (x + 0.5, - (y + n-y - 1)),
                      (x+alpha*dx, - (y - 1)),
                      (x+alpha*dx*0.8, - (y + n-y - 1)),
                      (x+alpha*dx, - (y + n-y - 1)),
                      mark: (
                        length: 0.7,
                         end: (symbol: ">",
                          fill: black,
                          length: 0.5, 
                          angle: 30deg, 
                          flex: false))
                    )
                    content(
                      (x + alpha*dx, -y + 1.2),
                      raw(str(fret.bend)),
                      anchor: "south"
                    )
                    if fret.bend-return {
                      bezier(
                        (x+alpha*dx, - (y - 1)),
                        (x+0.8*dx, - (y + n-y - 1)), 
                        (x+0.64*dx, -y+1), 
                        (x+0.8*dx, -y+1), 
                        mark: (
                          length: 0.7, 
                          end: (symbol: ">", 
                            fill: black, 
                            length: 0.5, 
                            angle: 30deg, flex: false))
                      )
                    }
                  }
                })
                last-string-x.at(n-y - 1) = x
                last-tab-x.at(n-y - 1) = fret.fret
                last-sign = "n"
              }
              x += dx
            }
            x += 0.5
            draft.const += 0.5
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
      let bend-return = false
      if bend.len() > 1 {
        n = bend.at(0)
        bend = bend.at(-1)
        if bend.ends-with("r") {
          bend = bend.slice(0, -1)
          bend-return = true
        }
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
      res.bend-return = bend-return

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
      if n.starts-with("##") {
        code-mode = false
        cur-bar.push(("##", n.slice(2), code.join()))
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

