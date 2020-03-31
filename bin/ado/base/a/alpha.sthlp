{smcl}
{* *! version 1.2.2  19oct2017}{...}
{viewerdialog alpha "dialog alpha"}{...}
{vieweralsosee "[MV] alpha" "mansection MV alpha"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[R] icc" "help icc"}{...}
{viewerjumpto "Syntax" "alpha##syntax"}{...}
{viewerjumpto "Menu" "alpha##menu"}{...}
{viewerjumpto "Description" "alpha##description"}{...}
{viewerjumpto "Links to PDF documentation" "alpha##linkspdf"}{...}
{viewerjumpto "Options" "alpha##options"}{...}
{viewerjumpto "Examples" "alpha##examples"}{...}
{viewerjumpto "Stored results" "alpha##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[MV] alpha} {hline 2}}Compute interitem correlations
(covariances) and Cronbach's alpha{p_end}
{p2col:}({mansection MV alpha:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:alpha}
{varlist}
{ifin}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt :{opt a:sis}}take sign of each item as is{p_end}
{synopt :{opt c:asewise}}delete cases with missing values{p_end}
{synopt :{opt d:etail}}list individual interitem correlations and covariances{p_end}
{synopt :{opth g:enerate(newvar)}}save the generated scale in {it:newvar}{p_end}
{synopt :{opt i:tem}}display item-test and item-rest correlations{p_end}
{synopt :{opt l:abel}}include variable labels in output table{p_end}
{synopt :{opt m:in(#)}}must have at least {it:#} observations for inclusion{p_end}
{synopt :{opth r:everse(varlist)}}reverse signs of these variables{p_end}
{synopt :{opt s:td}}standardize items in the scale to mean 0, variance 1{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2} {opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > Cronbach's alpha}


{marker description}{...}
{title:Description}

{pstd}
{cmd:alpha} computes the interitem correlations or covariances for all
pairs of variables in {varlist} and Cronbach's alpha statistic for the
scale formed from them.  At least two variables must be specified with
{cmd:alpha}.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV alphaQuickstart:Quick start}

        {mansection MV alphaRemarksandexamples:Remarks and examples}

        {mansection MV alphaMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}{opt asis} specifies that the sense (sign) of each item be taken
as presented in the data.  The default is to determine the sense empirically 
and reverse the scorings for any that enter negatively.

{phang}{opt casewise} specifies that cases with missing values be
deleted listwise.  The default is pairwise computation of
covariances and correlations.

{phang}{opt detail} lists the individual interitem correlations and
covariances.

{phang}{opth generate(newvar)} specifies that the scale constructed
from {varlist} be saved in {it:newvar}.  Unless {opt asis} is
specified, the sense of items entering negatively is automatically reversed.
If {opt std} is also specified, the scale is constructed by using standardized
(mean 0, variance 1) values of the individual items.  Unlike most Stata
commands, {opt generate()} does not use casewise deletion.  A score is
created for every observation for which there is a response to at least one
item (one variable in {it:varlist} is not missing).  The summative score is
divided by the number of items over which the sum is calculated.

{phang}{opt item} specifies that item-test and item-rest correlations and the
effects of removing an item from the scale be displayed.  {opt item} is valid
only when more than two variables are specified in {varlist}.

{phang}{opt label} requests that the detailed output table be displayed in a
compact format that enables the inclusion of variable labels.

{phang}{opt min(#)} specifies that only cases with at least {it:#}
observations be included in the computations.  {opt casewise} is a shorthand
for {opt min(k)}, where {it:k} is the number of variables in
{varlist}.

{phang}{opth reverse(varlist)} specifies that the signs (directions)
of the variables (items) in {it:varlist} be reversed.  Any variables
specified in {opt reverse()} that are not also included in {cmd:alpha}'s
{it:varlist} are ignored.

{phang}{opt std} specifies that the items in the scale be standardized
(mean 0, variance 1) before summing.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse automiss}{p_end}

{pstd}Obtain average interitem covariance and Cronbach's alpha{p_end}
{phang2}{cmd:. alpha price headroom rep78 trunk weight length turn displ}{p_end}

{pstd}Obtain item-test and item-rest correlations and individual interitem
correlations{p_end}
{phang2}{cmd:. alpha price headroom rep78 trunk weight length turn displ, std item detail}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:alpha} stores the following in {cmd:r()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 27 2: Scalars}{p_end}
{synopt:{cmd:r(alpha)}}scale reliability coefficient{p_end}
{synopt:{cmd:r(k)}}number of items in the scale{p_end}
{synopt:{cmd:r(cov)}}average interitem covariance{p_end}
{synopt:{cmd:r(rho)}}average interitem correlation if {cmd:std} is
	specified{p_end}

{p2col 5 23 27 2: Matrices}{p_end}
{synopt:{cmd:r(Alpha)}}scale reliability coefficient{p_end}
{synopt:{cmd:r(ItemTestCorr)}}item-test correlation{p_end}
{synopt:{cmd:r(ItemRestCorr)}}item-rest correlation{p_end}
{synopt:{cmd:r(MeanInterItemCov)}}average interitem covariance{p_end}
{synopt:{cmd:r(MeanInterItemCorr)}}average interitem correlation if {cmd:std}
	is specified{p_end}

{pstd}
If the option {cmd:item} is specified, results are stored as row
matrices for the {cmd:k} subscales when one variable is removed.{p_end}
{p2colreset}{...}
