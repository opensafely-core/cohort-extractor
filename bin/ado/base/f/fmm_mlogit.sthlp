{smcl}
{* *! version 1.0.8  14feb2019}{...}
{viewerdialog "fmm: mlogit" "dialog fmm, message(-mlogit-)"}{...}
{vieweralsosee "[FMM] fmm: mlogit" "mansection FMM fmmmlogit"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_mlogit##syntax"}{...}
{viewerjumpto "Menu" "fmm_mlogit##menu"}{...}
{viewerjumpto "Description" "fmm_mlogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_mlogit##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_mlogit##remarks"}{...}
{viewerjumpto "Examples" "fmm_mlogit##examples"}{...}
{viewerjumpto "Stored results" "fmm_mlogit##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col :{bf:[FMM] fmm: mlogit} {hline 2}}Finite mixtures of multinomial
(polytomous) logistic regression models{p_end}
{p2col:}({mansection FMM fmmmlogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:mlogit} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm mlogit##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_mlogit##fmmopts:fmmopts}}]{cmd::} {cmd:mlogit}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{opt b:aseoutcome(#)}}value of {depvar} that will be the base
outcome{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help mlogit##options:{it:Options}} in {manhelp mlogit R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Multinomial logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: mlogit} fits mixtures of multinomial logistic regression models;
see {manhelp fmm FMM} and {manhelp mlogit R} for details.


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
For general information about logistic regression, see {manhelp mlogit R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sim_car}{p_end}

{pstd}Mixture of two multinomial logistic regression models{p_end}
{phang2}{cmd:. fmm 2, lcinvariant(cons): mlogit model i.female income}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
