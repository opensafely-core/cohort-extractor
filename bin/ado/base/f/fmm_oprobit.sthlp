{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: oprobit" "dialog fmm, message(-oprobit-)"}{...}
{vieweralsosee "[FMM] fmm: oprobit" "mansection FMM fmmoprobit"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_oprobit##syntax"}{...}
{viewerjumpto "Menu" "fmm_oprobit##menu"}{...}
{viewerjumpto "Description" "fmm_oprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_oprobit##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_oprobit##remarks"}{...}
{viewerjumpto "Examples" "fmm_oprobit##examples"}{...}
{viewerjumpto "Stored results" "fmm_oprobit##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col :{bf:[FMM] fmm: oprobit} {hline 2}}Finite mixtures of ordered probit
regression models{p_end}
{p2col:}({mansection FMM fmmoprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:oprobit} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm oprobit##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_oprobit##fmmopts:fmmopts}}]{cmd::} {cmd:oprobit}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth off:set(varname)}}include {it:varname} in
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
{help oprobit##options:{it:Options}} in {manhelp oprobit R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Ordinal outcomes > Ordered probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: oprobit} fits mixtures of ordered probit regression models;
see {manhelp fmm FMM} and {manhelp oprobit R} for details.


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
For general information about logistic regression, see {manhelp oprobit R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fmm_health}{p_end}

{pstd}Mixture of two ordered probit regression models with cutpoints
constrained to be equal across classes using {cmd:lcinv(cons)}{p_end}
{phang2}{cmd:. fmm 2, lcinv(cons): oprobit health area weight i.female i.rural}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
