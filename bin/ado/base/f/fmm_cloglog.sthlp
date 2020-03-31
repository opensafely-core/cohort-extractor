{smcl}
{* *! version 1.0.7  04oct2018}{...}
{viewerdialog "fmm: cloglog" "dialog fmm, message(-cloglog-)"}{...}
{vieweralsosee "[FMM] fmm: cloglog" "mansection FMM fmmcloglog"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cloglog" "help cloglog"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_cloglog##syntax"}{...}
{viewerjumpto "Menu" "fmm_cloglog##menu"}{...}
{viewerjumpto "Description" "fmm_cloglog##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_cloglog##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_cloglog##remarks"}{...}
{viewerjumpto "Examples" "fmm_cloglog##examples"}{...}
{viewerjumpto "Stored results" "fmm_cloglog##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col :{bf:[FMM] fmm: cloglog} {hline 2}}Finite mixtures of complementary log-log regression models{p_end}
{p2col:}({mansection FMM fmmcloglog:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:cloglog} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm cloglog##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_betareg##fmmopts:fmmopts}}]{cmd::} {cmd:cloglog}
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
{help cloglog##options:{it:Options}} in {manhelp cloglog R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Binary outcomes > Complementary log-log regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: cloglog} fits mixtures of complementary log-log regression models;
see {manhelp fmm FMM} and {manhelp cloglog R} for details.


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
For general information about complementary log-log regression, see
{manhelp cloglog R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse epay}{p_end}

{pstd}Mixture of two complementary log-log regression models{p_end}
{phang2}{cmd:. fmm 2: cloglog epay age i.male}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See
{help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
