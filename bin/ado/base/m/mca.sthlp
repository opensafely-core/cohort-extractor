{smcl}
{* *! version 1.1.19  15may2018}{...}
{viewerdialog mca "dialog mca"}{...}
{vieweralsosee "[MV] mca" "mansection MV mca"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mca postestimation" "help mca postestimation"}{...}
{vieweralsosee "[MV] mca postestimation plots" "help mca postestimation plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] canon" "help canon"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{viewerjumpto "Syntax" "mca##syntax"}{...}
{viewerjumpto "Menu" "mca##menu"}{...}
{viewerjumpto "Description" "mca##description"}{...}
{viewerjumpto "Links to PDF documentation" "mca##linkspdf"}{...}
{viewerjumpto "Options" "mca##options"}{...}
{viewerjumpto "Examples" "mca##examples"}{...}
{viewerjumpto "Stored results" "mca##results"}{...}
{viewerjumpto "References" "mca##references"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[MV] mca} {hline 2}}Multiple and joint correspondence analysis
{p_end}
{p2col:}({mansection MV mca:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax for two or more categorical variables

{p 8 12 2}
{cmd:mca} {varlist} {ifin}
[{it:{help mca##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Full syntax for use with two or more categorical or crossed (stacked)
categorical variables

{p 8 16 2}
{cmd:mca} {it:speclist} {ifin}
[{it:{help mca##weight:weight}}]
[{cmd:,} {it:options}]


{marker speclist}{...}
    where

{p 12 16 2}
{it:speclist} = {it:spec} [{it:spec} ...]

{p 12 16 2}
{it:spec} = {varlist} | {cmd:(}{newvar} {cmd::} {varlist}{cmd:)}

{synoptset 25 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt sup:plementary(speclist)}}supplementary (passive) variables{p_end}
{synopt:{cmdab:meth:od(}{cmdab:b:urt)}}use the Burt matrix approach
	to MCA; the default{p_end}
{synopt:{cmdab:meth:od(}{cmdab:i:ndicator)}}use the indicator matrix
	approach to MCA{p_end}
{synopt:{cmdab:meth:od(}{cmdab:j:oint)}}perform a joint correspondence
	analysis (JCA){p_end}
{synopt:{opt dim:ensions(#)}}number of dimensions (factors, axes);
	default is {cmd:dim(2)}{p_end}
{synopt:{cmdab:norm:alize(}{cmdab:st:andard)}}display standard coordinates;
	the default{p_end}
{synopt:{cmdab:norm:alize(}{cmdab:pr:incipal)}}display principal
	coordinates{p_end}
{synopt:{opt iter:ate(#)}}maximum number of {cmd:method(joint)} iterations;
	default is {cmd:iterate(250)}{p_end}
{synopt:{opt tol:erance(#)}}tolerance for {cmd:method(joint)} convergence
	criterion; default is {cmd:tolerance(1e-5)}{p_end}
{synopt:{opt miss:ing}}treat missing values as ordinary values{p_end}
{synopt:{opt noadj:ust}}suppress the adjustment of eigenvalues
	({cmd:method(burt)} only){p_end}

{syntab:Codes}
{synopt:{cmdab:rep:ort(}{cmdab:v:ariables)}}report coding of
	crossing variables{p_end}
{synopt:{cmdab:rep:ort(}{cmdab:c:rossed)}}report coding of
	crossed variables{p_end}
{synopt:{cmdab:rep:ort(}{cmdab:a:ll)}}report coding of crossing and
	crossed variables{p_end}
{synopt:{cmdab:len:gth(}{cmdab:m:in)}}use minimal length unique codes of
        crossing variables{p_end}
{synopt:{opt len:gth(#)}}use {it:#} as coding length of crossing variables
{p_end}

{syntab:Reporting}
{synopt:{opt ddim:ensions(#)}}display {it:#} singular values;
	default is {cmd:ddim(.)} (all){p_end}
{synopt:{opth poi:nts(varlist)}}display tables for listed variables;
	default is all variables{p_end}
{synopt:{opt comp:act}}display statistics table in a compact format{p_end}
{synopt:{opt log}}display the iteration log ({cmd:method(joint)} only){p_end}
{synopt:{opt plo:t}}plot the coordinates (that is, {helpb mcaplot}){p_end}
{synopt:{opt max:length(#)}}maximum number of characters for labels in plot;
	default is {cmd:maxlength(12)}{p_end}
{synoptline}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, and {cmd:statsby}
may be used with {cmd:mca}; see {help prefix}.  However, {cmd:bootstrap} and
{cmd:jackknife} results should be interpreted with caution; identification of
the {cmd:mca} parameters involves data-dependent restrictions, possibly
leading to badly biased and overdispersed estimates
({help mca##MW1995:Milan and Whittaker 1995}).
{p_end}
{p 4 6 2}
Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.
{p_end}
{p 4 6 2}
See {manhelp mca_postestimation MV:mca postestimation} for features available
after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Correspondence analysis >}
      {bf:Multiple correspondence analysis (MCA)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mca} performs multiple correspondence analysis (MCA) or joint
correspondence analysis (JCA) on a series of categorical variables.  MCA and
JCA are two generalizations of correspondence analysis (CA) of a
cross-tabulation of two variables (see {manhelp ca MV}) to the
cross-tabulation of multiple variables.

{pstd}
{cmd:mca} performs an analysis of two or more integer-valued variables.
Crossing (also called stacking) of integer-valued variables is also allowed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mcaQuickstart:Quick start}

        {mansection MV mcaRemarksandexamples:Remarks and examples}

        {mansection MV mcaMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opt supplementary(speclist)}
specifies that {it:speclist} are supplementary variables.  Such variables do
not affect the MCA solution, but their categories are mapped into the solution
space.  For {cmd:method(indicator)}, this mapping uses the first method
described by {help mca##G2006:Greenacre (2006)}.
For {cmd:method(burt)} and {cmd:method(joint)},
the second and recommended method described by 
{help mca##G2006:Greenacre (2006)} is used, in
which supplementary column principal coordinates are derived as a weighted
average of the standard row coordinates, weighted by the supplementary profile.
See the {it:{help mca##speclist:syntax diagram}} for the syntax of
{it:speclist}.

{phang}{opt method(method)}
specifies the method of MCA/JCA.

{phang2}{cmd:method(burt)},
the default, specifies MCA, a categorical
variables analogue to principal component analysis (see {manhelp pca MV}).
The Burt method performs a CA of the Burt matrix, a matrix of the two-way
cross-tabulations of all pairs of variables.

{phang2}{cmd:method(indicator)}
specifies MCA via a CA on the indicator matrix formed from the variables.

{phang2}{cmd:method(joint)}
specifies JCA, a categorical variables
analogue to factor analysis (see {manhelp factor MV}).  This method analyzes
a variant of the Burt matrix, in which the diagonal blocks are iteratively
adjusted for the poor diagonal fit of MCA.

{phang}{opt dimensions(#)}
specifies the number of dimensions (= factors = axes) to be extracted.  The
default is {cmd:dimensions(2)}.  If you specify {cmd:dimensions(1)}, the
categories are placed on one dimension.  The number of dimensions
is no larger than the number of categories in the active variables (regular and
crossed) minus the number of active variables, and it can be less.  This
excludes supplementary variables.  Specifying a larger number than
dimensions available results in extracting all dimensions.

{pmore}
MCA is a hierarchical method so that extracting more dimensions does not
affect the coordinates and decomposition of inertia of dimensions already
included.  The percentages of inertia accounting for the dimensions are in
decreasing order as indicated by the singular values.  The first dimension
accounts for the most inertia, followed by the second dimension, and then the
third dimension, etc.

{phang}{opt normalize(normalization)} specifies the normalization method, that
is, how the row and column coordinates are obtained from the singular vectors
and singular values of the matrix of standardized residuals.

{phang2}{cmd:normalize(standard)}
specifies that coordinates are returned in standard normalization
(singular values divided by the square root of the mass).  This is the default.

{phang2}{cmd:normalize(principal)}
specifies that coordinates are returned in principal normalization.
Principal coordinates are standard coordinates multiplied by the square
root of the corresponding principal inertia.

{phang}{opt iterate(#)}
is a technical and rarely used option specifying the maximum number of
iterations.  {cmd:iterate()} is permitted only with {cmd:method(joint)}.  The
default is {cmd:iterate(250)}.

{phang}{opt tolerance(#)}
is a technical and rarely used option specifying the tolerance for
subsequent modification of the diagonal blocks of the Burt matrix.
{cmd:tolerance()} is permitted only with {cmd:method(joint)}.  The default is
{cmd:tolerance(1e-5)}.

{phang}{opt missing}
treats missing values as ordinary values to be
included in the analysis.  Observations with missing values are omitted from
the analysis by default.

{phang}{opt noadjust} suppresses principal inertia adjustment and
is allowed with {cmd:method(burt)} only.  By default, the principal inertias
(eigenvalues of the Burt matrix) are adjusted.  The unmodified principal
inertias present a pessimistic measure of fit because MCA fits the diagonal
of P poorly (see {help mca##G1984:Greenacre [1984]}).

{dlgtab:Codes}

{phang}{opt report(opt)} displays coding information for the crossing
variables, crossed variables, or both.  {cmd:report()} is ignored if you do
not specify at least one crossed variable.

{phang2}
{cmd:report(variables)} displays the coding schemes of the crossing variables,
that is, the variables used to define the crossed variables.

{phang2}
{cmd:report(crossed)} displays a table explaining the value labels of the
crossed variables.

{phang2}
{cmd:report(all)} displays the codings of the crossing and crossed variables.

{phang}{opt length(opt)}
specifies the coding length of crossing variables.

{phang2}{cmd:length(min)}
specifies that the minimal-length unique codes of crossing variables be used.

{phang2}{opt length(#)}
specifies that the coding length {it:#} of crossing variables be used, where
{it:#} must be between 4 and 32.

{dlgtab:Reporting}

{phang}{opt ddimensions(#)}
specifies the number of singular values to be displayed.  If
{cmd:ddimensions()} is greater than the number of singular values, all the
singular values will be displayed.  The default is {cmd:ddimensions(.)},
meaning all singular values.

{phang}{opth points(varlist)}
indicates the variables to be included in the tables.  By default, tables are
displayed for all variables.  Regular categorical variables, crossed
variables, and supplementary variables may be specified in {opt points()}.

{phang}{opt compact}
specifies that point statistics tables be displayed multiplied by
1,000, enabling the display of more columns without wrapping output.  The
compact tables can be displayed without wrapping for models with two
dimensions at line size 79 and with three dimensions at line size 99.

{phang}{opt log}
displays an iteration log.  This option is permitted with {cmd:method(joint)}
only.

{phang}{opt plot}
displays a plot of the row and column coordinates in two dimensions.  Use
{cmd:mcaplot} directly to select different plotting points or for other
graph refinements; see
{manhelp mca_postestimation_plots MV:mca postestimation plots}.

{phang}{opt maxlength(#)}
specifies the maximum number of characters for labels in plots.
The default is {cmd:maxlength(12)}. {it:#} must be less than 32.

{pstd}
Note: The reporting options may be specified during estimation or replay.


{marker examples}{...}
{title:Examples}

{pstd}
By default MCA analyzes the Burt matrix of cross-tabulations of the data and
performs adjustments on the principal inertias.

{phang2}{cmd:. webuse issp93a}{p_end}
{phang2}{cmd:. mca A B C D}{p_end}

{pstd}
Other methods are available with {cmd:mca}. {cmd:method(indicator)}
is equivalent to analyzing the indicator matrix of the data.  We
extract three dimensions and display output in compact form.

{phang2}{cmd:. mca A B C D, method(indicator) dim(3) compact}{p_end}

{pstd}{cmd:method(joint)} performs joint correspondence analysis.
Here a crossed supplementary variable, {cmd:demo}, with the demographic
information on gender and education, is added.  Supplementary variables do not
affect the estimation results.

{phang2}{cmd:. mca A B C D, method(joint) supp((demo: sex edu))}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mca} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(f)}}number of dimensions{p_end}
{synopt:{cmd:e(inertia)}}total inertia{p_end}
{synopt:{cmd:e(ev_unique)}}{cmd:1} if all eigenvalues are distinct, {cmd:0}
	otherwise{p_end}
{synopt:{cmd:e(adjust)}}{cmd:1} if eigenvalues are adjusted, {cmd:0}
	otherwise ({cmd:method(burt)} only){p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if successful convergence, {cmd:0} otherwise
	({cmd:method(joint)} only){p_end}
{synopt:{cmd:e(iter)}}number of iterations ({cmd:method(joint)} only){p_end}
{synopt:{cmd:e(inertia_od)}}proportion of off-diagonal inertia explained by the
	extracted dimensions ({cmd:method(joint)} only){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mca}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(names)}}names of MCA variables (crossed or actual){p_end}
{synopt:{cmd:e(supp)}}names of supplementary variables{p_end}
{synopt:{cmd:e(defs)}}per crossed variable: crossing variables separated by
	"{cmd:\}"{p_end}
{synopt:{cmd:e(missing)}}{cmd:missing}, if specified{p_end}
{synopt:{cmd:e(crossed)}}{cmd:1} if there are crossed variables, {cmd:0}
	otherwise{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in output{p_end}
{synopt:{cmd:e(method)}}{cmd:burt}, {cmd:indicator}, or {cmd:joint}{p_end}
{synopt:{cmd:e(norm)}}{cmd:standard} or {cmd:principal}{p_end}
{synopt:{cmd:e(properties)}}{cmd:nob noV eigen}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(Coding}{it:#}{cmd:)}}row vector with coding of variable {it:#}{p_end}
{synopt:{cmd:e(A)}}standard coordinates for column categories{p_end}
{synopt:{cmd:e(F)}}principal coordinates for column categories{p_end}
{synopt:{cmd:e(cMass)}}column mass{p_end}
{synopt:{cmd:e(cDist)}}distance column to centroid{p_end}
{synopt:{cmd:e(cInertia)}}column inertia{p_end}
{synopt:{cmd:e(cGS)}}general statistics of column categories{p_end}
{synopt:}[.,1]{space 5}column mass{p_end}
{synopt:}[.,2]{space 5}overall quality{p_end}
{synopt:}[.,3]{space 5}inertia/sum(inertia){p_end}
{synopt:}[.,3*f+1] dim f: coordinate in e(norm) normalization{p_end}
{synopt:}[.,3*f+2] dim f: contribution of the profiles to principal axes{p_end}
{synopt:}[.,3*f+3] dim f: contribution of principal axes to profiles{p_end}
{synopt:}{space 7}(= squared correlation of profile and axes){p_end}
{synopt:{cmd:e(rSCW)}}weight matrix for row standard coordinates{p_end}
{synopt:{cmd:e(Ev)}}principal inertias/eigenvalues{p_end}
{synopt:{cmd:e(inertia_e)}}explained inertia (percent){p_end}
{synopt:{cmd:e(Bmod)}}modified Burt matrix of active variables
	({cmd:method(joint)} only){p_end}
{synopt:{cmd:e(inertia_sub)}}variable-by-variable inertias ({cmd:method(joint)}
	only){p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{marker references}{...}
{title:References}

{marker G1984}{...}
{phang}
Greenacre, M. J. 1984.
{it:Theory and Applications of Correspondence Analysis}.
London: Academic Press.

{marker G2006}{...}
{phang}
------. 2006.
From simple to multiple correspondence analysis. In
{it:Multiple Correspondence Analysis and Related Methods}, ed.
M. Greenacre and J. Blasius.  Boca Raton, FL: Chapman & Hall/CRC.

{marker MW1995}{...}
{phang}
Milan, L., and J. Whittaker. 1995. Application of the parametric bootstrap
to models that incorporate a singular value decomposition.
{it:Applied Statistics} 44: 31-49.
{p_end}
