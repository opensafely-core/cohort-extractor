{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: logit" "dialog fmm, message(-logit-)"}{...}
{vieweralsosee "[FMM] fmm: logit" "mansection FMM fmmlogit"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_logit##syntax"}{...}
{viewerjumpto "Menu" "fmm_logit##menu"}{...}
{viewerjumpto "Description" "fmm_logit##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_logit##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_logit##remarks"}{...}
{viewerjumpto "Examples" "fmm_logit##examples"}{...}
{viewerjumpto "Stored results" "fmm_logit##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col :{bf:[FMM] fmm: logit} {hline 2}}Finite mixtures of logistic
regression models{p_end}
{p2col:}({mansection FMM fmmlogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:logit} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm logit##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_logit##fmmopts:fmmopts}}]{cmd::} {cmd:logit}
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
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help logit##options:{it:Options}} in {manhelp logit R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Binary outcomes > Logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: logit} fits mixtures of logistic regression models;
see {manhelp fmm FMM} and {manhelp logit R} for details.


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
For general information about logistic regression, see {manhelp logit R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse epay}{p_end}

{pstd}Mixture of two logistic regression models{p_end}
{phang2}{cmd:. fmm 2: logit epay age i.male}{p_end}

{pstd}Estimated marginal probability of {cmd:epay} in each classes{p_end}
{phang2}{cmd:. estat lcmean}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
