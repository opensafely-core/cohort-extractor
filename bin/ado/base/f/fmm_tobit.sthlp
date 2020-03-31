{smcl}
{* *! version 1.0.5  04oct2018}{...}
{viewerdialog "fmm: tobit" "dialog fmm, message(-tobit-)"}{...}
{vieweralsosee "[FMM] fmm: tobit" "mansection FMM fmmtobit"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[R] tobit" "help tobit"}{...}
{viewerjumpto "Syntax" "fmm_tobit##syntax"}{...}
{viewerjumpto "Menu" "fmm_tobit##menu"}{...}
{viewerjumpto "Description" "fmm_tobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_tobit##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_tobit##remarks"}{...}
{viewerjumpto "Example" "fmm_tobit##example"}{...}
{viewerjumpto "Stored results" "fmm_tobit##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col :{bf:[FMM] fmm: tobit} {hline 2}}Finite mixtures of tobit regression
models{p_end}
{p2col:}({mansection FMM fmmtobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:tobit} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm tobit##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_tobit##fmmopts:fmmopts}}]{cmd::} {cmd:tobit}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{cmd:ll}[{cmd:(}{varname}|{it:#}{cmd:)}]}left-censoring
variable or limit{p_end}
{synopt :{cmd:ul}[{cmd:(}{varname}|{it:#}{cmd:)}]}right-censoring
variable or limit{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in
model with coefficient constrained to 1{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlists}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help tobit##options:{it:Options}} in {manhelp tobit R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Continuous outcomes > Tobit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: tobit} fits mixtures of tobit regression models;
see {manhelp fmm FMM} and {manhelp tobit R} for details.


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
For general information about tobit regression, see {manhelp tobit R}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gpa}{p_end}

{pstd}Mixture of two tobit regression models{p_end}
{phang2}{cmd:. fmm 2: tobit gpa2 hsgpa pincome program, ll}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
