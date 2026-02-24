# "official" docs or cheatsheets
- reference: [Comprehensive TeX Archive Network](https://ctan.org/) and a [directory](https://tug.ctan.org/) to file browse, check out even [info](https://tug.ctan.org/info/) for bunch of random stuff
- cheat sheets
    - https://katex.org/docs/supported.html
    - [Every friggen symbol](https://tug.ctan.org/info/symbols/comprehensive/symbols-a4.pdf)
    - [symbols in a wiki but its incomplete](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols)
    - [overleaf version](https://assets.ctfassets.net/nrgyaltdicpt/4e825etqMUW8vTF8drfRbw/d4f3d9adcb2980b80818f788e36316b2/A_quick_guide_to_LaTeX__Overleaf_version.pdf)
    - [LaTeX2e: An unofficial reference manual](https://latexref.xyz/Math-symbols.html)
- issues / bugs
    - https://github.com/KaTeX/KaTeX/issues/2003
- guides / courses
    - [lshort--the bible](https://www.ctan.org/tex-archive/info/lshort/) for lots of lanugages which end up hosting [pdfs like this](https://mirror.las.iastate.edu/tex-archive/info/lshort/english/lshort.pdf)
    - [overleaf intro guide, see left hand side](https://www.overleaf.com/learn/latex/Learn_LaTeX_in_30_minutes) but dont pay for it
    - [Interactive Website Guide](https://latexguide.org/book-contents/chapter-09-writing-math-formulas/)
    - [Another interactive guide](https://colinsauze.github.io/introduction-to-latex/07-equations/index.html)
- really cool websites
    - [draw and get a symbol](https://detexify.kirelabs.org/classify.html)


# The Language Infrastructure
- install packages
    - open `MiKTeX Console` in admin mode


# MY Cheat Sheet
- $% invisible comment$ - comment (invisible in presentation)
- $\text{visible comment}$ - comment (invisible in presentation)
- $X$ - ascii upper
- $\mathrm{X} \rm{X}$ - ascii upper in roman style non-italic
- $\rm X y z a b c D$ - remove math styling during this inline, doesnt behave well with blocks
- spaces
    $$
    % \url{https://tex.stackexchange.com/a/74354}{source} \\
    \mathrm{newline} \newline
    \text{also newline} \\
    a~ b \\  % nbsp
    a\, b  \\  % 3/18 of \quad (= 3 mu)
    a\: b  \\  % 4/18 of \quad (= 4 mu)
    a\; b  \\  % 5/18 of \quad (= 5 mu)
    a\! b  \\  % -3/18 of \quad (= -3 mu)
    a\quad b \\  % 18 mu
    a\qquad b \\  % 36 mu
    a\medspace b \\
    a\negmedspace b \\
    a\thickspace b \\
    a\negthickspace b \\
    a\hphantom{15}b \\
    \rm{weird stuff happens with \backslash{rm} }
    hello
    $$
                    wild stuff
      only two spaces comments under the thingy (only happens when tabs are 4 spaces)
        four spaces and you get a small indent like this
                    hello?
- text symbols - $`` <quoted text here> "$
- $n ~ \mathrm{n} ~ \text{n} $ - ascii lower, all 3 styles separated by nbsp non breaking space
- $\newpage$ - page break
- $\appendix$ - appendix
- $\neq, \leq, \geq \equiv \approx \thickapprox \cong \simeq \sim \propto \parallel$ - [comparators](https://www.geeksforgeeks.org/relational-operators-in-latex/) - not equal, less than or equal, greater than or equal, almost equal, ~=, sort of equal, sortof, semi-equal, semi equal
- $\sim$ - tilde
- $\Phi ~ \phi$ - greek
- $e \pi i$ - constants
- $Y = Ax + b$ - formula equation
    $$
    \begin{equation}
    % \label{eu_eqn}  % no support for labels  % https://github.com/KaTeX/KaTeX/issues/2003
    \begin{split}
        A & = \frac{\pi r^2}{2} \\
        & = \frac{1}{2} \pi r^2
    \end{split}
    \end{equation}
    % The beautiful equation \ref{eu_eqn} is known as the Euler equation.  % or \ref  % https://github.com/KaTeX/KaTeX/issues/2003
    $$
- $1 + 2 - 3 * 4 /    5 ^ {(6)} \times 7 \cdot 8 \div \pm \plusmn$ - pemdas plus minus
- $\bar{X} \hat{X}$ - bar    hat
- $X_{(i + 1)}$ - subscript underscript
- $X^{(i + 1)}$ - superscript upperscript
- $\frac{1 + 1}{n - 1}$ - fraction
- $1 \over {2}$ - alternate fraction
- $\sum_{i=1}^n$ - sum small
- $\displaystyle\sum_{i=1}^{n}( \bar{a} + \hat{b}^{i}_{i} )$ - sum big
- $\displaystyle\prod_{i=1}^n \displaystyle\bigwedge_{i=1}^n  \displaystyle\bigcup_{i=1}^n  \displaystyle\bigvee_{i=1}^n  \displaystyle\bigcap_{i=1}^n  \displaystyle\bigoplus_{i=1}^n  \displaystyle\int_{i=1}^n  \displaystyle\oint_{i=1}^n$ - other sums, sum logic, sum conjunction, sum disjunction, sum union, sum disunion, product, etc.
- $\mathbf {p} \text{ vs. } p \mathbf {\text{ doesnt work on text }} \text{text}$ - bold
- displaystyle just means alternate display style
    $$
    a_0+{1\over a_1+
        {1\over a_2+
            {1 \over a_3 +
            {1 \over a_4}}}}
    $$
    > vs
    $$
    a_0+{1\over\displaystyle a_1+
        {1\over\displaystyle a_2+
            {1 \over\displaystyle a_3 +
            {1 \over\displaystyle a_4}}}}
    $$
- $\lim_{x\to\infty} f(x) \displaystyle\lim_{x\to\infty} f(x)$ - limit
- $\iiint^{E}_{V} \mu(u,v,w) \,du\,dv\,dw \qquad \displaystyle\iint^{10}_{13} \frac{\partial{x}}{\partial{y}}$ - integral
- $\sqrt{4i} \space \sqrt[3]{4i} \space \sqrt[n]{4i}$ - roots
- $\log(10) \qquad \log_{10}(10) \qquad \log_{(e+1)}(10) \qquad \ln(e)$ - logs
- $\inf \infty \R \mathbb{R} \mathbb{C} \neg \iff \implies \cong \angle \triangle \overrightarrow{\rm AB} \partial \arccos \arctan \cosh \dots $ - symbols infinity, sets, negate, iff if only if congruence, elipses, dots, vector
- [logic](https://en.wikipedia.org/wiki/List_of_logic_symbols)
    - operators: $\neg \lnot \lor \land \oplus \otimes$
    - sayings: $\exists \nexists \forall \implies \iff \equiv$
    - misc: $\veebar \vee \parallel \bot \top \rightarrow \longrightarrow \Rightarrow  \Longrightarrow \leftarrow \longleftarrow \Leftarrow \Longleftarrow \leftrightarrow \Leftrightarrow \longleftrightarrow \Longleftrightarrow$
    - contradiction: $\Rightarrow\!\Leftarrow$
- [set](???)
    - sets: $\emptyset \mathfrak{P} \wp(A)$ - empty null set, power set
    - operators: $\cup \cap \overline{A} A^\prime A^\complement \wp \subset \subseteq \supset \rm A \subseteq B$ - union, intersection, proper subset, subset, superset, use rm to make bold face
    - sayings / isms: $\in \notin$
- overs:
    $$
    \overline{ABC} \\
    \overrightarrow{ABC} \\
    \widehat{ABC} \\  % yhmath package required
    \hat{ABC} \\
    \tilde{ABC} \\
    $$
- functions, compose, ceiling floor, abs pipe - $f \circ g; f \bullet g \lceil h \rceil \lfloor h \rfloor \quad | reg pipe | \quad \vert abs \vert \quad \Vert doublepipe \Vert $
    $$
    \displaystyle\sum^{n}_{k=1} x^k, \vert x \vert  % regular pipe doesnt work within sum
    $$
- divides / indivisible / modulo: $\mid \nmid a \bmod b \quad a \mod b a \pmod b a \pod b a \operatorname{div} b \equiv a \bmod c$
- misc anything, check, x mark x-mark xbox x-box x box, cross, multiply, wide tilde, is distributed as, degrees - $\checkmark \times \sim \degree$
- [big braces big brackets](https://tex.stackexchange.com/a/38870)
    $$
    (   \big(   \Big(   \bigg(  \Bigg(  \Bigg)  \bigg)  \Big)   \big)   ) \\
    [   \big[   \Big[   \bigg[  \Bigg[  \Bigg]  \bigg]  \Big]   \big]   ] \\
    \{  \big\{  \Big\{  \bigg\{ \Bigg\{ \Bigg\} \bigg\} \Big\}  \big\} \} \\
    $$
- $\backslash \$5.00 \# \% \& \~{a} \_ \^{b} \{ \} \$$ - escapes percent octothorp hashtag [via so](https://stackoverflow.com/a/5422751)
    - backslash is not escapable, if you need it, you have to use the explicit `\backslash`
- number theory
$$
\begin{aligned}
\mathbb{U} & \text{ - universal}      \\
\mathbb{P} & \text{ - prime}      \\
\mathbb{W} & \text{ - whole}      \\
\mathbb{N} & \text{ - natural}        \\
\mathbb{Z} & \text{ - integers}       \\
\mathbb{I} & \text{ - irrational}     \\
\mathbb{Q} & \text{ - rational}       \\
\mathbb{R} & \text{ - real}       \\
\mathbb{C} & \text{ - complex}        \\
\mathbb{H} & \text{ - quaternions}        \\
\mathbb{O} & \text{ - octonions}      \\
\mathbb{S} & \text{ - sedenions}      \\
\end{aligned}
$$
- cases
    $$
    CE(p, y) =
        \begin{cases}
                -\log(p)            & \text{if } y = 1 \\    % & is your "\tab"-like command (it's a tab alignment character)
                -\log(1-p)        & \text{otherwise.} \\
                0        & \text{otherwise.} \\
        \end{cases}
    $$
- best alignment method I know (2 "columns", one aligned left, another aligned left starting center )
    $$
    \begin{aligned}
        & y = f(x) = \alpha \plusmn \beta{x}  && \text{after the double amps is all left aligned TO the center } \\
        & \text{text on left} && \text{text on right} \\
        & y = f(x) = \alpha \plusmn \beta{x}   \\
        \text{if you type here, you push things }  \\
        & && \text{empty on the left} \\
        & \text{empty on the right} &&  \\
    \end{aligned} \\
    $$
    > the reason you want to use "aligned" rather than "align*" is "align*" does something funk and declares a new "math space" in latex itself. so it renders correctly in vscode, but in pandoc conversions, pdflatex chokes.
    >
- previous best alignment method I know (2 "columns", one aligned left, another aligned left starting center )
    $$
    \begin{align*}
        & y = f(x) = \alpha \plusmn \beta{x}  && \text{after the double amps is all left aligned TO the center } \\
        & \text{text on left} && \text{text on right} \\
        & y = f(x) = \alpha \plusmn \beta{x}   \\
        \text{if you type here, you push things }  \\
        & && \text{empty on the left} \\
        & \text{empty on the right} &&  \\
    \end{align*} \\
    $$
- n-col
    $$
    \begin{align*}
        & \text{what happens} \\
        && \text{what happens} \\
        &&& \text{what happens} \\
        &&&& \text{what happens} \\
        % just one per line
        &&& \text{3} \\
        &&&& \text{4} \\
        && \text{2} \\
        & \text{1} \\
        % multi one per line out of order?
        & \text{1} && \text{2} &&& \text{3} &&&& \text{4} \\
        \text{0} \\
        & \text{1} &&&& \text{4} \\
    \end{align*}
    $$
- jank 3-col
    $$
    \begin{align*}
        \text{left but coming out of the center} & \text{the actual center} && \text{right from center} \\
    \end{align*} \\
    $$
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
- formula definition alignment (numbering implicit)    TODO
    $$
    \begin{alignat}{7}
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
- $A\newline{A}$    - A newline A
- $A\\{A}$    - A newline A (version 2)
- markdown table with latex in there
        | header | header |
        | --- | --- |
        | $\Rho(A\|B)$ | $\text{escapes usually work well in this area}$ |
- array / matrix, note boldface matrix symbol
    $$
    \mathbf{A}_{2\times2} = \left[
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
- matrix / pmatrix / parenthetical matrix, note boldface matrix symbol
    $$
    \mathbf{A}_{2\times2} =
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
- big matrix from https://latex-tutorial.com/ellipses-in-latex/, note boldface matrix symbol
$$
\mathbf{A} = \begin{bmatrix}
-10 & -20 & 15 & 20 & -15 & -20 \\
22 & -10 & \cdots & \cdots & -10 & -15 \\
-11 & -10 & \cdots & \cdots & -10 & -10 \\
-10 & -10 & \cdots & \cdots & -10 & -10 \\
\vdots & \vdots & \ddots & & \vdots & \vdots \\
\vdots & \vdots & & \ddots & \vdots & \vdots \\
-10 & 10 & \cdots & \cdots & -10 & -10 \\
-10 & 10 & \cdots & \cdots & -10 & -10 \\
11 & 10 & \cdots & \cdots & -10 & -20 \\
-20 & -11 & -10 & -1 & -20 & -10
\end{bmatrix}
$$
- ![dimenison setting](./Layout-dimensions.png) which comes from [Overleaf](https://www.overleaf.com/learn/latex/Page_size_and_margins)
    - ez recomend:
        ```tex
        \documentclass{article}
        \usepackage{blindtext}
        \usepackage{geometry}
        % this shit right here.
        \geometry{
            a4paper,
            total={170mm,257mm},
            left=20mm,
            top=20mm,}
        \begin{document}
        \section{Some dummy text}
        \blindtext[10]
        \end{document}
        ```
- janky proof but it looks ok:
    $$
    \begin{aligned}
    \text{let } p &: \text{it is hotter than 100} \degree \text{ today.} \\
                q &: \text{the pollution is dangerous.} \\
    \\
    & p \lor q \\
    & \lnot p \\
    \hline
    & \blacksquare q \\
    & \therefore q \\
    \end{aligned}
    $$
- horizontal lines, hr
    $$
    \rule{4cm}{0.4pt}\\
    \begin{aligned}
    1000 &\\
    + 2000 &\\
    \rule{1cm}{0.0pt} &\\
    30000 &\\
    \end{aligned}

    % must be in \documentclass{article}\begin{document}\end{document}...
    % https://tex.stackexchange.com/questions/19579/horizontal-line-spanning-the-entire-document-in-latex
    % https://thelinuxcode.com/latex-horizontal-line/
    Below is a Line spanning the entire width of the page
    \noindent\makebox[\linewidth]{\rule{\paperwidth}{0.4pt}}
    Below is a 2cm long line
    \noindent\rule{2cm}{0.4pt}
    Below is a 4cm long line
    \noindent\rule{4cm}{0.4pt}
    Below is a 8cm long line
    \noindent\rule{8cm}{0.4pt}
    \newcommand{\hr}{
        \begin{center}
            \line(1,0){450}
        \end{center}
    }
    $$
- linear algebra / statistics / machine learning / deep learning
    - sigmoid function or sigma field $\mathcal{F} \mathscr{F}$
    - gradient $\nabla$
    - unit vectors (i and j without the dots): $\hat{\imath} \hat{\jmath}$
        - vector: $\vec{\rm v} ~ \overrightarrow{vabd}$
        - span: $\text{span}\{\mathbf{v}_1, \mathbf{v}_2, \ldots, \mathbf{v}_n\}$
            - https://www.underleaf.ai/learn/latex/vector-spaces
    - combinatorics / binomial
        $$
        \binom{a}{b}
        $$
    - "is modeled as" $X \sim \text{Normal}(\mu, \sigma^2)$
    - iid (independent, identically distributed): $X_1, X_2, \cdots X_n \overset{\mathrm{iid}}{\sim} \text{Normal}(\mu, \sigma^2) \rightarrow \bar{X} \sim \text{Normal}(\mu, \frac{\sigma^2}{n})$
- math fonts (Table 348 in [symbols-a4.pdf](./symbols-a4.pdf) or [by name](https://www.physicsread.com/latex-mathematical-font/))
    $$
    \begin{align*}
    3x^2 \in R \subset Q \\
    \mathrm{3x^2 \in R \subset Q}       & \quad \text{math roman} \\
    \mathbb{3x^2 \in R \subset Q}       & \quad \text{math blackboard} \\
    \mathbf{3x^2 \in R \subset Q}       & \quad \text{math boldface} \\
    \mathit{3x^2 \in R \subset Q}       & \quad \text{math italic} \\
    \mathsf{3x^2 \in R \subset Q}       & \quad \text{math san serif} \\
    \mathtt{3x^2 \in R \subset Q}       & \quad \text{math typewriter} \\
    % \mathds{3x^2 \in R \subset Q}       & \quad \text{math double stroke} \\
    \mathcal{3x^2 \in R \subset Q}      & \quad \text{math caligraphy} \\
    \mathscr{3x^2 \in R \subset Q}      & \quad \text{math RSFS (Ralph Smith's Formal Script)} \\
    % \mathrsfs{3x^2 \in R \subset Q}     & \quad \text{math Ralph Smith's Formal Script} \\
    \mathfrak{3x^2 \in R \subset Q}     & \quad \text{math Fraktur gothic} \\
    \mathnormal{3x^2 \in R \subset Q}   & \quad \text{math standard} \\
    \end{align*}
    $$

- Math symbols
    - $\mathcal{N}$ - Normal Distribution

# Hacks
- left and right subscript, a prescript if you will ${}^{1}_{2}x^{3}_{4}$ - https://tex.stackexchange.com/a/305700