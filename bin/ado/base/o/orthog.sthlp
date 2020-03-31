{smcl}
{* *! version 1.1.17  19oct2017}{...}
{viewerdialog orthog "dialog orthog"}{...}
{viewerdialog orthpoly "dialog orthpoly"}{...}
{vieweralsosee "[R] orthog" "mansection R orthog"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "orthog##syntax"}{...}
{viewerjumpto "Menu" "orthog##menu"}{...}
{viewerjumpto "Description" "orthog##description"}{...}
{viewerjumpto "Links to PDF documentation" "orthog##linkspdf"}{...}
{viewerjumpto "Options for orthog" "orthog##options_orthog"}{...}
{viewerjumpto "Options for orthpoly" "orthog##options_orthpoly"}{...}
{viewerjumpto "Remarks" "orthog##remarks"}{...}
{viewerjumpto "Examples of orthog" "orthog##orthog_examples"}{...}
{viewerjumpto "Examples of orthpoly" "orthog##orthpoly_examples"}{...}
{viewerjumpto "Reference" "orthog##reference"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] orthog} {hline 2}}Orthogonalize variables and compute
orthogonal polynomials{p_end}
{p2col:}({mansection R orthog:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Orthogonalize variables

{p 8 15 2}
{cmd:orthog}
[{varlist}]
{ifin}
[{it:{help orthog##weight:weight}}]
{cmd:,}
{opth g:enerate(newvarlist)}
[{opt mat:rix(matname)}]


{phang}
Compute orthogonal polynomial

{p 8 17 2}
{cmd:orthpoly}
{varname}
{ifin}
[{it:{help orthog##weight:weight}}]
{cmd:,}{break}
{c -(}{opth g:enerate(newvarlist)}{c |}{opt p:oly(matname)}{c )-}
[{opt d:egree(#)}]


{p 4 6 2}
{opt orthpoly} requires that {opt generate(newvarlist)} or {opt poly(matname)}, or both, be specified.{p_end}
{p 4 6 2}
{it:varlist} may contain time-series operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt iweight}s, {opt aweight}s, {opt fweight}s, and {opt pweight}s are
allowed; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

    {title:orthog}

{phang2}
{bf:Data > Create or change data > Other variable-creation commands >}
     {bf:Orthogonalize variables}

    {title:orthpoly}

{phang2}
{bf:Data > Create or change data > Other variable-creation commands >}
      {bf:Orthogonal polynomials}


{marker description}{...}
{title:Description}

{pstd}
{opt orthog} orthogonalizes a set of variables, creating a new set of
orthogonal variables (all of type {opt double}), using a
modified Gram-Schmidt procedure ({help orthog##GL2013:Golub and Van Loan 2013}).
The order of the variables determines the orthogonalization;
hence, the "most important" variables should be listed first.

{pstd}Execution time is proportional to the square of the number of
variables.  With many (>10) variables, {cmd:orthog} will be fairly slow.

{pstd}
{opt orthpoly} computes orthogonal polynomials for one variable.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R orthogQuickstart:Quick start}

        {mansection R orthogRemarksandexamples:Remarks and examples}

        {mansection R orthogMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_orthog}{...}
{title:Options for orthog}

{dlgtab:Main}

{phang}
{opth generate(newvarlist)} is required.  {opt generate()} creates new
orthogonal variables of type {opt double}.
For {opt orthog}, {it:newvarlist}
will contain the orthogonalized {varlist}.
If {it:varlist} contains d variables, then so will {it:newvarlist}.
{it:newvarlist} can be specified by giving a list of exactly d new variable
names, or it can be abbreviated using the styles
{it:newvar}{cmd:1-}{it:newvard} or {it:newvar}{opt *}.  For these two styles of
abbreviation, new variables {it:newvar}{cmd:1}, {it:newvar}{cmd:2}, ...,
{it:newvard} are generated.  See {help orthog##orthog_examples:Examples} below.

{phang}
{opt matrix(matname)} creates a (d + 1) * (d + 1) matrix 
containing the matrix R defined by X = QR, where X is the N * (d + 1)
matrix representation of {varlist} plus a column of ones and Q is the 
N * (d + 1) matrix representation of {it:{help newvarlist}} plus a column of
ones (d = number of variables in {it:varlist}, and N = number of observations).


{marker options_orthpoly}{...}
{title:Options for orthpoly}

{dlgtab:Main}

{phang}
{opth generate(newvarlist)} or {opt poly()}, or both, must be specified.
{opt generate()} creates new orthogonal variables of type {opt double}.
{it:newvarlist} will contain orthogonal polynomials of degree 1, 2, ..., d
evaluated at {it:varname}, where d is as specified by {opt degree(d)}.
{it:newvarlist} can be specified by giving a list of exactly d new variable
names, or it can be abbreviated using the styles {it:newvar}{cmd:1-}
{it:newvard} or {it:newvar}{opt *}.  For these two styles of abbreviation, new
variables {it:newvar}{cmd:1}, {it:newvar}{cmd:2}, ..., {it:newvard} are
generated.  See {help orthog##orthpoly_examples:Examples} below.

{phang}
{opt poly(matname)} creates a (d + 1) * (d + 1) matrix
called {it:matname} containing the coefficients of the orthogonal polynomials.
The orthogonal polynomial of degree i {ul:<} d is

{pin2}
{it:matname}{cmd:[}i{cmd:,} d + 1{cmd:] +}
{it:matname}{cmd:[}i{cmd:, 1]*}{it:varname} {cmd:+}
{it:matname}{cmd:[}i{cmd:, 2]*}{it:varname}^2
{cmd:+}...{cmd:+}
{it:matname}{cmd:[}i{cmd:,} i{cmd:]*}{it:varname}^i

{pmore}
The coefficients corresponding to the constant term are placed in
the last column of the matrix.  The last row of the matrix is all zeros, except
for the last column, which corresponds to the constant term.

{phang}
{opt degree(#)} specifies the highest-degree polynomial to include.
Orthogonal polynomials of degree 1, 2, ..., d = {it:#} are computed.
The default is {bind:d = 1}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Orthogonal variables are useful for two reasons.  The first is numerical
accuracy for highly collinear variables.  Stata's {cmd:regress} and other
estimation commands can face much collinearity and still produce
accurate results.  But, at some point, these commands will drop variables
because of collinearity.  If you know with certainty that the variables are
not perfectly collinear, you may want to retain all their effects in the
model.  If you use {cmd:orthog} or {cmd:orthpoly} to produce a set of
orthogonal variables, all variables will be present in the estimation results.

{pstd}
Users are more likely to find orthogonal variables useful for the second
reason:  ease of interpreting results.  {cmd:orthog} and {cmd:orthpoly} create
a set of variables such that the "effects" of all the preceding variable have
been removed from each variable.  For example, if we issue the command

{phang2}{cmd:. orthog x1 x2 x3, generate(q1 q2 q3)}

{pstd}
the effect of the constant is removed from {cmd:x1} to produce {cmd:q1}; the
constant and {cmd:x1} are removed from {cmd:x2} to produce {cmd:q2}; and
finally the constant, {cmd:x1}, and {cmd:x2} are removed from {cmd:x3} to
produce {cmd:q3}.  Hence,

{p 8 13 2}{cmd:q1} = r01 + r11*{cmd:x1}{p_end}
{p 8 13 2}{cmd:q2} = r02 + r12*{cmd:x1} + r22*{cmd:x2}{p_end}
{p 8 13 2}{cmd:q3} = r03 + r13*{cmd:x1} + r23*{cmd:x2} + r33*{cmd:x3}

{pstd}
This effect can be generalized and written in matrix notation as

	X = QR

{pstd}
where X is the N * (d + 1) matrix representation of {it:varlist} plus a column
of ones, and Q is the N * (d + 1) matrix representation of {it:newvarlist}
plus a column of ones (d = number of variables in {it:varlist} and N = number
of observations).  The (d + 1) * (d + 1) matrix R is a permuted
upper-triangular matrix; that is, R would be upper triangular if the constant
were first, but the constant is last, so the first row/column has been
permuted with the last row/column.  Because Stata's estimation commands list the
constant term last, this allows R, obtained via the {cmd:matrix()} option, to
be used to transform estimation results.


{marker examples}{...}
{marker orthog_examples}{...}
{title:Examples of orthog}

{pstd}Create orthogonal variables{p_end}

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. orthog price weight mpg, gen(u*)}{p_end}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. orthog price weight mpg, gen(upr uwei umpg)}{p_end}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. orthog price weight mpg, gen(upr uwei umpg) matrix(R)}

{pstd}The matrix R created by the {cmd:matrix()} option can be used to
transform coefficients from a regression{p_end}

{phang2}{cmd:. regress length upr uwei umpg}{p_end}
{p 8 40 2}{cmd:. matrix b1 = e(b)*inv(R)'}{space 3}(the transpose of
            {cmd:inv(R)} is used){p_end}
{phang2}{cmd:. matrix list b1}{p_end}
{phang2}{cmd:. regress length price weight mpg}

{pstd} The matrix R can also be used to recover X (original {it:varlist}) from Q
(orthogonalized {it:newvarlist}) one variable at a time 

{phang2}{cmd:. matrix c = R[1...,"price"]}{p_end}
{p 8 40 2}{cmd:. matrix c = c'}{space 14}({cmd:matrix score} requires a row vector)
{p_end}
{phang2}{cmd:. matrix score double samepr = c}{p_end}
{phang2}{cmd:. compare price samepr}{p_end}

{pstd}
That is, the variable {opt samepr} is the same as the original {opt price}.
This procedure can be performed as a check of the numerical soundness of the
orthogonalization.


{marker orthpoly_examples}{...}
{title:Examples of orthpoly}

{pstd}Compute orthogonal polynomials for {cmd:weight} and perform orthogonal
polynomial regression{p_end}

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. orthpoly weight, deg(4) generate(pw*)}{p_end}
{phang2}{cmd:. regress mpg pw1-pw4}

{pstd}The matrix P created by the {cmd:poly()} option can be used to transform
coefficients for orthogonal polynomials to coefficients for natural
polynomials{p_end}

{phang2}{cmd:. orthpoly weight, deg(4) poly(P)}{p_end}
{phang2}{cmd:. matrix b3 = e(b)*P}{p_end}
{phang2}{cmd:. matrix list b3}{p_end}

{phang2}{cmd:. gen double w1=weight}{p_end}
{phang2}{cmd:. gen double w2=weight^2}{p_end}
{phang2}{cmd:. gen double w3=weight^3}{p_end}
{phang2}{cmd:. gen double w4=weight^4}{p_end}
{phang2}{cmd:. regress mpg w1-w4}{p_end}


{marker reference}{...}
{title:Reference}

{marker GL2013}{...}
{phang}
Golub, G. H., and C. F. Van Loan. 2013.
{it:Matrix Computations}. 4th ed.
Baltimore: Johns Hopkins University Press.
{p_end}
