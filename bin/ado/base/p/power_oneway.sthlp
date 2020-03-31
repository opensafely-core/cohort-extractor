{smcl}
{* *! version 1.0.17  27feb2019}{...}
{viewerdialog power "dialog power_oneway"}{...}
{vieweralsosee "[PSS-2] power oneway" "mansection PSS-2 poweroneway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power repeated" "help power repeated"}{...}
{vieweralsosee "[PSS-2] power twomeans" "help power twomeans"}{...}
{vieweralsosee "[PSS-2] power twoway" "help power twoway"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] oneway" "help oneway"}{...}
{viewerjumpto "Syntax" "power_oneway##syntax"}{...}
{viewerjumpto "Menu" "power_oneway##menu"}{...}
{viewerjumpto "Description" "power_oneway##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_oneway##linkspdf"}{...}
{viewerjumpto "Options" "power_oneway##options"}{...}
{viewerjumpto "Remarks: Using power oneway" "power_oneway##remarks"}{...}
{viewerjumpto "Examples" "power_oneway##examples"}{...}
{viewerjumpto "Video examples" "power_oneway##video"}{...}
{viewerjumpto "Stored results""power_oneway##stored_results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[PSS-2] power oneway} {hline 2}}Power analysis for one-way
analysis of variance{p_end}
{p2col:}({mansection PSS-2 poweroneway:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 20 2}
{opt power} {opt oneway}
{it:{help power_oneway##meanspec:meanspec}} 
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_oneway##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt oneway}  
{it:{help power_oneway##meanspec:meanspec}}, 
{opth n(numlist)}
[{it:{help power_oneway##synoptions:options}}]


{phang}
Compute effect size and target between-group variance 

{p 8 20 2}
{opt power} {opt oneway}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} {opt ng:roups(#)} 
[{opth varerr:or(numlist)} {it:{help power_oneway##synoptions:options}}]

{marker meanspec}{...}
{phang}
where {it:meanspec} is either a matrix {it:matname} containing group means or
individual group means specified in a matrix form:

{phang3}
{it:m1} {it:m2} [{it:m3} ... {it:mJ}]

{pmore}
{it:mj}, where {it:j} = 1, 2, ..., {it:J}, is the alternative group mean or
the group mean under the alternative hypothesis for the {it:j}th group.  Each
{it:mj} may be specified either as one number or as a list of values in
parentheses; see {help numlist}.

{pmore}
{it:matname} is the name of a Stata matrix with {it:J} columns containing
values of alternative group means.  Multiple rows are allowed, in which case
each row corresponds to a different set of {it:J} group means or,
equivalently, column {it:j} corresponds to a {it:numlist} for the {it:j}th
group mean.


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
{p2coldent:* {opth nperg:roup(numlist)}}number of subjects per group; implies
balanced design{p_end}
{p2coldent:* {cmd:n}{it:#}{cmd:(}{help numlist}{cmd:)}}number of subjects in
group {it:#}{p_end}
{synopt:{cmdab:grw:eights(}{help power_oneway##wgtspec:wgtspec}{cmd:)}}group weights; default is one for each group, meaning equal group
sizes{p_end}
{synopt:{opt ng:roups(#)}}number of groups{p_end}
{p2coldent:* {opth varm:eans(numlist)}}variance of the group means or
between-group variance{p_end}
{p2coldent:* {opth varerr:or(numlist)}}error (within-group) variance; default
is {cmd:varerror(1)}{p_end}
{synopt:{cmd:contrast(}{it:{help power_oneway##contrastspec:contrastspec}}{cmd:)}}contrast specification for group means{p_end}
{synopt: {opt par:allel}}treat number lists in starred options or in command
arguments as parallel when multiple values per option or arguments are
specified (do not enumerate all possible combinations of values)

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_oneway##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or the effect size;
   default is to use a bisection algorithm to bound the solution{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


{marker wgtspec}{...}
{synoptset 15 tabbed}{...}
{synopthdr:wgtspec}
{synoptline}
{synopt: {it:#1} {it:#2} ... {it:#J}}{it:J} group weights.  Weights must be
positive and must be integers unless option {cmd:nfractional} is specified.
Multiple values for each group weight {it:#j} can be specified as a 
{help numlist} enclosed in parentheses.{p_end}
{synopt: {it:matname}}matrix with {it:J} columns containing {it:J} group
weights.  Multiple rows are allowed, in which case each row corresponds to a
different set of {it:J} weights or, equivalently, column {it:j} corresponds
to a {it:numlist} for the {it:j}th weight.{p_end}
{synoptline}
{p2colreset}{...}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_oneway##column:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]

{pstd}
{it:column} is one of the columns defined below,
and {it:label} is a column label (may contain quotes and compound quotes).

{synoptset 20}{...}
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
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt N_g}}number of groups{p_end}
{synopt :{opt m}{it:#}}group mean {it:#}{p_end}
{synopt :{opt Cm}}mean contrast{p_end}
{synopt :{opt c0}}null mean contrast{p_end}
{synopt :{opt Var_m}}group means (between-group) variance{p_end}
{synopt :{opt Var_Cm}}contrast variance{p_end}
{synopt :{opt Var_e}}error (within-group) variance{p_end}
{synopt :{opt grwgt}{it:#}}group weight {it:#}{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:Var_m} or {cmd:Var_Cm}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}

{p 4 6 2}
Column {cmd:N_per_group} is available and is shown in the default table only for
balanced designs.{p_end}

{p 4 6 2}
Columns {cmd:N_avg} and {cmd:N}{it:#} are shown in the default table only for
unbalanced designs.{p_end}

{p 4 6 2}
Columns {cmd:m}{it:#} are shown in the default table only if group means are
specified.{p_end}

{p 4 6 2}
Column {cmd:Var_m} is not shown in the default table if the {cmd:contrast()}
option is specified.{p_end}

{p 4 6 2}
Columns {cmd:Cm}, {cmd:c0}, and {cmd:Var_Cm} are shown in the default table
only if the {cmd:contrast()} option is specified.{p_end}

{p 4 6 2}
Columns {cmd:grwgt}{it:#} are not shown in the default table.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power oneway} computes sample size, power, or effect size for one-way
analysis of variance (ANOVA).  By default, it computes sample size for given
power and effect size.  Alternatively, it can compute power for given sample
size and effect size or compute effect size for given sample size, power, and
number of groups.  Also see {manhelp power PSS-2} for a general introduction to
the {cmd:power} command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 poweronewayQuickstart:Quick start}

        {mansection PSS-2 poweronewayRemarksandexamples:Remarks and examples}

        {mansection PSS-2 poweronewayMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; 
see {manhelp power##mainopts PSS-2: power}.

{phang}
{opth npergroup(numlist)} specifies the group size.  Only positive integers
are allowed.  This option implies a balanced design.  {cmd:npergroup()}
cannot be specified with {opt n()}, {cmd:n}{it:#}{cmd:()}, or
{cmd:grweights()}.

{phang}
{cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)} specifies the size of the
{it:#}th group.  Only positive integers are allowed.  All group sizes must
be specified.  For example, all three options {cmd:n1()}, {cmd:n2()}, and
{cmd:n3()} must be specified for a design with three groups.
{cmd:n}{it:#}{cmd:()} cannot be specified with {cmd:n()}, {cmd:npergroup()},
or {cmd:grweights()}.

{phang}
{cmd:grweights(}{it:{help power_oneway##wgtspec:wgtspec}}{cmd:)} specifies
{it:J} group weights for an unbalanced design.  The weights may be specified
either as a list of values or as a matrix, and multiple sets of weights are
allowed; see {it:{help power_oneway##wgtspec:wgtspec}} for details.  The
weights must be positive and must also be integers unless the
{cmd:nfractional} option is specified.  {cmd:grweights()} cannot be specified
with {cmd:npergroup()} or {cmd:n}{it:#}{cmd:()}.

{phang}
{opt ngroups(#)} specifies the number of groups.  At least two groups must be
specified.  This option is required
if {it:{help power_oneway##meanspec:meanspec}} is not specified.  This option
is also required for effect-size determination unless {cmd:grweights()} is
specified.

{phang}
{opth varmeans(numlist)} specifies the variance of the group means or the
between-group variance.  {cmd:varmeans()} cannot be specified with
{it:{help power_oneway##meanspec:meanspec}} or {opt contrast()}, nor is it
allowed with effect-size determination.

{phang}
{opth varerror(numlist)} specifies the error (within-group) variance.  The
default is {cmd:varerror(1)}.

{marker contrastspec}{...}
{phang}
{opt contrast(contrastspec)} specifies a contrast for group means containing
{it:J} contrast coefficients that must sum to zero.  {it:contrastspec} is

{phang2}
{it:#1} {it:#2} [{it:#3} ... {it:#J}] [{cmd:,} {opth null(numlist)} {cmdab:onesid:ed}]

{phang2}
{opth null(numlist)} specifies the null or hypothesized value of the mean
contrast.  The default is {cmd:null(0)}.  

{phang2}
{cmd:onesided} requests a one-sided t test. The default is F test.

{phang}
{cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 poweronewaySyntaxcolumn:column} table in
{bf:[PSS-2] power oneway} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the effect size {it:delta}
for the effect-size determination.  The default uses a bisection algorithm to
bracket the solution.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power oneway} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power oneway}

{pstd}
{cmd:power oneway} computes sample size, power, or effect size and target
variance of the effect for a one-way fixed-effects analysis of variance.  All
computations are performed assuming a significance level of 0.05.  You may
change the significance level by specifying the {cmd:alpha()} option.

{pstd}
By default, the computations are performed for an overall F test, which tests
the equality of all group means.  The within-group or error variance for this
test is assumed to be 1 but may be changed by specifying the {cmd:varerror()}
option.

{pstd}
To compute the total sample size, you must specify the alternative 
{it:{help power_oneway##meanspec:meanspec}} and, optionally, the power of the
test in the {cmd:power()} option.  The default power is set to 0.8.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option and the alternative {it:{help power_oneway##meanspec:meanspec}}.

{pstd}
Instead of the alternative group means, you can specify the number of groups
in the {cmd:ngroups()} option and the variance of the group means (or the
between-group variance) in the {cmd:varmeans()} option when computing sample
size or power.

{pstd}
To compute effect size, the square root of the ratio of the between-group
variance to the error variance, and the target between-group variance, you
must specify the total sample size in the {cmd:n()} option, the power in the
{cmd:power()} option, and the number of groups in the {cmd:ngroups()} option.

{pstd}
To compute sample size or power for a test of a mean contrast, in addition to
the respective options {cmd:power()} or {cmd:n()} as described above, you must
specify alternative {it:{help power_oneway##meanspec:meanspec}}
and the corresponding contrast coefficients in the {cmd:contrast()} option.  A
contrast coefficient must be specified for each of the group means, and the
specified coefficients must sum to zero.  The null value for the specified
contrast is assumed to be zero but may be changed by specifying the
{cmd:null()} suboption within {cmd:contrast()}.  The default test is an F test.
You can instead request a one-sided t test by specifying the {cmd:onesided}
suboption within {cmd:contrast()}.  Effect-size determination is not available
when testing a mean contrast.

{pstd}
For all the above computations, the error or within-group variance is
assumed to be 1.  You can change this value by specifying the
{cmd:varerror()} option.

{pstd}
By default, all computations assume a balanced- or equal-allocation design.  You
can use the {cmd:grweights()} option to specify an unbalanced design for
power, sample-size, or effect-size computations.

{pstd}
For power and effect-size computations, you can specify individual group sizes
in options {cmd:n1()}, {cmd:n2()}, and so on instead of a combination of
{cmd:n()} and {cmd:grweights()} to accommodate an unbalanced design.  For a
balanced design, you can also specify the {cmd:npergroup()} option to specify
a group size instead of a total sample size in {cmd:n()}.

{pstd}
In a one-way ANOVA, sample size and effect size depend on the
noncentrality parameter of the F distribution, and their estimation requires
iteration.  The default initial values are obtained from a bisection search
that brackets the solution.  If you desire, you may change this by specifying
your own value in the {cmd:init()} option.  See {manhelp power PSS-2} for the
descriptions of other options that control the iteration procedure.


{marker examples}{...}
{title:Examples}

{pstd}
In the examples below, we consider a three-group fixed-effects ANOVA model
with postulated groups means of 260, 289, and 295, and the error variance of
4900.

    {title:Examples: Computing sample size}

{pstd}
Compute the total sample size for an overall F test of the equality of
means assuming equal group sizes, 5% significance level, and 80% power{p_end}
{phang2}{cmd:. power oneway 260 289 295, varerror(4900)}

{pstd}
Specify the variance of the means instead of individual group means{p_end}
{phang2}{cmd:. power oneway, varmeans(233.5556) ngroups(3) varerror(4900)}

{pstd}
Specify an unbalanced design{p_end}
{phang2}{cmd:. power oneway 260 289 295, varerror(4900) grweights(1 2 2)}

{pstd}
Compute sample size for a mean contrast comparing means of the first two
groups{p_end}
{phang2}{cmd:. power oneway 260 289 295, varerror(4900) contrast(1 -1 0)}


    {title:Examples: Computing power}

{pstd}
Compute the power for a total sample size of 300{p_end}
{phang2}{cmd:. power oneway 260 289 295, n(300) varerror(4900)}

{pstd}
Compute the power assuming unequal allocation among the three groups{p_end}
{phang2}{cmd:. power oneway 260 289 295, n(300) varerror(4900) grweights(1 2 2)}
 

    {title:Examples: Computing effect size}

{pstd}
Compute the minimum effect size detectable with a power 80% for a sample size of
300 equally allocated among 3 groups{p_end}
{phang2}{cmd:. power oneway, n(300) power(.80) ngroups(3)}

{pstd}
Specify error variance to compute the corresponding between-group
variance{p_end}
{phang2}{cmd:. power oneway, n(300) power(.80) ngroups(3) varerror(4900)}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=3trds1UO5C8":Sample-size calculation for one-way analysis of variance}

{phang}
{browse "https://www.youtube.com/watch?v=uo9q0elpvMI":Power calculation for one-way analysis of variance}

{phang}
{browse "https://www.youtube.com/watch?v=rh8XFbFEn2k":Minimum detectable effect size for one-way analysis of variance}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power oneway} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}total sample size{p_end}
{synopt:{cmd: r(N_a)}}actual sample size{p_end}
{synopt:{cmd: r(N_avg)}}average sample size{p_end}
{synopt:{cmd: r(N}{it:#}{cmd:)}}number of subjects in group {it:#}{p_end}
{synopt:{cmd: r(N_per_group)}}number of subjects per group{p_end}
{synopt:{cmd: r(N_g)}}number of groups{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified,
{cmd:0} otherwise{p_end}
{synopt:{cmd: r(balanced)}}{cmd:1} for a balanced design, {cmd:0} otherwise
{p_end}
{synopt:{cmd: r(grwgt}{it:#}{cmd:)}}group weight {it:#}{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test of a mean contrast, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(m}{it:#}{cmd:)}}group mean {it:#}{p_end}
{synopt:{cmd: r(Cm)}}mean contrast{p_end}
{synopt:{cmd: r(c0)}}null mean contrast{p_end}
{synopt:{cmd: r(Var_m)}}group-means (between-group) variance{p_end}
{synopt:{cmd: r(Var_Cm)}}contrast variance{p_end}
{synopt:{cmd: r(Var_e)}}error (within-group) variance{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for the sample size or effect size{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:oneway}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
