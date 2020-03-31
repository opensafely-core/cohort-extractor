{smcl}
{* *! version 1.3.4  15oct2018}{...}
{viewerdialog dstdize "dialog dstdize"}{...}
{viewerdialog istdize "dialog istdize"}{...}
{vieweralsosee "[R] dstdize" "mansection R dstdize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{viewerjumpto "Syntax" "dstdize##syntax"}{...}
{viewerjumpto "Menu" "dstdize##menu"}{...}
{viewerjumpto "Description" "dstdize##description"}{...}
{viewerjumpto "Links to PDF documentation" "dstdize##linkspdf"}{...}
{viewerjumpto "Options for dstdize" "dstdize##options_dstdize"}{...}
{viewerjumpto "Options for istdize" "dstdize##options_istdize"}{...}
{viewerjumpto "Examples" "dstdize##examples"}{...}
{viewerjumpto "Stored results" "dstdize##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] dstdize} {hline 2}}Direct and indirect standardization{p_end}
{p2col:}({mansection R dstdize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Direct standardization

{p 8 16 2}
{cmd:dstdize} {it:charvar} {it:popvar} {it:stratavars} {ifin}{cmd:,}
{opth by:(varlist:groupvars)} 
[{it:{help dstdize##dstdize_options:dstdize_options}}]


{phang}
Indirect standardization

{p 8 16 2}{cmd:istdize} {it:casevar_s} {it:popvar_s} {it:stratavars} {ifin}
{opt using} {it:{help filename}}{cmd:,}
{{opt pop:vars(casevar_p popvar_p)} |{break}
{opt rate(ratevar_p {#|crudevar_p})}}
[{it:{help dstdize##istdize_options:istdize_options}}]


{phang}
{it:charvar} is the characteristic to be standardized across different
subpopulations identified by {it:{help varlist:groupvars}}.

{phang}
{it:popvar} defines the weights used in standardization.

{phang}
{it:stratavars} defines the strata across which the weights are to be
averaged in {cmd:dstdize}.  For {cmd:istdize}, {it:stratavars} defines the
strata for which {it:casevar_s} is measured.

{phang}
{it:casevar_s} is the variable name for the study population's number of
cases. If {opt by(groupvars)} is specified, {it:casevar_s} must be
constant or missing within each group defined by combinations of
{it:groupvars}.

{phang}
{it:popvar_s} identifies the number of subjects in each strata in the study
population.

{phang}
{it:filename} must be a Stata dataset and contain {it:popvar} and
{it:stratavars}.

{synoptset 31 tabbed}{...}
{marker dstdize_options}{...}
{synopthdr :dstdize_options}
{synoptline}
{syntab :Main}
{p2coldent: * {opth "by(varlist:groupvars)"}}study populations{p_end}
{synopt :{opth us:ing(filename)}}use standard population from Stata dataset{p_end}
{synopt :{opt ba:se(#|string)}}use standard population from a value of grouping
variable{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}

{syntab :Options}
{synopt :{opth sav:ing(filename)}}save computed standard population distribution
as a Stata dataset{p_end}
{synopt :{opth f:ormat(%fmt)}}final summary table display format; default is
{cmd:%10.0g}{p_end}
{synopt :{opt pr:int}}include table summary of standard population in output{p_end}
{synopt :{opt nores}}suppress storing results in {opt r()}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt by(groupvars)} is required.{p_end}

{synoptset 31 tabbed}{...}
{marker istdize_options}{...}
{synopthdr :istdize_options}
{synoptline}
{syntab :Main}
{p2coldent: * {opt pop:vars(casevar_p popvar_p)}}for standard population,
{it:casevar_p} is number of cases and {it:popvar_p} is number of individuals{p_end}
{p2coldent : * {opt rate(ratevar_p {#|crudevar_p})}}{it:ratevar_p} is stratum-specific rates and {it:#} or {it:crudevar_p} is the crude case rate value or variable{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}

{syntab :Options}
{synopt :{opth "by(varlist:groupvars)"}}variables identifying study populations{p_end}
{synopt :{opth f:ormat(%fmt)}}final summary table display format; default is 
{cmd:%10.0g}{p_end}
{synopt :{opt pr:int}}include table summary of standard population in output{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2} * Either {opt popvars(casevar_p popvar_p)} or 
{opt rate(ratevar_p {#|crudevar_p})} must be specified.


{marker menu}{...}
{title:Menu}

    {title:dstdize} 

{phang2}
{bf:Statistics > Epidemiology and related > Other > Direct standardization}

    {title:istdize}

{phang2}
{bf:Statistics > Epidemiology and related > Other > Indirect standardization}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dstdize} produces standardized rates, a weighted average of the
stratum-specific rates.

{pstd}
{cmd:istdize} produces indirectly standardized rates that are appropriate when
the stratum-specific rates for the population being studied are either
unavailable or unreliable.

{pstd}
{cmd:istdize} also calculates a point estimate and exact confidence interval
for the study population's standardized mortality ratio (SMR) or the
standardized incidence ratio.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R dstdizeQuickstart:Quick start}

        {mansection R dstdizeRemarksandexamples:Remarks and examples}

        {mansection R dstdizeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_dstdize}{...}
{title:Options for dstdize}

{dlgtab:Main}

{phang}
{opth "by(varlist:groupvars)"} is required for the {cmd:dstdize} command; it
specifies the variables identifying the study populations.  If {opt base()} is
also specified, there must be only one variable in the {opt by()} group.  If
you do not have a variable for this option, you can generate one by using
something like {cmd:generate newvar=1} and then use {cmd:newvar} as the
argument to this option.

{phang}
{opth using(filename)} or {opt base(#|string)} may be used to specify the
standard population.  You may not specify both options.  {opt using(filename)}
supplies the name of a {cmd:.dta} file containing the standard population.
The standard population must contain the {it:popvar} and the {it:stratavars}.
If {opt using()} is not specified, the standard population distribution will
be obtained from the data.  {opt base(#|string)} lets you specify one of
the values of {it:{help varlist:groupvar}} -- either a numeric value or a 
string -- to be used as the standard population.  If neither {opt base()}
nor {opt using()} is specified, the entire dataset is used to determine an
estimate of the standard population.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for a
confidence interval of the adjusted rate.  The default is {cmd:level(95)} or
as set by {helpb set level}.

{dlgtab:Options}

{phang}
{opth saving(filename)} saves the computed standard population distribution as
a Stata dataset that can be used in further analyses.

{phang}
{opth format(%fmt)} specifies the format in which to display the final summary
table.  The default is {cmd:%10.0g}.

{phang}
{opt print} includes a table summary of the standard population before
displaying the study population results.

{phang}
{opt nores} suppresses storing results in {opt r()}.  This option is seldom
specified.  Some results are stored in matrices.  If there are more groups
than can fit in a matrix, {cmd:dstdize} will report the
"{err:unable to allocate matrix}" error message.  In this case, you must
specify {opt nores}.  The {opt nores} option does not change how results are
calculated but specifies that results need not be left behind for use by other
programs.


{marker options_istdize}{...}
{title:Options for istdize}

{dlgtab:Main}

{phang}
{opt popvars(casevar_p popvar_p)} or
{opt rate(ratevar_p {#|crudevar_p})} must be specified with 
{cmd:istdize}.  Only one of these two options is allowed.  These options are
used to describe the standard population's data.

{pmore}
With {opt popvars(casevar_p popvar_p)}, {it:casevar_p} records the
number of cases (deaths) for each stratum in the standard population, and
{it:popvar_p} records the total number of individuals in each stratum
(individuals at risk).

{pmore}
With {opt rate(ratevar_p {#|crudevar_p})}, {it:ratevar_p} contains the
stratum-specific rates.  {it:#}|{it:crudevar_p} specifies the crude case rate
either by a variable name or by the crude case rate value.  If a
crude rate variable is used, it must be the same for all observations,
although it could be missing for some.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for a
confidence interval of the adjusted rate.  The default is {cmd:level(95)} or
as set by {helpb set level}.

{dlgtab:Options}

{phang}
{opth "by(varlist:groupvars)"} specifies variables identifying study
populations when more than one exists in the data.  If this option is not
specified, the entire study population is treated as one group.

{phang} {opth format(%fmt)} specifies the format in which to display the final
summary table.  The default is {cmd:%10.0g}.

{phang}
{opt print} outputs a table summary of the standard population before
displaying the study population results.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hbp}{p_end}
{phang2}{cmd:. generate pop = 1}{p_end}

{pstd}Obtain standardized rates of {cmd:hbp} by {cmd:city} and {cmd:year},
using the {cmd:age}, {cmd:race}, and {cmd:sex} distribution of the cities
and years combined as the standard{p_end}
{phang2}{cmd:. dstdize hbp pop age race sex, by(city year)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse kahn, clear}{p_end}

{pstd}Obtain mortality rates by {cmd:state} using the standard population
saved in {cmd:popkahn.dta}{p_end}
{phang2}{cmd:. istdize death pop age using}
       {cmd:https://www.stata-press.com/data/r16/popkahn,}
       {cmd:by(state) pop(deaths pop) print}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:dstdize} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of populations{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(by)}}variable names specified in {cmd:by()}{p_end}
{synopt:{cmd:r(c}{it:#}{cmd:)}}values of {cmd:r(by)} for {it:#}th group{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(se)}}1 x k vector of standard errors of adjusted rates{p_end}
{synopt:{cmd:r(ub_adj)}}1 x k vector of upper bounds of confidence intervals for adjusted
	rates{p_end}
{synopt:{cmd:r(lb_adj)}}1 x k vector of lower bounds of confidence intervals for adjusted
	rates{p_end}
{synopt:{cmd:r(Nobs)}}1 x k vector of number of observations{p_end}
{synopt:{cmd:r(crude)}}1 x k vector of crude rates (*){p_end}
{synopt:{cmd:r(adj)}}1 x k vector of adjusted rates (*){p_end}
{synopt:}{space 2}(*) If, in a group, the number of observations is 0, then 9
	is stored for the corresponding crude and adjusted rates.{p_end}
{p2colreset}{...}

{pstd}
{cmd:istdize} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(k)}}number of populations{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(by)}}variable names specified in {cmd:by()}{p_end}
{synopt:{cmd:r(c}{it:#}{cmd:)}}values of {cmd:r(by)} for {it:#}th group{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(cases_obs)}}1 x k vector of number of observed cases{p_end}
{synopt:{cmd:r(cases_exp)}}1 x k vector of number of expected cases{p_end}
{synopt:{cmd:r(ub_adj)}}1 x k vector of upper bounds of confidence 
	intervals for adjusted rates{p_end}
{synopt:{cmd:r(lb_adj)}}1 x k vector of lower bounds of confidence 
	intervals for adjusted rates{p_end}
{synopt:{cmd:r(crude)}}1 x k vector of crude rates{p_end}
{synopt:{cmd:r(adj)}}1 x k vector of adjusted rates{p_end}
{synopt:{cmd:r(smr)}}1 x k vector of SMRs{p_end}
{synopt:{cmd:r(ub_smr)}}1 x k vector of upper bounds of confidence 
	intervals for SMRs{p_end}
{synopt:{cmd:r(lb_smr)}}1 x k vector of lower bounds of confidence 
	intervals for SMRs{p_end}
{p2colreset}{...}
