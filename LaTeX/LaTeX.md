# MY Cheat Sheet
- $% invisible comment$ - comment (invisible in presentation)
- $\text{visible comment}$ - comment (invisible in presentation)
- $X$ - ascii upper
- $n$ - ascii lower
- $\Zeta$ - greek upper
- $\zeta$ - greek lower
- $Y = Ax + b$ - formula
- $1 + 2 - 3 * 4 /  5 ^ {(6)} \times \div \pm$ - pemdas
- $\bar{X}$ - bar
- $X_{(i + 1)}$ - subscript underscript
- $X^{(i + 1)}$ - superscript upperscript
- $\frac{1 + 1}{n - 1}$ - fraction
- $\sum_{i=1}^n$ - sum small
- $\displaystyle\sum_{i=1}^n$ - sum big
- $\sqrt{4i} \space \sqrt[3]{4i} \space \sqrt[n]{4i}$ - roots
- multiline center aligned
  $$
  \begin{aligned}
  p & = \hbar k \\
  E & = \hbar \omega \\
  \end{aligned}
  $$
- freeform alignment
  $$
  \begin{align*}
  A = 1 \\
  A = &1 \\
  A& = 1 \\
  A& = &1 \\
  &A= 1 \\
  &A &= 1 \\
  &A &= &1 \\
  \end{align*}
  $$
- formula definition alignment
  $$
  \begin{alignat}{5}
  10& x + &3 &y = 2 \\
  3& x + &13 &y = 4 \\
  &A &= &\text{has} \\
  &\neg{B} &= &\text{not has} \\
  &B &= &\text{test positive} \\
  &\neg{B} &= &\text{not test positive}
  \end{alignat}
  $$
- diagram
  $$
  \begin{CD}
  A @>a>> B \\
  @VbVV @AAcA \\
  C @= D
  \end{CD}
  $$
- $A\newline{A}$  - A newline A
- $A\\{A}$  - A newline A (version 2)
- markdown table with latex in there
    | header | header |
    | --- | --- |
    | $\Rho(A\|B)$ | $\text{escapes usually work well in this area}$ |
- array / matrix
  $$
  A_{2\times2} = \left[
    {
      \begin{array}
        {cc}
        a_{11} & a_{12} \\
        a_{21} & a_{22} \\
        a_{31} & a_{32} \\
      \end{array}
    }
  \right]
  $$
- matrix / pmatrix / parenthetical matrix
  $$
  A_{2\times2} =
    {
      \begin{pmatrix}
        a_{11} & a_{12} & a_{13} & a_{14} \\
        a_{21} & a_{22} & a_{23} & a_{24} \\
        a_{31} & a_{32} & a_{33} & a_{34} \\
        a_{41} & a_{42} & a_{43} & a_{44} \\
        a_{51} & a_{52} & a_{53} & a_{54} \\
      \end{pmatrix}
    }
  $$
- $\vdots \cdots \ddots$ - elipses
