// loom.typ -- a WOVEN notebook template for Typst
// ============================================================================
//  Concept:  A page is cloth on a loom.  You don't just typeset the maths,
//            you typeset the WEAVE of your own understanding.
//
//  Palette:  customisable via theme presets or per-colour overrides.
//  Author:   北极甜虾 (Polaris), 2026.   MIT-licensed.
// ============================================================================

// ─── THE DYE-POT ─────────────────────────────────────────────────────────────
// Seven role-based colours: body, three accents, fill, hairline, muted.
// Classic names (indigo, madder, weld …) are kept as dictionary keys.

#let _classic = (
  inkiron: rgb("#211C17"),
  indigo:  rgb("#27406B"),
  madder:  rgb("#9C2B2E"),
  weld:    rgb("#BE8A20"),
  linen:   rgb("#F5EFE2"),
  thread:  rgb("#C7BBA1"),
  selvage: rgb("#8A7F6B"),
  names:   ("indigo", "madder", "weld"),
  tagline: "ruled in iron-gall.",
)

#let _sead = (
  inkiron: rgb("#0c1820"),
  indigo:  rgb("#2a6e6e"),
  madder:  rgb("#b89838"),
  weld:    rgb("#708050"),
  linen:   rgb("#F2F0E6"),
  thread:  rgb("#A8A090"),
  selvage: rgb("#4A6860"),
  names:   ("竹", "蜂", "云"),
  tagline: "from the 青竹蜂云 palette.",
)

#let themes = (classic: _classic, sead: _sead)

// Module-level exports (classic defaults, for backward compat)
#let inkiron = _classic.inkiron
#let indigo  = _classic.indigo
#let madder  = _classic.madder
#let weld    = _classic.weld
#let linen   = _classic.linen
#let thread  = _classic.thread
#let selvage = _classic.selvage

// Active palette (set once by loom() or loom-nocover())
#let _pal = state("loom-palette", _classic)

#let _resolve(theme: "classic", palette: none) = {
  let base = themes.at(theme, default: _classic)
  if palette != none { base + palette } else { base }
}

// ─── FONT STACKS ────────────────────────────────────────────────────────────

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

#let weaveemblem(size: 132pt) = context {
  let p = _pal.get()
  let cells = 8
  let cell = size / cells
  let colors = (p.indigo, p.indigo, p.weld)
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
            fill: p.madder,
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

#let warmth(n) = context {
  let p = _pal.get()
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
            rect(width: 100%, height: 100%, fill: p.weld, stroke: none)
          } else {
            rect(width: 100%, height: 100%, fill: none, stroke: 0.5pt + p.thread)
          },
        )
      }
    },
  )
}

