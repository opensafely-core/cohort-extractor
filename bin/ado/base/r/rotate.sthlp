{smcl}
{* *! version 1.3.2  19oct2017}{...}
{viewerdialog rotate "dialog rotate"}{...}
{vieweralsosee "[MV] rotate" "mansection MV rotate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] rotatemat" "help rotatemat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] factor postestimation" "help factor_postestimation"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{vieweralsosee "[MV] pca postestimation" "help pca_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] procrustes" "help procrustes"}{...}
{viewerjumpto "Syntax" "rotate##syntax"}{...}
{viewerjumpto "Menu" "rotate##menu"}{...}
{viewerjumpto "Description" "rotate##description"}{...}
{viewerjumpto "Links to PDF documentation" "rotate##linkspdf"}{...}
{viewerjumpto "Options" "rotate##options"}{...}
{viewerjumpto "Rotation criteria" "rotate##criteria"}{...}
{viewerjumpto "Examples" "rotate##examples"}{...}
{viewerjumpto "Stored results" "rotate##results"}{...}
{viewerjumpto "References" "rotate##references"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MV] rotate} {hline 2}}
Orthogonal and oblique rotations after factor and pca
{p_end}
{p2col:}({mansection MV rotate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax} 

{p 8 15 2}
{cmdab:rot:ate} [{cmd:,} {it:options}]

{p 8 15 2}
{cmdab:rot:ate}{cmd:,} {opt clear}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt ortho:gonal}}restrict to orthogonal rotations; 
	the default, except with {cmd:promax()}{p_end}
{synopt:{opt obliq:ue}}allow oblique rotations{p_end}
{synopt:{it:{help rotate##rotation_methods:rotation_methods}}}rotation criterion{p_end}
{synopt:{opt norm:alize}}rotate Kaiser normalized matrix{p_end}
{synopt:{opt f:actors(#)}}rotate {it:#} factors or components;
	default is to rotate all{p_end}
{synopt:{opt comp:onents(#)}}synonym for {cmd:factors()}{p_end}

{syntab:Reporting}
{synopt:{opt bl:anks(#)}}display loadings as blank when
	|loading| < {it:#}; default is {cmd:blanks(0)}{p_end}
{synopt:{opt det:ail}}show {cmd:rotatemat} output; seldom used{p_end}
{synopt:{opth for:mat(%fmt)}}display format for matrices;
	default is {cmd:format(%9.5f)}{p_end}
{synopt:{opt noload:ing}}suppress display of rotated loadings{p_end}
{synopt:{opt norota:tion}}suppress display of rotation matrix{p_end}

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
     {bf:Factor and principal component analysis > Postestimation >}
     {bf:Rotate loadings}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rotate} performs a rotation of the loading matrix after {cmd:factor},
{cmd:factormat}, {cmd:pca}, and {cmd:pcamat}; see {manhelp factor MV} and
{manhelp pca MV}.  Many rotation criteria (such as varimax and oblimin) are
available that can be applied with respect to the orthogonal and oblique
class of rotations.

{pstd}
{cmd:rotate, clear} removes the rotation results from the estimation
results. 

{pstd}
If you want to rotate a given matrix, see {manhelp rotatemat MV}.

{pstd}
If you want a Procrustes rotation, which rotates variables optimally toward
other variables, see {manhelp procrustes MV}. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV rotateQuickstart:Quick start}

        {mansection MV rotateRemarksandexamples:Remarks and examples}

        {mansection MV rotateMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}{opt orthogonal}
specifies that an orthogonal rotation be applied.  This is the default.

{pmore}
See {it:{help rotate##criteria:Rotation criteria}} below for details on the
{it:rotation_methods} available with {opt orthogonal}.

{phang}{opt oblique}
specifies that an oblique rotation be applied.  This often yields more
interpretable factors with a simpler structure than that obtained with an
orthogonal rotation.  In many applications (for example, after {cmd:factor} and
{cmd:pca}) the factors before rotation are orthogonal (uncorrelated), whereas
the oblique rotated factors are correlated.

{pmore}
See {it:{help rotate##criteria:Rotation criteria}} below for details on the
{it:rotation_methods} available with {opt oblique}.

{phang}{opt clear}
specifies that rotation results be cleared (removed) from the last
estimation command.  {opt clear} may not be combined with any other option.

{pmore}
{cmd:rotate} stores its results within the {cmd:e()} results of {cmd:pca} and
{cmd:factor}, overwriting any previous rotation results.  Postestimation
commands such as {cmd:predict} operate on the last rotated results, if any,
instead of the unrotated results, and allow you to specify {cmd:norotated} to
use the unrotated results.  The {opt clear} option of {cmd:rotate} allows you
to remove the rotation results from {cmd:e()}, thus freeing you from
having to specify {cmd:norotated} for the postestimation commands.

{phang}{opt normalize}
requests that the rotation be applied to the Kaiser normalization
({help rotate##H1965:Horst 1965}) of the matrix
{it:A}, so that the rowwise sums of squares equal 1.  Kaiser normalization
applies to the rotated columns only (see the {cmd:factors()} option below).

{phang}{opt factors(#)}, and synonym {opt components(#)},
specifies the number of factors or components (columns of the loading matrix)
to be rotated, counted "from the left", that is, with the lowest column index.
The other columns are left unrotated.  All columns are rotated by default.

{dlgtab:Reporting}

{phang}{opt blanks(#)}
shows blanks for loadings with absolute values smaller than {it:#}.

{phang}{opt detail} displays the {cmd:rotatemat} output; seldom used.

{phang}
{opth format(%fmt)} specifies the display format for matrices.  The default is
{cmd:format(%9.5f)}.

{phang}
{opt noloading} suppresses the display of the rotated loadings.

{phang}
{opt norotation} suppresses the display of the optimal rotation matrix.

{dlgtab:Optimization}

{phang}{it:optimize_options}
are seldom used; see {helpb rotatemat##optimizeopts:[MV] rotatemat}.


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
apply the orthogonal varimax rotation ({help rotate##K1958:Kaiser 1958}).
{cmd:varimax} maximizes the variance of the squared loadings within factors
(columns of {bf:A}).  It is equivalent to {cmd:cf(}{it:1/p}{cmd:)} and to
{cmd:oblimin(1)}.  {cmd:varimax}, the most popular rotation, is implemented
with a dedicated fast algorithm and ignores all
{it:{help rotatemat##optimizeopts:optimize_options}}.  Specify {cmd:vgpf} to
switch to the general GPF algorithm used for the other criteria.

{phang2}{opt quartimax}
uses the quartimax criterion
({help rotate##H1976:Harman 1976}).  {cmd:quartimax} maximizes the
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
({help rotate##J2004:Jennrich 2004}).

{phang2}{opt tandem1}
specifies that the first principle of Comrey's tandem be applied.
According to 
{help rotate##C1967:Comrey (1967)}, this principle should be used to judge which
"small" factors should be dropped.

{phang2}{opt tandem2}
specifies that the second principle of Comrey's tandem be applied.  According
to {help rotate##C1967:Comrey (1967)}, {opt tandem2} should be used for
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
gamma defaults to zero.  {help rotate##J1979:Jennrich (1979)} recommends
gamma {ul:<} 0 is recommended for oblique rotations.  For gamma > 0 it is
possible that optimal oblique rotations do not exist; the iterative procedure
used to compute the solution will wander off to a degenerate solution.

{phang2}{opt cf(#)}
specifies that a criterion from the Crawford-Ferguson
({help rotate##CF1970:1970}) family be used
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
({help rotate##B1977:Bentler 1977}) be used.

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


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bg2}{p_end}
{phang2}{cmd:. factor bg2cost1-bg2cost6, factors(2)}

{pstd}Perform varimax rotation, the default{p_end}
{phang2}{cmd:. rotate}

{pstd}Perform oblique promax rotation with promax power equal to 2{p_end}
{phang2}{cmd:. rotate, oblique promax(2)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:rotate} adds stored results named {cmd:e(r_}{it:name}{cmd:)} to the stored
results that were already defined by {cmd:factor} or {cmd:pca}.

{pstd}
{cmd:rotate} adds to the following results:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:e(r_f)}}number of factors/components in rotated solution{p_end}
{synopt:{cmd:e(r_fmin)}}rotation criterion value{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:e(r_class)}}{cmd:orthogonal} or {cmd:oblique}{p_end}
{synopt:{cmd:e(r_criterion)}}rotation criterion{p_end}
{synopt:{cmd:e(r_ctitle)}}title for rotation{p_end}
{synopt:{cmd:e(r_normalization)}}{cmd:kaiser} or {cmd:none}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:e(r_L)}}rotated loadings{p_end}
{synopt:{cmd:e(r_T)}}rotation{p_end}
{synopt:{cmd:e(r_Phi)}}correlations between common factors (after {cmd:factor} only){p_end}
{synopt:{cmd:e(r_Ev)}}explained variance by common factors ({cmd:factor}) or rotated components ({cmd:pca}){p_end}

{pstd}
The factors/components in the rotated solution are in decreasing order of
{cmd:e(r_Ev)}.
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
