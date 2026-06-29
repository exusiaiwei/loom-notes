#import "../loom.typ": *

#show: loom.with(
  title: "Edge Case Tests",
  subtitle: "Testing breakable boxes, nested content, CJK",
  author: "Test Suite",
  date: "June 2026",
)

= Breakable Boxes

#definition(note: "a long definition")[
  This definition is intentionally long to test page-breaking behavior.
  A *topological space* is a set $X$ together with a collection $tau$ of subsets
  of $X$ (called open sets) satisfying:
  - The empty set $emptyset$ and $X$ itself are in $tau$.
  - Any union of members of $tau$ is in $tau$.
  - The intersection of any finite number of members of $tau$ is in $tau$.

  The pair $(X, tau)$ is called a topological space. The members of $tau$ are
  called *open sets*. A subset $F subset.eq X$ is *closed* if its complement
  $X backslash F$ is open. A set can be both open and closed (a *clopen* set),
  neither open nor closed, or one but not the other.

  Given a point $x in X$, a *neighbourhood* of $x$ is any set $N$ containing
  an open set $U$ with $x in U subset.eq N$. The collection of all
  neighbourhoods of $x$ is called the *neighbourhood filter* of $x$.
]

#theorem(note: "Heine–Borel")[
  A subset of $RR^n$ is compact if and only if it is closed and bounded.
]

#proof[
  _(Forward direction.)_ Let $K subset.eq RR^n$ be compact. Every compact subset
  of a Hausdorff space is closed. For boundedness: cover $K$ by the open balls
  $B(0, n)$ for $n = 1, 2, 3, ...$. By compactness, finitely many suffice, so
  $K subset.eq B(0, N)$ for some $N$.

  _(Reverse direction.)_ Let $K$ be closed and bounded. Since $K$ is bounded,
  $K subset.eq [-M, M]^n$ for some $M > 0$. By Tychonoff's theorem (or direct
  argument), $[-M, M]^n$ is compact. Since $K$ is a closed subset of a compact
  set, $K$ is compact.

  The key step in the reverse direction uses the fact that $[a,b]$ is compact
  in $RR$ (the Bolzano–Weierstrass theorem), together with the fact that a
  finite product of compact spaces is compact.
]

== Nested Content in Boxes

#example[
  Consider the matrix
  $ A = mat(1, 2; 3, 4) $
  Its eigenvalues satisfy $det(A - lambda I) = 0$:
  $ lambda^2 - 5lambda - 2 = 0 $
  giving $lambda = (5 plus.minus sqrt(33)) / 2$.

  #yourturn[
    Find the eigenvectors for each eigenvalue:
    #workspace(n: 3)
  ]
]

#strand[
  #keyword[Eigenvalues] are the "natural frequencies" of a linear map. Every matrix
  is secretly just stretching along its eigendirections. Once you see that, half of
  linear algebra collapses into one picture.
]

== Lists and Enumerations in Knots

#theorem(note: "fundamental theorem of algebra")[
  Every non-constant polynomial $p(z) in CC[z]$ has at least one root in $CC$.
  Equivalently:
  + $CC$ is algebraically closed.
  + Every polynomial of degree $n$ has exactly $n$ roots (counted with multiplicity).
  + The field $CC$ has no proper algebraic extensions.
]

= Tables and Mixed Content

#warp("table-test")

#block-heading[Comparison table]

#loom-table(
  headers: ("Space", "Complete?", "Separable?", "Compact?"),
  columns: (auto, auto, auto, auto),
  [$RR^n$], [Yes], [Yes], [No],
  [$ell^2$], [Yes], [Yes], [No],
  [$ell^infinity$], [Yes], [No], [No],
  [$C[0,1]$], [Yes], [Yes], [No],
)

#recall[$ell^2$ is the only $ell^p$ that's a Hilbert space. Why?]

#definition[
  A Banach space is a #keyword[complete normed vector space].
  A Hilbert space is a Banach space whose norm comes from an inner product:
  $ norm(x) = sqrt(lr(angle.l x, x angle.r)) $
]

#loose[Does every separable Banach space embed isometrically into $C[0,1]$? (Banach–Mazur)]

#remark(note: "parallelogram law")[
  A norm comes from an inner product iff it satisfies
  $||x+y||^2 + ||x-y||^2 = 2(||x||^2 + ||y||^2)$ for all $x, y$.
  This is why $ell^p$ for $p != 2$ is not a Hilbert space.
]

#warmth(3) #whisper[I can state the parallelogram law but would need to look up the proof that it's sufficient.]

== Fill-in Exercises

#yourturn[
  Complete the following:

  The dual space of $ell^p$ is #fillin(width: 2cm) for $1 < p < infinity$.

  The dual of $ell^1$ is #fillin(width: 2cm), but the dual of $ell^infinity$ is
  #fillin(width: 3cm) (strictly larger than $ell^1$).

  #workspace(n: 2)
]
