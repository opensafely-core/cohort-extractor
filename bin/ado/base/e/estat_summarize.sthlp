{smcl}
{* *! version 1.1.3  14may2018}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[R] estat summarize" "mansection R estatsummarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat" "help estat"}{...}
{vieweralsosee "[R] estat ic" "help estat ic"}{...}
{vieweralsosee "[R] estat vce" "help estat vce"}{...}
{viewerjumpto "Syntax" "estat summarize##syntax"}{...}
{viewerjumpto "Menu for estat" "estat summarize##menu_estat"}{...}
{viewerjumpto "Description" "estat summarize##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_summarize##linkspdf"}{...}
{viewerjumpto "Options" "estat summarize##options_estat_summarize"}{...}
{viewerjumpto "Examples" "estat summarize##examples"}{...}
{viewerjumpto "Stored results" "estat summarize##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[R] estat summarize} {hline 2}}Summarize estimation sample{p_end}
{p2col:}({mansection R estatsummarize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

        {cmd:estat} {cmdab:su:mmarize} [{it:eqlist}] [{cmd:,} {it:estat_summ_options}]

{marker estat_summ_options}{...}
{synoptset 21}{...}
{p2coldent:{it:estat_summ_options}}Description{p_end}
{synoptline}
{synopt:{opt eq:uation}}display summary by equation{p_end}
{synopt:{opt gro:up}}display summary by group; only after {cmd:sem} and {cmd:gsem}{p_end}
{synopt:{opt lab:els}}display variable labels{p_end}
{synopt:{opt nohea:der}}suppress the header{p_end}
{synopt:{opt nowei:ghts}}ignore weights{p_end}
{synopt :{it:{help estat_summarize##display_options:display_options}}}control
           row spacing, line width, display of omitted variables and base and
	   empty cells, and factor-variable labeling{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:eqlist} is rarely used and specifies the variables, with optional equation
name, to be summarized.  {it:eqlist} may be {varlist} or ({it:eqname1}{cmd::}
{it:varlist}) ({it:eqname2}{cmd::} {it:varlist}) {it:...}.  {it:varlist} may
contain time-series operators; see {help tsvarlist}.
{p_end}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt estat summarize} summarizes the variables used by the command and
automatically restricts the sample to the estimation sample; it also
summarizes the weight variable and cluster structure, if specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estatsummarizeQuickstart:Quick start}

        {mansection R estatsummarizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_estat_summarize}{...}
{title:Options}

{phang}
{opt equation} requests that the dependent variables and the independent
variables in the equations be displayed in the equation-style format of
estimation commands, repeating the summary information about variables entered
in more than one equation.

{phang}
{opt group} displays summary information separately for each group.
{opt group} is only allowed after {cmd:sem} or {cmd:gsem}
with a {opt group()} variable
specified.

{phang}
{opt labels} displays variable labels.

{phang}
{opt noheader} suppresses the header.

{phang}
{opt noweights} ignores the weights, if any, from the previous estimation
command.  The default when weights are present is to perform a weighted
{cmd:summarize} on all variables except the weight variable itself.  An
unweighted {cmd:summarize} is performed on the weight variable.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)}, and
{opt fvwrapon(style)};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress price headroom trunk length mpg}{p_end}

{pstd}Obtain summary of estimation sample{p_end}
{phang2}{cmd:. estat summarize}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse klein}{p_end}
{phang2}{cmd:. reg3 (consump wagep wageg) (wagep consump govt capital)}{p_end}

{pstd}Obtain summary of estimation sample for each equation{p_end}
{phang2}{cmd:. estat summarize, equation}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat summarize} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N_groups)}}number of groups ({cmd:group} only){p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(stats)}}k x 4 matrix of means, standard deviations, minimums,
and maximums{p_end}
{synopt:{cmd:r(stats}[{cmd:_}{it:#}]{cmd:)}}k x 4 matrix of means, standard
	deviations, minimums, and maximums for group {it:#}
        ({cmd:group} only){p_end}
