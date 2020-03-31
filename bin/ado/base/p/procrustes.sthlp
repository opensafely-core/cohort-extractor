{smcl}
{* *! version 1.2.2  19oct2017}{...}
{viewerdialog procrustes "dialog procrustes"}{...}
{vieweralsosee "[MV] procrustes" "mansection MV procrustes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] procrustes postestimation" "help procrustes postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] ca" "help ca"}{...}
{vieweralsosee "[MV] mvreg" "help mvreg"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{vieweralsosee "[MV] rotate" "help rotate"}{...}
{viewerjumpto "Syntax" "procrustes##syntax"}{...}
{viewerjumpto "Menu" "procrustes##menu"}{...}
{viewerjumpto "Description" "procrustes##description"}{...}
{viewerjumpto "Links to PDF documentation" "procrustes##linkspdf"}{...}
{viewerjumpto "Options" "procrustes##options"}{...}
{viewerjumpto "Remarks" "procrustes##remarks"}{...}
{viewerjumpto "Examples" "procrustes##examples"}{...}
{viewerjumpto "Stored results" "procrustes##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MV] procrustes} {hline 2}}Procrustes transformation
{p_end}
{p2col:}({mansection MV procrustes:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}{cmd:procrustes}
{cmd:(}{it:{help varlist:varlist_y}}{cmd:)}
{cmd:(}{it:{help varlist:varlist_x}}{cmd:)}
{ifin}
[{it:{help procrustes##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{cmdab:tr:ansform:(}{cmdab:or:thogonal}{cmd:)}}orthogonal rotation and
	reflection transformation; the default{p_end}
{synopt:{cmdab:tr:ansform:(}{cmdab:ob:lique}{cmd:)}}oblique rotation
	transformation{p_end}
{synopt:{cmdab:tr:ansform:(}{cmdab:un:restricted}{cmd:)}}unrestricted
	transformation{p_end}
{synopt:{opt nocons:tant}}suppress the constants{p_end}
{synopt:{opt norh:o}}suppress the dilation factor rho (set rho=1){p_end}
{synopt:{opt force}}allow overlap and duplicates in
        {it:{help varlist:varlist_y}} and {it:varlist_x} (advanced){p_end}

{syntab:Reporting}
{synopt:{opt nofi:t}}suppress table of fit statistics by target variable{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, and {cmd:statsby} are
allowed; see {help prefix}.
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s and {cmd:fweight}s are allowed; see {help weights}.
{p_end}
{p 4 6 2}
See {manhelp procrustes_postestimation MV:procrustes postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Procrustes transformations}


{marker description}{...}
{title:Description}

{pstd}
{cmd:procrustes} performs the Procrustean analysis, a standard method of
multidimensional scaling in which the goal is to transform the source varlist
to be as close as possible to the target varlist.  Closeness is measured by
the residual sum of squares.  The permitted transformations are any
combination of dilation (uniform scaling), rotation and reflection (that is,
orthogonal or oblique transformations), and translation.  {cmd:procrustes}
deals with complete cases only.  {cmd:procrustes} assumes equal weights or
scaling for the dimensions.  Variables measured on different scales should be
standardized before using {cmd:procrustes}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV procrustesQuickstart:Quick start}

        {mansection MV procrustesRemarksandexamples:Remarks and examples}

        {mansection MV procrustesMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opt transform(transform)}
specifies the transformation method.  The following transformation methods
are allowed:

{phang2}{opt orthogonal}
specifies that the linear transformation matrix {bf:A} should be orthogonal,
{bf:A}'{bf:A} = {bf:A}{bf:A}' = {bf:I}.  This is the default.

{phang2}{opt oblique}
specifies that the linear transformation matrix {bf:A} should be oblique,
diag({bf:A}{bf:A}') = {bf:1}.

{phang2}{opt unrestricted}
applies no restrictions to {bf:A}, making the {cmd:procrustes} transformation
equivalent to multivariate regression with uncorrelated errors; see
{manhelp mvreg MV}.

{phang}{opt noconstant}
specifies that the translation component {bf:c} is fixed at {bf:0}
(the 0 vector).

{phang}{opt norho}
specifies that the dilation (scaling) constant rho is fixed at 1.
This option is not relevant with {cmd:transform(unrestricted)};
here rho is always fixed at 1.

{phang}{opt force},
an advanced option,
allows overlap and duplicates in the target variables 
{it:{help varlist:varlist_y}} and source variables {it:varlist_x}.

{dlgtab:Reporting}

{phang}{opt nofit}
suppresses the table of fit statistics per target variable.  This option may
be specified during estimation and upon replay.


{marker remarks}{...}
{title:Remarks}

{pstd}
Formally, {cmd:procrustes} solves the minimization problem

{pin2}
Minimize {space 1}  | {bf:Y} - ({bf:1} {bf:c}' + rho {bf:X} {bf:A}) |

{pstd}
where {bf:c} is a row vector representing the translation; rho is the
scalar "dilation factor"; {bf:A} is the rotation and reflection matrix
(orthogonal, oblique, or unrestricted); and |.| denotes the L2 norm.

{pstd}
The number of source ({bf:X}) variables should not exceed the number of target
({bf:Y}) variables for the orthogonal transformation.  {cmd:procrustes} deals
with complete cases only.  Efficient algorithms for the "partial Procrustes
problem" in which some elements of the target variables are missing are still
under development.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse speed_survey}

{pstd}Procrustes transformation{p_end}
{phang2}{cmd:. procrustes (survey_x survey_y) (speed_x speed_y)}

{pstd}Same as above, but omit dilation factor{p_end}
{phang2}{cmd:. procrustes (survey_x survey_y) (speed_x speed_y), norho}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:procrustes} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(rho)}}dilation factor{p_end}
{synopt:{cmd:e(P)}}Procrustes statistic{p_end}
{synopt:{cmd:e(ss)}}total sum of squares, summed over all y variables{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares, summed over all y variables{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(urmse)}}root mean squared error (unadjusted for # of estimated
parameters){p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(ny)}}number of y variables (target variables){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:procrustes}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(ylist)}}y variables (target variables){p_end}
{synopt:{cmd:e(xlist)}}x variables (source variables){p_end}
{synopt:{cmd:e(transform)}}{cmd:orthogonal}, {cmd:oblique}, or
{cmd:unrestricted}{p_end}
{synopt:{cmd:e(uniqueA)}}{cmd:1} if rotation is unique, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(properties)}}{cmd:nob noV}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(c)}}translation vector{p_end}
{synopt:{cmd:e(A)}}orthogonal transformation matrix{p_end}
{synopt:{cmd:e(ystats)}}matrix containing fit statistics{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
