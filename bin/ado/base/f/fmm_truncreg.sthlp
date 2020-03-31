{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: truncreg" "dialog fmm, message(-truncreg-)"}{...}
{vieweralsosee "[FMM] fmm: truncreg" "mansection FMM fmmtruncreg"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[R] truncreg" "help truncreg"}{...}
{viewerjumpto "Syntax" "fmm_truncreg##syntax"}{...}
{viewerjumpto "Menu" "fmm_truncreg##menu"}{...}
{viewerjumpto "Description" "fmm_truncreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_truncreg##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_truncreg##remarks"}{...}
{viewerjumpto "Examples" "fmm_truncreg##examples"}{...}
{viewerjumpto "Stored results" "fmm_truncreg##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col :{bf:[FMM] fmm: truncreg} {hline 2}}Finite mixtures of truncated
linear regression models{p_end}
{p2col:}({mansection FMM fmmtruncreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:truncreg} {depvar} [{indepvars}]
[{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm truncreg##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_truncreg##fmmopts:fmmopts}}]{cmd::} {cmd:truncreg}
{depvar} [{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{cmd:ll(}{varname}|{it:#}{cmd:)}}left-truncation variable or limit{p_end}
{synopt :{cmd:ul(}{varname}|{it:#}{cmd:)}}right-truncation variable or limit{p_end}
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
{help truncreg##options:{it:Options}} in {manhelp truncreg R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Continuous outcomes > Truncated regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: truncreg} fits mixtures of truncated linear regression models;
see {manhelp fmm FMM} and {manhelp truncreg R} for details.


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
For general information about tobit regression, see {manhelp truncreg R}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse laborsub}{p_end}

{pstd}Mixture of two truncated regression models with lower truncation limit 0{p_end}
{phang2}{cmd:. fmm 2: truncreg whrs kl6 k618 wa we, ll(0)}{p_end}

{pstd}Estimated probabilities of membership in the two classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
