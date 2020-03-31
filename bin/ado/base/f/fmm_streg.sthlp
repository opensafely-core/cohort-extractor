{smcl}
{* *! version 1.0.7  04oct2018}{...}
{viewerdialog "fmm: streg" "dialog fmm, message(-streg-)"}{...}
{vieweralsosee "[FMM] fmm: streg" "mansection FMM fmmstreg"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm" "help fmm"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfmmexsurv}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fmm_streg##syntax"}{...}
{viewerjumpto "Menu" "fmm_streg##menu"}{...}
{viewerjumpto "Description" "fmm_streg##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm_streg##linkspdf"}{...}
{viewerjumpto "Remarks" "fmm_streg##remarks"}{...}
{viewerjumpto "Example" "fmm_streg##example"}{...}
{viewerjumpto "Stored results" "fmm_streg##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col :{bf:[FMM] fmm: streg} {hline 2}}Finite mixtures of parametric
survival models{p_end}
{p2col:}({mansection FMM fmmstreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 15 2}
{cmd:fmm} {it:#}{cmd::} {cmd:streg} [{indepvars}] [{cmd:,} {it:options}]


{pstd}
Full syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{help fmm ivregress##weight:{it:weight}}]
[{cmd:,} {it:{help fmm_streg##fmmopts:fmmopts}}]{cmd::} {cmd:streg}
[{indepvars}]
{bind:[{cmd:,} {it:options}]}


{phang}
where {it:#} specifies the number of class models.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress the constant term{p_end}
{p2coldent:* {opt dist:ribution(distname)}}specify survival
distribution{p_end}
{synopt :{opt time}}use accelerated failure-time metric{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in
model with coefficient constrained to 1{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
*{opt distribution(distname)} is required.{p_end}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:fmm: streg}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
For a detailed description of {it:options}, see 
{help streg##options:{it:Options}} in {manhelp streg ST}.

{marker distname}{...}
{synoptset 26 tabbed}{...}
{synopthdr:distname}
{synoptline}
{synopt :{opt e:xponential}}exponential survival distribution{p_end}
{synopt :{opt logl:ogistic}}loglogistic survival distribution{p_end}
{synopt :{opt ll:ogistic}}synonym for {opt loglogistic}{p_end}
{synopt :{opt w:eibull}}Weibull survival distribution{p_end}
{synopt :{opt logn:ormal}}lognormal survival distribution{p_end}
{synopt :{opt ln:ormal}}synonym for {opt lognormal}{p_end}
{p2coldent:* {opt gam:ma}}gamma survival distribution{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:fmm: streg} uses the gamma survival distribution and not the generalized
gamma distribution that is used by {helpb streg}.
{p_end}

INCLUDE help fmm_options_table
INCLUDE help fmm_options_note

INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > Parametric survival regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fmm: streg} fits mixtures of parametric survival regression models;
see {manhelp fmm FMM} and {manhelp streg ST} for details.


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
For general information about parametric survival models, see
{manhelp streg ST}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lenses}{p_end}
{phang2}{cmd:. stset t, failure(fail)}{p_end}

{pstd}Cure model as a mixture of a point mass distribution at
zero and a Weibull survival model{p_end}
{phang2}{cmd:. fmm: (pointmass fail) (streg inclength i.sex age10, distribution(weibull))}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {help fmm##results:{it:Stored results}} in {manhelp fmm FMM}.
{p_end}
