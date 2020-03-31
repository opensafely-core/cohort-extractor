{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: pointmass" "dialog fmm, message(-pointmass-)"}{...}
{vieweralsosee "[FMM] fmm: pointmass" "mansection FMM fmmpointmass"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfmmexzip}{...}
{findalias asfmmexsurv}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[R] zinb" "help zinb"}{...}
{vieweralsosee "[R] zioprobit" "help zioprobit"}{...}
{vieweralsosee "[R] zip" "help zip"}{...}
{viewerjumpto "Syntax" "fmm_pointmass##syntax"}{...}
{viewerjumpto "Menu" "fmm_pointmass##menu"}{...}
{viewerjumpto "Description" "fmm_pointmass##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_pointmass##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_pointmass##remarks"}{...}
{viewerjumpto "Examples" "fmm_pointmass##examples"}{...}
{viewerjumpto "Stored results" "fmm_pointmass##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col :{bf:[FMM] fmm: pointmass} {hline 2}}Finite mixtures models with a
density mass at a single point{p_end}
{p2col:}({mansection FMM fmmpointmass:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:fmm} {ifin}
[{help fmm pointmass##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_pointmass##fmmopts:fmmopts}}]{cmd::}
{cmd:(pointmass} {depvar} [{cmd:,} {it:options}]{cmd:)} 
{cmd:(}{it:component_1}{cmd:)}
[{cmd:(}{it:component_2}{cmd:)} ...]

{pstd}
{it:component} is defined in {manhelp fmm FMM}.

{synoptset 26}{...}
{synopthdr}
{synoptline}
{synopt :{opth lcp:rob(varlist)}}specify independent variables for class
probability{p_end}
{synopt :{opt value(#)}}integer-valued location of the point mass{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:depvar} may contain time-series operators; see {help tsvarlist}.{p_end}

{synoptset 26 tabbed}{...}
INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > General estimation and regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: pointmass} is a degenerate distribution that takes on
a single integer value with probability one.  This distribution cannot
be used by itself and is always combined with other {cmd:fmm}
distributions, often to model zero-inflated outcomes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection FMM fmmintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth lcprob(varlist)} specifies that the linear prediction for belonging to
the point mass component includes the variables in {it:varlist}.
{opt lcinvariant()} has no effect on these parameters.

{phang}
{opt value(#)} specifies the value of {depvar} at which the latent class has a
singular point mass. The default is {cmd:value(0)}.
Only integer values are allowed for {it:#}.


{marker remarks}{...}
{title:Remarks}

{pstd}
For a general introduction to finite mixture models, see
{manlink FMM fmm intro}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fish2}{p_end}

{pstd}Zero-inflated Poisson model as a mixture of a point mass distribution at
zero and a Poisson regression model{p_end}
{phang2}{cmd:. fmm: (pointmass count) (poisson count persons boat)}{p_end}

{pstd}Include {cmd:child} and {cmd:camper} as predictors of membership for
the point mass component{p_end}
{phang2}{cmd:. fmm: (pointmass count, lcprob(child camper)) (poisson count persons boat)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lenses}{p_end}
{phang2}{cmd:. stset t, failure(fail)}{p_end}

{pstd}Cure model as a mixture of a point mass distribution at
zero and a Weibull survival model{p_end}
{phang2}{cmd:. fmm: (pointmass fail) (streg inclength i.sex age10, distribution(weibull))}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
