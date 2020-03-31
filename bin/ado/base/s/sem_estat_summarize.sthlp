{smcl}
{* *! version 1.1.4  14may2018}{...}
{viewerdialog estat "dialog sem_estat, message(-summarize-) name(sem_estat_summarize)"}{...}
{vieweralsosee "[SEM] estat summarize" "mansection SEM estatsummarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat summarize" "help estat summarize"}{...}
{vieweralsosee "[SEM] gsem postestimation" "help gsem_postestimation"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{viewerjumpto "Syntax" "sem_estat_summarize##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_summarize##menu"}{...}
{viewerjumpto "Description" "sem_estat_summarize##description"}{...}
{viewerjumpto "Options" "sem_estat_summarize##options"}{...}
{viewerjumpto "Examples" "sem_estat_summarize##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_summarize##results"}{...}
{p2colset 1 26 27 2}{...}
{p2col:{bf:[SEM] estat summarize} {hline 2}}Report summary statistics for estimation sample{p_end}
{p2col:}({mansection SEM estatsummarize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmdab:su:mmarize} [{it:eqlist}]
[{cmd:,} {opt group}
{it:{help estat_summarize##estat_summ_options:estat_summ_options}}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Other >}
         {bf:Estimation-sample summary statistics}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat summarize} is a standard postestimation command of Stata.
This entry concerns use of {cmd:estat summarize} after {cmd:sem} or
{cmd:gsem}.

{pstd}
{cmd:estat summarize} reports the summary statistics in the estimation sample
for the observed variables in the model.
{cmd:estat summarize} is mentioned here because 

{phang}
1.  {cmd:estat summarize} cannot be used if {cmd:sem} was 
            run on summary statistics data; see
	    {manlink SEM Intro 11}.

{phang}
2.  {cmd:estat summarize} allows the additional option {cmd:group} 
            after estimation by {cmd:sem} and {cmd:gsem}. 


{marker options}{...}
{title:Options}

{phang}
{opt group} may be specified if {opt group(varname)} was specified with
{cmd:sem} or {cmd:gsem} at the time the model was fit.  It requests that
summary statistics be reported by group. 

{phang}
{it:estat_summ_options} are the standard options allowed 
         by {cmd:estat summarize} and are outlined in
         {it:{help estat summarize##options_estat_summarize:Options}} of
	 {bf:[R] estat summarize}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length), group(foreign)}{p_end}

{pstd}Obtain summary of estimation sample{p_end}
{phang2}{cmd:. estat summarize}{p_end}

{pstd}Obtain summary of each group{p_end}
{phang2}{cmd:. estat summarize, group}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {it:{help estat summarize##results:Stored results}} of
{bf:[R] estat summarize}.
{p_end}
