# Pitfalls — engine-specific traps that will bite

Hard-won from building the example notebooks. Each one cost a compile cycle.

---

## Typst (`loom.typ`)

### Compile command
- `typst compile --root .. main.typ` — the `--root` flag is required so the import
  `#import "../loom.typ": *` resolves from the repo root.
- Typst compiles in one pass; no need to run twice.

### Math syntax
- **`sqrt` with angle brackets needs `lr()`.** `sqrt(angle.l x, x angle.r)` parses as
  two arguments to `sqrt`. Write `sqrt(lr(angle.l x, x angle.r))`.
- **Subscript/superscript grouping.** `x^a+b` means `(x^a)+b`; write `x^(a+b)` for
  the whole expression as the exponent.
- **`bb()` for blackboard bold.** Write `$bb(R)$` not `$\mathbb{R}$`. Define shorthands:
  `#let RR = $bb(R)$`.

### Layout
- **`#fillin()` blanks on one display line can overflow.** Stack them in a grid or
  use separate math lines instead of one long row.
- **Long `#warp("key")` tags clip in the narrow margin.** Keep keys short.
- **Margin notes can overlap.** `#loose[]`, `#recall[]`, and `#warp()` use
  `place(right + top, …)` and do not auto-stack. Don't place a `#loose` right after
  a `#yourturn` whose last element is a `#recall` — they overprint. Separate them
  with some prose.
- **Font availability.** Typst does not bundle fonts. Libertinus Serif, Liberation Sans,
  and DejaVu Sans must be installed on the system. Check with `typst fonts | grep -i libertinus`.
  If missing, install from your distro's package manager or download from the font project.
- **`context` and `set` rules don't mix.** Typst's `set` rules cannot appear inside
  a `context` block. This is why `loom-page-setup` and `loomcover` take an explicit
  `pal` parameter instead of reading from state.
- **Counter step placement.** `counter.step()` inside a `context` block won't be
  visible to `counter.get()` in the same block. The template handles this, but if
  extending knot-box, keep `step()` outside and `get()` inside `context`.
- **Small caps fallback.** DejaVu Sans lacks small-caps glyphs. The template simulates
  them with slightly reduced tracking+size. Don't rely on `smallcaps[]` rendering
  correctly in headings unless the font supports it.

### Style
- Go light on em-dashes in prose; prefer commas/colons.

### Verify before declaring done
Open the compiled PDF and scan for overflow, font substitution warnings, and layout issues.
Typst prints warnings to stderr — check with `typst compile --root .. main.typ 2>&1 | head`.

---

## XeLaTeX (`loom.cls`)

### Engine & fonts
- **Must use XeLaTeX** (`xelatex` / `latexmk -xelatex`), never pdflatex — the class loads
  `fontspec` and macOS system fonts (Optima, Avenir Next). LaTeX Workshop in VS Code
  defaults to pdflatex; the repo's `.vscode/settings.json` overrides it to XeLaTeX.
- **Run twice** (or use latexmk): the selvage rail uses `remember picture`, and the TOC
  + `\ref`s resolve on the second pass.
- Non-macOS: swap the three `\newfontfamily` lines in `loom.cls` for any display sans;
  Libertinus (body + math) is bundled with TeX Live and stays.

### unicode-math gotchas (these throw `Missing { inserted` / `\__um_group_begin:`)
- **`\mathbb` in a subscript needs braces.** `\PP^1_\R` fails; write `\PP^1_{\R}`.
  Define shorthands braced too: `\newcommand{\R}{\mathbb{R}}` (not `\mathbb R`).
- **`\widehat` over a `\mathbb` macro needs braces.** `\widehat\E` fails (where `\E=\mathbb E`);
  write `\widehat{\E}`.
- **Do not load `amssymb`** — unicode-math already supplies those glyphs; loading it throws
  `Command \eth already defined`. (The class deliberately loads only `amsmath,mathtools`.)

### Layout
- **Several `\fillin` blanks on one display line overflow.** Stack them in a 2×2
  `\begin{aligned}…\end{aligned}` instead of one long row.
- **A wide non-wrapping table column overflows.** Use the provided `L` (wrapping `X`) column
  for the last/long column; wrap its header as `\multicolumn{1}{l}{…}` to fix baseline.
- **Long `\warp{key}` tags clip in the narrow margin.** Keep keys short; the tag is
  `\raggedright` so multi-word keys wrap, but a single long word can still overrun.
- **Margin notes don't auto-avoid each other.** `\loose`, `\recall`, and `\warp` use `marginnote`
  (which works inside boxes, unlike `\marginpar`) but it does *not* stack to avoid overlap. So do
  NOT place a `\loose` right after a `yourturn` whose last element is a `\recall` — the two collide
  and overprint. Make the section-closing thread an inline `strand` instead, or separate them.
- **Optima lacks some glyphs** (e.g. `→`). In a `\block`/heading use math mode `$\to$`,
  not a literal arrow, or it tofus.

### Style
- Go light on em-dashes (`---`) in prose; prefer commas/colons. When bulk-replacing in
  Chinese files, use a tool that handles UTF-8 (`perl -CSD` *double-encodes* an ASCII-typed
  Chinese replacement → mojibake; use `\x{FF0C}` escapes or Python with `encoding='utf-8'`).

### Verify before declaring done
Rasterize a page and actually look at it:
```bash
gs -dQUIET -dBATCH -dNOPAUSE -sDEVICE=png16m -r130 -dFirstPage=2 -dLastPage=2 -o p2.png main.pdf
```
Scan the log for real problems: `grep -cE 'Overfull \\hbox \([0-9]{2,}\.' main.log`,
`grep -c undefined main.log`, `grep -c 'Font shape .*undefined' main.log` — aim for 0.
