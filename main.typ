#import "@preview/tablex:0.0.7": tablex, rowspanx, colspanx, hlinex
#import "@preview/polylux:0.3.1": *

#import "tfachmann-theme.typ": *
#import "utils.typ": *

// rgb("#FF5D05"), 
#let c_warning = rgb("#EF4444");
#let c_primary = rgb("#E65100");
#let c_secondary = rgb("#0078b8");
#let c_background = rgb("#212121");
#let c_background_light = rgb("A2AABC")
#let c_white = rgb("#CFD8DC");

#set page(paper: "presentation-16-9")
#set line(stroke: 1pt + c_primary)

#let Mat(v) = $bold(#v)$
#let Vec(v) = $bold(#v)$
#let Rot = $Mat(R)$
#let Identity = $Mat(I)$
#let SO(n) = $italic("SO")(#n)$

#enable-handout-mode(true)

// #set mat(delim="[")

#show raw: it => block(
  fill: rgb("#2b303b"),
  inset: 1em,
  radius: 0.8em,
  text(fill: c_background_light, it)
)

#show heading: set text(c_primary)

#show: simple-theme.with(
  // background: c_background,
  // foreground: c_white,
  background: white,
  foreground: c_background,
  footer: [Unveiling the Dark Arts of Rotations],
)

#title-slide[
  = #text(c_background, "Unveiling the Dark Arts of Rotations")
  And why you should care#footnote[Inspired and based on Geist: "Learning with 3D Rotations, a Hitchiker's Guide to SO(3)" @geistLearning3DRotations2024]

  #line(length: 100%)
  Timo Bachmann\

  #place(
    top + right,
    text(size: 20pt, [May 1st 2024])
  )
]

#centered-slide[
  = What is a Rotation?
]

#let cred(body) = text(fill: rgb("#E53935"), body)
#set math.mat(delim: "[", gap: 10pt, column-gap: 15pt)

#slide[
  = What is a Rotation? -- Examples

  #set text(20pt)
  #stack(dir: ltr, spacing: 2em,
    bordered_box(title: emoji.checkmark.heavy, color: c_background, lighten: 90%, [
      $ mat(1, 0, 0; 0, 1, 0; 0, 0, 1) $
      Identity Matrix
    ]),
    bordered_box(title: emoji.checkmark.heavy, color: c_background, lighten: 90%, [
      $ mat(#h(0.8em)0.707, 0.707, 0; -0.707, 0.707, 0; 0, 0, 1) $
      $45 degree$ rotation around $z$
    ]),
    bordered_box(title: emoji.crossmark, color: c_background, lighten: 90%, [
      $ mat(#cred("0"), 0, 0; 0, 1, 0; 0, 0, 1) $
      $ #cred([Projects $x$ to zero])$
    ]),
  )
  #stack(dir: ltr, spacing: 1em,
    bordered_box(title: emoji.checkmark.heavy, color: c_background, lighten: 90%, [
      $ mat(delim: "[", #h(0.8em)0.707, 0, 0.707; 0, 1, 0; -0.707, 0, 0.707) $
      $45 degree$ rotation around $y$
    ]),
    bordered_box(title: emoji.crossmark, color: c_background, lighten: 90%, [
      $ mat(delim: "[", 2, 0, 0; 0, 2, 0; 0, 0, 2) $
      #cred("Scales each dim by 2")
    ]),
    bordered_box(title: emoji.excl.quest, color: c_background, lighten: 90%, [
      $ mat(delim: "[",-0.751, -0.306, -0.584; #h(0.8em)0.213, #h(0.8em)0.726, -0.654; #h(0.8em)0.624, #h(0.8em)0.616, -0.480) $
      Can't interpret this easily...
    ]),
  )
]

#slide[
  = What is a Rotation? -- Recap on Groups

  #v(1em)

  A group is a set G with an operation $circle.small: G times G -> G$ such that

  1. closed:  #h(12pt) $g_1 circle.small g_2 in G$ #h(268pt) $forall g_1, g_2 in G$
  2. assoc.:  #h(12pt) $(g_1 circle.small g_2) circle.small g_3 = g_1 circle.small (g_2 circle.small g_3)$ #h(85pt) $forall g_1, g_2, g_3 in G$
  3. neutral: #h(5pt) $exists e in G: e space circle.small space g = g space circle.small space e = g$ #h(138pt) $forall g in G$
  4. inverse: #h(5pt) $exists g^(-1) in G: g space circle.small space g^(-1) = g^(-1) space circle.small space g = e$ #h(60pt) $forall g in G$

  #bordered_box(title:  text(size: 20pt, "General Linear Group"), color: c_background, lighten: 90%, [
    $italic("GL")(n) = { Rot in RR^(n times n): det(Rot) != 0 }$
  ])

  #place(top + right, [@murrayMathematicalIntroductionRobotic2017])
]