#let looseglyph() = context {
  let p = _pal.get()
  box(
    width: 18pt,
    height: 5pt,
    baseline: 0pt,
    {
      place(
        left + horizon,
        curve(
          stroke: 0.6pt + p.madder,
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

#let selvage-rail(pal) = context {
  let h = page.height
  place(
    top + left,
    dx: 1.05cm,
    dy: -2.0cm,
    rect(width: 0.5cm, height: h, fill: pal.linen, stroke: none),
  )
  for i in range(4) {
    place(
      top + left,
      dx: 1.10cm + i * 0.13cm,
      dy: -2.0cm,
      line(length: h, angle: 90deg, stroke: 0.4pt + pal.thread),
    )
  }
}

// ─── PAGE SETUP ──────────────────────────────────────────────────────────────

#let loom-page-setup(body, paper: "a4", cjk: false, running-title: "", pal: _classic) = {
  set page(
    paper: paper,
    margin: (top: 2.0cm, bottom: 2.3cm, left: 2.9cm, right: 3.1cm),
    footer: context {
      set text(font: strand-fonts, size: 9pt, fill: pal.selvage)
      grid(
        columns: (1fr, 1fr),
        align: (left, right),
        lower(running-title),
        [#counter(page).display()],
      )
    },
    background: selvage-rail(pal),
  )

  set text(
    font: if cjk { (body-fonts, "WenQuanYi Zen Hei") } else { body-fonts },
    size: 11pt,
    fill: pal.inkiron,
  )
  set par(first-line-indent: 0pt, spacing: 0.55em, leading: 0.55em)

  show math.equation: set text(font: math-fonts)

  show link: set text(fill: pal.indigo)

  set table(
    stroke: none,
    inset: (x: 6pt, y: 5pt),
  )
  show table: set text(size: 10pt)
  show figure.where(kind: table): set figure.caption(position: top)

  set enum(indent: 0pt, spacing: 0.6em)
  set list(indent: 0pt, spacing: 0.6em, marker: text(fill: pal.inkiron, size: 6pt)[#sym.circle.filled])

  show math.equation.where(block: true): it => {
    v(3pt)
    it
    v(3pt)
  }

  body
}

// ─── HEADINGS ────────────────────────────────────────────────────────────────

#let loom-heading-rules(body) = {
  show heading.where(level: 1): it => context {
    let p = _pal.get()
    v(18pt)
    block(width: 100%, {
      place(left + top, dx: -20pt, dy: 1pt, loomtile(p.indigo))
      {
        set text(
          font: heading-fonts,
          size: 14pt,
          weight: "bold",
          fill: p.indigo,
          tracking: 0.06em,
        )
        show: upper
        if it.numbering != none {
          text(fill: p.selvage, counter(heading).display())
          h(0.6em)
        }
        it.body
      }
      v(2pt)
      line(length: 100%, stroke: 1.1pt + p.madder)
    })
    v(8pt)
  }

  show heading.where(level: 2): it => context {
    let p = _pal.get()
    v(10pt)
    block({
      set text(font: heading-fonts, weight: "bold", fill: p.madder, size: 12pt)
      if it.numbering != none {
        counter(heading).display()
        h(0.55em)
      }
      it.body
    })
    v(4pt)
  }

  show heading.where(level: 3): it => context {
    let p = _pal.get()
    v(7pt)
    {
      set text(font: strand-fonts, weight: "bold", fill: p.indigo, size: 11pt)
      it.body
    }
    h(0.6em)
  }

  body
}

// ─── KNOTS (theorem-likes) ───────────────────────────────────────────────────

#let _knot-counter = counter("loom-knot")

#let _knot-bg(p, role) = {
  if role == "indigo" {
    color.mix((p.linen, 60%), (white, 40%))
  } else if role == "madder" {
    color.mix((p.madder, 6%), (p.linen, 94%))
  } else {
    color.mix((p.weld, 10%), (p.linen, 90%))
  }
}

#let knot-box(title: none, note: none, role: "indigo", numbered: true, body) = {
  v(8pt)
  _knot-counter.step()
  context {
    let p = _pal.get()
    let accent = if role == "indigo" { p.indigo } else if role == "madder" { p.madder } else { p.weld }
    let bg = _knot-bg(p, role)

    block(
      width: 100%,
      fill: bg,
      inset: (left: 14pt, right: 12pt, top: 9pt, bottom: 9pt),
      stroke: (left: 2.2pt + accent),
      breakable: true,
      {
        place(top + left, dx: -21pt, dy: -2pt, loomtile(accent))
        {
          set text(font: heading-fonts, weight: "bold", fill: accent, size: 11pt)
          [#title]
          if numbered {
            {
              let sec = counter(heading).get().first()
              let k = _knot-counter.get().first()
              [~#sec.#k]
            }
          }
        }
      if note != none {
        [ ]
        {
          set text(style: "italic", fill: p.inkiron)
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
}

#let theorem(body, note: none) = knot-box(title: [Theorem], note: note, role: "indigo", body)
#let lemma(body, note: none) = knot-box(title: [Lemma], note: note, role: "indigo", body)
#let proposition(body, note: none) = knot-box(title: [Proposition], note: note, role: "indigo", body)
#let corollary(body, note: none) = knot-box(title: [Corollary], note: note, role: "indigo", body)
#let definition(body, note: none) = knot-box(title: [Definition], note: note, role: "madder", body)
#let example(body, note: none) = knot-box(title: [Example], note: note, role: "weld", body)

#let remark(body, note: none) = context {
  let p = _pal.get()
  v(5pt)
  block({
    {
      set text(style: "italic", fill: p.madder)
      [Remark]
    }
    if note != none {
      [ ]
      {
        set text(style: "italic", fill: p.inkiron)
        [(#note)]
      }
    }
    [. ]
    body
  })
  v(5pt)
}

#let proof(body) = context {
  let p = _pal.get()
  v(3pt)
  block({
    text(style: "italic", fill: p.selvage, font: heading-fonts)[Proof.]
    [ ]
    body
    h(1fr)
    loomtile(p.inkiron, size: 5pt)
  })
  v(3pt)
}

// ─── THE INTUITION VOICE ─────────────────────────────────────────────────────

#let strand(body) = context {
  let p = _pal.get()
  v(6pt)
  block(
    width: 100%,
    fill: p.indigo.lighten(97%),
    inset: (left: 11pt, right: 9pt, top: 7pt, bottom: 7pt),
    stroke: (left: 1.6pt + p.indigo.lighten(45%)),
    breakable: true,
    {
      set text(font: strand-fonts, size: 9.5pt, fill: p.inkiron.lighten(10%))
      body
    },
  )
  v(6pt)
}

#let whisper(body) = context {
  let p = _pal.get()
  text(font: strand-fonts, size: 10pt, fill: p.indigo.lighten(22%), body)
}

#let keyword(body) = context {
  let p = _pal.get()
  text(weight: "bold", fill: p.madder, body)
}

// ─── THE SELVAGE EDGE (margin features) ──────────────────────────────────────

#let loose(body) = context {
  let p = _pal.get()
  place(
    right,
    dx: 2.8cm,
    block(width: 2.35cm, {
      set text(font: strand-fonts, size: 7.5pt, fill: p.selvage)
      looseglyph()
      linebreak()
      v(1pt)
      body
    }),
  )
}

#let recall(question) = context {
  let p = _pal.get()
  place(
    right,
    dx: 2.8cm,
    block(width: 2.35cm, {
      set text(font: strand-fonts, size: 7.5pt, fill: p.selvage)
      text(weight: "bold", fill: p.indigo, size: 9pt)[?]
      h(2pt)
      question
    }),
  )
}

#let warp(key) = context {
  let p = _pal.get()
  [#box[] #label("warp-" + key)]
  place(
    right,
    dx: 2.8cm,
    block(width: 2.35cm, {
      set text(font: strand-fonts, size: 7pt, fill: p.indigo)
      [$arrow.r.squiggly$~#key]
    }),
  )
}

#let pick(key) = context {
  let p = _pal.get()
  link(label("warp-" + key), {
    set text(font: strand-fonts, size: 7pt, fill: p.indigo)
    [\[~#key~$arrow.l.hook$\]]
  })
}

// ─── PEDAGOGY ────────────────────────────────────────────────────────────────

#let fillin(width: 2.2cm) = context {
  let p = _pal.get()
  h(2pt)
  box(width: width, baseline: -1pt, stroke: (bottom: 0.5pt + p.inkiron))
  h(2pt)
}

#let TODO(hint) = context {
  let p = _pal.get()
  text(font: strand-fonts, size: 10pt, fill: p.madder)[\[fill in: #hint\]]
}

#let block-heading(title) = context {
  let p = _pal.get()
  v(5pt)
  {
    set text(font: heading-fonts, weight: "bold", fill: p.indigo, size: 11pt)
    title
  }
  v(3pt)
}

#let trigger(body) = context {
  let p = _pal.get()
  v(3pt)
  {
    set text(font: heading-fonts, weight: "bold", fill: p.madder)
    [Trigger.]
  }
  [ ]
  body
  v(3pt)
}

#let yourturn(body) = context {
  let p = _pal.get()
  v(7pt)
  block(
    width: 100%,
    fill: p.weld.lighten(91%),
    inset: (left: 11pt, right: 10pt, top: 7pt, bottom: 8pt),
    stroke: (left: 2pt + p.weld),
    breakable: true,
    {
      text(font: heading-fonts, weight: "bold", fill: p.weld.darken(40%))[Your turn.]
      [ ]
      body
    },
  )
  v(7pt)
}

#let workspace(n: 3) = context {
  let p = _pal.get()
  v(2pt)
  for i in range(n) {
    line(length: 100%, stroke: 0.3pt + p.thread)
    v(9pt)
  }
}

#let weaveid(id) = context {
  let p = _pal.get()
  h(-19pt)
  loomtile(p.madder, size: 5pt)
  h(4pt)
  text(size: 7.5pt, fill: p.selvage, font: heading-fonts)[#id]
  h(0.6em)
}

// ─── TABLES (booktabs style) ─────────────────────────────────────────────────

#let loom-table(headers: (), columns: auto, ..args) = context {
  let p = _pal.get()
  let cells = args.pos()
  let ncols = headers.len()
  let cols = if columns == auto { (auto,) * ncols } else { columns }
  table(
    columns: cols,
    stroke: none,
    inset: (x: 8pt, y: 5pt),
    table.hline(stroke: 1.2pt + p.inkiron),
    ..headers.map(h => table.cell(text(font: heading-fonts, size: 9pt, fill: p.selvage, weight: "bold", lower(h)))),
    table.hline(stroke: 0.6pt + p.thread),
    ..cells,
    table.hline(stroke: 1.2pt + p.inkiron),
  )
}

// ─── THE COVER ───────────────────────────────────────────────────────────────

#let loomcover(title: "", subtitle: "", author: "", date: "", pal: _classic) = {
  page(
    margin: (top: 2cm, bottom: 2cm, left: 2.9cm, right: 3.1cm),
    background: none,
    footer: none,
    {
      // set palette state on the cover page so weaveemblem reads it
      _pal.update(pal)
      v(2.0cm)
      align(center, {
        weaveemblem(size: 132pt)
        v(1.3cm)
        text(
          size: 30pt,
          weight: "bold",
          fill: pal.indigo,
          font: heading-fonts,
          tracking: 0.02em,
          title,
        )
        v(0.55cm)
        line(length: 4.2cm, stroke: 1.1pt + pal.madder)
        v(0.5cm)
        text(font: strand-fonts, size: 13pt, fill: pal.inkiron.lighten(15%), subtitle)
        v(1fr)
        text(font: strand-fonts, fill: pal.inkiron, author)
        v(0.25em)
        text(font: strand-fonts, size: 10pt, fill: pal.selvage, date)
        v(1.1cm)
        {
          let n = pal.at("names", default: ("indigo", "madder", "weld"))
          let tl = pal.at("tagline", default: "ruled in iron-gall.")
          set text(font: strand-fonts, size: 8pt, fill: pal.selvage)
          [dyed in #text(fill: pal.indigo)[#n.at(0)], #text(fill: pal.madder)[#n.at(1)] & #text(fill: pal.weld)[#n.at(2)]; #tl #h(1em) woven on #text(size: 0.85em, tracking: 0.05em)[LOOM].]
        }
      })
    },
  )
}

// ─── MAIN TEMPLATE ENTRY ─────────────────────────────────────────────────────

#let loom-nocover(
  paper: "a4",
  cjk: false,
  running-title: "",
  theme: "classic",
  palette: none,
  body,
) = {
  let pal = _resolve(theme: theme, palette: palette)
  _pal.update(pal)

  show: loom-page-setup.with(paper: paper, cjk: cjk, running-title: running-title, pal: pal)
  show: loom-heading-rules

  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    _knot-counter.update(0)
    it
  }

  body
}

#let loom(
  title: "",
  subtitle: "",
  author: "",
  date: "",
  paper: "a4",
  cjk: false,
  running-title: none,
  theme: "classic",
  palette: none,
  body,
) = {
  let pal = _resolve(theme: theme, palette: palette)

  loomcover(title: title, subtitle: subtitle, author: author, date: date, pal: pal)

  let rt = if running-title != none { running-title } else { lower(title) }

  _pal.update(pal)

  show: loom-page-setup.with(paper: paper, cjk: cjk, running-title: rt, pal: pal)
  show: loom-heading-rules

  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    _knot-counter.update(0)
    it
  }

  body
}
