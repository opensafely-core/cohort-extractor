{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: ologit" "dialog fmm, message(-ologit-)"}{...}
{vieweralsosee "[FMM] fmm: ologit" "mansection FMM fmmologit"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_ologit##syntax"}{...}
{viewerjumpto "Menu" "fmm_ologit##menu"}{...}
{viewerjumpto "Description" "fmm_ologit##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_ologit##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_ologit##remarks"}{...}
{viewerjumpto "Examples" "fmm_ologit##examples"}{...}
{viewerjumpto "Stored results" "fmm_ologit##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col :{bf:[FMM] fmm: ologit} {hline 2}}Finite mixtures of ordered
logistic regression models{p_end}
{p2col:}({mansection FMM fmmologit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:ologit} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm ologit##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_ologit##fmmopts:fmmopts}}]{cmd::} {cmd:ologit}
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
{help ologit##options:{it:Options}} in {manhelp ologit R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Ordinal outcomes > Ordered logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: ologit} fits mixtures of ordered logistic regression models;
see {manhelp fmm FMM} and {manhelp ologit R} for details.


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
For general information about logistic regression, see {manhelp ologit R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fmm_health}{p_end}

{pstd}Mixture of two ordered logistic regression models with cutpoints
constrained to be equal across classes using {cmd:lcinv(cons)}{p_end}
{phang2}{cmd:. fmm 2, lcinv(cons): ologit health area weight i.female i.rural}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
