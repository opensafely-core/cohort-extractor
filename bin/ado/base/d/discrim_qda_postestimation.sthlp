{smcl}
{* *! version 1.2.5  15may2018}{...}
{viewerdialog predict "dialog discrim_qda_p"}{...}
{viewerdialog estat "dialog discrim_qda_estat"}{...}
{vieweralsosee "[MV] discrim qda postestimation" "mansection MV discrimqdapostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim qda" "help discrim qda"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim estat" "help discrim_estat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim" "help discrim"}{...}
{viewerjumpto "Postestimation commands" "discrim qda postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "discrim_qda_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "discrim qda postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "discrim qda postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "discrim qda postestimation##examples"}{...}
{viewerjumpto "Stored results" "discrim qda postestimation##results"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[MV] discrim qda postestimation} {hline 2}}Postestimation tools
        for discrim qda
{p_end}
{p2col:}({mansection MV discrimqdapostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:discrim qda}:

{synoptset 19}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb discrim estat##syntax_estat:estat classtable}}classification
	table{p_end}
{synopt:{helpb discrim qda postestimation##syntax_estat:estat correlations}}group
	correlation matrices and p-values{p_end}
{synopt:{helpb discrim qda postestimation##syntax_estat:estat covariance}}group
	covariance matrices{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat errorrate}}classification
	error-rate estimation{p_end}
{synopt:{helpb discrim qda postestimation##syntax_estat:estat grdistances}}Mahalanobis
	and generalized squared distances between the group means{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat grsummarize}}group
	summaries{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat list}}classification
	listing{p_end}
{synopt:{helpb discrim estat##syntax_estat:estat summarize}}estimation
        sample summary{p_end}
{synoptline}

{pstd}
The following standard postestimation commands are also available:

{synoptset 19 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{p2coldent:* {helpb estimates}}cataloging estimation results{p_end}
{synopt:{helpb discrim qda postestimation##predict:predict}}group
	classification and posterior probabilities{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* All {cmd:estimates} subcommands except {opt table} and {opt stats} are
available.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV discrimqdapostestimationRemarksandexamples:Remarks and examples}

        {mansection MV discrimqdapostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar}
	{ifin} [{cmd:,} {it:statistic} {it:options}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
	{ifin} [{cmd:,} {it:statistic} {it:options}]

{synoptset 18 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt c:lassification}}group membership classification; the default
	with one variable specified and {cmd:group()} not specified{p_end}
{synopt:{opt pr}}probability of group membership; the default when
	{cmd:group()} is specified or when multiple variables are
	specified{p_end}
{synopt:{opt mah:alanobis}}Mahalanobis squared distance between observations
	and groups{p_end}
{synopt:{opt clsc:ore}}group classification function score{p_end}
{p2coldent:* {opt looc:lass}}leave-one-out group membership classification;
may be used only when one new variable is specified{p_end}
{p2coldent:* {opt loop:r}}leave-one-out probability of group membership{p_end}
{p2coldent:* {opt loom:ahal}}leave-one-out Mahalanobis squared distance between
	observations and groups{p_end}
{synoptline}

{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt g:roup(group)}}the group for which the statistic is
        to be calculated{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_qda_postestimation##priors:priors)}}group prior
         probabilities; defaults to {cmd:e(grouppriors)}{p_end}
{synopt:{opth tie:s(discrim_qda_postestimation##ties:ties)}}how ties in
         classification are to be handled; defaults to {cmd:e(ties)}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help discrim_optsp

{p 4 6 2}
You specify one new variable with {opt classification} or {opt looclass} and
specify either one or {cmd:e(N_groups)} new variables with {opt pr},
{opt loopr}, {opt mahalanobis}, {opt loomahal}, or {opt clscore}.
{p_end}
{p 4 6 2}
Unstarred statistics are available both in and out of sample;
type {cmd:predict ... if e(sample) ...} if wanted only for the estimation
sample.  Starred statistics are calculated only for the estimation sample,
even when {cmd:if e(sample)} is not specified.
{p_end}
{p 4 6 2}
{opt group()} is not allowed with {opt classification} or {opt looclass}.
{p_end}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
group classifications, probabilities, Mahalanobis squared distances,
leave-one-out group classifications,
leave-one-out probabilities,
and leave-one-out Mahalanobis squared distances.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt classification},
the default, calculates the group classification.  Only one new variable may
be specified.

{phang}
{opt pr}
calculates group membership posterior probabilities.  If you specify the
{opt group()} option, specify one new variable.  Otherwise, you must specify
{cmd:e(N_groups)} new variables.

{phang}
{opt mahalanobis}
calculates the squared Mahalanobis distance between the observations and group
means.  If you specify the {opt group()} option, specify one new variable.
Otherwise, you must specify {cmd:e(N_groups)} new variables.

{phang}
{opt clscore}
produces the group classification function score.  If you specify the
{opt group()} option, specify one new variable.  Otherwise, you must specify
{cmd:e(N_groups)} new variables.

{phang}
{opt looclass}
calculates the leave-one-out group classifications.  Only one new variable may
be specified.  Leave-one-out calculations are restricted to {cmd:e(sample)}
observations.

{phang}
{opt loopr}
calculates the leave-one-out group membership posterior probabilities.  If you
specify the {opt group()} option, specify one new variable.  Otherwise, you
must specify {cmd:e(N_groups)} new variables.  Leave-one-out calculations are
restricted to {cmd:e(sample)} observations.

{phang}
{opt loomahal}
calculates the leave-one-out squared Mahalanobis distance between the
observations and group means.  If you specify the {opt group()} option,
specify one new variable.  Otherwise, you must specify {cmd:e(N_groups)} new
variables.  Leave-one-out calculations are restricted to {cmd:e(sample)}
observations.

{phang}
{opt group(group)}
specifies the group for which the statistic is to be calculated
and can be specified using

{pin2}
{cmd:#1}, {cmd:#2}, ..., where {cmd:#1} means the first category of
the {cmd:e(groupvar)} variable, {cmd:#2} the second category, etc.; 

{pin2}
the values of the {cmd:e(groupvar)} variable; or 

{pin2}
the value labels of the {cmd:e(groupvar)} variable if they exist.

{pmore}
{cmd:group()} is not allowed with {cmd:classification} or {cmd:looclass}.

{marker priorsdesc}{...}
{dlgtab:Options}

INCLUDE help discrim_priorsp


{marker estatcorr}{marker estatcov}{marker estatgrdist}{...}
{marker syntax_estat}{...}
{title:Syntax for estat}

{pstd}Group correlation matrices and p-values

{p 8 25 2}
	{cmd:estat} {opt cor:relations} [{cmd:,}
    {it:{help discrim_qda_postestimation##correlations_options:correlations_options}}]


{pstd}Group covariance matrices

{p 8 25 2}
	{cmd:estat} {opt cov:ariance} [{cmd:,}
    {it:{help discrim_qda_postestimation##covariance_options:covariance_options}}]


{pstd}Mahalanobis and generalized squared distances between the group means

{p 8 25 2}
	{cmd:estat} {opt grd:istances} [{cmd:,}
    {it:{help discrim_qda_postestimation##grdistances_options:grdistances_options}}]


{marker correlations_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:correlations_options}
{synoptline}
{syntab:Main}
{synopt:{opt p}}display two-sided p-values{p_end}
{synopt:{opth for:mat(%fmt)}}numeric display format; default is
        {cmd:%9.0g}{p_end}
{synopt:{opt noha:lf}}display full matrix even if symmetric{p_end}
{synoptline}


{marker covariance_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:covariance_options}
{synoptline}
{syntab:Main}
{synopt:{opth for:mat(%fmt)}}numeric display format; default is
	{cmd:%9.0g}{p_end}
{synopt:{opt noha:lf}}display full matrix even if symmetric{p_end}
{synoptline}


{marker grdistances_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:grdistances_options}
{synoptline}
{syntab:Main}
{synopt:{opt mah:alanobis}}display Mahalanobis squared distances between group
        means; the default{p_end}
{synopt:{opt gen:eralized}}display generalized Mahalanobis squared distances
        between group means{p_end}
{synopt:{opt all}}equivalent to {cmd:mahalanobis generalized}{p_end}
{synopt:{opth for:mat(%fmt)}}numeric display format; default is
        {cmd:%9.0g}{p_end}

{syntab:Options}
{synopt:{opth pri:ors(discrim_qda_postestimation##grdist_priors:priors)}}group
	prior probabilities; defaults to {cmd:e(grouppriors)}{p_end}
{synoptline}


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat correlations} displays group correlation matrices.  Two-tailed
p-values for the correlations are also available.

{pstd}
{cmd:estat covariance} displays group covariance matrices.

{pstd}
{cmd:estat grdistances} provides Mahalanobis squared distances and generalized
squared distances between the group means.


{marker options_estat_correlations}{...}
{title:Options for estat correlations}

{dlgtab:Main}

{phang}
{opt p} specifies that two-sided p-values be computed and displayed for the
correlations.

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%8.5f)}.

{phang}
{opt nohalf} specifies that, even though the matrix is symmetric, the full
matrix be printed.  The default is to print only the lower triangle.


{marker options_estat_covariance}{...}
{title:Options for estat covariance}

{dlgtab:Main}

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%9.0g)}.

{phang}
{opt nohalf} specifies that, even though the matrix is symmetric, the full
matrix be printed.  The default is to print only the lower triangle.


{marker options_estat_grdistances}{...}
{title:Options for estat grdistances}

{dlgtab:Main}

{phang}
{opt mahalanobis} specifies that a table of Mahalanobis squared
distances between group means be presented.

{phang}
{opt generalized} specifies that a table of generalized Mahalanobis squared
distances between group means be presented.  {opt generalized} starts with
what is produced by the {opt mahalanobis} option and adds a term for the
possibly unequal covariances and a term accounting for prior probabilities.
Prior probabilities are provided with the {opt priors()} option, or if
{opt priors()} is not specified, by the values in {cmd:e(grouppriors)}.  By
common convention, if prior probabilities are equal across the groups, the
prior probability term is omitted.

{phang}
{opt all} is equivalent to specifying {cmd:mahalanobis} and {opt generalized}.

{phang}
{opth format(%fmt)} specifies the matrix display format.  The default is
{cmd:format(%9.0g)}.

{dlgtab:Options}

{marker grdist_priors}{...}
{phang}
{opt priors(priors)} specifies the group prior probabilities and affects only
the output of the {opt generalized} option.
By default, {it:priors} is determined from {cmd:e(grouppriors)}.
See {it:{help discrim_qda_postestimation##priorsdesc:Options for predict}} for
the {it:priors} specification.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rootstock}{p_end}

{pstd}Fit a quadratic discriminant analysis (QDA) model with equal prior
	probabilities for the six rootstock groups and display classification
	matrix{p_end}
{phang2}{cmd:. discrim qda y1 y2 y3 y4, group(rootstock)}{p_end}

{pstd}List true group, predicted group, and posterior probabilities for
	misclassified observations{p_end}
{phang2}{cmd:. estat list, misclassified}{p_end}

{pstd}Predict leave-one-out posterior probabilities{p_end}
{phang2}{cmd:. predict pp1 pp2 pp3 pp4 pp5 pp6, loopr}{p_end}

{pstd}Display the leave-one-out classification table{p_end}
{phang2}{cmd:. estat classtable, loo}{p_end}

{pstd}Show the Mahalanobis squared distance between the group means{p_end}
{phang2}{cmd:. estat grdistances}{p_end}

{pstd}Display the group covariance matrices{p_end}
{phang2}{cmd:. estat covariance}{p_end}

{pstd}Display the group correlation matrices with associated two-tailed
	p-values{p_end}
{phang2}{cmd:. estat correlations, p}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat correlations} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Rho_}{it:#}{cmd:)}}group {it:#} correlation matrix{p_end}
{synopt:{cmd:r(P_}{it:#}{cmd:)}}two-sided p-values for group {it:#}
        correlations{p_end}


{pstd}
{cmd:estat covariance} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(S_}{it:#}{cmd:)}}group {it:#} covariance matrix{p_end}


{pstd}
{cmd:estat grdistances} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(sqdist)}}Mahalanobis squared distances between group means
	({opt mahalanobis} only){p_end}
{synopt:{cmd:r(gsqdist)}}generalized squared distances between group means
	({opt generalized} only){p_end}
