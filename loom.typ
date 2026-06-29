// loom.typ -- a WOVEN notebook template for Typst
// ============================================================================
//  Concept:  A page is cloth on a loom.  You don't just typeset the maths,
//            you typeset the WEAVE of your own understanding.
//
//  Palette:  natural dyes -- indigo, madder, weld -- ruled in iron-gall.
//  Author:   北极甜虾 (Polaris), 2026.   MIT-licensed.
// ============================================================================

// ─── THE DYE-POT ─────────────────────────────────────────────────────────────

#let inkiron = rgb("#211C17")
#let indigo  = rgb("#27406B")
#let madder  = rgb("#9C2B2E")
#let weld    = rgb("#BE8A20")
#let linen   = rgb("#F5EFE2")
#let thread  = rgb("#C7BBA1")
#let selvage = rgb("#8A7F6B")

// ─── FONT STACKS ────────────────────────────────────────────────────────────
// Optima → Liberation Sans (closest available humanist sans)
// Avenir Next → DejaVu Sans (clean geometric sans)
// Body/Math → Libertinus Serif + New Computer Modern Math

#let heading-fonts = ("Liberation Sans", "FreeSans", "DejaVu Sans")
#let strand-fonts = ("DejaVu Sans", "FreeSans")
#let body-fonts = "Libertinus Serif"
#let math-fonts = "New Computer Modern Math"

// ─── WOVEN PRIMITIVES ────────────────────────────────────────────────────────

#let loomtile(color, size: 6pt) = {
  let half = size / 2
  let light = color.lighten(72%)
  box(
    width: size,
    height: size,
    baseline: 20%,
    {
      place(top + left, rect(width: half, height: half, fill: color, stroke: none))
      place(top + right, rect(width: half, height: half, fill: light, stroke: none))
      place(bottom + left, rect(width: half, height: half, fill: light, stroke: none))
      place(bottom + right, rect(width: half, height: half, fill: color, stroke: none))
    },
  )
}

#let weaveemblem(size: 132pt) = {
  let cells = 8
  let cell = size / cells
  let colors = (indigo, indigo, weld)
  box(width: size, height: size, {
    for c in range(cells) {
      for r in range(cells) {
        let warp-over = calc.rem(c + r, 2) == 1
        let warp-color = colors.at(calc.rem(c, 3))
        let x = c * cell
        let y = r * cell
        let warp-rect = place(
          top + left,
          dx: x + 0.17 * cell,
          dy: y - 0.03 * cell,
          rect(
            width: 0.66 * cell,
            height: 1.06 * cell,
            fill: warp-color,
            radius: 0.8pt,
            stroke: none,
          ),
        )
        let weft-rect = place(
          top + left,
          dx: x - 0.03 * cell,
          dy: y + 0.17 * cell,
          rect(
            width: 1.06 * cell,
            height: 0.66 * cell,
            fill: madder,
            radius: 0.8pt,
            stroke: none,
          ),
        )
        if warp-over {
          weft-rect
          warp-rect
        } else {
          warp-rect
          weft-rect
        }
      }
    }
  })
}

#let warmth(n) = {
  box(
    baseline: 0pt,
    inset: (x: 1pt),
    {
      for i in range(5) {
        if i > 0 { h(1.6pt) }
        box(
          width: 3.4pt,
          height: 3.4pt,
          if i < n {
            rect(width: 100%, height: 100%, fill: weld, stroke: none)
          } else {
            rect(width: 100%, height: 100%, fill: none, stroke: 0.5pt + thread)
          },
        )
      }
    },
  )
}

#let looseglyph() = {
  box(
    width: 18pt,
    height: 5pt,
    baseline: 0pt,
    {
      place(
        left + horizon,
        curve(
          stroke: 0.6pt + madder,
          curve.move((0pt, 2.5pt)),
          curve.cubic((3pt, -1pt), (3pt, 6pt), (6pt, 2.5pt)),
          curve.cubic((9pt, -1pt), (9pt, 6pt), (12pt, 2.5pt)),
          curve.cubic((15pt, -1pt), (15pt, 6pt), (18pt, 2.5pt)),
        ),
      )
    },
  )
}

