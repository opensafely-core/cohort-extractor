{smcl}
{* *! version 1.1.6  14may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi estimate using" "mansection MI miestimateusing"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[MI] mi estimate postestimation" "help mi estimate postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] Glossary" "help mi glossary"}{...}
{viewerjumpto "Syntax" "mi_estimate_using##syntax"}{...}
{viewerjumpto "Menu" "mi_estimate_using##menu"}{...}
{viewerjumpto "Description" "mi_estimate_using##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_estimate_using##linkspdf"}{...}
{viewerjumpto "Options" "mi_estimate_using##options"}{...}
{viewerjumpto "Example" "mi_estimate_using##example"}{...}
{viewerjumpto "Stored results" "mi_estimate_using##results"}{...}
{viewerjumpto "References" "mi_estimate_using##references"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[MI] mi estimate using} {hline 2}}Estimation using previously saved estimation results{p_end}
{p2col:}({mansection MI miestimateusing:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute MI estimates of coefficients using previously saved estimation results

{p 8 16 2}
{cmd:mi} {cmdab:est:imate} {cmd:using} {it:miestfile} [{cmd:,} {it:options}]


{phang}
Compute MI estimates of transformed coefficients using previously saved
estimation results

{p 8 16 2}
{cmd:mi} {cmdab:est:imate} [{it:spec}] {cmd:using} {it:miestfile}
 [{cmd:,} {it:options}]


{phang}
where {it:spec} may be one or more terms of the form
{cmd:(}[{it:name}{cmd::}] {it:{help nlcom##exp:exp}}{cmd:)}.
{it:exp} is any function of the parameter estimates allowed by {helpb nlcom}.

{phang}
{it:miestfile}{cmd:.ster} contains estimation results previously saved by
{cmd:mi} {cmd:estimate, saving(}{it:miestfile}{cmd:)}; see
{manhelp mi_estimate MI:mi estimate}.


{marker mi_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt:{opt ni:mputations(#)}}specify number of imputations to use; default is to use all existing imputations{p_end}
{synopt:{opth i:mputations(numlist)}}specify which imputations to use{p_end}
{synopt:{opth est:imations(numlist)}}specify which estimation results to use{p_end}
{synopt:{opt mcerr:or}}compute Monte Carlo error estimates{p_end}
{synopt:{opt ufmit:est}}perform unrestricted FMI model test{p_end}
{synopt:{opt nosmall}}do not apply small-sample correction to the degrees of freedom{p_end}

{syntab:Tables}
{synopt:[{cmdab:no:}]{cmdab:citab:le}}suppress/display standard estimation
table containing parameter-specific confidence intervals; default is
{cmd:citable}{p_end}
{synopt:{opt dftab:le}}display degrees-of-freedom table; {cmd:dftable}
implies {cmd:nocitable}{p_end}
{synopt:{opt vart:able}}display variance information about estimates; {cmd:vartable} implies {cmd:citable}{p_end}
{synopt:{it:{help mi_estimate##table_options:table_options}}}control table
output{p_end}
{synopt :{it:{help mi_estimate_using##display_options:display_options}}}control
columns and column formats, row spacing, display of omitted variables and base
   and empty cells, and factor-variable labeling{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt dots}}display dots as estimations are performed{p_end}
{synopt:{opt noi:sily}}display any output from {helpb nlcom} if transformations are specified{p_end}
{synopt:{opt trace}}trace {cmd:nlcom} if transformations are specified; implies {cmd:noisily}{p_end}
{synopt:{opt replay}}replay command-specific results from each individual estimation in {it:miestfile}{cmd:.ster}; implies {cmd:noisily}{p_end}
{synopt:{opt cmdleg:end}}display the command legend{p_end}
{synopt:{opt nogr:oup}}suppress summary about groups displayed for {cmd:xt} commands{p_end}
{synopt:{it:{help mi_estimate_using##me_options:me_options}}}control output from mixed-effects commands{p_end}

{syntab:Advanced}
{synopt:{opt errorok}}allow estimation even when {cmd:nlcom}
errors out in some imputations; such imputations are discarded from the
analysis{p_end}

INCLUDE help shortdes-coeflegend
{synopt:{opt nowarn:ing}}suppress the warning about varying estimation
sample{p_end}
{synopt:{opt noerrn:otes}}suppress error notes associated with failed
estimation results in {it:miestfile}{cmd:.ster}{p_end}
{synopt:{opt showimp:utations}}show imputations saved in {it:miestfile}{cmd:.ster}{p_end}
{synopt:{it:{help eform_option}}}display coefficients table in exponentiated form{p_end}
{synopt:{opt post}}post estimated coefficients and VCE to {cmd:e(b)} and {cmd:e(V)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt coeflegend}, {opt nowarning}, {opt noerrnotes}, {opt showimputations},
{it:eform_option}, and {cmd:post} do not appear in the dialog box.{p_end}


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
features available after estimation.  To replay results, type {cmd:mi}
{cmd:estimate} without arguments.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi estimate using} {it:miestfile} is for use after {cmd:mi estimate,}
{opt saving(miestfile)}{cmd::} ....  It allows obtaining multiple-imputation
(MI) estimates, including standard errors and confidence intervals, for
transformed coefficients or the original coefficients, this time calculated on
a subset of the imputations.  The transformation can be linear or nonlinear.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miestimateusingRemarksandexamples:Remarks and examples}

        {mansection MI miestimateusingMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opt nimputations(#)} specifies that the first {it:#} imputations be used;
{it:#} must be M_min <= {it:#} <= M, where M_min = 3 if {cmd:mcerror} is
specified and M_min = 2, otherwise.  The default is to use all imputations, M.
Only one of {cmd:nimputations()}, {cmd:imputations()}, or {cmd:estimations()}
may be specified.

{phang}
{opth imputations(numlist)} specifies which imputations to use.  The
default is to use all of them.  {it:numlist} must contain at least two
numbers corresponding to the imputations saved in {it:miestfile}{cmd:.ster}.
If {cmd:mcerror} is specified, {it:numlist} must contain at least three
numbers.  You can use the {cmd:showimputations} option to display imputations
currently saved in {it:miestfile}{cmd:.ster}.  Only one of
{cmd:nimputations()}, {cmd:imputations()}, or {cmd:estimations()} may be
specified.

{phang}
{opth estimations(numlist)} does the same thing as {opt imputations(numlist)},
but this time the imputations are numbered differently.  Say that
{it:miestfile}{cmd:.ster} was created by {cmd:mi estimate} and {cmd:mi estimate}
was told to limit itself to imputations 1, 3, 5, and 9.  With
{cmd:imputations()}, the imputations are still numbered 1, 3, 5, and 9.  With
{cmd:estimations()}, they are numbered 1, 2, 3, and 4.  Usually, one does not
specify a subset of imputations when using {cmd:mi estimate}, and so usually,
the {cmd:imputations()} and {cmd:estimations()} options are identical.  The
specified {it:numlist} must contain at least two numbers.  If {cmd:mcerror} is
specified, {it:numlist} must contain at least three numbers.  Only one of
{cmd:nimputations()}, {cmd:imputations()}, or {cmd:estimations()} may be
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
for details about the jackknife procedure.  As such, the Monte Carlo error
computation requires at least three imputations.

{pmore}
If {cmd:level()} is specified during estimation, MCE estimates are obtained
for confidence intervals with the specified confidence level instead of using
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
of freedom.  By default, individual tests of coefficients (and transformed
coefficients) use the small-sample correction of
{help mi estimate using##BR1999:Barnard and Rubin (1999)},
and the overall model test uses the small-sample correction of
{help mi estimate using##R2007:Reiter (2007)}.

{dlgtab:Tables}

{pstd}
All table options below may be specified at estimation time or when
redisplaying previously estimated results.  

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
{cmd:nocmdlegend} suppresses the table legend showing the command line, used
to produce results in {it:miestfile}{cmd:.ster}, from the output.  This
legend appears above the tables containing transformed coefficients (or above
the variance-information table if {cmd:vartable} is used) when {cmd:nocoef} is
specified.

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

{phang}
{opt level(#)}; see {manhelp estimation_options R:Estimation options}.

{phang}
{cmd:dots} specifies that dots be displayed as estimations of transformed
coefficients are successfully completed.  An {bf:x} is displayed if {cmd:nlcom}
fails to estimate one of the transformed coefficients specified in {it:spec}.
This option is relevant only if transformations are specified.

{phang}
{cmd:noisily} specifies that any output from {cmd:nlcom}, used to obtain the
estimates of transformed coefficients, be displayed.  This option is relevant
only if transformations are specified.

{phang}
{cmd:trace} traces the execution of {cmd:nlcom}.  {cmd:trace} implies
{cmd:noisily} and is relevant only if transformations are specified.

{phang}
{cmd:replay} replays estimation results from {it:miestfile}{cmd:.ster},
previously saved by {cmd:mi estimate,} {opt saving(miestfile)}.  This option
implies {cmd:noisily}.

{phang}
{cmd:cmdlegend} requests that the command line corresponding to the estimation
command used to produce the estimation results saved in
{it:miestfile}{cmd:.ster} be displayed.  {cmd:cmdlegend} may be specified at
run time or when redisplaying results.

{phang}
{cmd:nogroup} suppresses the display of group summary information (number of
groups, average group size, minimum, and maximum) as well as other
command-specific information displayed for {cmd:xt} commands.

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
The {cmd:stddeviations} option is the default with {cmd:mi estimate using}.
The {cmd:estmetric} option is implied when {cmd:vartable} or {cmd:dftable} is
used.

{dlgtab:Advanced}

{phang}
{cmd:errorok} specifies that estimations of transformed coefficients that fail
be skipped and the combined results be based on the successful estimation
results.  The default is that {cmd:mi estimate} stops if an individual
estimation fails.  If the {it:miestfile}{cmd:.ster} file contains failed
estimation results, {cmd:mi estimate using} does not error out; it issues
notes about which estimation results failed and discards these estimation
results in the computation.  You can use the {cmd:noerrnotes} option to
suppress the display of the notes.


{pstd}
The following options are available with {cmd:mi} {cmd:estimate} {cmd:using}
but are not shown in the dialog box:

{phang}
{cmd:coeflegend}; see {manhelp estimation_options R:Estimation options}.
{cmd:coeflegend} implies {cmd:nocitable} and cannot be combined with
{cmd:citable} or {cmd:dftable}.

{phang}
{cmd:nowarning} suppresses the warning message at the bottom of table output
that occurs if the estimation sample varies and {cmd:esampvaryok} is specified.
See
{mansection MI miestimateRemarksandexamplesPotentialproblemsthatcanarisewhenusingmiestimate:{it:Potential problems that can arise when using mi estimate}} in
{manhelp mi_estimate MI:mi estimate} for details.

{phang}
{cmd:noerrnotes} suppresses notes about failed estimation results.  These
notes appear when {it:miestfile}{cmd:.ster} contains estimation results,
previously saved by {cmd:mi estimate,} {opt saving(miestfile)}, from
imputations for which the estimation command used with {cmd:mi estimate}
failed to estimate parameters. 

{phang}
{cmd:showimputations} displays imputation numbers corresponding to the
estimation results saved in {it:miestfile}{cmd:.ster}.  {cmd:showimputations}
may be specified at run time or when redisplaying results. 

{phang}
{it:eform_option}; see {manhelpi eform_option R}.  {cmd:mi estimate using}
reports results in the coefficient metric under which the combination rules are
applied.  You may use the appropriate {it:eform_option} to redisplay results
in exponentiated form, if desired.  If {cmd:dftable} is also specified, the
reported degrees of freedom and percentage increases in standard errors are
not adjusted and correspond to the original coefficient metric. 

{phang}
{cmd:post} requests that MI estimates of coefficients and their
respective VCEs be posted in the usual way.  This allows the use of
{it:{help mi_estimation##estimation_command:estimation_command}}-specific postestimation tools with
MI estimates.  There are issues; see
{mansection MI miestimatepostestimationRemarksandexamplesUsingthecommand-specificpostestimationtools:{it:Using the command-specific postestimation tools}}
in {manhelp mi_estimate_postestimation MI:mi estimate postestimation}.
{cmd:post} may be specified at estimation time or when redisplaying previously
estimated results.


{marker example}
{title:Example}

{pstd}
Use previously saved estimates to obtain estimate of the ratio of coefficients;
(1) make the previously saved estimates
{p_end}
{phang2}
{cmd:. webuse mhouses1993s30}
{p_end}
{phang2}
{cmd:. mi estimate, saving(miest): regress price tax sqft age nfeatures ne custom corner}
{p_end}

{pstd}
(2) use previously saved estimates to obtain estimate of the desired ratio
{p_end}
{phang2}
{cmd:. mi estimate (ratio: _b[age]/_b[sqft]) using miest}

{pstd}
Compute Monte Carlo error estimates of coefficients and the ratio of coefficients
{p_end}
{phang2}
{cmd:. mi estimate (ratio: _b[age]/_b[sqft]) using miest, mcerror}

{pstd}
If you just ran this example, when you are through, erase file containing 
previous estimates, 
{p_end}
{phang2}
{cmd:. erase miest.ster}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {it:{helpb mi_estimate##results:Stored results}} in
{manhelp mi_estimate MI:mi estimate}.


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

{marker WRW2011}{...}
{phang}
White, I. R., P. Royston, and A. M. Wood. 2011.  Multiple imputation using 
chained equations: Issues and guidance for practice.  
{it:Statistics in Medicine} 30: 377-399.
{p_end}
