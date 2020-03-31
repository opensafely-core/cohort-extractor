{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: betareg" "dialog fmm, message(-betareg-)"}{...}
{vieweralsosee "[FMM] fmm: betareg" "mansection FMM fmmbetareg"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] betareg" "help betareg"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_betareg##syntax"}{...}
{viewerjumpto "Menu" "fmm_betareg##menu"}{...}
{viewerjumpto "Description" "fmm_betareg##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_betareg##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_betareg##remarks"}{...}
{viewerjumpto "Examples" "fmm_betareg##examples"}{...}
{viewerjumpto "Stored results" "fmm_betareg##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col :{bf:[FMM] fmm: betareg} {hline 2}}Finite mixtures of beta regression models{p_end}
{p2col:}({mansection FMM fmmbetareg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:betareg} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm betareg##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_betareg##fmmopts:fmmopts}}]{cmd::} {cmd:betareg}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{opt li:nk(linkname)}}specify link function for the conditional
mean; default is {cmd:link(logit)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{it:{help betareg##options:Options}} in {manhelp betareg R}.

{marker linkname}{...}
{synoptset 26}{...}
{synopthdr:linkname}
{synoptline}
{synopt :{opt logit}}logit{p_end}
{synopt :{opt prob:it}}probit{p_end}
{synopt :{opt clog:log}}complementary log-log{p_end}
{synoptline}

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Beta regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: betareg} fits mixtures of beta regression models to a
fractional outcome whose values are greater than 0 and less than 1;
see {manhelp fmm FMM} and {manhelp betareg R} for details.


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
For general information about beta regression, see {manhelp betareg R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sprogram}{p_end}

{pstd}Mixture of two beta regression models with lower truncation limit
0{p_end}
{phang2}{cmd:. fmm 2: betareg prate i.summer freemeals pdonations}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See
{help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
