{smcl}
{* *! version 1.3.4  19oct2017}{...}
{viewerdialog rotatemat "dialog rotatemat"}{...}
{vieweralsosee "[MV] rotatemat" "mansection MV rotatemat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] rotate" "help rotate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] procrustes" "help procrustes"}{...}
{viewerjumpto "Syntax" "rotatemat##syntax"}{...}
{viewerjumpto "Menu" "rotatemat##menu"}{...}
{viewerjumpto "Description" "rotatemat##description"}{...}
{viewerjumpto "Links to PDF documentation" "rotatemat##linkspdf"}{...}
{viewerjumpto "Options" "rotatemat##options"}{...}
{viewerjumpto "Rotation criteria" "rotatemat##criteria"}{...}
{viewerjumpto "Remark on identification" "rotatemat##remark"}{...}
{viewerjumpto "Examples" "rotatemat##examples"}{...}
{viewerjumpto "Stored results" "rotatemat##results"}{...}
{viewerjumpto "References" "rotatemat##references"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MV] rotatemat} {hline 2}}Orthogonal and oblique rotations of a
Stata matrix{p_end}
{p2col:}({mansection MV rotatemat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 30 2}
{cmd:rotatemat} {it:matrix_L} [{cmd:,} {it:options}]
{p_end}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt ortho:gonal}}restrict to orthogonal rotations; the default,
	except with {cmd:promax()}{p_end}
{synopt:{opt obliq:ue}}allow oblique rotations{p_end}
{synopt:{it:{help rotatemat##rotation_methods:rotation_methods}}}rotation criterion{p_end}
{synopt:{opt norm:alize}}rotate Kaiser normalized matrix{p_end}

{syntab:Reporting}
{synopt:{opth for:mat(%fmt)}}display format for matrices;
	default is {cmd:format(%9.5f)}{p_end}
{synopt:{opt bl:anks(#)}}display loadings as blanks when
	|loading| < {it:#}; default is {cmd:blanks(0)}{p_end}
{synopt:{opt nodisp:lay}}suppress all output except log and trace{p_end}
{synopt:{opt noload:ing}}suppress display of rotated loadings{p_end}
{synopt:{opt norota:tion}}suppress display of rotation matrix{p_end}
{synopt:{opth matn:ame(strings:string)}}descriptive label of the matrix to be
	rotated{p_end}
{synopt:{opth coln:ames(strings:string)}}descriptive name for columns of the
         matrix to be rotated{p_end}

{syntab:Optimization}
{synopt:{it:{help rotatemat##optimizeopts:optimize_options}}}control
	the maximization process; seldom used{p_end}
{synoptline}

INCLUDE help rotate_criteria_table
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis >}
      {bf:Orthogonal and oblique rotations of a matrix}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rotatemat} applies a linear transformation to the specified matrix so
that the result minimizes a criterion function over all matrices in a class of
feasible transformations.  Two classes are supported: orthogonal (orthonormal)
and oblique.  A wide variety of criterion functions are available,
representing different ways to measure the "simplicity" of a matrix.  Most
of these criteria can be applied with both orthogonal and oblique rotations.

{pstd}
This entry describes the computation engine for orthogonal and oblique
transformations of Stata matrices.  This command may be used directly
on any Stata matrix.

{pstd}
If you are interested in rotation after {cmd:factor}, {cmd:factormat},
{cmd:pca}, or {cmd:pcamat}, see
{manhelp factor_postestimation MV:factor postestimation}, 
{manhelp pca_postestimation MV:pca postestimation}, and the general
description of {cmd:rotate} as a
postestimation facility in {manhelp rotate MV}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV rotatematRemarksandexamples:Remarks and examples}

        {mansection MV rotatematMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt orthogonal}
specifies that an orthogonal rotation be applied.  This is the default.

{pmore}
See {it:{help rotatemat##criteria:Rotation criteria}} below for details on the
{it:rotation_methods} available with {opt orthogonal}.

{phang}{opt oblique}
specifies that an oblique rotation be applied.  This often yields more
interpretable factors with a simpler structure than that obtained with an
orthogonal rotation.  In many applications (for example, after {cmd:factor} and
{cmd:pca}), the factors before rotation are orthogonal (uncorrelated), whereas
the oblique rotated factors are correlated.

{pmore}
See {it:{help rotatemat##criteria:Rotation criteria}} below for details on the
{it:rotation_methods} available with {opt oblique}.

{phang}{opt normalize}
requests that the rotation be applied to the Kaiser normalization of the matrix
{bf:A} so that the rowwise sums of squares equal 1.

{dlgtab:Reporting}

{phang}{opth format(%fmt)}
specifies the display format for matrices.  The default is
{cmd:format(%9.5f)}.

{phang}{opt blanks(#)}
specifies that small values of the rotated matrix -- that is, those elements
of {bf:A} ({bf:T}')^{-1} that are less than {it:#} in absolute value --
are displayed as spaces.

{phang}{opt nodisplay}
suppresses all output except the log and trace.

{phang}{opt noloading}
suppresses the display of the rotated loadings.

{phang}{opt norotation}
suppresses the display of the optimal rotation matrix.

{phang}{opth matname:(strings:string)}
is a rarely used output option; it specifies a descriptive label of the matrix
to be rotated.

{phang}{opth colnames:(strings:string)}
is a rarely used output option; it specifies a descriptive name to refer to
the columns of the matrix to be rotated.  For instance,
{cmd:colnames(components)} specifies that the output labels the columns as
"components".  The default is "factors".

{marker optimizeopts}{...}
{dlgtab:Optimization}

{phang}
{it:optimize_options} control the iterative optimization process.  These
options are seldom used.

{phang2}{opt iterate(#)}
is a rarely used option; it specifies the maximum number of iterations.  The
default is {cmd:iterate(1000)}.

{phang2}{opt log}
specifies that an iteration log be displayed.

{phang2}{opt trace}
is a rarely used option; it specifies that the rotation be displayed at each
iteration.

{phang2}{opt tolerance(#)}
is one of three criteria for declaring convergence and is rarely used.  The
{cmd:tolerance()} convergence criterion is satisfied when the relative change
in the rotation matrix {bf:T} from one iteration to the next is less than or
equal to {it:#}.  The default is {cmd:tolerance(1e-6)}.

{phang2} {opt gtolerance(#)}
is one of three criteria for declaring convergence and is rarely used.  The
{cmd:gtolerance()} convergence criterion is satisfied when the Frobenius norm
of the gradient of the criterion function c() projected on the manifold of
orthogonal matrices or of normal matrices is less than or equal to {it:#}.
The default is {cmd:gtolerance(1e-6)}.

{phang2}{opt ltolerance(#)}
is one of three criteria for declaring convergence and is rarely used.  The
{cmd:ltolerance()} convergence criterion is satisfied when the relative change
in the minimization criterion c() from one iteration to the next is less than
or equal to {it:#}.  The default is {cmd:ltolerance(1e-6)}.

{phang2}{opt protect(#)}
requests that {it:#} optimizations with random starting values be performed
and that the best of the solutions be reported.  The output also indicates
whether all starting values converged to the same solution.  When specified
with a large number, such as {cmd:protect(50)}, this provides reasonable
assurance that the solution found is the global maximum and not just a local
maximum.  If {cmd:trace} is also specified, the rotation matrix and rotation
criterion value of each optimization will be reported.

{phang2}{opt maxstep(#)}
is a rarely used option; it specifies the maximum number of step-size
halvings.  The default is {cmd:maxstep(20)}.

{phang2}{opt init(matname)}
is a rarely used option; it specifies the initial rotation matrix.
{it:matname} should be square and regular (nonsingular) and have the same
number of columns as matrix {it:matrix_L} to be rotated.  It should be
orthogonal ({bf:T}'*{bf:T} = {bf:T}*{bf:T}' = {bf:I}) or normal
(diag({bf:T}'*{bf:T}) = {bf:1}), depending on whether orthogonal or oblique
rotations are performed.  {opt init()} cannot be combined with
{opt random}.  If neither {opt init()} nor {cmd:random} is specified, the
identity matrix is used as the initial rotation.

{phang2}{opt random}
is a rarely used option; it specifies that a random orthogonal or random
normal matrix be used as the initial rotation matrix.  {cmd:random}
cannot be combined with {opt init()}.  If neither {opt init()} nor
{opt random} is specified, the identity matrix is used as the initial
rotation.


{marker criteria}{...}
{title:Rotation criteria}

{pstd}
In the descriptions below, the matrix to be rotated is denoted as {bf:A},
{it:p} denotes the number of rows of {bf:A}, and {it:f} denotes the number
of columns of {bf:A} (factors or components).  If {bf:A} is a loading matrix
from {cmd:factor} or {cmd:pca}, {it:p} is the number of variables, and {it:f}
the number of factors or components.

    {title:Criteria suitable only for orthogonal rotations}

{phang2}{opt varimax} and {opt vgpf}
apply the orthogonal varimax rotation
({help rotatemat##K1958:Kaiser 1958}).  {cmd:varimax} maximizes the variance
of the squared loadings within factors (columns of {bf:A}).  It is equivalent
to {cmd:cf(}{it:1/p}{cmd:)} and to {cmd:oblimin(1)}.  {cmd:varimax},
the most popular rotation, is implemented with a dedicated fast
algorithm and ignores all
{it:{help rotatemat##optimizeopts:optimize_options}}.  Specify {cmd:vgpf} to
switch to the general GPF algorithm used for the other criteria.

{phang2}{opt quartimax}
uses the quartimax criterion
({help rotatemat##H1976:Harman 1976}).  {cmd:quartimax} maximizes the
variance of the squared loadings within the variables (rows of {bf:A}).  For
orthogonal rotations, {cmd:quartimax} is equivalent to {cmd:cf(0)} and to
{cmd:oblimax}.

{phang2}{opt equamax}
specifies the orthogonal equamax rotation.  {cmd:equamax} maximizes a weighted
sum of the {cmd:varimax} and {cmd:quartimax} criteria, reflecting a concern
for simple structure within variables (rows of {bf:A}) as well as within
factors (columns of {bf:A}).  {cmd:equamax} is equivalent to
{cmd:oblimin(}{it:p}{cmd:/2)} and {cmd:cf(}{it:f}{cmd:/(2}{it:p}{cmd:))}.

{phang2}{opt parsimax}
specifies the orthogonal parsimax rotation.  {cmd:parsimax} is equivalent
to {cmd:cf((}{it:f}{cmd:-1)/(}{it:p}{cmd:+}{it:f}{cmd:-2))}.

{phang2}{opt entropy}
applies the minimum entropy rotation criterion 
({help rotatemat##J2004:Jennrich 2004}).

{phang2}{opt tandem1}
specifies that the first principle of Comrey's tandem be applied.
According to 
{help rotatemat##C1967:Comrey (1967)}, this principle should be used to judge
which "small" factors should be dropped.

{phang2}{opt tandem2}
specifies that the second principle of Comrey's tandem be applied.  According
to {help rotatemat##C1967:Comrey (1967)}, {opt tandem2} should be used for
"polishing".

    {title:Criteria suitable only for oblique rotations}

{phang2}{cmd:promax}[{cmd:(}{it:#}{cmd:)}]
specifies the oblique promax rotation.  The optional argument specifies the
{cmd:promax} power.  Not specifying the argument is equivalent to specifying
{cmd:promax(3)}.  Values less than 4 are recommended, but the choice is yours.
Larger {cmd:promax} powers simplify the loadings (generate numbers closer to
zero and one) but at the cost of additional correlation between factors.
Choosing a value is a matter of trial and error, but most sources find values
in excess of 4 undesirable in practice.  The power must be greater than 1 but
is not restricted to integers.

{pmore2}
Promax rotation is an oblique rotation method that was developed before the
"analytical methods" (based on criterion optimization) became computationally
feasible.  Promax rotation comprises an oblique Procrustean rotation of
the original loadings {bf:A} toward the elementwise {it:#}-power of the
orthogonal varimax rotation of {bf:A}.

    {title:Criteria suitable for orthogonal and oblique rotations}

{phang2}{cmd:oblimin}[{cmd:(}{it:#}{cmd:)}]
specifies that the oblimin criterion with gamma = {it:#} be used.  When
restricted to orthogonal transformations, the {cmd:oblimin()} family is
equivalent to the orthomax criterion function.  Special cases of
{cmd:oblimin()} include

{space 16}{c TLC}{hline 36}{c TRC}
{space 16}{c |} gamma    Special case              {c |}
{space 16}{c LT}{hline 36}{c RT}
{space 16}{c |} 0        quartimax / quartimin     {c |}
{space 16}{c |} 1/2      biquartimax / biquartimin {c |}
{space 16}{c |} 1        varimax / covarimin       {c |}
{space 16}{c |} {it:p}/2      equamax                   {c |}
{space 16}{c BLC}{hline 36}{c BRC}
{space 16}  {it:p} = number of rows of {bf:A}.

{pmore2}
gamma defaults to zero.  {help rotatemat##J1979:Jennrich (1979)} recommends
gamma {ul:<} 0 is recommended for oblique rotations.  For gamma > 0 it is
possible that optimal oblique rotations do not exist; the iterative procedure
used to compute the solution will wander off to a degenerate solution.

{phang2}{opt cf(#)}
specifies that a criterion from the Crawford-Ferguson
({help rotatemat##CF1970:1970}) family be used
with kappa = {it:#}.  {opt cf(kappa)} can be seen as
(1-{it:kappa})cf_1({bf:A}) + {it:kappa} cf_2({bf:A}), where cf_1({bf:A}) is a
measure of row parsimony and cf_2({bf:A}) is a measure of column parsimony.
cf_1({bf:A}) attains its greatest lower bound when no row of {bf:A} has more
than one nonzero element, whereas cf_2({bf:A}) reaches zero if no column of
{bf:A} has more than one nonzero element.

{pmore2}
For orthogonal rotations, the Crawford-Ferguson family is equivalent to the
{cmd:oblimin()} family.  For orthogonal rotations, special cases include
the following:

{space 16}{c TLC}{hline 40}{c TRC}
{space 16}{c |} kappa            Special case          {c |}
{space 16}{c LT}{hline 40}{c RT}
{space 16}{c |} 0                quartimax / quartimin {c |}
{space 16}{c |} 1/{it:p}              varimax / covarimin   {c |}
{space 16}{c |} {it:f}/(2{it:p})           equamax               {c |}
{space 16}{c |} ({it:f}-1)/({it:p}+{it:f}-2)    parsimax              {c |}
{space 16}{c |} 1                factor parsimony      {c |}
{space 16}{c BLC}{hline 40}{c BRC}
{space 16}  {it:p} = number of rows of {bf:A}.
{space 16}  {it:f} = number of columns of {bf:A}.

{phang2}{opt bentler}
specifies that Bentler's "invariant pattern simplicity" criterion
({help rotatemat##B1977:Bentler 1977}) be used.

{phang2}{opt oblimax}
specifies the oblimax criterion.  {cmd:oblimax}  maximizes the number of
high and low loadings.  {cmd:oblimax} is equivalent to {cmd:quartimax}
for orthogonal rotations.

{phang2}{opt quartimin}
specifies that the quartimin criterion be used.  For orthogonal rotations,
{cmd:quartimin} is equivalent to {cmd:quartimax}.

{phang2}{opt target(Tg)}
specifies that {bf:A} be rotated as near as possible to the conformable matrix
{it:Tg}.  Nearness is expressed by the Frobenius matrix norm.

{phang2}{opt partial(Tg W)}
specifies that {bf:A} be rotated as near as possible to the conformable matrix
{it:Tg}.  Nearness is expressed by a weighted (by {it:W}) Frobenius matrix
norm.  {it:W} should be nonnegative, and usually is zero-one valued, with ones
identifying the target values to be reproduced as closely as possible by the
factor loadings, whereas zeros identify loadings to remain unrestricted.
{p_end}


{marker remark}{...}
{title:Remark on identification}

{pstd}
All supported criteria are invariant with respect to permutations of the
columns and change of signs of the columns.  {cmd:rotatemat} returns the
solution with positive column sums and with columns sorted by the L2 norm;
columns are ordered with respect to the L1 norm if the columns have the
same L2 norm.


{marker examples}{...}
{title:Examples}

    {cmd:. rotatemat L}
    {cmd:. rotatemat X, oblique}
    {cmd:. rotatemat L, entropy protect(20)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:rotatemat} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(f)}}criterion value{p_end}
{synopt:{cmd:r(iter)}}number of GPF iterations{p_end}
{synopt:{cmd:r(rc)}}return code{p_end}
{synopt:{cmd:r(nnconv)}}number of nonconvergent trials; {cmd:protect()} only{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:rotatemat}{p_end}
{synopt:{cmd:r(ctitle)}}descriptive label of rotation method{p_end}
{synopt:{cmd:r(ctitle12)}}version of {cmd:r(ctitle)} at most 12 characters
long{p_end}
{synopt:{cmd:r(criterion)}}criterion name (e.g., {cmd:oblimin}){p_end}
{synopt:{cmd:r(class)}}{cmd:orthogonal} or {cmd:oblique}{p_end}
{synopt:{cmd:r(normalization)}}{cmd:kaiser} or {cmd:none}{p_end}
{synopt:{cmd:r(carg)}}criterion argument{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(T)}}optimal transformation T{p_end}
{synopt:{cmd:r(AT)}}optimal AT = A(T')^-1{p_end}
{synopt:{cmd:r(fmin)}}minimums found; {cmd:protect()} only{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker B1977}{...}
{phang}
Bentler, P. M. 1977. Factor simplicity index and transformations.
   {it:Psychometrika} 42: 277-295.

{marker C1967}{...}
{phang}
Comrey, A. L. 1967.
Tandem criteria for analytic rotation in factor analysis.
{it:Psychometrika} 32: 277-295.

{marker CF1970}{...}
{phang}
Crawford, C. B., and G. A. Ferguson. 1970. A general rotation criterion
    and its use in orthogonal rotation.
    {it:Psychometrika} 35: 321-332.

{marker H1976}{...}
{phang}
Harman, H. H. 1976. {it:Modern Factor Analysis}. 3rd ed.
  Chicago: University of Chicago Press.

{marker H1965}{...}
{phang}
Horst, P. 1965. {it:Factor Analysis of Data Matrices}.
New York: Holt, Rinehart & Winston.

{marker J1979}{...}
{phang}
Jennrich, R. I. 1979. Admissible values of gamma in direct oblimin rotation.
   {it:Psychometrika} 44: 173-177.

{marker J2004}{...}
{phang}
------. 2004. Rotation to simple loadings using component loss 
    functions: The orthogonal case.
    {it:Psychometrika} 69: 257-273.

{marker K1958}{...}
{phang}
Kaiser, H. F. 1958. The varimax criterion for analytic rotation in factor
   analysis. {it:Psychometrika} 23: 187-200.
{p_end}