// ─── THE SELVAGE RAIL ────────────────────────────────────────────────────────

#let selvage-rail() = context {
  let h = page.height
  place(
    top + left,
    dx: 1.05cm,
    dy: -2.0cm,
    rect(width: 0.5cm, height: h, fill: linen, stroke: none),
  )
  for i in range(4) {
    place(
      top + left,
      dx: 1.10cm + i * 0.13cm,
      dy: -2.0cm,
      line(length: h, angle: 90deg, stroke: 0.4pt + thread),
    )
  }
}

// ─── PAGE SETUP ──────────────────────────────────────────────────────────────

#let loom-page-setup(body, paper: "a4", cjk: false, running-title: "") = {
  set page(
    paper: paper,
    margin: (top: 2.0cm, bottom: 2.3cm, left: 2.9cm, right: 3.1cm),
    footer: context {
      set text(font: strand-fonts, size: 9pt, fill: selvage)
      grid(
        columns: (1fr, 1fr),
        align: (left, right),
        lower(running-title),
        [#counter(page).display()],
      )
    },
    background: selvage-rail(),
  )

  set text(
    font: if cjk { (body-fonts, "WenQuanYi Zen Hei") } else { body-fonts },
    size: 11pt,
    fill: inkiron,
  )
  set par(first-line-indent: 0pt, spacing: 0.55em, leading: 0.55em)

  show math.equation: set text(font: math-fonts)

  // link styling
  show link: set text(fill: indigo)

  // booktabs-style tables
  set table(
    stroke: none,
    inset: (x: 6pt, y: 5pt),
  )
  show table: set text(size: 10pt)
  show figure.where(kind: table): set figure.caption(position: top)

  // list styling
  set enum(indent: 0pt, spacing: 0.6em)
  set list(indent: 0pt, spacing: 0.6em, marker: text(fill: inkiron, size: 6pt)[#sym.circle.filled])

  // equation spacing
  show math.equation.where(block: true): it => {
    v(3pt)
    it
    v(3pt)
  }

  body
}

// ─── HEADINGS ────────────────────────────────────────────────────────────────

#let loom-heading-rules(body) = {
  show heading.where(level: 1): it => {
    v(18pt)
    block(width: 100%, {
      place(left + top, dx: -20pt, dy: 1pt, loomtile(indigo))
      {
        set text(
          font: heading-fonts,
          size: 14pt,
          weight: "bold",
          fill: indigo,
          tracking: 0.06em,
        )
        show: upper
        if it.numbering != none {
          text(fill: selvage, counter(heading).display())
          h(0.6em)
        }
        it.body
      }
      v(2pt)
      line(length: 100%, stroke: 1.1pt + madder)
    })
    v(8pt)
  }

  show heading.where(level: 2): it => {
    v(10pt)
    block({
      set text(font: heading-fonts, weight: "bold", fill: madder, size: 12pt)
      if it.numbering != none {
        counter(heading).display()
        h(0.55em)
      }
      it.body
    })
    v(4pt)
  }

  show heading.where(level: 3): it => {
    v(7pt)
    {
      set text(font: strand-fonts, weight: "bold", fill: indigo, size: 11pt)
      it.body
    }
    h(0.6em)
  }

  body
}

// ─── KNOTS (theorem-likes) ───────────────────────────────────────────────────

#let _knot-counter = counter("loom-knot")

// linen-based backgrounds matching LaTeX: warm cream with subtle color tint
#let _knot-bg-indigo = rgb("#F9F5EE")   // linen!60!white
#let _knot-bg-madder = rgb("#F0E3D7")   // madder!6!linen
#let _knot-bg-weld   = rgb("#F0E5CF")   // weld!10!linen

#let knot-box(title: none, note: none, color: indigo, numbered: true, body) = {
  let bg = if color == indigo {
    _knot-bg-indigo
  } else if color == madder {
    _knot-bg-madder
  } else {
    _knot-bg-weld
  }

  v(8pt)
  _knot-counter.step()
  block(
    width: 100%,
    fill: bg,
    inset: (left: 14pt, right: 12pt, top: 9pt, bottom: 9pt),
    stroke: (left: 2.2pt + color),
    breakable: true,
    {
      place(top + left, dx: -21pt, dy: -2pt, loomtile(color))
      {
        set text(font: heading-fonts, weight: "bold", fill: color, size: 11pt)
        [#title]
        if numbered {
          context {
            let sec = counter(heading).get().first()
            let k = _knot-counter.get().first()
            [~#sec.#k]
          }
        }
      }
      if note != none {
        [ ]
        {
          set text(style: "italic", fill: inkiron)
          [(#note).]
        }
      } else {
        [.]
      }
      [ ]
      body
    },
  )
  v(8pt)
}

#let theorem(body, note: none) = knot-box(title: [Theorem], note: note, color: indigo, body)
#let lemma(body, note: none) = knot-box(title: [Lemma], note: note, color: indigo, body)
#let proposition(body, note: none) = knot-box(title: [Proposition], note: note, color: indigo, body)
#let corollary(body, note: none) = knot-box(title: [Corollary], note: note, color: indigo, body)
#let definition(body, note: none) = knot-box(title: [Definition], note: note, color: madder, body)
#let example(body, note: none) = knot-box(title: [Example], note: note, color: weld, body)

#let remark(body, note: none) = {
  v(5pt)
  block({
    {
      set text(style: "italic", fill: madder)
      [Remark]
    }
    if note != none {
      [ ]
      {
        set text(style: "italic", fill: inkiron)
        [(#note)]
      }
    }
    [. ]
    body
  })
  v(5pt)
}

#let proof(body) = {
  v(3pt)
  block({
    text(style: "italic", fill: selvage, font: heading-fonts)[Proof.]
    [ ]
    body
    h(1fr)
    loomtile(inkiron, size: 5pt)
  })
  v(3pt)
}

// ─── THE INTUITION VOICE ─────────────────────────────────────────────────────

#let strand(body) = {
  v(6pt)
  block(
    width: 100%,
    fill: indigo.lighten(97%),
    inset: (left: 11pt, right: 9pt, top: 7pt, bottom: 7pt),
    stroke: (left: 1.6pt + indigo.lighten(45%)),
    breakable: true,
    {
      set text(font: strand-fonts, size: 9.5pt, fill: inkiron.lighten(10%))
      body
    },
  )
  v(6pt)
}

#let whisper(body) = text(font: strand-fonts, size: 10pt, fill: indigo.lighten(22%), body)

#let keyword(body) = text(weight: "bold", fill: madder, body)

// ─── THE SELVAGE EDGE (margin features) ──────────────────────────────────────

#let loose(body) = {
  place(
    right,
    dx: 2.8cm,
    block(width: 2.35cm, {
      set text(font: strand-fonts, size: 7.5pt, fill: selvage)
      looseglyph()
      linebreak()
      v(1pt)
      body
    }),
  )
}

#let recall(question) = {
  place(
    right,
    dx: 2.8cm,
    block(width: 2.35cm, {
      set text(font: strand-fonts, size: 7.5pt, fill: selvage)
      text(weight: "bold", fill: indigo, size: 9pt)[?]
      h(2pt)
      question
    }),
  )
}

#let warp(key) = {
  [#box[] #label("warp-" + key)]
  place(
    right,
    dx: 2.8cm,
    block(width: 2.35cm, {
      set text(font: strand-fonts, size: 7pt, fill: indigo)
      [$arrow.r.squiggly$~#key]
    }),
  )
}

#let pick(key) = {
  link(label("warp-" + key), {
    set text(font: strand-fonts, size: 7pt, fill: indigo)
    [\[~#key~$arrow.l.hook$\]]
  })
}

// ─── PEDAGOGY ────────────────────────────────────────────────────────────────

#let fillin(width: 2.2cm) = {
  h(2pt)
  box(width: width, baseline: -1pt, stroke: (bottom: 0.5pt + inkiron))
  h(2pt)
}

#let TODO(hint) = {
  text(font: strand-fonts, size: 10pt, fill: madder)[\[fill in: #hint\]]
}

#let block-heading(title) = {
  v(5pt)
  {
    set text(font: heading-fonts, weight: "bold", fill: indigo, size: 11pt)
    title
  }
  v(3pt)
}

#let trigger(body) = {
  v(3pt)
  {
    set text(font: heading-fonts, weight: "bold", fill: madder)
    [Trigger.]
  }
  [ ]
  body
  v(3pt)
}

#let yourturn(body) = {
  v(7pt)
  block(
    width: 100%,
    fill: weld.lighten(91%),
    inset: (left: 11pt, right: 10pt, top: 7pt, bottom: 8pt),
    stroke: (left: 2pt + weld),
    breakable: true,
    {
      text(font: heading-fonts, weight: "bold", fill: weld.darken(40%))[Your turn.]
      [ ]
      body
    },
  )
  v(7pt)
}

