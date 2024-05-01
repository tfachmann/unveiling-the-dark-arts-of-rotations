#let todo(body) = [
  #let rblock = block.with(stroke: red, radius: 0.5em, fill: red.lighten(80%))
  #let top-left = place.with(top + left, dx: 1em, dy: -0.35em)
  #block(inset: (top: 0.35em), {
    rblock(width: 100%, inset: 1em, body)
    top-left(rblock(fill: white, outset: 0.25em, text(fill: red)[*TODO*]))
  })
  <todo>
]

#let bordered_box(title: none, width: auto, color: blue, lighten: 80%, inset: 1em, body) = [
  #let rblock = block.with(stroke: color, radius: 0.2em, fill: color.lighten(lighten))
  #let top-left = place.with(top + left, dx: 1em, dy: -0.35em)
  #block(inset: (top: 0.35em), {
    rblock(width: width, inset: inset, body)
    if not (title == none or title == "") {
      top-left(rblock(fill: white, outset: 0.30em, text(fill: color)[*#title*]))
    }
  })
  <todo>
]

#let subfigure(body, caption: "", numbering: "(a)") = {
  let figurecount = counter(figure) // Main figure counter
  let subfigurecount = counter("subfigure") // Counter linked to main counter with additional sublevel
  let subfigurecounterdisply = counter("subfigurecounter") // Counter with only the last level of the previous counter, to allow for nice formatting

  let number = locate(loc => {
    let fc = figurecount.at(loc)
    let sc = subfigurecount.at(loc)

    if fc == sc.slice(0,-1) {
      subfigurecount.update(
        fc + (sc.last()+1,)
      ) // if the first levels match the main figure count, update by 1
      subfigurecounterdisply.update((sc.last()+1,)) // Set the display counter correctly
    } else {
      subfigurecount.update( fc + (1,)) // if the first levels _don't_ match the main figure count, set to this and start at 1
      subfigurecounterdisply.update((1,)) // Set the display counter correctly
    }
    subfigurecounterdisply.display(numbering) // display the counter with the first figure level chopped off
  })
  
  body // put in the body
  v(-.65em) // remove some whitespace that appears (inelegant I think)
  if not caption == none {
    align(center)[#number #caption] // place the caption in below the content
  }
}
