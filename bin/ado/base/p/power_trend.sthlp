{smcl}
{* *! version 1.0.13  21mar2019}{...}
{viewerdialog power "dialog power_trend"}{...}
{vieweralsosee "[PSS-2] power trend" "mansection PSS-2 powertrend"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{viewerjumpto "Syntax" "power_trend##syntax"}{...}
{viewerjumpto "Menu" "power_trend##menu"}{...}
{viewerjumpto "Description" "power_trend##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_trend##linkspdf"}{...}
{viewerjumpto "Options" "power_trend##options"}{...}
{viewerjumpto "Remarks: Using power trend" "power_trend##remarks"}{...}
{viewerjumpto "Examples" "power_trend##examples"}{...}
{viewerjumpto "Stored results""power_trend##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[PSS-2] power trend} {hline 2}}Power analysis for the 
Cochran-Armitage trend test{p_end}
{p2col:}({mansection PSS-2 powertrend:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 20 2}
{opt power} {opt trend}
{help power trend##probspec:{it:probspec}}
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_trend##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt trend}
{help power trend##probspec:{it:probspec}}{cmd:,}  
{opth n(numlist)}
[{it:{help power_trend##synoptions:options}}]


{marker probspec}{...}
{phang}
where {it:probspec} is either a matrix {it:matname} containing group
probabilities or a list of individual group probabilities:

            {it:p1}  {it:p2}  [ {it:p3}  ...  {it:pJ} ]

{pmore}
{it:pj}, where {it:j} = 1, 2, ..., {it:J}, is the alternative group
probability of observing a success for subjects with the {it:j}th level of
exposure. Each {it:pj} may be specified either as one number or as a list of
values in parentheses (see {help numlist}).

{pmore}
{it:matname} is the name of a Stata matrix with {it:J} columns containing
values of alternative group probabilities.  Multiple rows are allowed, in
which case each row corresponds to a different set of {it:J} group
probabilities or, equivalently, column {it:j} corresponds to a
{it:{help numlist}} for the {it:j}th group probabilities.

{pmore}
Alternative probabilities should be strictly monotonic: all increasing
or all decreasing.


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
{p2coldent:* {opth n(numlist)}}total sample size; required to compute power{p_end}
{synopt:{opt nfrac:tional}}allow fractional sample sizes{p_end}
{p2coldent:* {opth nperg:roup(numlist)}}number of subjects per group; implies
   balanced design{p_end}
{p2coldent:* {cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)}}number of subjects
   in group {it:#}{p_end}
{synopt:{cmdab:grw:eights(}{it:{help power_trend##wgtspec:wgtspec}}{cmd:)}}group
   weights; default is one for each group, meaning equal group sizes{p_end}
{synopt:{cmdab:expos:ure(}{it:{help power_trend##exposspec:exposspec}}{cmd:)}}strictly
increasing exposure levels; default is equally spaced ordinal values{p_end}
{synopt:{opt contin:uity}}apply the continuity correction; default is no
	continuity correction{p_end}
{synopt:{opt onesid:ed}}one-sided test; default is two sided{p_end}
{synopt: {opt par:allel}}treat number lists in starred options or in command
arguments as parallel when multiple values per option or argument are
specified (do not enumerate all possible combinations of values)

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_trend##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size for a two-sided test;
   default is to use a sample-size estimate for a one-sided test{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


{synoptset 17}{...}
{marker wgtspec}{...}
{synopthdr :wgtspec}
{synoptline}
{synopt:{it:#1} {it:#2} ... {it:#J}}{it:J} group weights. 
	Weights must be positive and must be integers unless option
	{opt nfractional} is specified.  Multiple values for each group weight
	{it:#j} can be specified as a {it:{help numlist}} enclosed in
	parentheses.{p_end}
{synopt:{it:matname}}matrix with {it:J} columns containing {it:J} group
	weights.  Multiple rows are allowed, in which case each row
	corresponds to a different set of {it:J} weights or, equivalently,
	column {it:j} corresponds to a {it:{help numlist}} for the {it:j}th
	weight.{p_end}
{synoptline}


{marker exposspec}{...}
{synopthdr :exposspec}
{synoptline}
{synopt:{it:#1} {it:#2} ... {it:#J}}{it:J} exposure levels.  By default,
	equally spaced exposure levels of 1, 2, ..., {it:J} are used.
	Multiple values for each exposure level {it:#j} can be specified as a
	{it:{help numlist}} enclosed in parentheses.{p_end}
{synopt:{it:matname}}matrix with {it:J} columns containing {it:J} exposure
        levels.  Multiple rows are allowed, in which case each row corresponds
	to a different set of {it:J} exposure levels or, equivalently, column
	{it:j} corresponds to a {it:{help numlist}} for the {it:j}th exposure
	level.{p_end}
{synoptline}


{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_trend##column:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]

{pstd}
{it:column} is one of the columns defined below,
and {it:label} is a column label (may contain quotes and compound quotes).


{synoptset 28}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt power}}power{p_end}
{synopt :{opt beta}}type II error probability{p_end}
{synopt :{opt N}}total number of subjects{p_end}
{synopt :{opt N_per_group}}number of subjects per group{p_end}
{synopt :{opt N_avg}}average number of subjects per group{p_end}
{synopt :{opt N}{it:#}}number of subjects in group {it:#}{p_end}
{synopt :{opt N_g}}number of groups{p_end}
{synopt :{opt p}{it:#}}probability of outcome for group {it:#}{p_end}
{synopt :{opt x}{it:#}}exposure level {it:#}{p_end}
{synopt :{opt grwgt}{it:#}}group weight {it:#}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if option {cmd:beta()} is specified.{p_end}
{p 4 6 2}Column {cmd:N_per_group} is shown in the default table only for
balanced designs.{p_end}
{p 4 6 2}Columns {cmd:N_avg} and {cmd:N}{it:#} are shown in the default table
only for unbalanced designs.{p_end}
{p 4 6 2}Columns {cmd:x}{it:#} are shown only when exposure levels are
specified using the {cmd:exposure()} option.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power trend} computes sample size or power for the Cochran-Armitage trend
test, a test for a linear trend in a probability of response in {it:J} x 2
tables.  It can accommodate unbalanced designs and unequally spaced exposure
levels (doses).  With equally spaced exposure levels, a continuity correction
is available.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powertrendQuickstart:Quick start}

        {mansection PSS-2 powertrendRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powertrendMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; 
see {manhelp power##mainopts PSS-2: power}.

{phang}
{opth npergroup(numlist)} specifies the group size.  Only positive integers are
allowed.  This option implies a balanced design.  {cmd:npergroup()} cannot be
specified with {cmd:n()}, {cmd:n}{it:#}{cmd:()}, or {cmd:grweights()}.

{phang}
{cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)} specifies the number of
subjects in the {it:#}th group to be used for power determination.  Only
positive integers are allowed.  All group sizes must be specified.
{cmd:n}{it:#}{cmd:()} cannot be specified with {cmd:n()}, {cmd:npergroup()},
or {cmd:grweights()}.

{phang}
{opt grweights(wgtspec)} specifies {it:J} group weights for an unbalanced
design.  The weights may be specified either as a list of values or as a
matrix, and multiple sets of weights are allowed; see
{it:{help power_trend##wgtspec:wgtspec}} for details.  The weights must be
positive and must also be integers unless the {cmd:nfractional} option is
specified.  {cmd:grweights()} cannot be specified with {cmd:npergroup()} or
{cmd:n}{it:#}{cmd:()}.

{phang}
{cmd:exposure(}{it:{help power_trend##exposspec:exposspec}}{cmd:)} specifies
the {it:J} strictly increasing exposure levels.  The default is equally spaced
values of 1, 2, ..., {it:J}.{p_end}

{phang}
{opt continuity} requests that the continuity correction be applied.  This
option can be specified only for equally spaced exposure levels.  
By default, no continuity correction is applied.

{phang}
{cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powertrendSyntaxcolumn:column} table in
{bf:[PSS-2] power trend} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size computation for a two-sided test.  The default initial value is
the sample size for the corresponding one-sided test.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power trend} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power trend}

{pstd}
{cmd:power trend} computes sample size or power for a Cochran-Armitage
trend test in {it:J} x 2 tables. All computations are performed for a
two-sided hypothesis test where, by default, the significance level is set to
0.05. You may change the significance level by specifying the {cmd:alpha()}
option.  You can specify the {cmd:onesided} option to request a one-sided test.

{pstd}
To compute the total and individual group sample sizes, you must specify the
alternative probabilities of a success for {it:J} levels of exposure and,
optionally, the power of the test in the {cmd:power()} option.  The default
power is set to 0.8.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option and the alternative probabilities. 

{pstd}
There are multiple ways to specify the alternative probabilities; see
{mansection PSS-2 powertrendRemarksandexamplessub1:{it:Alternative ways of specifying probabilities}}
in {bf:[PSS-2] power trend}. 

{pstd}
By default, all computations assume a balanced- or equal-allocation design.
You can use the {cmd:grweights()} option to specify an unbalanced design for
power or sample-size computations.  For power computations, you can specify
individual group sizes in options {cmd:n1()}, {cmd:n2()}, ...,
{cmd:n}{it:J}{cmd:()} instead of a combination of {cmd:n()} and
{cmd:grweights()} to accommodate an unbalanced design.  For a balanced design,
you can also specify the {cmd:npergroup()} option to specify a group size
instead of a total sample size in {cmd:n()}.

{pstd}
Computations also assume that exposure levels are equally spaced and no
continuity correction is applied. When the exposure levels are equally spaced,
you can use option {cmd:continuity} to request that the continuity correction
be applied. You may specify specific exposure levels in the {cmd:exposure()}
option.  There are multiple ways of specifying the levels; any method
described in {mansection PSS-2 powertrendRemarksandexamplessub1:{it:Alternative ways of specifying probabilities}}
in {bf:[PSS-2] power trend} can also be applied to the specification of exposure
levels.

{pstd}
Sample-size determination for a two-sided test requires iteration.  The
default initial values are sample-size estimates for the corresponding
one-sided test. You can use the {cmd:init()} option to specify your own value.
See {manhelp power PSS-2} for a description of other options that control the
iteration process.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
We investigate whether the number of doses per day (1, 2, 3, or 4) is
associated with an increase in successfully treating a skin infection within
10 days.  We use a two-sided test with a significance level of 0.05 and
power of 0.8.

{phang2}{cmd:. power trend 0.80 0.85 0.90 0.95}

{pstd}
We next vary the number of subjects exposed at each level.

{phang2}{cmd:. power trend 0.80 0.85 0.90 0.95, grweights(2 2 3 3)}

{pstd}
We next vary the dosages per day.

{phang2}{cmd:. power trend 0.80 0.85 0.90 0.95, exposure(1 3 6 7)}


    {title:Examples: Computing power}

{pstd}
Continuing with the same example, we believe we can recruit only 200 subjects.
We investigate what power the test will have in this case.

{phang2}{cmd:. power trend 0.80 0.85 0.90 0.95, n(200)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power trend} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(alpha)}}significance level{p_end}
{synopt:{cmd:r(power)}}power{p_end}
{synopt:{cmd:r(beta)}}probability of a type II error{p_end}
{synopt:{cmd:r(delta)}}effect size{p_end}
{synopt:{cmd:r(N)}}total sample size{p_end}
{synopt:{cmd:r(N_a)}}actual sample size{p_end}
{synopt:{cmd:r(N_avg)}}average sample size{p_end}
{synopt:{cmd:r(N}{it:#}{cmd:)}}number of subjects in group {it:#}{p_end}
{synopt:{cmd:r(N_per_group)}}number of subject per group{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}
{synopt:{cmd:r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(balanced)}}{cmd:1} for a balanced design,
	{cmd:0} otherwise{p_end}
{synopt:{cmd:r(grwgt}{it:#}{cmd:)}}group weight {it:#}{p_end}
{synopt:{cmd:r(onesided)}}{cmd:1} for a one-sided test; {cmd:0}
	otherwise{p_end}
{synopt:{cmd:r(p}{it:#}{cmd:)}}probability of a success in group {it:#}{p_end}
{synopt:{cmd:r(x}{it:#}{cmd:)}}exposure level for group {it:#}{p_end}
{synopt:{cmd:r(continuity)}}{cmd:1} if continuity correction is used; {cmd:0}
otherwise{p_end}
{synopt:{cmd:r(c)}}continuity-correction value{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd:r(init)}}initial value for sample size for a two-sided test{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:trend}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{p2colreset}{...}
