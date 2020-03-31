{smcl}
{* *! version 1.0.7  04oct2018}{...}
{viewerdialog "fmm: ivregress" "dialog fmm, message(-ivregress-)"}{...}
{vieweralsosee "[FMM] fmm: ivregress" "mansection FMM fmmivregress"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_ivregress##syntax"}{...}
{viewerjumpto "Menu" "fmm_ivregress##menu"}{...}
{viewerjumpto "Description" "fmm_ivregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_ivregress##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_ivregress##remarks"}{...}
{viewerjumpto "Examples" "fmm_ivregress##examples"}{...}
{viewerjumpto "Stored results" "fmm_ivregress##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col :{bf:[FMM] fmm: ivregress} {hline 2}}Finite mixtures of linear
regression models with endogenous covariates{p_end}
{p2col:}({mansection FMM fmmivregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:ivregress} {depvar}
         [{help varlist:{it:varlist_1}}]
	{cmd:(}{it:varlist_2} {cmd:=} {it:varlist_iv}{cmd:)}
	{bind:[{cmd:,} {it:options}]}


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm ivregress##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_ivregress##fmmopts:fmmopts}}]{cmd::}
	{cmd:ivregress} {depvar}
	[{help varlist:{it:varlist_1}}]
	{cmd:(}{it:varlist_2} {cmd:=} {it:varlist_iv}{cmd:)}
	[{cmd:,} {it:options}]


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:varlist_1} and {it:varlist_iv} may contain factor variables;
see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar}, {it:varlist_1}, and {it:varlist_iv} may contain
time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see 
{help ivregress##options:{it:Options}} in {manhelp ivregress R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Continuous outcomes > Linear regression with endogenous covariates}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: ivregress} fits mixtures of linear regression models with
endogenous covariates;
see {manhelp fmm FMM} and {manhelp ivregress R} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection FMM fmmintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
For a general introduction to finite mixture models, see
{manlink FMM fmm intro}.
For general information about linear regression, see {manhelp ivregress R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fmm_hsng2}{p_end}

{pstd}Mixture of two regression models with endogenous covariate {cmd:hsngval}{p_end}
{phang2}{cmd:. fmm 2: ivregress rent pcturban (hsngval = faminc)}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