#let workspace(n: 3) = {
  v(2pt)
  for i in range(n) {
    line(length: 100%, stroke: 0.3pt + thread)
    v(9pt)
  }
}

#let weaveid(id) = {
  h(-19pt)
  loomtile(madder, size: 5pt)
  h(4pt)
  text(size: 7.5pt, fill: selvage, font: heading-fonts)[#id]
  h(0.6em)
}

// ─── TABLES (booktabs style) ─────────────────────────────────────────────────

#let loom-table(headers: (), columns: auto, ..args) = {
  let cells = args.pos()
  let ncols = headers.len()
  let cols = if columns == auto { (auto,) * ncols } else { columns }
  table(
    columns: cols,
    stroke: none,
    inset: (x: 8pt, y: 5pt),
    table.hline(stroke: 1.2pt + inkiron),
    ..headers.map(h => table.cell(text(font: heading-fonts, size: 9pt, fill: selvage, weight: "bold", lower(h)))),
    table.hline(stroke: 0.6pt + thread),
    ..cells,
    table.hline(stroke: 1.2pt + inkiron),
  )
}

// ─── THE COVER ───────────────────────────────────────────────────────────────

#let loomcover(title: "", subtitle: "", author: "", date: "") = {
  page(
    margin: (top: 2cm, bottom: 2cm, left: 2.9cm, right: 3.1cm),
    background: none,
    footer: none,
    {
      v(2.0cm)
      align(center, {
        weaveemblem(size: 132pt)
        v(1.3cm)
        text(
          size: 30pt,
          weight: "bold",
          fill: indigo,
          font: heading-fonts,
          tracking: 0.02em,
          title,
        )
        v(0.55cm)
        line(length: 4.2cm, stroke: 1.1pt + madder)
        v(0.5cm)
        text(font: strand-fonts, size: 13pt, fill: inkiron.lighten(15%), subtitle)
        v(1fr)
        text(font: strand-fonts, fill: inkiron, author)
        v(0.25em)
        text(font: strand-fonts, size: 10pt, fill: selvage, date)
        v(1.1cm)
        {
          set text(font: strand-fonts, size: 8pt, fill: selvage)
          [dyed in #text(fill: indigo)[indigo], #text(fill: madder)[madder] & #text(fill: weld)[weld]; ruled in iron-gall. #h(1em) woven on #text(size: 0.85em, tracking: 0.05em)[LOOM].]
        }
      })
    },
  )
}

// ─── MAIN TEMPLATE ENTRY ─────────────────────────────────────────────────────

// Start the rail without a cover page (equivalent to LaTeX \weave)
#let loom-nocover(
  paper: "a4",
  cjk: false,
  running-title: "",
  body,
) = {
  show: loom-page-setup.with(paper: paper, cjk: cjk, running-title: running-title)
  show: loom-heading-rules

  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    _knot-counter.update(0)
    it
  }

  body
}

// Full template with cover page
#let loom(
  title: "",
  subtitle: "",
  author: "",
  date: "",
  paper: "a4",
  cjk: false,
  running-title: none,
  body,
) = {
  loomcover(title: title, subtitle: subtitle, author: author, date: date)

  let rt = if running-title != none { running-title } else { lower(title) }

  show: loom-page-setup.with(paper: paper, cjk: cjk, running-title: rt)
  show: loom-heading-rules

  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    _knot-counter.update(0)
    it
  }

  body
}
