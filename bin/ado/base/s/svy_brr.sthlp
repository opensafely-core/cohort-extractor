{smcl}
{* *! version 1.2.7  23jan2019}{...}
{viewerdialog "svy brr" "dialog svy_brr"}{...}
{vieweralsosee "[SVY] svy brr" "mansection SVY svybrr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy bootstrap" "help svy_bootstrap"}{...}
{vieweralsosee "[SVY] svy jackknife" "help svy_jackknife"}{...}
{vieweralsosee "[SVY] svy sdr" "help svy_sdr"}{...}
{viewerjumpto "Syntax" "svy_brr##syntax"}{...}
{viewerjumpto "Menu" "svy_brr##menu"}{...}
{viewerjumpto "Description" "svy_brr##description"}{...}
{viewerjumpto "Links to PDF documentation" "svy_brr##linkspdf"}{...}
{viewerjumpto "Options" "svy_brr##options"}{...}
{viewerjumpto "Examples" "svy_brr##examples"}{...}
{viewerjumpto "Stored results" "svy_brr##results"}{...}
{p2colset 1 18 22 2}{...}
{p2col:{bf:[SVY] svy brr} {hline 2}}Balanced repeated replication for survey
data{p_end}
{p2col:}({mansection SVY svybrr:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
[{cmd:svy}] {cmd:brr}
	{it:{help exp_list}}
	[{cmd:,}
		{help svy brr##svy_options:{it:svy_options}}
		{help svy brr##brr_options:{it:brr_options}}
		{it:{help eform_option}}]
	{cmd::} {it:command}

{phang}
{it:{help exp_list}} specifies the statistics to be collected from the
execution of {it:command}.  {it:exp_list} is required unless {it:command} has
the {cmd:svyb} program property, in which case {it:exp_list} defaults to
{cmd:_b}; see {manhelp program_properties P:program properties}.

{marker svy_options}{...}
{synoptset 25 tabbed}{...}
{synopthdr:svy_options}
{synoptline}
{syntab:if/in}
{synopt :{opt sub:pop}{cmd:(}[{varname}] [{it:{help if}}]{cmd:)}}identify a
	   subpopulation{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt noh:eader}}suppress table header{p_end}
{synopt :{opt nol:egend}}suppress table legend{p_end}
{synopt :{opt noadj:ust}}do not adjust model Wald statistic{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help svy##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
{opt coeflegend} is not shown in the dialog boxes for estimation commands.
{p_end}

{marker brr_options}{...}
{synopthdr:brr_options}
{synoptline}
{syntab:Main}
{synopt :{opt h:adamard(matrix)}}Hadamard matrix{p_end}
{synopt :{opt fay(#)}}Fay's adjustment{p_end}

{syntab:Options}
{synopt :{help prefix_saving_option:{bf:{ul:sa}ving(}{it:filename}{bf:[, ...])}}}save
	results to {it:filename}; save statistics in double precision; save
	results to {it:filename} every {it:#} replications{p_end}
{synopt :{opt mse}}use MSE formula for variance{p_end}

{syntab:Reporting}
{synopt :{opt v:erbose}}display the full table legend{p_end}
{synopt :{opt nodots}}suppress replication dots{p_end}
{synopt :{opt dots(#)}}display dots every {it:#} replications{p_end}
{synopt :{opt noi:sily}}display any output from {it:command}{p_end}
{synopt :{opt tr:ace}}trace {it:command}{p_end}
{synopt :{opt ti:tle(text)}}use {it:text} as title for BRR results{p_end}

{syntab:Advanced}
{synopt :{opt nodrop}}do not drop observations{p_end}
{synopt :{opth reject(exp)}}identify invalid results{p_end}
{synopt :{opt dof(#)}}design degrees of freedom{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help svy_notes_common


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survey data analysis > Resampling >}
      {bf:Balanced repeated replications estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:svy} {cmd:brr} performs balanced repeated replication (BRR) estimation of
specified statistics (or expressions) for a Stata command or a user-written
program.  The command is executed once for each replicate using sampling
weights that are adjusted according to the BRR methodology.  Any Stata
estimation command listed in {manhelp svy_estimation SVY:svy estimation} may
be used with {cmd:svy} {cmd:brr}.  User-written programs that meet the
requirements in {manhelp program_properties P:program properties} may also be
used.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SVY svybrrQuickstart:Quick start}

        {mansection SVY svybrrRemarksandexamples:Remarks and examples}

        {mansection SVY svybrrMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:svy_options}; see {manhelp svy SVY}.

{dlgtab:Main}

{phang}
{opt hadamard(matrix)} specifies the Hadamard matrix to be used to determine
which PSUs are chosen for each replicate.

{phang}
{opt fay(#)} specifies Fay's adjustment, where 0 {ul:<} {it:#} {ul:<} 2, 
but excluding 1.
This option overrides the {opt fay(#)} option of {helpb svyset}.

{dlgtab:Options}

INCLUDE help prefix_saving_option

{pmore}
See {it:{help prefix_saving_option}} for details about {it:suboptions}.

{phang}
{opt mse} specifies that {cmd:svy} {cmd:brr} compute the variance by using
deviations of the replicates from the observed value of the statistics based
on the entire dataset.  By default, {cmd:svy} {cmd:brr} computes the variance
by using deviations of the replicates from their mean.

{dlgtab:Reporting}

{phang}
{opt verbose} requests that the full table legend be displayed.

INCLUDE help svy_dots

{phang}
{opt noisily} requests that any output from {it:command} be displayed.
This option implies the {opt nodots} option.

{phang}
{opt trace} causes a trace of the execution of {it:command} to be displayed.
This option implies the {opt noisily} option.

{phang}
{opt title(text)} specifies a title to be displayed above the
table of BRR results; the default title is "BRR results".

{phang}
{it:eform_option}; see {manhelpi eform_option R}.
This option is ignored if {it:{help exp_list}} is not {cmd:_b}.

{dlgtab:Advanced}

{phang}
{opt nodrop} prevents observations outside {cmd:e(sample)} and the
{cmd:if} and {cmd:in} qualifiers from being dropped before the data are
resampled.

{phang}
{opth reject(exp)} identifies an expression that indicates when results should
be rejected.  When {it:exp} is true, the resulting values are reset to missing
values.

{phang}
{opt dof(#)} specifies the design degrees of freedom, overriding the default
calculation, df = N_psu - N_strata.


{marker examples}{...}
{title:Examples}

{phang}
{cmd:. webuse nhanes2brr}
{p_end}
{phang}
{cmd:. svyset}
{p_end}
{phang}
{cmd:. svy brr WtoH = (_b[weight]/_b[height]) : total weight height}
{p_end}
{phang}
{cmd:. svy brr WtoH = (_b[weight]/_b[height]), mse : total weight height}
{p_end}

{pstd}
Hadamard matrices
{p_end}

{phang}
{cmd:. matrix h2 = (-1, 1 \ 1, 1)}
{p_end}
{phang}
{cmd:. matrix h4 = h2 # h2}
{p_end}
{phang}
{cmd:. matrix h8 = h2 # h4}
{p_end}
{phang}
{cmd:. matrix h16 = h2 # h8}
{p_end}
{phang}
{cmd:. matrix h32 = h2 # h16}
{p_end}
{phang}
{cmd:. webuse nhanes2}
{p_end}
{phang}
{cmd:. svy brr, hadamard(h32) : ratio (WtoH: weight/height)}
{p_end}



{marker results}{...}
{title:Stored results}

{pstd}
In addition to the results documented in {manhelp svy SVY},
{cmd:svy brr} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N_reps)}}number of replications{p_end}
{synopt:{cmd:e(N_misreps)}}number of replications with missing values{p_end}
{synopt:{cmd:e(k_exp)}}number of standard expressions{p_end}
{synopt:{cmd:e(k_eexp)}}number of {cmd:_b}/{cmd:_se} expressions{p_end}
{synopt:{cmd:e(k_extra)}}number of extra estimates added to {cmd:_b}{p_end}
{synopt:{cmd:e(fay)}}Fay's adjustment{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmdname)}}command name from {it:command}{p_end}
{synopt:{cmd:e(cmd)}}same as {cmd:e(cmdname)} or {cmd:brr}{p_end}
{synopt:{cmd:e(vce)}}{cmd:brr}{p_end}
{synopt:{cmd:e(brrweight)}}{cmd:brrweight()} variable list{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b_brr)}}BRR means{p_end}
{synopt:{cmd:e(V)}}BRR variance estimates{p_end}

{pstd}
When {it:exp_list} is {cmd:_b}, {cmd:svy brr} will also carry forward most of
the results already in {cmd:e()} from {it:command}.{p_end}
{p2colreset}{...}
