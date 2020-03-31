{smcl}
{* *! version 1.0.17  21mar2019}{...}
{viewerdialog power "dialog power_cmh"}{...}
{vieweralsosee "[PSS-2] power cmh" "mansection PSS-2 powercmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab (cc)" "help cc"}{...}
{viewerjumpto "Syntax" "power_cmh##syntax"}{...}
{viewerjumpto "Menu" "power_cmh##menu"}{...}
{viewerjumpto "Description" "power_cmh##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_cmh##linkspdf"}{...}
{viewerjumpto "Options" "power_cmh##options"}{...}
{viewerjumpto "Remarks: Using power cmh" "power_cmh##remarks"}{...}
{viewerjumpto "Examples" "power_cmh##examples"}{...}
{viewerjumpto "Stored results""power_cmh##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[PSS-2] power cmh} {hline 2}}Power analysis for a 
Cochran-Mantel-Haenszel test{p_end}
{p2col:}({mansection PSS-2 powercmh:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 20 2}
{opt power} {opt cmh}
{help power cmh##probspec:{it:probspec}}{cmd:,}
{opth or:atio(numlist)}
[{opth p:ower(numlist)} 
{it:{help power_cmh##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt cmh}
{help power cmh##probspec:{it:probspec}}{cmd:,}  
{opth or:atio(numlist)}
{opth n(numlist)}
[{it:{help power_cmh##synoptions:options}}]


{phang}
Compute target odds ratio

{p 8 20 2}
{opt power} {opt cmh}
{help power cmh##probspec:{it:probspec}}{cmd:,}
{opth n(numlist)} {opth p:ower(numlist)}
[{it:{help power_cmh##synoptions:options}}]


{marker probspec}{...}
{phang}
where {it:probspec} is either a matrix {it:matname} containing the
probability of a success in a control group for each stratum or a list of
individual stratum probabilities:

            {it:p11}  {it:p12}  ...  {it:p1K}  

{pmore}
{it:p1k}, where {it:k} = 1, 2, ..., {it:K}, is the control-group probability
of a success in the kth stratum.  Each {it:p1k} may be specified either as one
number or as a list of values in parentheses (see {help numlist}).

{pmore}
{it:matname} is the name of a Stata matrix with {it:K} columns containing
control-group success probabilities.  Multiple rows are allowed, in which case
each row corresponds to a different set of {it:K} strata probabilities or,
equivalently, column {it:k} corresponds to a {it:{help numlist}} for the
control-group success probability in the kth stratum.


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
{p2coldent:* {opth n(numlist)}}total sample size; required to compute power or
effect size{p_end}
{synopt:{opt nfrac:tional}}allow fractional sample sizes{p_end}
{p2coldent:* {opth nperstr:atum(numlist)}}number of subjects per stratum;
   implies balanced design{p_end}
{p2coldent:* {cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)}}number of subjects in
stratum {it:#}{p_end}
{synopt:{cmdab:strw:eights(}{it:{help power_cmh##wgtspec:wgtspec}}{cmd:)}}stratum
   weights; default is one for each stratum, meaning equal stratum sizes{p_end}
{p2coldent:* {cmd:grratios(}{it:{help power_cmh##grspec:grspec}}{cmd:)}}stratum-specific group ratios of the experimental-group size to the stratum size, {it:n2k}/{it:nk}{p_end}
{p2coldent:* {opth or:atio(numlist)}}common odds ratio of the experimental
group to the control group; required to compute power or sample size{p_end}
{synopt:{opt contin:uity}}apply continuity correction; default is no
	continuity correction{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_cmh##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or effect size{p_end}
INCLUDE help pss_iteropts.ihlp

{syntab:Reporting}
{synopt: [{cmd:no}]{opt showgrstrsizes}}suppress or display group-per-stratum
sizes{p_end}
{synopt: {cmd:showasmatrix}}display all sample sizes in a matrix{p_end}

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}

{synoptset 17}{...}
{marker wgtspec}{...}
{synopthdr :wgtspec}
{synoptline}
{synopt:{it:#1} {it:#2} ... {it:#K}}{it:K} stratum weights.
	Weights must be positive and must be integers unless option
	{opt nfractional} is specified.  Multiple values for each stratum
	weight {it:#k} can be specified as a {it:{help numlist}} enclosed
	in parentheses.{p_end}
{synopt:{it:matname}}matrix with {it:K} columns containing {it:K} stratum
	weights.  Multiple rows are allowed, in which case each row
	corresponds to a different set of {it:K} weights or, equivalently,
	column {it:k} corresponds to a {it:numlist} for the {it:k}th weight.
	{p_end}
{synoptline}


{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_cmh##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt N_per_stratum}}number of subjects per stratum{p_end}
{synopt :{opt N_avg}}average number of subjects per stratum{p_end}
{synopt :{opt N}{it:#}}number of subjects in stratum {it:#}{p_end}
{synopt :{opt N_per_group}}number of subjects per group{p_end}
{synopt :{opt G1}}number of subjects in control group{p_end}
{synopt :{opt G2}}number of subjects in experimental group{p_end}
{synopt :{opt N_per_grstr}}number of subjects per group and stratum{p_end}
{synopt :{opt G1_}{it:#}}number of subjects in control group and stratum {it:#}{p_end}
{synopt :{opt G2_}{it:#}}number of subjects in experimental group and stratum {it:#}{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt N_s}}number of strata{p_end}
{synopt :{opt oratio}}odds ratio{p_end}
{synopt :{opt p1_}{it:#}}{it:#}th stratum control-group success probability{p_end}
{synopt :{opt strwgt}{it:#}}weight for stratum {it:#}{p_end}
{synopt :{opt grratio}{it:#}}ratio of experimental-group size to stratum size
for stratum {it:#}{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:oratio}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Column {cmd:beta} is shown in place of column {cmd:power} in the default table
if option {cmd:beta()} is specified.{p_end}
{p 4 6 2}
Column {cmd:N_per_stratum} is shown in the default table only for
equal-strata designs; otherwise, columns {cmd:N}{it:#} are displayed.{p_end}
{p 4 6 2}
Column {cmd:N_per_group} is shown in the default table only when group sizes
are the same; otherwise, columns {cmd:G1} and {cmd:G2} are displayed.{p_end}
{p 4 6 2}
Column {cmd:N_per_grstr} is shown in the default table only for balanced
designs.{p_end}
{p 4 6 2}
Columns {cmd:G1_}{it:#} and {cmd:G2_}{it:#} are shown in the table only if
requested or if option {cmd:showgrstrsizes} is specified.{p_end}
{p 4 6 2}
Columns {cmd:strwgt}{it:#} are shown in the default table only if option
{cmd:strweights()} is specified.{p_end}
{p 4 6 2}
Columns {cmd:grratio}{it:#} are shown in the default table only if option
{cmd:grratios()} is specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power cmh} computes sample size, power, or effect size (the minimum
detectable odds ratio) for a Cochran-Mantel-Haenszel (CMH) test of association
in stratified 2 x 2 tables.  The command accommodates unbalanced stratum sizes
and unbalanced group sizes within each stratum.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powercmhQuickstart:Quick start}

        {mansection PSS-2 powercmhRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powercmhMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; 
see {manhelp power##mainopts PSS-2: power}.

{phang}
{opth nperstratum(numlist)} specifies the stratum size.  Only positive
integers are allowed.  This option implies a balanced-strata design with equal
strata sizes.  {cmd:nperstratum()} cannot be specified with {cmd:n()},
{cmd:n}{it:#}{cmd:()}, or {cmd:strweights()}.

{phang}
{cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)} specifies the size of the
{it:#}th stratum.  Only positive integers are allowed.  All stratum sizes must
be specified.  For example, all three options {cmd:n1()}, {cmd:n2()}, and
{cmd:n3()} must be specified for a design with three strata.
{cmd:n}{it:#}{cmd:()} cannot be specified with {cmd:n()}, {cmd:nperstratum()},
or {cmd:strweights()}.

{phang}
{opt strweights(wgtspec)} specifies
{it:K} stratum weights for an unequal-strata design.  The weights may be
specified either as a list of values or as a matrix, and multiple sets of
weights are allowed; see {it:{help power_cmh##wgtspec:wgtspec}} for details.
The weights must be positive and must also be integers unless the
{cmd:nfractional} option is specified.  {cmd:strweights()} cannot be specified
with {cmd:nperstratum()} or {cmd:n}{it:#}{cmd:()}.

{phang}
{opt grratios(grspec)} specifies {it:K} ratios, one for each stratum, of the
number of subjects in the experimental group to the number of subjects in the
corresponding stratum, {it:n2k}/{it:nk}.  By default, a balanced group design
(or equal numbers of subjects in the control and experimental groups in each
stratum) is assumed, which corresponds to setting the {it:K} ratios to 0.5.

{marker grspec}{...}
{pmore}
{it:grspec} is similar to {help power cmh##wgtspec:{it:wgtspec}} but allows
noninteger numbers.

{phang}
{opth oratio(numlist)} specifies the alternative value of the common odds
ratio of the experimental group to the control group.  This option specifies
the magnitude of an effect size.  It is required to compute power or sample
size.

{phang}
{opt continuity} requests that the continuity correction be applied.  By
default, no continuity correction is applied.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powercmhSyntaxcolumn:{it:column}} table in
{bf:[PSS-2] power cmh} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the estimated sample size or 
effect size when an iterative search is required.  When computing the sample
size for the two-sided test, the sample-size estimate from the
one-sided test is used.  The initial estimate for computing the effect size
is obtained from a bisection search.

INCLUDE help pss_iteroptsdes.ihlp

{dlgtab:Reporting}

{phang}
{cmd:showgrstrsizes} and {cmd:noshowgrstrsizes} displays or suppresses the
display of sample sizes in each group and stratum.  The default for general
output is to display group-per-stratum sizes in a matrix.  The default for
table output is to suppress the display of group-per-stratum sizes.  If you
specify this option with table output, group-per-stratum sizes will be
displayed in a table as columns.  This option has no effect on graphical
output.

{phang}
{cmd:showasmatrix} requests that reported sample sizes be displayed as a matrix
containing group-per-stratum sizes as cells, and total strata sizes, total
group sizes, and a total sample size as marginal totals.  This option is not
allowed with table or graphical output.

{pstd}
The following option is available with {cmd:power cmh} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power cmh}

{pstd}
{cmd:power cmh} computes sample size, power, or effect size (the minimum
detectable odds ratio) for the CMH test of association in 2 x 2 x {it:K}
tables.  All computations are performed for a two-sided hypothesis test where,
by default, the significance level is set to 0.05.  You may change the
significance level by specifying option {cmd:alpha()}.  You can specify the
{cmd:onesided} option to request a one-sided test.

{pstd}
To compute the total sample size, you must specify the probabilities of
success {it:p1k} in the control group in each of the {it:K} strata following the
command name; the common odds ratio in the {cmd:oratio()} option; and,
optionally, the power of the test in option {cmd:power()}.  The default power
is set to 0.8.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option, the common odds ratio in the {cmd:oratio()} option, and the
control-group success probabilities {it:p1k} following the command name.

{pstd}
To compute effect size, the minimum detectable odds ratio, or the target odds
ratio, you must specify the total sample size in {cmd:n()}; the power in
{cmd:power()}; the control-group success probabilities following the command
name; and, optionally, the direction of the effect.  The direction is upper by
default, {cmd:direction(upper)}, which means that the common odds ratio is
assumed to be larger than one.  You can change the direction to be lower, which
means that the common odds ratio is assumed to be smaller than one, by
specifying the {cmd:direction(lower)} option.

{pstd}
There are multiple ways to specify the control-group success probabilities;
see {mansection PSS-2 powercmhRemarksandexamplessub1:{it:Alternative ways of specifying probabilities}}
in {bf:[PSS-2] power cmh}.

{pstd}
By default, all computations assume a design with equal numbers of subjects in
each group and each stratum.  To change group-specific proportions of subjects
in each stratum, use the
{cmd:grratios(}{help power cmh##grspec:{it:grspec}}{cmd:)} option.
A common proportion may be used for all strata or you may specify different
proportions for each stratum.  Regardless of whether you choose a common
proportion or choose to let the proportions vary across strata, you must
specify {it:K} ratios of cases to the stratum sample size within
{cmd:grratios()}.

{pstd}
To accommodate unequal stratum sizes for power and effect-size computations,
you can specify either individual stratum sizes in options {cmd:n1()},
{cmd:n2()}, ..., {cmd:n}{it:K}{cmd:()} or a combination of the total sample
size in {cmd:n()} and integer stratum weights in
{opth strweights:(power_cmh##wgtspec:wgtpec)}.  For equal stratum
sizes, you can also specify the {cmd:nperstratum()} option to specify a common
stratum size instead of a total sample size in {cmd:n()}.

{pstd}
By default, all computations assume no continuity correction.  Use the
{cmd:continuity} option to change that.

{pstd}
{cmd:power cmd} reports group-per-stratum sizes as a matrix in the output.  To
suppress this matrix, use the {cmd:noshowgrstrsizes} option.  Alternatively,
for the table output, you can use the {cmd:showgrstrsizes} option to include
columns containing group-per-stratum sizes in the default table.

{pstd}
To make the output of {cmd:power cmd} more compact, you may consider using the
{cmd:showasmatrix} option to display all sample sizes in a matrix.

{pstd}
Sample-size determination for the two-sided test and effect-size determination
require iteration.  The default initial value for the sample size uses the
estimate for the one-sided test.  The initial estimate for the effect size is
obtained using a bisection search.  To specify a different starting value, you
may use option {cmd:init()}.  For more options used to control the iteration
process, see {manhelp power PSS-2}.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
We investigate whether a particular drug exposure is linked to infant birth
defects.  Using pilot data to obtain probability of defect for the control
group and stratifying on 4 age groups we wish to calculate
the sample size to detect an odds ratio of at least 1.8.  We use the default
power of 0.8 with a significance of 0.05.

{phang2}{cmd:. power cmh 0.25 0.3 0.3 0.35, or(1.8)}

{pstd}
We vary the odds ratio from 1.2 to 2.0 in steps of 0.1 to generate a
table of required sample sizes.

{phang2}{cmd:. power cmh 0.25 0.3 0.3 0.35, or(1.2(.1)2.0)}

{pstd}
We investigate what is the required sample size if we allocate 15% of
the sample to the first age group, 40% of the sample to the second age group,
35% of the sample to the third age group, and 10% of the sample to the fourth
age group.

{phang2}{cmd:. power cmh 0.25 0.3 0.3 0.35, or(1.8) strweights(15 40 35 10)}

{pstd}
We anticipate it will be more difficult to recruit cases than controls.  We
plan for 40% of the sample to be cases and 60% to be controls.

{phang2}{cmd:. power cmh 0.25 0.3 0.3 0.35, or(1.8) strweights(15 40 35 10) grratios(0.4 0.4 0.4 0.4)}


    {title:Examples: Computing power}

{pstd}
Continuing the above example, we wish to explore the power of detecting an
odds ratio of 1.8 if our total sample size ranges from 100 to 400 in steps
of 50 and is evenly allocated among the age groups.  We use a one-sided test
and graph the results.

{phang2}{cmd:. power cmh 0.25 0.3 0.3 0.35, or(1.8) n(100(50)400) onesided table graph}


    {title:Examples: Computing the minimum detectable odds ratio}

{pstd}
Continuing with the above example, we determine that we can recruit only 400
subjects and wish to determine the minimum detectable odds ratio.

{phang2}{cmd:. power cmh 0.25 0.3 0.3 0.35, n(400) power(0.8)}

{pstd}
Finally, we believe a one-sided test would be more appropriate.

{phang2}{cmd:. power cmh 0.25 0.3 0.3 0.35, n(400) power(0.8) onesided}



{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power cmh} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}total sample size{p_end}
{synopt:{cmd: r(N_a)}}actual sample size{p_end}
{synopt:{cmd: r(N_avg)}}average sample size{p_end}
{synopt:{cmd: r(N}{it:#}{cmd:)}}number of subjects in stratum {it:#}{p_end}
{synopt:{cmd: r(N_per_stratum)}}number of subjects per stratum{p_end}
{synopt:{cmd: r(N_s)}}number of strata{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(balanced)}}{cmd:1} for a balanced design, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(strwgt}{it:#}{cmd:)}}stratum weight {it:#}{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test; {cmd:0}
	otherwise{p_end}
{synopt:{cmd: r(N_per_group)}}number of subjects per group{p_end}
{synopt:{cmd: r(G1)}}number of subjects in the control group{p_end}
{synopt:{cmd: r(G2)}}number of subjects in the experimental group{p_end}
{synopt:{cmd: r(N_per_grstr)}}number of subjects per group and stratum{p_end}
{synopt:{cmd: r(G1_}{it:#}{cmd:)}}number of subjects in the control group in stratum {it:#}{p_end}
{synopt:{cmd: r(G2_}{it:#}{cmd:)}}number of subjects in the experimental group in stratum {it:#}{p_end}
{synopt:{cmd: r(grratio}{it:#}{cmd:)}}ratio of the experimental-group size to
stratum size for stratum {it:#}{p_end}
{synopt:{cmd: r(p1_}{it:#}{cmd:)}}control-group probability of success in stratum {it:#}{p_end}
{synopt:{cmd: r(oratio)}}odds ratio of the experimental group to control group{p_end}
{synopt:{cmd: r(continuity)}}{cmd:1} if continuity correction is used, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(c)}}continuity-correction value{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or effect size{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:cmh}{p_end}
{synopt:{cmd:r(direction)}}{cmd:upper} or {cmd:lower}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{p2colreset}{...}
