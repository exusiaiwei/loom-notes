// ===========================================================================
//  A blank LOOM fill-in notebook.  Copy this folder and start writing.
//  Compile:  typst compile --root .. main.typ
//  Everything below is a live cheat-sheet of what the template gives you.
// ===========================================================================
#import "../loom.typ": *

// math shorthands (per-document):
#let RR = $bb(R)$
#let EE = $bb(E)$

// Theme options: "classic" (natural dyes) or "sead" (青竹蜂云 palette).
// You can also override individual colours:
//   palette: (indigo: rgb("#2E5090"), madder: rgb("#8B2252"))
#show: loom.with(
  title: "Title of the Notebook",
  subtitle: "a one-line subtitle",
  author: "Your Name",
  date: datetime.today().display("[month repr:long] [day], [year]"),
  running-title: "your topic",
  theme: "classic",
)

= First Course

#warmth(0) #whisper[One-line orientation for this section.]

#strand[
  The #keyword[big idea], in your own words, before the machinery. This is the
  _passive_ layer: written to be read.
]

#block-heading[The paradigm]
#trigger[When you'd reach for this.]
A displayed master fact:
$ "your key equation here" $

#block-heading[Cheat-sheet]

#loom-table(
  headers: ("Tool", "Setting", "When to use"),
  columns: (auto, auto, 1fr),
  [A], [a setting], [a wrapping description that flows to the next line if it is long],
  [B], [another], [another note],
)

#block-heading[Results (read the statement, fill the proof)]

#definition(note: "a name")[
  A madder knot. State the object, but leave the key clause blank: closed under
  #fillin(width: 3cm) and #fillin(width: 2cm).
]

#theorem(note: "attribution")[
  An indigo knot. State the result in full.
]
#proof[
  Skeleton: (i) the first move; (ii) the second. #TODO[the step that makes it work]
]

#example[
  A weld knot for a worked instance.
]

#yourturn[
  Restage the example as a computation you do. Show that ...
  #workspace(n: 3)
]

#remark[
  An unboxed aside.
]

#recall[A quick active-recall question, parked in the margin.]
Inline prose continues here. #warmth(2) marks how well you grok this block (0--5).

#loose[An open thread / exercise to pull next time.]
