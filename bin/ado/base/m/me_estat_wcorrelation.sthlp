{smcl}
{* *! version 1.0.5  13feb2019}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[ME] estat wcorrelation" "mansection ME estatwcorrelation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{viewerjumpto "Syntax" "me estat wcorrelation##syntax"}{...}
{viewerjumpto "Menu for estat" "me estat wcorrelation##menu_estat"}{...}
{viewerjumpto "Description" "me estat wcorrelation##description"}{...}
{viewerjumpto "Links to PDF documentation" "me_estat_wcorrelation##linkspdf"}{...}
{viewerjumpto "Options" "me estat wcorrelation##option_estat_wcorrelation"}{...}
{viewerjumpto "Examples" "me estat wcorrelation##examples"}{...}
{viewerjumpto "Stored results" "me estat wcorrelation##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[ME] estat wcorrelation} {hline 2}}Display within-cluster
correlations and standard deviations{p_end}
{p2col:}({mansection ME estatwcorrelation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {opt wcor:relation} [{cmd:,} {it:options}]

{marker options_estat_wcorrelation}{...}
{synoptset 18}{...}
{synopthdr :options}
{synoptline}
{synopt :{opt at(at_spec)}}specify the cluster for which you want the
	correlation matrix; default is the first two-level cluster
	encountered in the data{p_end}
{synopt:{opt all}}display correlation matrix for all the data{p_end}
{synopt:{opt cov:ariance}}display the covariance matrix instead of the
	correlation matrix{p_end}
{synopt:{opt list}}list the data corresponding to the correlation matrix{p_end}
{synopt:{opt nosort}}list the rows and columns of the correlation matrix in
	the order they were originally present in the data{p_end}
{synopt:{opt iter:ate(#)}}maximum number of iterations to compute
	random effects; default is {cmd:iterate(50)}; only for use after
	{cmd:menl}{p_end}
{synopt:{opt tol:erance(#)}}convergence tolerance when computing random
	effects; default is {cmd:tolerance(1e-6)}; only for use after
	{cmd:menl}{p_end}
{synopt:{opt nrtol:erance(#)}}scaled gradient tolerance when computing random
	effects; default is {cmd:nrtolerance(1e-5)}; only for use after
	{cmd:menl}{p_end}
{synopt:{opt nonrtol:erance}}ignore the {opt nrtolerance()} option; only for
	use after {cmd:menl}{p_end}
{synopt :{opth format(%fmt)}}set the display format; default is {cmd:format(%6.3f)}{p_end}
{synopt :{help matlist:{it:matlist_options}}}style and formatting options that control how
	matrices are displayed{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat wcorrelation} is for use after estimation with {cmd:menl} and
{cmd:mixed}.

{pstd}
{cmd:estat wcorrelation} displays the overall correlation matrix for a given
cluster calculated on the basis of the design of the random effects and their
assumed covariance and the correlation structure of the residuals.  This allows
for a comparison of different multilevel models in terms of the ultimate
within-cluster correlation matrix that each model implies.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME estatwcorrelationRemarksandexamples:Remarks and examples}

        {mansection ME estatwcorrelationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option_estat_wcorrelation}{...}
{title:Options}

{marker atspec}{...}
{phang}
{opt at(at_spec)} specifies the cluster of observations for which you want the
within-cluster correlation matrix.  {it:at_spec} is

{phang3}
{it:relevel_var} {cmd:=} {it:value}
   [{it:relevel_var} {cmd:=} {it:value} ...]

{pmore}
For example, if you specify

{phang3}
{cmd:. estat wcorrelation, at(school = 33)}

{pmore}
you get the within-cluster correlation matrix for those observations 
in school 33.  If  you specify

{phang3}
{cmd:. estat wcorrelation, at(school = 33 classroom = 4)}

{pmore}
you get the correlation matrix for classroom 4 in school 33.

{pmore}
If {cmd:at()} is not specified, then you get the correlations
for the first level-two cluster encountered in the data.  This is
usually what you want.

{phang}
{opt all} specifies that you want the correlation matrix for all 
the data.  This is not recommended unless you have a relatively small dataset
or you enjoy seeing large n x n matrices.  However, this can prove
useful in some cases.

{phang}
{opt covariance} specifies that the within-cluster covariance matrix be
displayed instead of the default correlations and standard deviations.

{phang}
{opt list} lists the model data for those observations depicted in the
displayed correlation matrix.  With linear mixed-effects models, this option
is also useful if you have many random-effects design variables and you wish
to see the represented values of these design variables.

{phang}
{opt nosort} lists the rows and columns of the correlation matrix in the order
that they were originally present in the data.  Normally,
{cmd:estat wcorrelation} will first sort the data according to level
variables, by-group variables, and time variables to produce correlation
matrices whose rows and columns follow a natural ordering.  {opt nosort}
suppresses this.

{phang}
{opt iterate(#)} specifies the maximum number of iterations when
computing estimates of the random effects.  The default is {cmd:iterate(50)}.
This option is only for use after {cmd:menl}.

{phang}
{opt tolerance(#)} specifies a convergence tolerance when computing
estimates of the random effects.  The default is {cmd:tolerance(1e-4)}.
This option is only for use after {cmd:menl}.

{phang}
{opt nrtolerance(#)} and {opt nonrtolerance} control the tolerance for
the scaled gradient  when computing estimates of the random effects.
These options are only for use after {cmd:menl}.

{phang2}
{opt nrtolerance(#)} specifies the tolerance for the scaled
gradient.  Convergence is declared when g(-H^{-1})g' is less than
{opt nrtolerance(#)}, where g is the gradient row vector and H is the
approximated Hessian matrix from the current iteration.  The default is
{cmd:nrtolerance(1e-5)}.

{phang2}
{opt nonrtolerance} specifies that the default
{opt nrtolerance()} criterion be turned off.

{phang}
{opth format(%fmt)} sets the display format for the standard-deviation vector
and correlation matrix.  The default is {cmd:format(%6.3f)}.

{phang}
{it:matlist_options} are style and formatting options that control how the
matrix (or matrices) is displayed; see {helpb matlist:[P] matlist} for
a list of options that are available.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}
{phang2}{cmd:. mixed weight week || id: week, covariance(unstructured)}{p_end}

{pstd}Random-effects correlation matrix for level ID{p_end}
{phang2}{cmd:. estat recovariance, correlation}{p_end}

{pstd}Display within-cluster marginal standard deviations and correlations
for a cluster{p_end}
{phang2}{cmd:. estat wcorrelation, format(%4.2g)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse childweight}
{p_end}
{phang2}{cmd:. mixed weight age || id: age, covariance(unstructured)}{p_end}

{pstd}Display within-cluster correlations for the first cluster{p_end}
{phang2}{cmd:. estat wcorrelation, list}{p_end}

{pstd}Display within-cluster correlations for ID 258{p_end}
{phang2}{cmd:. estat wcorrelation, at(id=258) list}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat wcorrelation} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(sd)}}standard deviations{p_end}
{synopt:{cmd:r(Corr)}}within-cluster correlation matrix{p_end}
{synopt:{cmd:r(Cov)}}within-cluster variance-covariance matrix{p_end}
{synopt:{cmd:r(G)}}variance-covariance matrix of random effects{p_end}
{synopt:{cmd:r(Z)}}model-based design matrix{p_end}
{synopt:{cmd:r(R)}}variance-covariance matrix of level-one errors{p_end}
{synopt:{cmd:r(path)}}path identifying cluster for which correlation is
reported{p_end}
{p2colreset}{...}

{pstd}
Results {cmd:r(G)}, {cmd:r(Z)}, and {cmd:r(R)} are available only after
{cmd:mixed}.  Result {cmd:r(path)} is available only after {cmd:menl}.
{p_end}
