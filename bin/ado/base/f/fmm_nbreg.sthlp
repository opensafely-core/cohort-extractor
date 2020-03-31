{smcl}
{* *! version 1.0.5  04oct2018}{...}
{viewerdialog "fmm: nbreg" "dialog fmm, message(-nbreg-)"}{...}
{vieweralsosee "[FMM] fmm: nbreg" "mansection FMM fmmnbreg"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] nbreg" "help nbreg"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_nbreg##syntax"}{...}
{viewerjumpto "Menu" "fmm_nbreg##menu"}{...}
{viewerjumpto "Description" "fmm_nbreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_nbreg##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_nbreg##remarks"}{...}
{viewerjumpto "Example" "fmm_nbreg##example"}{...}
{viewerjumpto "Stored results" "fmm_nbreg##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col :{bf:[FMM] fmm: nbreg} {hline 2}}Finite mixtures of negative
binomial regression models{p_end}
{p2col:}({mansection FMM fmmnbreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:nbreg} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm nbreg##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_nbreg##fmmopts:fmmopts}}]{cmd::} {cmd:nbreg}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{cmdab:d:ispersion(}{cmdab:m:ean)}}parameterization of dispersion;
the default{p_end}
{synopt :{cmdab:d:ispersion(}{cmdab:c:onstant)}}constant dispersion for all
observations{p_end}
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
{help nbreg##options_nbreg:{it:Options for nbreg}} in {manhelp nbreg R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Count outcomes > Negative binomial regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: nbreg} fits mixtures of negative binomial regression models;
see {manhelp fmm FMM} and {manhelp nbreg R} for details.


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
For general information about negative binomial regression, see
{manhelp nbreg R}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_mixture}{p_end}

{pstd}Mixture of two negative binomial regression models{p_end}
{phang2}{cmd:. fmm 2: nbreg drvisits private medicaid c.age##c.age actlim chronic}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
