{smcl}
{* *! version 1.0.14  04mar2019}{...}
{viewerdialog power "dialog power_mcc"}{...}
{vieweralsosee "[PSS-2] power mcc" "mansection PSS-2 powermcc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power pairedproportions" "help power pairedproportions"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{vieweralsosee "[R] symmetry" "help symmetry"}{...}
{viewerjumpto "Syntax" "power_mcc##syntax"}{...}
{viewerjumpto "Menu" "power_mcc##menu"}{...}
{viewerjumpto "Description" "power_mcc##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_mcc##linkspdf"}{...}
{viewerjumpto "Options" "power_mcc##options"}{...}
{viewerjumpto "Remarks: Using power mcc" "power_mcc##remarks"}{...}
{viewerjumpto "Examples" "power_mcc##examples"}{...}
{viewerjumpto "Stored results""power_mcc##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[PSS-2] power mcc} {hline 2}}Power analysis for matched 
case-control studies{p_end}
{p2col:}({mansection PSS-2 powermcc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 43 2}
{opt power} {opt mcc} {it:p0}{cmd:,} {opth or:atio(numlist)}
[{opth p:ower(numlist)} 
{it:{help power_mcc##synoptions:options}}] 


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt mcc} {it:p0}{cmd:,} {opth or:atio(numlist)}
{opth n(numlist)}  
[{it:{help power_mcc##synoptions:options}}]


{phang}
Compute target odds ratio

{p 8 43 2}
{opt power} {opt mcc} {it:p0}{cmd:,} 
{opth p:ower(numlist)}  
{opth n(numlist)} 
[{it:{help power_mcc##synoptions:options}}]


{phang}
where {it:p0} is the probability of exposure among control patients. 
{it:p0} must satisfy the condition 0 < {it:p0} < 1 and may be specified
either as one number or as a list of values in parentheses
(see {help numlist}).


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
   {cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is {cmd:power(0.8)}{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error; default is
   {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth n(numlist)}}sample size; required to compute power or 
effect size{p_end}
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth or:atio(numlist)}}odds ratio of exposure in cases relative
to controls; required to compute power or sample size{p_end}
{p2coldent:* {opth m(numlist)}}number of matched controls per case; default
	is {cmd:m(1)}{p_end}
{synopt: {cmd:compare}}ratio of the required number of cases for
         1:{it:M} design relative to a paired 1:1 design{p_end}
{p2coldent:* {opth corr(numlist)}}correlation of exposure between cases and
         controls; default is {cmd:corr(0)}{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_mcc##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or effect size{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_mcc##column:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]

{pstd}
{it:column} is one of the columns defined below,
and {it:label} is a column label (may contain quotes and compound quotes).


{synoptset 15}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt power}}power{p_end}
{synopt :{opt beta}}type II error probability{p_end}
{synopt :{opt N}}number of cases{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt M}}number of matched controls{p_end}
{synopt :{opt F_M}}ratio of the number of cases with {it:M} controls relative
     to one control{p_end}
{synopt :{opt p0}}probability of exposure among controls{p_end}
{synopt :{opt p1}}probability of exposure among cases{p_end}
{synopt :{opt oratio}}odds ratio{p_end}
{synopt :{opt corr}}correlation of exposure between cases and controls{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:oratio}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if option {cmd:beta()} is specified.{p_end}
{p 4 6 2}Column {cmd:F_M} is shown in the default table only if option
{cmd:compare} is specified.{p_end}
{p 4 6 2}Column {cmd:p1} is not shown in the default table.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power mcc} computes sample size, power, or effect size (the minimum
detectable odds ratio) for a test of association between a risk factor and a
disease in 1:{it:M} matched case-control studies.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powermccQuickstart:Quick start}

        {mansection PSS-2 powermccRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powermccMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; 
see {manhelp power##mainopts PSS-2: power}.  The sample size in {cmd:n()} is the
number of matched case-control sets or, equivalently, the number of cases.
The {cmd:nfractional} option is allowed only for sample-size determination.

{phang}
{opth oratio(numlist)} specifies the odds ratio of exposure in cases relative
to controls.  This option is required for power or sample-size
determination and may not be specified for effect-size determination.

{phang}
{opth m(numlist)} specifies the number of matched controls per case.  Only
positive integers are allowed.  The default is {cmd:m(1)}, which implies a
paired design.

{phang}
{opt compare} specifies that the ratio, {it:FM}, of the required number of
cases for a 1:{it:M} design relative to a paired 1:1 design be computed.
{cmd:compare} can be specified only when computing sample size and when a
value of 2 or greater is specified in option {cmd:m()}.

{phang}
{opth corr(numlist)} specifies the correlation coefficient for exposure rho
between matched cases and controls. {cmd:corr()} must contain numbers between
-1 and 1. The default is {cmd:corr(0)}, meaning no correlation between
matched cases and controls.  This assumption may not be realistic in practice;
see {mansection PSS-2 powermccRemarksandexamplesex3:example 3} in
{bf:[PSS-2] power mcc} for discussion.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powermccSyntaxcolumn:column} table in
{bf:[PSS-2] power mcc} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the estimated sample size or
effect size when an iterative search is required.  When computing the sample
size for the two-sided test, the closed-form sample-size computation for the
one-sided test is used.  The initial estimate for computing the minimum
detectable odds ratio is obtained from a bisection search.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power mcc} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power mcc}

{pstd}
{cmd:power mcc} computes sample size, power, or effect size (the minimum
detectable odds ratio) for 1:{it:M} matched case-control studies, in
which one case is matched to {it:M} controls. All computations are performed for
a two-sided hypothesis test where, by default, the significance level is set
to 0.05. You may change the significance level by specifying the {cmd:alpha()}
option. You can specify the {cmd:onesided} option to request a one-sided test.

{pstd}
To compute sample size, you must specify the probability of exposure for the
control group {it:p0}; the odds ratio for exposure theta in option
{cmd:oratio()}; and, optionally, the power of the test in the {cmd:power()}
option.  The default power is set to 0.8. The sample-size estimate returned is
the number of matched pairs or, if option {cmd:m()} was specified, the number
of matched sets. This is equivalent to the number of cases.  Hereafter, we
simply refer to the number of cases.

{pstd}
To compute power, you must specify the sample size in option {cmd:n()}, the
probability of exposure for the control group {it:p0}, and the odds ratio in
option {cmd:oratio()}. 

{pstd}
To compute the minimum detectable odds ratios, you must specify the sample
size in option {cmd:n()}; the power in option {cmd:power()}; the probability
of exposure for the control group {it:p0}; and, optionally, the direction of
the effect. The direction is upper by default, {cmd:direction(upper)}, which
means that the probability of exposure among cases is assumed to be larger
than the specified control-group value. You can change the direction to be
lower, which means that the probability of exposure among cases is assumed to
be lower than the specified control-group value, by specifying the
{cmd:direction(lower)} option.  {cmd:power mcc} defines the effect size as the
target odds ratio. 

{pstd}
By default, all computations assume a 1:1 or paired design, in which
one case is matched to one control. You may specify the {cmd:m()} option to
accommodate multiple matches per case.

{pstd}
The correlation between the matched case-control subjects is set to 0
by default but may be changed by specifying option {cmd:corr()}.

{pstd}
For sample-size determination, you can specify the {cmd:compare} option to
compute the ratio of the required number of cases when using {it:M} matched
controls rather than one.

{pstd}
Sample-size determination for the two-sided test and effect-size determination
for {it:M} > 1 require iteration.  The default initial sample-size value is set
to the closed-form one-sided sample size.  The initial value for the effect
size is computed using a bisection algorithm.  You can use the {cmd:init()}
option to specify your own value. See {manhelp power PSS-2} for a description of
other options that control the iteration process.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
We plan a study in which lung cancer patients are matched with one control
of the same age, gender, and race.  The participants smoking history
is then recorded.  We use a previous study to determine the control
probability is 0.22.  We want to compute the minimum sample size
to detect an odds ratio of 1.7 at a power of 0.8 and a significance level
of 0.05.  First, we assume there is no correlation of exposure between the
matched case and the control.

{phang2}{cmd:. power mcc 0.22, oratio(1.7)}

{pstd}
Second, we investigate how an exposure correlation between each matched
case and control affects sample size.  We use a range of correlations
from 0 to 0.8 in steps of 0.1 and use 1 and 2 matches.  We graph the
results by the number of matches.

{phang2}{cmd:. power mcc 0.22, oratio(1.7) m(1 2) corr(0(0.1)0.8) table graph(by(M))}


    {title:Examples: Computing power}

{pstd}
Using the example above, we investigate what the test power would be if 
we have only 300 subjects for the 1:1 matched case-control scenario.  We
assume the exposure correlation between cases and controls to be 0.4.

{phang2}{cmd:. power mcc 0.22, oratio(1.7) corr(0.4) n(300)}

{pstd}
Now we want to find what the power would be if we matched two controls with 
each case.

{phang2}{cmd:. power mcc 0.22, oratio(1.7) corr(0.4) n(300) m(2)}


    {title:Examples: Minimum detectable odds ratio}

{pstd}
Continuing with our previous example, we have the 1:2 matching and a sample
size of 300.  We wish to determine the minimum detectable odds ratio at a
power of 0.8 and a significance level of 0.05.

{phang2}{cmd:. power mcc 0.22, corr(0.4) n(300) m(2) power(0.80)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power mcc} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(p0)}}probability of exposure among controls{p_end}
{synopt:{cmd: r(M)}}number of matched controls per case{p_end}
{synopt:{cmd: r(F_M)}}ratio of the number of cases relative to the 1:1 paired design{p_end}
{synopt:{cmd: r(oratio)}}odds ratio{p_end}
{synopt:{cmd: r(corr)}}correlation of exposure between matched cases and controls{p_end}
{synopt:{cmd: r(init)}}initial value for sample size or effect size{p_end}
INCLUDE help pss_rresiter_sc.ihlp
INCLUDE help pss_rrestab_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:mcc}{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{p2colreset}{...}