#slide[
  = What is a Rotation? -- Determinants I

  #v(1em)

  #bordered_box(title: text(size: 24pt, [Determinant]), color: c_background, lighten: 90%, [
    $n$-dimensional _volume_ scaling factor
  ])


  #box(width: 100%, height: 2em, [#place(left, $ det(mat(1, 0; 0, 1)) = 1 $) $space$  #place(left, dx: 30%, [identity should not change the volume])])
  #box(width: 100%, height: 2em, [#place(left, $ det(mat(2, 0; 0, 1)) = 2 $) $space$  #place(left, dx: 30%, [Scale $x$ dimension by 2])])
  #box(width: 100%, [#place(left, $ det(mat(2, 0; 0, 2)) = 4 $) $space$  #place(left, dx: 30%, [Scale $x$ and $y$ dimension by 2])])
]

#slide[
  = What is a Rotation? -- Determinants II
 
  #v(1em)

  #bordered_box(title: text(size: 24pt, [Determinant]), color: c_background, lighten: 90%, [
    $n$-dimensional _volume_ scaling factor
  ])

  #set text(size: 22pt)

  What does it mean, if $det(Mat(A)) = 0$ ? #h(1em) => $Mat(A)$ is not invertible! ... Why?

  ... volume scaling factor becomes 0 \ 
  #h(1em) => After applying $Mat(A)$, the volume becomes 0 \

  Think of _squishing_ something 3 dimensional to a plane \
  One dimension is lost, it is impossible to invert this action.

  Other example: $det(Mat(J)) = 0 => $ singular configuration
]

#slide[
  = What is a Rotation? -- Definition

  #set text(size: 22pt)

  #v(1.8em)

  #bordered_box(title: text(size: 20pt, "Orthogonal Group"), color: c_background, lighten: 90%, [
    $italic("O")(n) &= { Rot in RR^(n times n): Rot Rot^T = Identity}$
  ])
  #place(top + right, dy: 18%, [
  #text(size: 0.9em, [
    $ 
      det(Rot Rot^T) &= det(Identity) = 1 \
      det(Rot Rot^T) &= det(Rot)det(Rot^T) \ &= det(Rot)det(Rot) = (det(Rot))^2) \
    $
  ])])
  #v(-0.8em)$#h(2em) => det(Rot) in {+1, -1}$
  #v(0.7em)
  #bordered_box(title: text(size: 20pt, [#cred("Special") Orthogonal Group]), color: c_background, lighten: 90%, [
    $italic("SO")(n) &= { Rot in RR^(n times n): Rot Rot^T = Identity, det(Rot) = #cred("+")1}$  
  ])

  $ italic("SO")(n) subset italic("O")(n) &subset italic("GL")(n) \
    italic("SE")(n) subset italic("E")(n) subset italic("A")(n) &subset italic("GL")(n + 1) $

  #place(top + right, [@murrayMathematicalIntroductionRobotic2017])
]

#centered-slide[
  = Representing Rotations
]

#slide[
  = Representing Rotations -- Use-cases
 
  #v(1em)

  Limiting ourselves to $R in SO(3)$

  #place(bottom+left, figure(
    image("./figures/so3_sampling.png", width: 30%),
    supplement: "",
    caption: text(size: 22pt, [Uniform sampling of $R$ @kurzDiscretizationUsingRecursive2017]),
  ))

  #place(bottom+right, dy: 0%, figure(
    image("./figures/rotation_plane.png", width: 60%),
    supplement: "",
    caption: [Learning a rotation $R$ @geistLearning3DRotations2024],
  ))
]

