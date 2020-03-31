{smcl}
{* *! version 1.0.6  04oct2018}{...}
{viewerdialog "fmm: intreg" "dialog fmm, message(-intreg-)"}{...}
{vieweralsosee "[FMM] fmm: intreg" "mansection FMM fmmintreg"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[R] intreg" "help intreg"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_intreg##syntax"}{...}
{viewerjumpto "Menu" "fmm_intreg##menu"}{...}
{viewerjumpto "Description" "fmm_intreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_intreg##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_intreg##remarks"}{...}
{viewerjumpto "Example" "fmm_intreg##example"}{...}
{viewerjumpto "Stored results" "fmm_intreg##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col :{bf:[FMM] fmm: intreg} {hline 2}}Finite mixtures of interval
regression models{p_end}
{p2col:}({mansection FMM fmmintreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:intreg}
{help depvar:{it:depvar_lower}}
{help depvar:{it:depvar_upper}}
[{indepvars}] [{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm intreg##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_intreg##fmmopts:fmmopts}}]{cmd::} {cmd:intreg}
{help depvar:{it:depvar_lower}}
{help depvar:{it:depvar_upper}}
[{indepvars}] [{cmd:,} {it:options}]


{phang}
where {it:#} specifies the number of class models.

{marker typedepvar}{...}
{phang}
The values in {it:depvar_lower} and {it:depvar_upper}
should have the following form:

             Type of data {space 16} {it:depvar_lower}  {it:depvar_upper}
             {hline 56}
             point data{space 10}{it:a} = [{it:a},{it:a}]{space 7}{it:a}{space 13}{it:a} 
             interval data{space 11}[{it:a},{it:b}]{space 7}{it:a}{space 13}{it:b}
             left-censored data{space 3}(-inf,{it:b}]{space 7}{cmd:.}{space 13}{it:b}
             right-censored data{space 3}[{it:a},inf){space 7}{it:a}{space 13}{cmd:.} 
             missing{space 29}{cmd:.}{space 13}{cmd:.} 
             {hline 56}

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in
model with coefficient constrained to 1{p_end}
{synoptline}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar_lower},
{it:depvar_upper}, and 
{it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help intreg##options:{it:Options}} in {manhelp intreg R}.

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Continuous outcomes > Interval regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: intreg} fits mixtures of interval regression models;
see {manhelp fmm FMM} and {manhelp intreg R} for details.


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
For general information about linear regression, see {manhelp intreg R}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse intregxmpl}{p_end}

{pstd}Mixture of two interval regression models{p_end}
{phang2}{cmd:. fmm 2: intreg wage1 wage2 age c.age#c.age nev_mar rural school tenure}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See
{help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
