{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: tpoisson" "dialog fmm, message(-tpoisson-)"}{...}
{vieweralsosee "[FMM] fmm: tpoisson" "mansection FMM fmmtpoisson"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[R] tpoisson" "help tpoisson"}{...}
{viewerjumpto "Syntax" "fmm_tpoisson##syntax"}{...}
{viewerjumpto "Menu" "fmm_tpoisson##menu"}{...}
{viewerjumpto "Description" "fmm_tpoisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_tpoisson##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_tpoisson##remarks"}{...}
{viewerjumpto "Examples" "fmm_tpoisson##examples"}{...}
{viewerjumpto "Stored results" "fmm_tpoisson##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col :{bf:[FMM] fmm: tpoisson} {hline 2}}Finite mixtures of truncated
Poisson regression models{p_end}
{p2col:}({mansection FMM fmmtpoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:tpoisson} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm tpoisson##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_tpoisson##fmmopts:fmmopts}}]{cmd::} {cmd:tpoisson}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{cmd:ll(}{varname}|{it:#}{cmd:)}}truncation point; default value is
	{cmd:ll(0)}, zero truncation{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e})
in model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in
model with coefficient constrained to 1{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help tpoisson##options:{it:Options}} in {manhelp tpoisson R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Count outcomes > Truncated Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: tpoisson} fits mixtures of truncated Poisson regression models;
see {manhelp fmm FMM} and {manhelp tpoisson R} for details.


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
For general information about Poisson regression, see {manhelp tpoisson R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse runshoes}{p_end}

{pstd}Mixture of two truncated poisson regression models with default lower 
truncation limit 0{p_end}
{phang2}{cmd:. fmm 2: tpoisson shoes distance i.male age}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
