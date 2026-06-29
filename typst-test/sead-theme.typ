#import "../loom.typ": *

#show: loom.with(
  title: "Concentration of Measure",
  subtitle: "Notes on tail bounds and the Chernoff engine",
  author: "北极甜虾 (Polaris)",
  date: "June 2026",
  theme: "sead",
)

= The Cramér–Chernoff Engine

#warmth(0) #whisper[The trunk. Every later engine works on one step of this pipeline.]

#strand[
  In one line: to bound the probability that a random quantity strays far from
  its mean by something #keyword[exponentially small], exponentiate the tail
  through the Laplace transform, and pick a good $lambda$ to push the right-hand
  side down. The whole subject is variations on this single move.
]

#block-heading[The paradigm]

#trigger[You want an exponentially small bound on $Pr[X >= a]$, with the MGF under control.]

For every $lambda > 0$,
$ Pr[X >= a] = Pr[e^(lambda X) >= e^(lambda a)] <= EE[e^(lambda X)] e^(-lambda a) $

#block-heading[Cheat-sheet: the three opening moves]

#loom-table(
  headers: ("Tool", "Setting", "Tail bound / when to use"),
  columns: (auto, auto, 1fr),
  [Markov], [$Y >= 0$], [Opening move, first-order info only],
  [Chebyshev], [Var $X < infinity$], [Second-order info],
  [Chernoff], [MGF exists], [Want an exponential tail],
)

#block-heading[Main results]

#warp("chernoff")

#definition(note: "Chernoff master bound")[
  If the MGF of $X$ is finite near $0$, then $Pr[X >= a] <= e^(-psi_X^*(a))$,
  where $psi_X^*(a) = sup_(lambda > 0) (lambda a - psi_X (lambda))$ is the
  #keyword[Legendre transform] (rate function).
]

#theorem(note: "Hoeffding")[
  Let $X_1, ..., X_n$ be independent with $X_i in [a_i, b_i]$. Then
  $ Pr[overline(X) - EE overline(X) >= t] <= exp(- (2 n^2 t^2) / (sum_(i=1)^n (b_i - a_i)^2)) $
]

#proof[
  Apply Chernoff with the bounded-differences lemma. #TODO[fill in the details]
]

#recall[Why does bounding the MGF give an _exponential_ tail?]

#example[
  For $n$ fair coins, $overline(X) = 1/2$. Hoeffding with $a_i=0, b_i=1$ gives
  $ Pr[overline(X) - 1/2 >= t] <= e^(-2n t^2) $
  At $t = 0.1$ with $n = 100$: probability $<= e^(-4) approx 0.018$.
]

#yourturn[
  A survey of $n = 400$ voters. The true proportion is $p = 0.6$. Use Hoeffding
  to bound $Pr[hat(p) - p >= 0.05]$.

  #workspace(n: 3)
]

#remark(note: "sub-Gaussian")[
  The Hoeffding bound shows that bounded random variables are
  #keyword[sub-Gaussian]: their tails decay at least as fast as a Gaussian's.
  This is the key abstraction underlying most of concentration theory.
]

#loose[Does the sub-Gaussian constant $(b-a)/2$ match the variance proxy?]

== Beyond Hoeffding

#lemma(note: "McDiarmid")[
  If $f(x_1, ..., x_n)$ satisfies $|f - f'| <= c_i$ when only $x_i$ changes,
  then $f$ concentrates around $EE f$ with Hoeffding-type tails.
]

#corollary[
  Any Lipschitz function of independent bounded variables concentrates.
  #pick("chernoff")
]
