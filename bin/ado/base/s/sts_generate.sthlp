{smcl}
{* *! version 1.2.12  19sep2018}{...}
{viewerdialog "sts generate" "dialog sts_generate"}{...}
{vieweralsosee "[ST] sts generate" "mansection ST stsgenerate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] sts graph" "help sts_graph"}{...}
{vieweralsosee "[ST] sts list" "help sts_list"}{...}
{vieweralsosee "[ST] sts test" "help sts_test"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "sts_generate##syntax"}{...}
{viewerjumpto "Menu" "sts_generate##menu"}{...}
{viewerjumpto "Description" "sts_generate##description"}{...}
{viewerjumpto "Links to PDF documentation" "sts_generate##linkspdf"}{...}
{viewerjumpto "Functions" "sts_generate##functions"}{...}
{viewerjumpto "Options" "sts_generate##options"}{...}
{viewerjumpto "Examples" "sts_generate##examples"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[ST] sts generate} {hline 2}}Create variables containing survivor and related functions{p_end}
{p2col:}({mansection ST stsgenerate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}{cmd:sts} {opt gen:erate} {newvar} {cmd:=}
{c -(} {opt s} | {cmd:se(s)} | {opt h} | {cmd:se(lls)} | {cmd:lb(s)} |
{cmd:ub(s)} | {opt na} | {cmd:se(na)} | {cmd:lb(na)} | {cmd:ub(na)} |
{opt n} | {opt d} {c )-} [{newvar} {cmd:=} {{it:...}} {it:...}] {ifin}
[{cmd:,} {it:options}]

{synoptset 21 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt :{opth by(varlist)}}calculate separately for each group formed by {it:varlist}{p_end}
{synopt :{opth ad:justfor(varlist)}}adjust the estimates to zero values of {it:varlist}{p_end}
{synopt :{opth st:rata(varlist)}}stratify on different groups of {it:varlist}{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:sts generate}; see
{manhelp stset ST}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
       {bf:Create survivor, hazard, and other variables}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sts generate} creates new variables containing the estimated survivor
(failure) function, the Nelson-Aalen cumulative hazard (integrated hazard)
function, and related functions.  See {manhelp sts ST} for an introduction to
this command.

{pstd}
{cmd:sts generate} can be used with single- or multiple-record or single- or
multiple-failure st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stsgenerateQuickstart:Quick start}

        {mansection ST stsgenerateRemarksandexamples:Remarks and examples}

        {mansection ST stsgenerateMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker functions}{...}
{title:Functions}

{dlgtab:Main}

{phang}
{cmd:s} produces the Kaplan-Meier product-limit estimate of the
survivor function or, if {opt adjustfor()} is specified, the baseline survivor
function from a Cox regression model on the {opt adjustfor()} variables.

{phang}
{cmd:se(s)} produces the Greenwood, pointwise standard error.  This option may
not be used with {opt adjustfor()}.

{phang}
{cmd:h} produces the estimated hazard component deltaH_j = H(t_j) -
H(t_(j-1)), where t_j is the current failure time and t_(j-1) is the previous
one.  This is mainly a utility function used to calculate the estimated
cumulative hazard, H(t_j), yet you can estimate the hazard via a kernel smooth
of the deltaH_j; see {manhelp sts_graph ST:sts graph}.  It is recorded at all
the points at which a failure occurs and is computed as d_j/n_j, where d_j is
the number of failures occurring at time t_j and n_j is the number at risk at
t_j before the occurrence of the failures.

{phang}
{cmd:se(lls)} produces the standard error of ln{c -(}-ln S(t){c )-}.  This
option may not be used with {opt adjustfor()}.

{phang}
{cmd:lb(s)} produces the lower bound of the confidence interval for S(t) based
on ln{c -(}-ln S(t){c )-}.  This option may not be used with {opt adjustfor()}.

{phang}
{cmd:ub(s)} produces the corresponding upper bound.  This option may not be
used with {opt adjustfor()}.

{phang}
{cmd:na} produces the Nelson-Aalen estimate of the cumulative hazard
function.  This option may not be used with {cmd:adjustfor()}.

{phang}
{cmd:se(na)} produces the pointwise standard error for the Nelson-Aalen
estimate of the cumulative hazard function, H(t).  This option may not be used
with {opt adjustfor()}.

{phang}
{cmd:lb(na)} produces the lower bound of the confidence interval for
H(t) based on the log-transformed cumulative hazard function.  This option may
not be used with {opt adjustfor()}.

{phang}
{cmd:ub(na)} produces the corresponding upper bound.  This option may not be
used with {opt adjustfor()}.

{phang}
{cmd:n} produces n_j, the number at risk just before time t_j.  This option
may not be used with {opt adjustfor()}.

{phang}
{cmd:d} produces d_j, the number failing at time t_j.  This option may not
be used with {opt adjustfor()}.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opth by(varlist)} performs a separate calculation for each by-group.
By-groups are identified by equal values of the variables in {it:varlist}.
{opt by()} may not be combined with {opt strata()}.

{phang}
{opth adjustfor(varlist)} adjusts the estimate of the survivor (failure) or
hazard function to that for 0 values of {it:varlist}.  This
option is available only with functions {opt s} or {opt h}.  See
{manhelp sts_graph ST:sts graph} for an example of how to adjust for values
different from 0.

{pmore}
If you specify {opt adjustfor()} with {opt by()}, {cmd:sts} fits separate
Cox regression models for each group, using the {opt adjustfor()} variables as
the covariates.  The separately calculated baseline survivor functions are
then retrieved.

{pmore}
If you specify {opt adjustfor()} with {opt strata()}, {cmd:sts} fits
a stratified-on-group Cox regression model using the {opt adjustfor()}
variables as covariates.  The stratified, baseline survivor function is then
retrieved.

{phang}
{opth strata(varlist)} requests estimates of the survivor (failure) or hazard
functions stratified on variables in {it:varlist}.  It requires specifying
{opt adjustfor()} and may not be combined with {opt by()}.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for the
{cmd:lb(s)}, {cmd:ub(s)}, {cmd:lb(na)}, and {cmd:ub(na)} functions.  The default is {cmd:level(95)} or as set by {helpb set level}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}{p_end}
{phang2}{cmd:. stset}

{pstd}Create variable {cmd:surv} containing the estimate of the survivor
function{p_end}
{phang2}{cmd:. sts generate surv = s}

{pstd}Obtain the estimates of the survivor functions for the two categories of
{cmd:posttran} and save them in variable {cmd:surv_by}{p_end}
{phang2}{cmd:. sts generate surv_by = s, by(posttran)}

{pstd}Obtain the estimates of the survivor functions stratified on
{cmd:posttran} and adjusted for {cmd:age}{p_end}
{phang2}{cmd:. sts generate surv_adj = s, strata(posttran) adjustfor(age)}

{pstd}Create variables {cmd:cumh} and {cmd:cumh_se} containing the
Nelson-Aalen estimates and pointwise standard error for the Nelson-Aalen
estimate of the cumulative hazard function{p_end}
{phang2}{cmd:. sts generate cumh = na cumh_se = se(na)}{p_end}