#slide[
  = Representing Rotations
 
  #v(1em)

  $ &f: cal(R) -> SO(3) \ f^(-1) = &g: SO(3) -> cal(R)$ 
  #place(top + right, dy: 16%, [Representation Space $cal(R)$])
  #place(top + center, dy: 15%, [$ r &in cal(R) \ Rot &in SO(3) $])

  #set line(stroke: 2pt + black)
  #set text(size: 22pt)
  #align(start, [
  #tablex(
        columns: 5,
        inset: 8pt,
        align: (left + horizon, center, left, center, center),
        auto-vlines: false,
        auto-hlines: false,

        header-rows: 1,

        hlinex(),
        /* --- header --- */
        [*Representation*], [*Dim*], [*Domain*], [$g(Rot)$ *cont.*], [*Double cover*],
        /* -------------- */
        hlinex(stroke: 0.5pt),

        [Euler parameters], [3], [$RR^3$], [no], [yes],
        [Exponential coordinates], [3], [$RR^3$], [no], [yes],
        [Unit-quaternions], [4], [$cal(S)^3$], [no], [yes],
        [Axis-angle], [4], [$RR^3$], [no], [yes],
        [$RR^6$ + Gram-Schmidt Orthon.], [6], [$RR^(3 times 2)$], [yes], [no],
        [$RR^9$ + SVD], [9], [$RR^(3 times 3)$], [yes], [no],
        hlinex(),
      )
  ])

  #place(top + right, [@geistLearning3DRotations2024])
]

#slide[
  = Representing Rotations -- Euler
 
  #v(1em)

  6D pose needs to express rotation with *at least 3 coordinates* \ $r = (alpha, beta, gamma)$

  $
  Rot(alpha, beta, gamma) = Rot_3(gamma) Rot_2(beta) Rot_1(alpha)
  $ where $alpha, beta, gamma in [-pi, pi)$.


  #stack(dir: ttb, spacing: 0.4em,
    stack(dir: ltr, spacing: 1em,
      bordered_box(color: c_secondary, inset: 0.6em, lighten: 80%, [
        Easy interpretation
      ]),
      bordered_box(color: c_warning, inset: 0.6em, lighten: 80%, [
        Discontinous at bounding ranges
      ]),
    ),
    stack(dir: ltr, spacing: 1em,
      bordered_box(color: c_warning, inset: 0.6em, lighten: 80%, [
        Different parameterization $=>$ same rotation (double cover)
      ]),
    ),
  )
]

#slide[
  = Representing Rotations -- Exp
 
  #v(1em)

  Rotation axis $r = Vec(omega) in RR^3$ and length $||Vec(omega)||$ to enconde angle.

  $w$ can be written as skew-symmetric matrix where
  $
   [Vec(omega)]_times = mat(0, -omega_3, omega_2; omega_3, 0, -omega_1; -omega_2, omega_1, 0), "with" Vec(omega) = mat(omega_1; omega_2; omega_3)
  $

  #stack(dir: ltr, spacing: 1em,
    bordered_box(color: c_warning, inset: 0.6em, lighten: 80%, [
      Discontinous at bounding ranges
    ]),
    bordered_box(color: c_warning, inset: 0.6em, lighten: 80%, [
      Double cover
    ]),
  )
]

#slide[
  = Representing Rotations -- Quat
 
  #v(1em)

  Axis-angle: $r := (Vec(limits(omega)^tilde), alpha)$ with $||Vec(limits(omega)^tilde)|| = 1$

  Quaternions $r := q = (w, x, y, z) in cal(S)^3$ with 
  $
  ||q|| = 1, w = cos(alpha / 2) "and" (x, y, z) = sin(alpha / 2) Vec(limits(omega)^tilde)
  $

  #v(1em)

  #stack(dir: ltr, spacing: 1em,
    bordered_box(color: c_warning, inset: 0.6em, lighten: 80%, [
      Double cover as $f(q) = f(-q)$
    ]),
    bordered_box(color: c_background, inset: 0.6em, lighten: 90%, [
      Half-spaces to fix discontinuity  
    ])
  )


]

#slide[
  = Representing Rotations -- $RR^6$ + GSO
 
  #v(0.3em)

  $r = [Vec(v)_1, Vec(v)_2] in RR^(3 times 2)$

  #v(-0.5em)
  $ 
  r &= g(Rot) &&:= "diag"(1, 1, 0)Rot \
  Rot &= f(r) &&:= "GSO"(Vec(v)_1, Vec(v)_2)
  $
  #v(-0.5em)

  #set enum(tight: true, spacing: 20em)
  GSO process using orthonormal properties of $SO(3)$:
  #v(-0.4em)
  #par(first-line-indent: 1em, hanging-indent: 1em, [
    #h(0pt) 1. Normalize $Vec(v)_1$ \
    #h(0pt) 2. $Vec(v)_2^#sym.perp = Vec(v)_2 - $ colinear part of $Vec(v)_1$ \
    #h(0pt) 3. $Vec(v)_3 = [Vec(v_1)]_times Vec(v)_2$
  ])
  #v(-0.3em)
  #stack(dir: ltr, spacing: 1em,
    bordered_box(color: c_secondary, inset: 0.6em, lighten: 90%, [
      $g(Rot)$ is continous
    ]),
    bordered_box(color: c_secondary, inset: 0.6em, lighten: 90%, [
      no double cover
    ])
  )
]

