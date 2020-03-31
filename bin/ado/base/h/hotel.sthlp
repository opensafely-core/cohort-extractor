{smcl}
{* *! version 1.2.8  19oct2017}{...}
{viewerdialog hotelling "dialog hotelling"}{...}
{vieweralsosee "[MV] hotelling" "mansection MV hotelling"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{vieweralsosee "[MV] mvtest means" "help mvtest_means"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "hotel##syntax"}{...}
{viewerjumpto "Menu" "hotel##menu"}{...}
{viewerjumpto "Description" "hotel##description"}{...}
{viewerjumpto "Links to PDF documentation" "hotel##linkspdf"}{...}
{viewerjumpto "Options" "hotel##options"}{...}
{viewerjumpto "Examples" "hotel##examples"}{...}
{viewerjumpto "Stored results" "hotel##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MV] hotelling} {hline 2}}Hotelling's T-squared generalized means
test{p_end}
{p2col:}({mansection MV hotelling:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmd:hotelling} {varlist} {ifin} 
[{it:{help hotelling##weight:weight}}]
[{cmd:,} {opth by(varname)} {opt not:able}]

{marker weight}{...}
{pstd}
{cmd:aweight}s and {cmd:fweight}s are allowed; see {help weights}.

{pstd}
Note: {cmd:hotel} is a synonym for {cmd:hotelling}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis >}
     {bf:MANOVA, multivariate regression, and related >}
     {bf:Hotelling's generalized means test}


{marker description}{...}
{title:Description}

{pstd}
{cmd:hotelling} performs Hotelling's T-squared test of whether a set of means
is zero or, alternatively, equal between two groups.

{pstd}
See {manhelp mvtest_means MV:mvtest means} for generalizations of Hotelling's
one-sample test with more general hypotheses, two-sample tests that do not
assume that the covariance matrices are the same in the two groups, and tests
with more than two groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV hotellingQuickstart:Quick start}

        {mansection MV hotellingRemarksandexamples:Remarks and examples}

        {mansection MV hotellingMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opth by(varname)} specifies a variable identifying two
groups; the test of equality of means between groups is performed.  If
{cmd:by()} is not specified, a test of means being jointly zero is performed.

{phang}{cmd:notable} suppresses printing a table of the means being compared.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse gasexp}{p_end}
{phang}{cmd:. gen diff1 = ampg1 - bmpg1}{p_end}
{phang}{cmd:. gen diff2 = ampg2 - bmpg2}{p_end}
{phang}{cmd:. hotelling diff1 diff2}{p_end}

{phang}{cmd:. webuse gasexp2, clear}{p_end}
{phang}{cmd:. hotelling mpg1 mpg2, by(additive)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:hotelling} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(k)}}number of variables{p_end}
{synopt:{cmd:r(T2)}}Hotelling's T-squared{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{p2colreset}{...}
