# Loom command reference

## Typst (`loom.typ`)

`#import "../loom.typ": *` — import all Loom functions.
`#show: loom.with(title: …, theme: "classic")` — full document with woven cover.
`#show: loom-nocover.with(…)` — same setup, no cover page.

### Cover & structure
- `loom.with(title, subtitle, author, date, …)` — woven title page; turns on the selvage rail.
- `loom-nocover.with(paper, cjk, running-title, theme, palette)` — page setup without a cover.
- `running-title: "text"` — quiet footer label.
- `= Heading` / `== Subheading` / `=== Subsubheading` — knot-numbered headings; the section
  number hangs onto the rail as a woven knot.

### Knots (theorem-likes — auto-numbered, auto-styled boxes)
- `#theorem[]`, `#lemma[]`, `#proposition[]`, `#corollary[]` → **indigo** knot.
- `#definition[]` → **madder** knot.
- `#example[]` → **weld** knot.
- `#remark[]` → unboxed, madder italic head.
- `#proof[]` → ends on a tiny woven tile (not ∎).
- Each takes an optional `note` shown after the head, e.g. `#theorem(note: "Bézout, Thm. 2.16")[…]`.
- `#weaveid("L03")` — an inline knot-ID stamp (for claim-DAG habits).

### The intuition voice
- `#strand[…]` — the informal "what's really going on", on an indigo wash. Read-only layer.
- `#whisper[…]` — a short inline aside in the strand voice.
- `#keyword[…]` — madder bold for a term being introduced.

### Pedagogy (fill-in study notes)
- `#block-heading[…]` — a quiet sub-heading inside a section.
- `#trigger[…]` — a "when you'd reach for this" cue (madder **Trigger.** label).
- `#TODO[hint]` — a gap to fill inside a proof/derivation (madder `[ fill in: hint ]`).
- `#fillin(width: 2.2cm)` — an empty ruled blank to write the answer in.
- `#yourturn[…]` — the weld "Your turn." box: the active-input zone.
- `#workspace(n: 3)` — `n` faint ruled lines to write on (for print; delete if typing).
- `#recall[question]` — a quick active-recall prompt parked in the margin (a `?` glyph).
- `#warmth(0)` … `#warmth(5)` — a five-square weave gauge of how well you grok the block.

### The selvage edge
- `#loose[…]` — an open question / exercise as a dangling-thread margin note.
- `#warp("key")` — declare a recurring object (drops a `↝ key` margin tag + a label).
- `#pick("key")` — pick it up later: a `[ key ↩ ]` chip hyperlinked back to the `#warp`.

### Tables
- `#loom-table(headers: ("A", "B", "C"), columns: (auto, auto, 1fr), [a], [b], [c])` —
  booktabs-style table with indigo headers and linen stripes.

### Themes & palette
- `theme: "classic"` — natural-dye palette (indigo, madder, weld, iron-gall).
- `theme: "sead"` — 青竹蜂云 perceptual colormap palette.
- `palette: (indigo: rgb("#2E5090"))` — override individual colours in any theme.
- Seven palette keys: `inkiron`, `indigo`, `madder`, `weld`, `linen`, `thread`, `selvage`.

---

## LaTeX (`loom.cls`)

`\documentclass[cjk,letter]{loom}` — options: `cjk` (中文: Songti body, 楷体 emphasis),
`letter` (US-letter; default A4). XeLaTeX only.

### Cover & structure
- `\loomcover{title}{subtitle}{author}{date}` — woven title page; turns on the selvage rail.
- `\weave` — start the rail if you skip the cover.
- `\runningthread{text}` — quiet footer label.
- `\section`, `\subsection`, `\subsubsection` — incised Optima headings; the section number
  hangs onto the rail as a woven knot.

### Knots (theorem-likes — amsthm numbering, auto-styled boxes)
- `theorem`, `lemma`, `proposition`, `corollary` → **indigo** knot.
- `definition` → **madder** knot.
- `example` → **weld** knot.
- `remark`, `remark*` → unboxed, madder italic head.
- `proof` → ends on a tiny woven tile (not ∎); `\proofname` is restyled.
- Each takes an optional `[note]` shown after the head, e.g. `\begin{theorem}[Bézout, Thm. 2.16]`.
- `\weaveid{L03}` — an inline knot-ID stamp (for claim-DAG habits).

### The intuition voice
- `strand` env — the informal "what's really going on", on an indigo wash. Read-only layer.
- `\whisper{…}` — a short inline aside in the strand voice.
- `\keyword{…}` — madder bold for a term being introduced.

### Pedagogy (fill-in study notes) — built into the class
- `\block{…}` — a quiet sub-heading inside a section.
- `\trigger{…}` — a "when you'd reach for this" cue (madder **Trigger.** label).
- `\TODO{hint}` — a gap to fill inside a proof/derivation (madder `[ fill in: hint ]`).
- `\fillin[width]` — an empty ruled blank to write the answer in (default 2.2cm).
- `yourturn` env — the weld "Your turn." box: the active-input zone.
- `\workspace[n]` — `n` faint ruled lines to write on (for print; delete if typing).
- `\recall{question}` — a quick active-recall prompt parked in the margin (a `?` glyph).
- `\warmth{0..5}` — a five-square weave gauge of how well you grok the block.

### The selvage edge
- `\loose{…}` — an open question / exercise as a dangling-thread margin note.
- `\warp{key}` — declare a recurring object (drops a `↝ key` margin tag + a label).
- `\pick{key}` — pick it up later: a `[ key ↩ ]` chip hyperlinked back to the `\warp`.

### Tables
- `\newcolumntype{L}` (provided) — a left-aligned **wrapping** `X` column for tabularx.
- Pattern: `\begin{tabularx}{\linewidth}{@{}l l L@{}} … \end{tabularx}` with booktabs rules.
- Header cell over an `L` column: wrap it as `\multicolumn{1}{l}{\color{indigo}…}` so the
  header baseline aligns with the `l` columns.

### Palette (xcolor names you can use)
`inkiron` (body), `indigo` (structure), `madder` (definitions/emphasis), `weld` (examples),
`linen` (soft fills), `thread` (hairlines), `selvage` (margin text). Retune in `loom.cls`.