#slide[
  = Representing Rotations -- $RR^9$ + SVD
 
  #v(1em)

  Direct parameterization $r = Mat(M) in RR^(3 times 3)$, with SVD 
  $ Mat(M) = Mat(U) Mat(Sigma) Mat(V)^T $

  where $Mat(U), Mat(V) in RR^(3 times 3)$ and $Mat(Sigma) = text("diag")(sigma_1, sigma_2, sigma_3)$.

  Define mapping as
  $ f(r) := text("SVD")^plus (Mat(M)) = Mat(U) text("diag")(1, 1, det(Mat(U)Mat(V)^T))Mat(V)^T $
  where $det(Mat(U)Mat(V)^T)$ ensures that $det(text("SVD")^plus (Mat(M))) = 1$.

  #place(top + right, [@geistLearning3DRotations2024])
]

#slide[
  = Representing Rotations -- $RR^9$ + SVD
 
  #v(1em)

  #set text(size: 22pt)

  Direct parameterization $r = Mat(M) in RR^(3 times 3)$ \ \
  $f(r) := text("SVD")^plus (Mat(M)) &= Mat(U) text("diag")(1, 1, det(Mat(U)Mat(V)^T))Mat(V)^T \
    &:= limits(arg min)_(R in SO(3)) ||Rot - Mat(M)||_F \
    &:= limits(arg min)_(R in SO(3)) sum^3_(i=1)(||Vec(v)_i - Vec(m)_i||^2)
  $ \
  where $Mat(M) = [Vec(m)_1, Vec(m)_2, Vec(m)_3]$ and $Mat(R) = [Vec(v)_1, Vec(v)_2, Vec(v)_3]$.

  #v(-0.2em)

  #place(top+right, dy: 20%, figure(
    image("./figures/svd_springs.png", width: 30%),
    supplement: "",
    caption: text(size: 22pt, [Springs pull $Mat(M)$ to \ the closest $Rot$ @geistLearning3DRotations2024]),
  ))

  #stack(dir: ltr, spacing: 1em,
  bordered_box(color: c_secondary, inset: 0.6em, lighten: 90%, [
    $f(r)$ is smooth for $det(Mat(M)) != 0$
  ]),
  bordered_box(color: c_secondary, inset: 0.6em, lighten: 90%, [
    $g(Rot)$ continous
  ]),
  bordered_box(color: c_secondary, inset: 0.6em, lighten: 90%, [
    no double cover
  ])
)

  #place(top + right, [@geistLearning3DRotations2024])
]

#centered-slide[
  = Experimental Results + Conclusion
]

#slide[
  = Results
 
  #align(center + horizon, image("./figures/results_point_cloud.png", width: 76%))
  #place(top + right, [@geistLearning3DRotations2024])
]

#slide[
  = Results
  #align(center + horizon, stack(dir: ltr, spacing: 2em,
    image("./figures/results_rot_by_render.png", height: 88%),
    image("./figures/results_render_by_rot.png", height: 88%))
  )
  #place(top + right, [@geistLearning3DRotations2024])
]

#slide[
  = Conclusion + Takeaways

  #v(1em)

  #place(top + right, [@geistLearning3DRotations2024])

  #set text(size: 19pt)

  #bordered_box(title: "Rotation Estimation", color: c_background, width: 100%,  lighten: 90%, [
      $RR^9 + "SVD"$ and $RR^6 + "GSO"$  are superior representations
    #v(-0.4em)
  ])

  #bordered_box(title: "Rotation Estimation (small changes)", color: c_background, width: 100%,  lighten: 90%, [
      Quaternions + half-space map is viable
    #v(-0.4em)
  ])

  #bordered_box(title: "Feature Prediction", color: c_background, width: 100%,  lighten: 90%, [
      $RR^9 + "SVD"$ and $RR^6 + "GSO"$  are superior representations
    #v(-0.4em)
  ])

  #bordered_box(title: "Feature Prediction (memory constraints)", width: 100%,  color: c_background, lighten: 90%, [
      Quaternions + half-space map and data augmentation is viable
    #v(-0.4em)
  ])
    #v(-0.4em)

  Think twice which representation to use, both for input and output!
]

#slide[
  #bibliography("literature.bib")
]

