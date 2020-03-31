{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: probit" "dialog fmm, message(-probit-)"}{...}
{vieweralsosee "[FMM] fmm: probit" "mansection FMM fmmprobit"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_probit##syntax"}{...}
{viewerjumpto "Menu" "fmm_probit##menu"}{...}
{viewerjumpto "Description" "fmm_probit##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_probit##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_probit##remarks"}{...}
{viewerjumpto "Examples" "fmm_probit##examples"}{...}
{viewerjumpto "Stored results" "fmm_probit##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col :{bf:[FMM] fmm: probit} {hline 2}}Finite mixtures of probit
regression models{p_end}
{p2col:}({mansection FMM fmmprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:probit} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm probit##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_probit##fmmopts:fmmopts}}]{cmd::} {cmd:probit}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in
model with coefficient constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help probit##options:{it:Options}} in {manhelp probit R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Binary outcomes > Probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: probit} fits mixtures of probit regression models;
see {manhelp fmm FMM} and {manhelp probit R} for details.


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
For general information about probit regression, see {manhelp probit R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse epay}{p_end}

{pstd}Mixture of two probit regression models{p_end}
{phang2}{cmd:. fmm 2: probit epay age i.male}{p_end}

{pstd}Estimated marginal probability of {cmd:epay} in each classes{p_end}
{phang2}{cmd:. estat lcmean}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
