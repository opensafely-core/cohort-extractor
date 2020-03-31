{smcl}
{* *! version 1.0.7  04oct2018}{...}
{viewerdialog "fmm: regress" "dialog fmm, message(-regress-)"}{...}
{vieweralsosee "[FMM] fmm: regress" "mansection FMM fmmregress"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfmmexrega}{...}
{findalias asfmmexregb}{...}
{findalias asfmmexregc}{...}
{findalias asfmmexregd}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_regress##syntax"}{...}
{viewerjumpto "Menu" "fmm_regress##menu"}{...}
{viewerjumpto "Description" "fmm_regress##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_regress##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_regress##remarks"}{...}
{viewerjumpto "Examples" "fmm_regress##examples"}{...}
{viewerjumpto "Stored results" "fmm_regress##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col :{bf:[FMM] fmm: regress} {hline 2}}Finite mixtures of linear
regression models{p_end}
{p2col:}({mansection FMM fmmregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:regress} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm regress##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_regress##fmmopts:fmmopts}}]{cmd::} {cmd:regress}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


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
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help regress##options:{it:Options}} in {manhelp regress R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Continuous outcomes > Linear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: regress} fits mixtures of linear regression models;
see {manhelp fmm FMM} and {manhelp regress R} for details.


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
For general information about linear regression, see {manhelp regress R}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stamp}{p_end}

{pstd}Mixture of three normal distributions of {cmd:thickness}{p_end}
{phang2}{cmd:. fmm 3: regress thickness}{p_end}

{pstd}Estimated probabilities of membership in the three classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mus03sub}{p_end}

{pstd}Mixture of three linear regression models{p_end}
{phang2}{cmd:. fmm 3: regress lmedexp income c.age##c.age totchr i.sex}{p_end}

{pstd}Include {cmd:totchr} as a predictor of class membership{p_end}
{phang2}{cmd:. fmm 3, lcprob(totchr): regress lmedexp income c.age##c.age totchr i.sex}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
