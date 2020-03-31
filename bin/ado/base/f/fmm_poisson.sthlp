{smcl}
{* *! version 1.0.5  04oct2018}{...}
{viewerdialog "fmm: poisson" "dialog fmm, message(-poisson-)"}{...}
{vieweralsosee "[FMM] fmm: poisson" "mansection FMM fmmpoisson"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfmmexpoisson}{...}
{findalias asfmmexzip}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_poisson##syntax"}{...}
{viewerjumpto "Menu" "fmm_poisson##menu"}{...}
{viewerjumpto "Description" "fmm_poisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_poisson##linkspdf"}{...}
{viewerjumpto "Remarks " "fmm_poisson##remarks"}{...}
{viewerjumpto "Example" "fmm_poisson##example"}{...}
{viewerjumpto "Stored results" "fmm_poisson##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col :{bf:[FMM] fmm: poisson} {hline 2}}Finite mixtures of Poisson
regression models{p_end}
{p2col:}({mansection FMM fmmpoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:poisson} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm poisson##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_poisson##fmmopts:fmmopts}}]{cmd::} {cmd:poisson}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
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
{help poisson##options:{it:Options}} in {manhelp poisson R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Count outcomes > Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: poisson} fits mixtures of Poisson regression models;
see {manhelp fmm FMM} and {manhelp poisson R} for details.


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
For general information about Poisson regression, see {manhelp poisson R}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_mixture}{p_end}

{pstd}Mixture of two Poisson regression models{p_end}
{phang2}{cmd:. fmm 2: poisson drvisits private medicaid c.age##c.age actlim chronic}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
