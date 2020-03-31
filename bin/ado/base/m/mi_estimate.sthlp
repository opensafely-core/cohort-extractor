{smcl}
{* *! version 1.2.8  14may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi estimate" "mansection MI miestimate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate postestimation" "help mi estimate postestimation"}{...}
{vieweralsosee "[MI] mi estimate using" "help mi_estimate_using"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] Glossary" "help mi glossary"}{...}
{viewerjumpto "Syntax" "mi_estimate##syntax"}{...}
{viewerjumpto "Menu" "mi_estimate##menu"}{...}
{viewerjumpto "Description" "mi_estimate##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_estimate##linkspdf"}{...}
{viewerjumpto "Options" "mi_estimate##options"}{...}
{viewerjumpto "Examples" "mi_estimate##examples"}{...}
{viewerjumpto "Stored results" "mi_estimate##results"}{...}
{viewerjumpto "References" "mi_estimate##references"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[MI] mi estimate} {hline 2}}Estimation using multiple imputations{p_end}
{p2col:}({mansection MI miestimate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute MI estimates of coefficients by fitting estimation command to mi data

{p 8 16 2}
{cmd:mi} {cmdab:est:imate} [{cmd:,} {it:options}] {cmd::} {it:{help mi_estimation##estimation_command:estimation_command}} ...


{phang}
Compute MI estimates of transformed coefficients by fitting estimation command
to mi data

{p 8 16 2}
{cmd:mi} {cmdab:est:imate} [{it:{help mi_estimate##spec:spec}}]
   [{cmd:,} {it:options}] {cmd::}
   {it:{help mi_estimation##estimation_command:estimation_command}} ...


{marker spec}{...}
{phang}
where {it:spec} may be one or more terms of the form
{cmd:(}[{it:name}{cmd::}] {it:{help nlcom##exp:exp}}{cmd:)}.
{it:exp} is any function of the parameter estimates allowed by {helpb nlcom}.


{marker mi_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt:{opt ni:mputations(#)}}specify number of imputations to use; default is to use all existing imputations{p_end}
{synopt:{opth i:mputations(numlist)}}specify which imputations to use{p_end}
{synopt:{opt mcerr:or}}compute Monte Carlo error estimates{p_end}
{synopt:{opt ufmit:est}}perform unrestricted FMI model test{p_end}
{synopt:{opt nosmall}}do not apply small-sample correction to degrees of freedom{p_end}
{synopt:{cmdab:sav:ing(}{it:miestfile}[{cmd:, replace}]{cmd:)}}save individual estimation results to {it:miestfile}{cmd:.ster}{p_end}

{syntab:Tables}
{synopt:[{cmdab:no:}]{cmdab:citab:le}}suppress/display standard estimation
table containing parameter-specific confidence intervals; default is
{cmd:citable}{p_end}
{synopt:{opt dftab:le}}display degrees-of-freedom table; {cmd:dftable}
implies {cmd:nocitable}{p_end}
{synopt:{opt vart:able}}display variance information about estimates; {cmd:vartable} implies {cmd:citable}{p_end}
{synopt:{it:{help mi_estimate##table_options:table_options}}}control table
output{p_end}
{synopt :{it:{help mi_estimate##display_options:display_options}}}control
columns and column formats, row spacing, display of omitted variables and base
   and empty cells, and factor-variable labeling{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt dots}}display dots as estimations are performed{p_end}
{synopt:{opt noi:sily}}display any output from {it:{help mi_estimation##estimation_command:estimation_command}} (and from {cmd:nlcom} if transformations specified){p_end}
{synopt:{opt trace}}trace {it:{help mi_estimation##estimation_command:estimation_command}} (and {cmd:nlcom} if transformations specified); implies {cmd:noisily}{p_end}
{synopt:{opt nogr:oup}}suppress summary about groups displayed for {helpb mi estimation##xt_cmds:xt} commands{p_end}
{synopt:{it:{help mi_estimate##me_options:me_options}}}control output from mixed-effects commands{p_end}

{syntab:Advanced}
{synopt:{opth esample(newvar)}}store estimation sample in variable
{it:newvar}; available only in the flong and flongsep styles{p_end}
{synopt:{opt errorok}}allow estimation even when {it:{help mi_estimation##estimation_command:estimation_command}}
 (or {cmd:nlcom}) errors out; such imputations are discarded from the
analysis{p_end}
{synopt:{opt esampvaryok}}allow estimation when estimation sample varies across imputations{p_end}
{synopt:{opt cmdok}}allow estimation when
   {help mi_estimation##estimation_command:{it:estimation_command}} is not one
   of the supported estimation commands{p_end}

INCLUDE help shortdes-coeflegend
{synopt:{opt nowarn:ing}}suppress the warning about varying estimation sample{p_end}
{synopt:{it:{help eform_option}}}display coefficients table in exponentiated form{p_end}
{synopt:{opt post}}post estimated coefficients and VCE to {cmd:e(b)} and {cmd:e(V)}{p_end}
{synopt:{opt noup:date}}do not perform {cmd:mi update}; see {manhelp mi_noupdate_option MI:noupdate option}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:estimate};
see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
{opt coeflegend}, {opt nowarning}, {it:eform_option}, {cmd:post}, and
{cmd:noupdate} do not appear in the dialog box.{p_end}


{marker table_options}{...}
{synoptset 29}{...}
{synopthdr:table_options}
{synoptline}
{synopt:{opt nohead:er}}suppress table header(s){p_end}
{synopt:{opt notab:le}}suppress table(s){p_end}
{synopt:{opt nocoef}}suppress table output related to coefficients{p_end}
{synopt:{opt nocmdleg:end}}suppress command legend that appears in the presence of transformed coefficients when {cmd:nocoef} is used{p_end}
{synopt:{opt notrcoef}}suppress table output related to transformed
coefficients{p_end}
{synopt:{opt noleg:end}}suppress table legend(s){p_end}
{synopt:{opt nocnsr:eport}}do not display constraints{p_end}
{synoptline}
{p2colreset}{...}


{pstd}
See {manhelp mi_estimate_postestimation MI:mi estimate postestimation} for
features available after estimation.  {cmd:mi} {cmd:estimate} is its own
estimation command.  The postestimation features for {cmd:mi} {cmd:estimate} do
not include by default the postestimation features for {it:estimation_command}.
To replay results, type {cmd:mi} {cmd:estimate} without arguments.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mi estimate:}
{it:{help mi_estimation##estimation_command:estimation_command}} runs
{it:estimation_command} on the imputed {cmd:mi} data, and adjusts coefficients
and standard errors for the variability between imputations according to the
combination rules by {help mi estimate##R1987:Rubin (1987)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miestimateRemarksandexamples:Remarks and examples}

        {mansection MI miestimateMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opt nimputations(#)} specifies that the first {it:#} imputations be used;
{it:#} must be M_min <= {it:#} <= M, where M_min = 3 if {cmd:mcerror} is
specified and M_min = 2, otherwise.  The default is to use all imputations, M.
Only one of {cmd:nimputations()} or {cmd:imputations()} may be specified.

{phang}
{opth imputations(numlist)} specifies which imputations to use.  The
default is to use all of them.  {it:numlist} must contain at least two
numbers.  If {cmd:mcerror} is specified, {it:numlist} must contain at least
three numbers.  Only one of {cmd:nimputations()} or {cmd:imputations()} may be
specified.

{phang}
{cmd:mcerror} specifies to compute Monte Carlo error (MCE) estimates for the
results displayed in the estimation, degrees-of-freedom, and
variance-information tables.  MCE estimates reflect variability of MI results
across repeated uses of the same imputation procedure and are useful for
determining an adequate number of imputations to obtain stable MI results; see
{help mi estimate##WRW2011:White, Royston, and Wood (2011)} for details and
guidelines.

{pmore}
MCE estimates are obtained by applying the jackknife procedure to
multiple-imputation results.  That is, the jackknife pseudovalues of MI results
are obtained by omitting one imputation at a time; see {manhelp jackknife R}
for details about the jackknife procedure.  As such, the MCE
computation requires at least three imputations.

{pmore}
If {cmd:level()} is specified during estimation, MCE estimates are obtained
for confidence intervals using the specified confidence level instead of using
the default 95% confidence level.  If any of the options described in
{manhelpi eform_option R} is specified during estimation, MCE estimates for
the coefficients, standard errors, and confidence intervals in the
exponentiated form are also computed.  {cmd:mcerror} can also be used upon
replay to display MCE estimates.  Otherwise, MCE estimates are not reported
upon replay even if they were previously computed.

{phang}
{cmd:ufmitest} specifies that the unrestricted fraction missing information
(FMI) model test be used.  The default test performed assumes equal
fractions of information missing due to nonresponse for all coefficients.  This
is equivalent to the assumption that the between-imputation and
within-imputation variances are proportional.  The unrestricted test may be
preferable when this assumption is suspect provided the number of imputations
is large relative to the number of estimated coefficients.

{phang}
{cmd:nosmall} specifies that no small-sample correction be made to the degrees
of freedom.  The small-sample correction is made by default to estimation
commands that account for small samples.  If the command stores residual degrees
of freedom in {cmd:e(df_r)}, individual tests of coefficients (and transformed
coefficients) use the small-sample correction of 
{help mi estimate##BR1999:Barnard and Rubin (1999)} and
the overall model test uses the small-sample correction of
{help mi estimate##R2007:Reiter (2007)}.  If
the command does not store residual degrees of freedom, the large-sample test is
used and the {cmd:nosmall} option has no effect.

{phang}
{cmd:saving(}{it:miestfile} [{cmd:, replace}]{cmd:)} saves estimation results
from each model fit in {it:miestfile}{cmd:.ster}. The {cmd:replace}
suboption specifies to overwrite {it:miestfile}{cmd:.ster} if it exists.
{it:miestfile}{cmd:.ster} can later be used by {cmd:mi estimate using} (see
{manhelp mi_estimate_using MI:mi estimate using}) to obtain MI estimates of
coefficients or of transformed coefficients without refitting the
completed-data models.  This file is written in the format used by
{cmd:estimates use}; see {manhelp estimates_save R:estimates save}.

{dlgtab:Tables}

{pstd}
All table options below may be specified at estimation time or when
redisplaying previously estimated results.  Table options must be specified as
options to {cmd:mi estimate}, not to {it:estimation_command}.

{phang}
{cmd:citable} and {cmd:nocitable} specify whether the standard
estimation table containing parameter-specific confidence intervals is
displayed.  The default is {cmd:citable}.  {cmd:nocitable} can be used with
{cmd:vartable} to suppress the confidence interval table.

{phang}
{cmd:dftable} displays a table containing parameter-specific degrees of
freedom and percentages of increase in standard errors due to nonresponse.
{cmd:dftable} implies {cmd:nocitable}.  

{phang}
{cmd:vartable} displays a table reporting variance information about
MI estimates.  The table contains estimates of
within-imputation variances, between-imputation variances, total variances,
relative increases in variance due to nonresponse, fractions of information
about parameter estimates missing due to nonresponse, and relative
efficiencies for using finite M rather than a hypothetically infinite number
of imputations.  {cmd:vartable} implies {cmd:citable}.

{phang}
{it:table_options} control the appearance of all displayed table output:

{phang2}
{cmd:noheader} suppresses all header information from the output.  The table
output is still displayed.  

{phang2}
{cmd:notable} suppresses all tables from the output.  The header information
is still displayed.  

{phang2}
{cmd:nocoef} suppresses the display of tables containing coefficient
estimates.  This option affects the table output produced by {cmd:citable},
{cmd:dftable}, and {cmd:vartable}.  

{phang2}
{cmd:nocmdlegend} suppresses the table legend showing the specified command
line, {it:{help mi_estimation##estimation_command:estimation_command}}, from
the output.  This legend appears above the tables containing transformed
coefficients (or above the variance-information table if {cmd:vartable} is
used) when {cmd:nocoef} is specified.

{phang2}
{cmd:notrcoef} suppresses the display of tables containing estimates of
transformed coefficients (if specified).  This option affects the table output
produced by {cmd:citable}, {cmd:dftable}, and {cmd:vartable}.  

{phang2}
{cmd:nolegend} suppresses all table legends from the output.  

{phang2}
{cmd:nocnsreport}; see {manhelp estimation_options R:Estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)}, and
{opt sformat(%fmt)};
    see {helpb estimation options##display_options:[R] Estimation options}.
{p_end}

{dlgtab:Reporting}

{pstd}
Reporting options must be specified as options to {cmd:mi estimate} and not as
options to {it:estimation_command}.

{phang}
{opt level(#)}; see {manhelp estimation_options R:Estimation options}.

{phang}
{cmd:dots} specifies that dots be displayed as estimations are successfully
completed.  An {bf:x} is displayed if the
{it:{help mi_estimation##estimation_command:estimation_command}} returns
an error, if the model fails to converge, or if {cmd:nlcom} fails to estimate
one of the transformed coefficients specified in {it:spec}.

{phang}
{cmd:noisily} specifies that any output from
{it:{help mi_estimation##estimation_command:estimation_command}} and
{cmd:nlcom}, used to obtain the estimates of transformed coefficients if
transformations are specified, be displayed.

{phang}
{cmd:trace} traces the execution of
{it:{help mi_estimation##estimation_command:estimation_command}} and traces
{cmd:nlcom} if transformations are specified.  {cmd:trace} implies
{cmd:noisily}.

{phang}
{cmd:nogroup} suppresses the display of group summary information (number of
groups, average group size, minimum, and maximum) as well as other
command-specific information displayed for {cmd:xt} commands; see
the list of commands under {help mi estimation##xt_cmds:{it:Panel-data models}}
in {manhelp mi_estimation MI:Estimation}.

{marker me_options}{...}
{phang}
{it:me_options}:
{opt stddev:iations},
{opt var:iance},
{opt noret:able},
{opt nofet:able}, and
{opt estm:etric}.
These options are relevant only with the mixed-effects command
{cmd:mixed} (see {manhelp mixed ME}).
See the corresponding mixed-effects commands for more information.
The {cmd:stddeviations} option is the default with {cmd:mi estimate}.
The {cmd:estmetric} option is implied when {cmd:vartable} or {cmd:dftable} is
used.

{dlgtab:Advanced}

{marker esample()}{...}
{phang}
{opth esample(newvar)} creates {it:newvar} containing {cmd:e(sample)}.
This option is useful to identify which observations were used in the
estimation, especially when the estimation sample varies across imputations
(see {mansection MI miestimateRemarksandexamplesPotentialproblemsthatcanarisewhenusingmiestimate:{it:Potential problems that can arise when using mi estimate}}
for details).  {it:newvar} is zero in the original data (m=0) and in
any imputations (m>0) in which the estimation failed or that were not used
in the computation.  {cmd:esample()} may be specified only if the data are
flong or flongsep; see {manhelp mi_convert MI:mi convert} to convert to one of
those styles.  The variable created will be super varying and therefore must not
be registered; see {manhelp mi_varying MI:mi varying} for more explanation.
The saved estimation sample {it:newvar} may be used later with {cmd:mi extract}
(see {manhelp mi_extract MI:mi extract}) to set the estimation sample.

{phang}
{cmd:errorok} specifies that estimations that fail be skipped and the combined
results be based on the successful individual estimation results.  The default
is that {cmd:mi estimate} stops if an individual estimation fails.  If
{cmd:errorok} is specified with {cmd:saving()}, all estimation results,
including failed, are saved to a file.

{phang}
{cmd:esampvaryok} allows estimation to continue even if the estimation sample
varies across imputations.  {cmd:mi} {cmd:estimate} stops if the estimation
sample varies.  If {cmd:esampvaryok} is specified, results from all
imputations are used to compute MI estimates and a warning message is
displayed at the bottom of the table.  Also see the 
{helpb mi_estimate##esample():esample()} option.  See
{mansection MI miestimateRemarksandexamplesPotentialproblemsthatcanarisewhenusingmiestimate:{it:Potential problems that can arise when using mi estimate}}
for more information.

{phang}
{cmd:cmdok} allows unsupported estimation commands to be used with {cmd:mi}
{cmd:estimate}; see {manhelp mi_estimation MI:estimation} for a list of
supported estimation commands.  Alternatively, if you want {cmd:mi}
{cmd:estimate} to work with your estimation command, add the property {cmd:mi}
to the program properties; see
{manhelp program_properties P:program properties}.

{pstd}
The following options are available with {cmd:mi estimate} but are not shown in
the dialog box:

{phang}
{cmd:coeflegend}; see {manhelp estimation_options R:Estimation options}.
{cmd:coeflegend} implies {cmd:nocitable} and cannot be combined with
{cmd:citable} or {cmd:dftable}.

{phang}
{cmd:nowarning} suppresses the warning message at the bottom of table output
that occurs if the estimation sample varies and {cmd:esampvaryok} is specified.
See
{mansection MI miestimateRemarksandexamplesPotentialproblemsthatcanarisewhenusingmiestimate:{it:Potential problems that can arise when using mi estimate}}
for details.

{phang}
{it:eform_option}; see {manhelpi eform_option R}.  Regardless of the
{it:{help mi_estimation##estimation_command:estimation_command}} specified,
{cmd:mi estimate} reports results in the coefficient metric under which the
combination rules are applied.  You may use the appropriate {it:eform_option}
to redisplay results in exponentiated form, if desired.  If {cmd:dftable} is
also specified, the reported degrees of freedom and percentage increases in
standard errors are not adjusted and correspond to the original coefficient
metric.

{phang}
{cmd:post} requests that MI estimates of coefficients and their
respective VCEs be posted in the usual way.  This allows the use of
{it:{help mi_estimation##estimation_command:estimation_command}}-specific
postestimation tools with MI estimates.  There are issues; see
{mansection MI miestimatepostestimationRemarksandexamplesUsingthecommand-specificpostestimationtools:{it:Using the command-specific postestimation tools}} in
{manhelp mi_estimate_postestimation MI:mi estimate postestimation}.  {cmd:post}
may be specified at estimation time or when redisplaying previously estimated
results.

{phang}
{cmd:noupdate} in some cases suppresses the automatic {cmd:mi update} this
command might perform; see {manhelp noupdate_option MI:noupdate option}.  This
option is seldom used.


{marker examples}{...}
{title:Example 1}

{pstd}
Estimate on completed data using {cmd:logit}
{p_end}
{phang2}
{cmd:.  webuse mheart1s20}
{p_end}
{phang2}
{cmd:.  mi describe}
{p_end}
{phang2}
{cmd:.  mi estimate, dots: logit attack smokes age bmi hsgrad female}
{p_end}

{pstd}
Replay estimation results
{p_end}
{phang2}
{cmd:.  mi estimate}
{p_end}

{pstd}
Display coefficient-specific degrees of freedom
{p_end}
{phang2}
{cmd:.  mi estimate, dftable }
{p_end}

{pstd}
Show coefficient-specific variance information
{p_end}
{phang2}
{cmd:.  mi estimate, vartable nocitable}
{p_end}

{pstd}
Display odds ratios
{p_end}
{phang2}
{cmd:.  mi estimate, or}
{p_end}

{pstd}
Compute Monte Carlo error estimates
{p_end}
{phang2}
{cmd:.  mi estimate, dots mcerror: logit attack smokes age bmi hsgrad female}
{p_end}

{pstd}
Compute Monte Carlo error estimates for odds ratios
{p_end}
{phang2}
{cmd:.  mi estimate, dots mcerror or: logit attack smokes age bmi hsgrad female}
{p_end}


{title:Example 2}

{pstd}
Estimate on completed data using {cmd:stcox}
{p_end}
{phang2}
{cmd:. webuse mdrugtrs25}
{p_end}
{phang2}
{cmd:. mi describe}
{p_end}
{phang2}
{cmd:. mi stset studytime, failure(died)}
{p_end}
{phang2}
{cmd:. mi estimate, dots: stcox drug age}
{p_end}

{pstd}
Redisplay results as hazard ratios
{p_end}
{phang2}
{cmd:. mi estimate, hr}
{p_end}


{title:Example 3}

{pstd}
Estimate on completed data using {cmd:xtreg}
{p_end}
{phang2}
{cmd:. webuse mjsps5, clear}
{p_end}
{phang2}
{cmd:. mi xtset school}
{p_end}
{phang2}
{cmd:. mi estimate: xtreg math5 math3}
{p_end}


{title:Example 4}

{pstd}
Estimate on completed data using {cmd:mixed}
{p_end}
{phang2}
{cmd:. webuse mjsps5}
{p_end}
{phang2}
{cmd:. mi estimate, dots: mixed math5 math3 || school:, reml}
{p_end}

{pstd}
Redisplay results as variance components
{p_end}
{phang2}
{cmd:. mi estimate, variance}
{p_end}


{title:Example 5}

{pstd}
Estimate on completed data of specified linear regression and 
additionally specified transformation of those coefficients
{p_end}
{phang2}
{cmd:. webuse mhouses1993s30}
{p_end}
{phang2}
{cmd:. mi estimate (ratio: _b[age]/_b[sqft]): regress price tax sqft age nfeatures ne custom corner}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi estimate} stores the following in {cmd:e()}:

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(df_avg}[{cmd:_Q}]{cmd:_mi)}}average degrees of freedom{p_end}
{synopt:{cmd:e(df_c_mi)}}complete degrees of freedom (if originally stored by 
 {it:estimation_command} in {cmd:e(df_r)}){p_end}
{synopt:{cmd:e(df_max}[{cmd:_Q}]{cmd:_mi)}}maximum degrees of freedom{p_end}
{synopt:{cmd:e(df_min}[{cmd:_Q}]{cmd:_mi)}}minimum degrees of freedom{p_end}
{synopt:{cmd:e(df_m_mi)}}MI model test denominator (residual) degrees of 
freedom{p_end}
{synopt:{cmd:e(df_r_mi)}}MI model test numerator (model) degrees of freedom
{p_end}
{synopt:{cmd:e(esampvary_mi)}}varying-estimation sample flag ({cmd:0} or
{cmd:1}){p_end}
{synopt:{cmd:e(F_mi)}}model test F statistic{p_end}
{synopt:{cmd:e(k_exp_mi)}}number of expressions (transformed coefficients)
{p_end}
{synopt:{cmd:e(M_mi)}}number of imputations{p_end}
{synopt:{cmd:e(N_mi)}}number of observations (minimum, if varies){p_end}
{synopt:{cmd:e(N_min_mi)}}minimum number of observations{p_end}
{synopt:{cmd:e(N_max_mi)}}maximum number of observations{p_end}
{synopt:{cmd:e(N_g_mi)}}number of groups{p_end}
{synopt:{cmd:e(g_min_mi)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg_mi)}}average group size{p_end}
{synopt:{cmd:e(g_max_mi)}}largest group size{p_end}
{synopt:{cmd:e(p_mi)}}MI model test p-value{p_end}
{synopt:{cmd:e(cilevel_mi)}}confidence level used to compute Monte Carlo error estimates of confidence intervals{p_end}
{synopt:{cmd:e(fmi_max}[{cmd:_Q}]{cmd:_mi)}}largest FMI{p_end}
{synopt:{cmd:e(rvi_avg}[{cmd:_Q}]{cmd:_mi)}}average RVI{p_end}
{synopt:{cmd:e(rvi_avg_F_mi)}}average RVI associated with the residual degrees of freedom for model test{p_end}
{synopt:{cmd:e(ufmi_mi)}}{cmd:1} if unrestricted FMI model test is performed,
{cmd:0} if equal FMI model test is performed{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(mi)}}{cmd:mi}{p_end}
{synopt:{cmd:e(cmdline_mi)}}command as typed{p_end}
{synopt:{cmd:e(prefix_mi)}}{cmd:mi} {cmd:estimate}{p_end}
{synopt:{cmd:e(cmd_mi)}}name of {it:estimation_command}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:mi estimate} (equals {cmd:e(cmd_mi)} when {cmd:post} is used){p_end}
{synopt:{cmd:e(title_mi)}}"Multiple-imputation estimates"{p_end}
{synopt:{cmd:e(wvce_mi)}}title used to label within-imputation variance in
the table header{p_end}
{synopt:{cmd:e(modeltest_mi)}}title used to label the model test in the table
header{p_end}
{synopt:{cmd:e(dfadjust_mi)}}title used to label the degrees-of-freedom adjustment in the table header{p_end}
{synopt:{cmd:e(expnames_mi)}}names of expressions specified in
{it:spec}{p_end}
{synopt:{cmd:e(exp}{it:#}{cmd:_mi)}}expressions of the transformed
coefficients specified in {it:spec}{p_end}
{synopt:{cmd:e(rc_mi)}}return codes for each imputation{p_end}
{synopt:{cmd:e(m_mi)}}specified imputation numbers{p_end}
{synopt:{cmd:e(m_est_mi)}}imputation numbers used in the computation{p_end}
{synopt:{cmd:e(names_vvl_mi)}}command-specific {cmd:e()} macro names that
contents varied across imputations{p_end}
{synopt:{cmd:e(names_vvm_mi)}}command-specific {cmd:e()} matrix names that
values varied across imputations
(excluding {cmd:b}, {cmd:V}, and {cmd:Cns}){p_end}
{synopt:{cmd:e(names_vvs_mi)}}command-specific {cmd:e()} scalar names that
values varied across imputations{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}MI estimates of coefficients (equals {cmd:e(b_mi)}; stored only if {cmd:post} is used){p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix (equals {cmd:e(V_mi)}; stored only if {cmd:post} is used){p_end}
{synopt:{cmd:e(Cns)}}constraint matrix, for constrained estimation only (equals {cmd:e(Cns_mi)}; stored only if {cmd:post} is used){p_end}
{synopt:{cmd:e(N_g_mi)}}group counts{p_end}
{synopt:{cmd:e(g_min_mi)}}group-size minimums{p_end}
{synopt:{cmd:e(g_avg_mi)}}group-size averages{p_end}
{synopt:{cmd:e(g_max_mi)}}group-size maximums{p_end}
{synopt:{cmd:e(b}[{cmd:_Q}]{cmd:_mi)}}MI estimates of coefficients (or
transformed coefficients){p_end}
{synopt:{cmd:e(V}[{cmd:_Q}]{cmd:_mi)}}variance-covariance matrix (total
variance){p_end}
{synopt:{cmd:e(Cns}{cmd:_mi)}}constraint matrix (for constrained estimation only){p_end}
{synopt:{cmd:e(W}[{cmd:_Q}]{cmd:_mi)}}within-imputation variance matrix{p_end}
{synopt:{cmd:e(B}[{cmd:_Q}]{cmd:_mi)}}between-imputation variance matrix{p_end}
{synopt:{cmd:e(re}[{cmd:_Q}]{cmd:_mi)}}parameter-specific relative
efficiencies{p_end}
{synopt:{cmd:e(rvi}[{cmd:_Q}]{cmd:_mi)}}parameter-specific RVIs{p_end}
{synopt:{cmd:e(fmi}[{cmd:_Q}]{cmd:_mi)}}parameter-specific FMIs{p_end}
{synopt:{cmd:e(df}[{cmd:_Q}]{cmd:_mi)}}parameter-specific degrees of freedom
{p_end}
{synopt:{cmd:e(pise}[{cmd:_Q}]{cmd:_mi)}}parameter-specific percentages
increase in standard errors{p_end}
{synopt:{cmd:e(}{it:vs_names}{cmd:_vs_mi)}}values of command-specific
{cmd:e()} scalar {it:vs_names} that varied across imputations{p_end}

{phang}
{it:vs_names} include (but are not restricted to) {cmd:df_r}, {cmd:N},
{cmd:N_strata}, {cmd:N_psu}, {cmd:N_pop}, {cmd:N_sub}, {cmd:N_poststrata},
{cmd:N_stdize}, {cmd:N_subpop}, {cmd:N_over}, and {cmd:converged}. 

{phang}
Results {cmd:N_g_mi}, {cmd:g_min_mi}, {cmd:g_avg_mi}, and {cmd:g_max_mi} are
stored for panel-data models only.  The results are stored as matrices for
mixed-effects models and as scalars for other panel-data models.

{phang}
If transformations are specified, the corresponding estimation results are
stored with the {cmd:_Q_mi} suffix, as described above.

{phang}
Command-specific {cmd:e()} results that remain constant across imputations
are also stored.  Command-specific results that vary from imputation to
imputation are posted as missing, and their names are stored in the
corresponding macros {cmd:e(names_vvl_mi)}, {cmd:e(names_vvm_mi)}, and
{cmd:e(names_vvs_mi)}.  For some command-specific {cmd:e()} scalars (see
{it:vs_names} above), their values from each imputation are stored in a
corresponding matrix with the {cmd:_vs_mi} suffix.


{marker references}{...}
{title:References}

{marker BR1999}{...}
{phang}
Barnard, J., and D. B. Rubin. 1999.  Small-sample degrees of freedom with 
multiple imputation.  {it:Biometrika} 86: 948-955.

{marker R2007}{...}
{phang}
Reiter, J. P. 2007.  Small-sample degrees of freedom for multi-component 
significance tests with multiple imputation for missing data.  {it:Biometrika}
94: 502-508.

{marker R1987}{...}
{phang}
Rubin, D. B. 1987.  {it:Multiple Imputation for Nonresponse in Surveys}. New
York: Wiley.

{marker WRW2011}{...}
{phang}
White, I. R., P. Royston, and A. M. Wood. 2011.  Multiple imputation using 
chained equations: Issues and guidance for practice.  
{it:Statistics in Medicine} 30: 377-399.
{p_end}
