{smcl}
{* *! version 1.3.22  01apr2019}{...}
{vieweralsosee "[SVY] svy" "mansection SVY svy"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] program properties" "help program_properties"}{...}
{vieweralsosee "[P] _robust" "help _robust"}{...}
{vieweralsosee "[SVY] svy bootstrap" "help svy_bootstrap"}{...}
{vieweralsosee "[SVY] svy brr" "help svy_brr"}{...}
{vieweralsosee "[SVY] svy jackknife" "help svy_jackknife"}{...}
{vieweralsosee "[SVY] svy sdr" "help svy_sdr"}{...}
{vieweralsosee "[SVY] svyset" "help svyset"}{...}
{viewerjumpto "Syntax" "svy##syntax"}{...}
{viewerjumpto "Description" "svy##description"}{...}
{viewerjumpto "Links to PDF documentation" "svy##linkspdf"}{...}
{viewerjumpto "Options" "svy##options"}{...}
{viewerjumpto "Examples" "svy##examples"}{...}
{viewerjumpto "Stored results" "svy##results"}{...}
{viewerjumpto "Reference" "svy##reference"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[SVY] svy} {hline 2}}The survey prefix command
{p_end}
{p2col:}({mansection SVY svy:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:svy} [{help svy##svy_vcetype:{it:vcetype}}] [{cmd:,}
           {help svy##svy_options:{it: svy_options}}
	{it:{help eform_option}}] {cmd::} {it:command}

{marker svy_vcetype}{...}
{* NOTE:  Also see the following help files if you are going to change}{...}
{* the contents of this table.}{...}
{*	svy_bootstrap.sthp	}{...}
{*	svy_brr.sthlp		}{...}
{*	svy_jknife.sthlp	}{...}
{*	svy_sdr.sthlp		}{...}
{*	svy_tabulate_oneway.sthlp}{...}
{*	svy_tabulate_twoway.sthlp}{...}
INCLUDE help vcetype

{marker svy_options}{...}
{synopthdr:svy_options}
{synoptline}
{syntab:if/in}
{synopt :{opt sub:pop}{cmd:(}[{varname}] [{it:{help if}}]{cmd:)}}identify a subpopulation{p_end}

{syntab:SE}
{synopt :{opt dof(#)}}design degrees of freedom{p_end}
{synopt :{it:{help bootstrap_options}}}more
	options allowed with bootstrap variance estimation{p_end}
{synopt :{it:{help brr_options}}}more
	options allowed with BRR variance estimation{p_end}
{synopt :{it:{help jackknife_options}}}more
	options allowed with jackknife variance estimation{p_end}
{synopt :{it:{help sdr_options}}}more
	options allowed with SDR variance estimation{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help svy##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{synopt :{opt noh:eader}}suppress table header{p_end}
{synopt :{opt nol:egend}}suppress table legend{p_end}
{synopt :{opt noadj:ust}}do not adjust model Wald statistic{p_end}
{synopt :{opt noi:sily}}display any output from {it:command}{p_end}
{synopt :{opt tr:ace}}trace {it:command}{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
{cmd:svy} requires that the survey design variables be identified using
{helpb svyset}.
{p_end}
{p 4 6 2}
{it:command} defines the estimation command to be executed.  The {helpb by}
prefix cannot be part of {it:command}.{p_end}
{p 4 6 2}
{cmd:mi estimate} may be used with {cmd:svy linearized} if the estimation 
command allows {cmd:mi estimate}; it may not be used with {cmd:svy bootstrap},
{cmd:svy brr},
{cmd:svy jackknife}, or {cmd:svy sdr}.{p_end}
{p 4 6 2}
{opt noheader}, {opt nolegend}, {opt noadjust}, {opt noisily}, 
{opt trace}, and {opt coeflegend} are not shown in the dialog boxes for
estimation commands.
{p_end}
{p 4 6 2}
Warning:  Using {cmd:if} or {cmd:in} restrictions will often not produce correct
variance estimates for subpopulations.  To compute estimates
for subpopulations, use the {cmd:subpop()} option.
{p_end}
{p 4 6 2}
See {helpb svy postestimation:[SVY] svy postestimation} for features available
after estimation.
{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:svy} fits statistical models for complex survey data by adjusting the
results of a command for survey settings identified by {helpb svyset}.
Any Stata estimation command listed in 
{manhelp svy_estimation SVY:svy estimation} may be used with {cmd:svy}.
User-written programs that meet the requirements in
{manhelp program_properties P:program properties} may also be used.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SVY svyQuickstart:Quick start}

        {mansection SVY svyRemarksandexamples:Remarks and examples}

        {mansection SVY svyMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:if/in}

{phang}
{opt subpop}{cmd:(}{it:subpop}{cmd:)} specifies that
estimates be computed for the single subpopulation identified by
{it:subpop}, which is

{pmore2}
[{varname}] [{it:{help if}}]

{pmore}
Thus the subpopulation is defined by the observations for which
{it:varname}!=0 that also meet the {cmd:if} conditions.  Typically,
{it:varname}=1 defines the subpopulation, and {it:varname}=0 indicates
observations not belonging to the subpopulation.  For observations whose
subpopulation status is uncertain, {it:varname} should be set to a missing
value; such observations are dropped from the estimation sample.

{pmore}
See {manlink SVY Subpopulation estimation} and {manlink SVY estat}.

{dlgtab:SE}

{phang}
{opt dof(#)} specifies the design degrees of freedom, overriding the default
calculation, df = N_psu - N_strata.

{phang}
{it:bootstrap_options} are other options that are allowed with bootstrap
variance estimation specified by {cmd:svy} {cmd:bootstrap} or specified as
{cmd:svyset} using the {cmd:vce(bootstrap)} option;
see {manhelpi bootstrap_options SVY}.

{phang}
{it:brr_options} are other options that are allowed with BRR
variance estimation specified by {cmd:svy} {cmd:brr} or specified as
{cmd:svyset} using the {cmd:vce(brr)} option;
see {manhelpi brr_options SVY}.

{phang}
{it:jackknife_options} are other options that are allowed with
jackknife variance estimation specified by {cmd:svy} {cmd:jackknife} or 
specified as {cmd:svyset} using the {cmd:vce(jackknife)} option; see
{manhelpi jackknife_options SVY}.

{phang}
{it:sdr_options} are other options that are allowed with SDR
variance estimation specified by {cmd:svy} {cmd:sdr} or specified as
{cmd:svyset} using the {cmd:vce(sdr)} option;
see {manhelpi sdr_options SVY}.

{dlgtab:Reporting}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{pstd}
The following options are available with {cmd:svy} 
but are not shown in the dialog boxes:

{phang}
{opt noheader} prevents the table header from being displayed.  This option
implies {cmd:nolegend}.

{phang}
{opt nolegend} prevents the table legend identifying the subpopulations from
being displayed.

{phang}
{opt noadjust} specifies that the model Wald test be carried out as
{it:W}/{it:k} distributed {it:F}({it:k},{it:d}), where {it:W} is the Wald test
statistic, {it:k} is the number of terms in the model excluding the constant
term, {it:d} is the total number of sampled PSUs minus the total number of
strata, and {it:F}({it:k},{it:d}) is an {it:F} distribution with {it:k}
numerator degrees of freedom and {it:d} denominator degrees of freedom.  By
default, an adjusted Wald test is conducted:
({it:d}-{it:k}+1){it:W}/({it:k}{it:d}) distributed
{it:F}({it:k},{it:d}-{it:k}+{it:1}).

{pmore}
See {help svy##KG1990:Korn and Graubard (1990)} for a discussion of the Wald
test and the
adjustments thereof.  Using the {opt noadjust} option is not recommended.
{p_end}

{phang}
{opt noisily} requests that any output from {it:command} be displayed.

{phang}
{opt trace} causes a trace of the execution of {it:command} to be displayed.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{pstd}
The following option is usually available with {cmd:svy} at the time of 
estimation or on replay but is not shown in all dialog boxes:

{phang}
{it:eform_option}; see {manhelpi eform_option R}.


{marker examples}{...}
{title:Examples}

{phang}
{cmd:. webuse nhanes2f}
{p_end}
{phang}
{cmd:. svyset psuid [pweight=finalwgt], strata(stratid)}
{p_end}
{phang}
{cmd:. svy: mean zinc}
{p_end}
{phang}
{cmd:. mean zinc}
{p_end}

{phang}
{cmd:. svyset [pweight=finalwgt]}
{p_end}
{phang}
{cmd:. svy: mean zinc}
{p_end}

{phang}
{cmd:. svyset psuid [pweight=finalwgt]}
{p_end}
{phang}
{cmd:. svy: mean zinc}
{p_end}

{phang}
{cmd:. svyset psuid [pweight=finalwgt], strata(stratid)}
{p_end}
{phang}
{cmd:. svy: regress zinc age age2 weight female black orace rural}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:svy} stores the following in {cmd:e()}:

{synoptset 22 tabbed}{...}
{p2col 5 22 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_sub)}}subpopulation observations{p_end}
{synopt:{cmd:e(N_strata)}}number of strata{p_end}
{synopt:{cmd:e(N_strata_omit)}}number of strata omitted{p_end}
{synopt:{cmd:e(singleton)}}{cmd:1} if singleton strata, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(census)}}{cmd:1} if census data, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(F)}}model F statistic{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}variance degrees of freedom{p_end}
{synopt:{cmd:e(N_pop)}}estimate of population size{p_end}
{synopt:{cmd:e(N_subpop)}}estimate of subpopulation size{p_end}
{synopt:{cmd:e(N_psu)}}number of sampled PSUs{p_end}
{synopt:{cmd:e(stages)}}number of sampling stages{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_aux)}}number of ancillary parameters{p_end}
{synopt:{cmd:e(p)}}p-value{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 22 24 2: Macros}{p_end}
{synopt:{cmd:e(prefix)}}{cmd:svy}{p_end}
{synopt:{cmd:e(cmdname)}}command name from {it:command}{p_end}
{synopt:{cmd:e(cmd)}}same as {cmd:e(cmdname)} or {cmd:e(vce)}{p_end}
{synopt:{cmd:e(command)}}{it:command}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(weight}{it:#}{cmd:)}}variable identifying weight for stage {it:#}{p_end}
{synopt:{cmd:e(wvar)}}weight variable name{p_end}
{synopt:{cmd:e(singleunit)}}{cmd:singleunit()} setting{p_end}
{synopt:{cmd:e(strata)}}{cmd:strata()} variable{p_end}
{synopt:{cmd:e(strata}{it:#}{cmd:)}}variable identifying strata for stage {it:#}{p_end}
{synopt:{cmd:e(psu)}}{cmd:psu()} variable{p_end}
{synopt:{cmd:e(su}{it:#}{cmd:)}}variable identifying sampling units for stage
                          {it:#}{p_end}
{synopt:{cmd:e(fpc)}}{cmd:fpc()} variable{p_end}
{synopt:{cmd:e(fpc}{it:#}{cmd:)}}FPC for stage {it:#}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(poststrata)}}{cmd:poststrata()} variable{p_end}
{synopt:{cmd:e(postweight)}}{cmd:postweight()} variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(mse)}}{cmd:mse}, if specified{p_end}
{synopt:{cmd:e(subpop)}}{it:subpop} from {cmd:subpop()}{p_end}
{synopt:{cmd:e(adjust)}}{cmd:noadjust}, if specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginswtype)}}weight type for {cmd:margins}{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 22 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}estimates{p_end}
{synopt:{cmd:e(V)}}design-based variance{p_end}
{synopt:{cmd:e(V_srs)}}simple-random-sampling-without-replacement variance,
V_srswor hat{p_end}
{synopt:{cmd:e(V_srssub)}}subpopulation
simple-random-sampling-without-replacement variance, V_srswor hat (created only
when {cmd:subpop()} is specified){p_end}
{synopt:{cmd:e(V_srswr)}}simple-random-sampling-with-replacement variance,
V_srswr hat (created only when {cmd:fpc()} option is {cmd:svyset}){p_end}
{synopt:{cmd:e(V_srssubwr)}}subpopulation simple-random-sampling-with-replacement variance, V_srswr hat (created only when {cmd:subpop()} is specified){p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(V_msp)}}variance from misspecified model fit, V_msp hat{p_end}
{synopt:{cmd:e(_N_strata_single)}}number of strata with one sampling unit{p_end}
{synopt:{cmd:e(_N_strata_certain)}}number of certainty strata{p_end}
{synopt:{cmd:e(_N_strata)}}number of strata{p_end}
{synopt:{cmd:e(_N_subp)}}estimate of subpopulation sizes within {cmd:over()}
groups{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 22 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}

{pstd}
{cmd:svy} also carries forward most of the results already in {cmd:e()} from
{it:command}.


{marker reference}{...}
{title:Reference}

{marker KG1990}{...}
{phang}
Korn, E. L., and B. I. Graubard.  1990.  Simultaneous testing of regression
coefficients with complex survey data: Use of Bonferroni t statistics.
{it:American Statistician} 44: 270-276.
{p_end}
