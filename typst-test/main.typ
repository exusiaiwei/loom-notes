#import "../loom.typ": *

#show: loom.with(
  title: "Entropy & Information",
  subtitle: "Fill-in study notes on Shannon's theory",
  author: "北极甜虾 (Polaris)",
  date: "June 2026",
)

= Information Content

#warp("entropy")

A random variable $X$ with outcomes $x_1, ..., x_n$ and probabilities $p_1, ..., p_n$.

#definition(note: "Shannon, 1948")[
  The *entropy* of $X$ is defined as
  $ H(X) = - sum_(i=1)^n p_i log_2 p_i $
  measured in #keyword[bits].
]

#strand[
  Think of entropy as "average surprise." If you already know the outcome, surprise is zero. If every outcome is equally likely, surprise is maximised.
]

#recall[Why $log_2$ and not $ln$?]

The information content of a single outcome $x_i$ is #fillin(width: 3cm).

#theorem(note: "Maximum entropy")[
  Among all distributions on $n$ outcomes, entropy is maximised by the #fillin(width: 2.5cm) distribution, achieving $H = log_2 n$ bits.
]

#proof[
  Apply Jensen's inequality to the concave function $f(p) = -p log p$.

  #TODO[complete the Jensen argument]
]

== Properties of Entropy

#block-heading[Key identities]

#trigger[When comparing two sources, reach for relative entropy.]

+ $H(X) >= 0$ with equality iff $X$ is deterministic #warmth(5)
+ $H(X) <= log_2 |cal(X)|$ with equality iff $X$ is uniform #warmth(4)
+ $H(X, Y) = H(X) + H(Y|X)$ (chain rule) #warmth(3)

#loose[What's the chain rule for three variables?]

#yourturn[
  Compute $H(X)$ for a biased coin with $p = 1/4$:

  #workspace(n: 4)
]

= Mutual Information

#warp("mi")

#definition[
  The *mutual information* between $X$ and $Y$ is
  $ I(X; Y) = H(X) - H(X|Y) = H(Y) - H(Y|X) $
]

#strand[
  Mutual information measures how much knowing $Y$ tells you about $X$.
  It's symmetric: knowing $X$ tells you the same amount about $Y$.
]

#example[
  Let $X$ be a fair coin and $Y = X$. Then $I(X;Y) = H(X) = 1$ bit.
  The copy gives you everything. #pick("entropy")
]

#lemma(note: "Non-negativity")[
  $I(X;Y) >= 0$ with equality iff $X$ and $Y$ are independent.
]

#remark(note: "Connection to KL divergence")[
  $I(X;Y) = D_"KL" (p_(X,Y) || p_X p_Y)$, which makes non-negativity immediate from Gibbs' inequality.
]

#weaveid("L03")
#corollary[
  Data processing inequality: if $X -> Y -> Z$ forms a Markov chain, then $I(X;Z) <= I(X;Y)$.
]

#proof[
  Expand using chain rule for mutual information. The Markov condition $p(z|x,y) = p(z|y)$ kills the extra term.
]
