{smcl}
{* *! version 1.1.13  27feb2019}{...}
{viewerdialog power "dialog power_repeated"}{...}
{vieweralsosee "[PSS-2] power repeated" "mansection PSS-2 powerrepeated"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power oneway" "help power oneway"}{...}
{vieweralsosee "[PSS-2] power pairedmeans" "help power pairedmeans"}{...}
{vieweralsosee "[PSS-2] power twoway" "help power twoway"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{viewerjumpto "Syntax" "power_repeated##syntax"}{...}
{viewerjumpto "Menu" "power_repeated##menu"}{...}
{viewerjumpto "Description" "power_repeated##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_repeated##linkspdf"}{...}
{viewerjumpto "Options" "power_repeated##options"}{...}
{viewerjumpto "Remarks: Using power repeated" "power_repeated##remarks"}{...}
{viewerjumpto "Examples" "power_repeated##examples"}{...}
{viewerjumpto "Stored results""power_repeated##stored_results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[PSS-2] power repeated} {hline 2}}Power analysis for 
repeated-measures analysis of variance{p_end}
{p2col:}({mansection PSS-2 powerrepeated:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 20 2}
{opt power} {opt repeated}
{it:{help power_repeated##meanspec:meanspec}}{cmd:,}
{it:{help power_repeated##corrspec:corrspec}}
[{opth p:ower(numlist)} 
{it:{help power_repeated##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt repeated}
{it:{help power_repeated##meanspec:meanspec}}{cmd:,}
{opth n(numlist)} 
{it:{help power_repeated##corrspec:corrspec}}
[{it:{help power_repeated##synoptions:options}}]


{phang}
Compute effect size 

{p 8 20 2}
{opt power} {opt repeated}{cmd:,}
{opth n(numlist)} 
{opth p:ower(numlist)} {opt ng:roups(#)}
{it:{help power_repeated##corrspec:corrspec}}
[{it:{help power_repeated##synoptions:options}}]

{marker meanspec}{...}
{phang}
where {it:meanspec} is either a matrix {it:matname} containing cell means or
individual cell means in a matrix form:

{phang3}
{it:m1_1} {it:m1_2} [... {it:m1_K}] [{cmd:\} ... [{it:mJ_1} {it:mJ_2} [...  {it:mJ_K}]]]

{pmore}
{it:mj_k}, where j = 1, 2, ..., J and k = 1, 2, ..., K, is the alternative
cell mean or the cell mean of the {it:j}th row (group) and {it:k}th column
(repeated measures) under the alternative hypothesis.

{pmore}
{it:matname} is the name of a Stata matrix with {it:J} rows and {it:K} columns
containing values of alternative cell means.

{pmore}
At least one group, {it:J} = 1, and two repeated measures, {it:K} = 2, must be
specified.

{marker corrspec}{...}
{phang}
where {it:corrspec} for computing power and sample size is{break}
{c -(}{opth corr(numlist)} {c |} {opt covmat:rix(matname)}{c )-}, and
{it:corrspec} for computing effect size is
{c -(}{opt nrep:eated(#)} {opth corr(numlist)} {c |}
{opt covmat:rix(matname)}{c )-}.


{synoptset 31 tabbed}{...}
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
{p2coldent:* {cmd:n}{it:#}{cmd:(}{help numlist}{cmd:)}}number of subjects 
	in group {it:#}{p_end}
{synopt:{cmdab:grw:eights(}{help power_repeated##wgtspec:wgtspec}{cmd:)}}group
   weights; default is one for each group, meaning equal group sizes{p_end}
{synopt:{opt ng:roups(#)}}number of groups{p_end}
{synopt:{opt nrep:eated(#)}}number of repeated measures{p_end}
{p2coldent:* {opth corr(numlist)}}correlation between repeated measures; one
of {cmd:corr()} or {cmd:covmatrix()} is required{p_end}
{synopt:{opt covmat:rix(matname)}}covariance between repeated measures; one of
{cmd:corr()} or {cmd:covmatrix()} is required{p_end}
{synopt:{cmd:{ul on}f{ul off}actor({ul on}b{ul off}etween}|{cmd:{ul on}w{ul off}ithin}|{cmd:{ul on}bw{ul off}ithin)}}tested effect: between, within, or
between-within; default is {cmd:factor(between)}{p_end}
{p2coldent:* {opth vareff:ect(numlist)}}variance explained by the tested
	effect specified in {opt factor()}{p_end}
{p2coldent:* {opth varb:etween(numlist)}}variance explained by the
	between-subjects effect;
	synonym for {cmd:factor(between)} and {opt vareffect(numlist)}{p_end}
{p2coldent:* {opth varw:ithin(numlist)}}variance explained by the 
	within-subject effect;
	synonym for {cmd:factor(within)} and {opt vareffect(numlist)}{p_end}
{p2coldent:* {opth varbw:ithin(numlist)}}variance explained by the 
	between-within effect;
	synonym for {cmd:factor(bwithin)} and {opt vareffect(numlist)}{p_end}
{p2coldent:* {opth varerr:or(numlist)}}error variance; default is 
	{cmd:varerror(1)} when {opt corr()} is specified; not allowed with
	{cmd:covmatrix()}{p_end}
{synopt: {opt showmat:rices}}display cell-means matrix and covariance matrix{p_end}
{synopt: {opt showmea:ns}}display cell means{p_end}
{synopt: {opt par:allel}}treat number lists in starred options or in command
arguments as parallel when multiple values per option or argument are
specified (do not enumerate all possible combinations of values)

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_repeated##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or effect size;
   default is to use a bisection algorithm to bound the solution{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


{marker wgtspec}{...}
{synoptset 15}{...}
{synopthdr:wgtspec}
{synoptline}
{synopt: {it:#1} {it:#2} ... {it:#J}}{it:J} group weights.  Weights must be
positive and must be integers unless option {cmd:nfractional} is specified.
Multiple values for each group weight {it:#j} can be specified as a 
{help numlist} enclosed in parentheses.{p_end}
{synopt: {it:matname}}matrix with {it:J} columns containing {it:J} group
weights.  Multiple rows are allowed, in which case each row corresponds to a
different set of {it:J} weights or, equivalently, column {it:j} corresponds
to a {it:{help numlist}} for the {it:j}th weight.{p_end}
{synoptline}
{p2colreset}{...}


{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_repeated##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt N_g}}number of groups{p_end}
{synopt :{opt N_rep}}number of repeated measurements{p_end}
{synopt :{opt m}{it:#1}{cmd:_}{it:#2}}cell mean ({it:#1,#2}): 
         group {it:#1}, occasion {it:#2}{p_end}
{synopt :{opt Var_b}}between-subjects variance{p_end}
{synopt :{opt Var_w}}within-subject variance{p_end}
{synopt :{opt Var_bw}}between-within (group-by-occasion) variance{p_end}
{synopt :{opt Var_be}}between-subjects error variance{p_end}
{synopt :{opt Var_we}}within-subject error variance{p_end}
{synopt :{opt Var_bwe}}between-within (group-by-occasion) error variance{p_end}
{synopt :{opt Var_e}}error variance{p_end}
{synopt :{opt corr}}correlation between repeated measures{p_end}
{synopt :{opt grwgt}{it:#}}group weight {it:#}{p_end}
{synopt :{opt target}}target parameter; synonym for target effect variance{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Column {cmd:N_per_group} is available and is shown in the default
table only for balanced designs.{p_end}
{p 4 6 2}Columns {cmd:N_avg} and {cmd:N}{it:#} are shown in the default table 
only for unbalanced designs.{p_end}
{p 4 6 2}Columns {cmd:m}{it:#1}{cmd:_}{it:#2} are not shown in the default
table.{p_end}
{p 4 6 2}Columns {cmd:Var_b} and {cmd:Var_be} are shown in the default table
for the between-subjects test, {cmd:Var_w} and {cmd:Var_we} for the
within-subjects test, and {cmd:Var_bw} and {cmd:Var_bwe} for the
between-within test.{p_end}
{p 4 6 2}Columns {cmd:grwgt}{it:#} are not shown in the default table.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power repeated} computes sample size, power, or effect size for one-way 
or two-way repeated-measures analysis of variance (ANOVA).  By default, it
computes sample size for given power and effect size.  Alternatively, it can
compute power for given sample size and effect size or compute effect size for
given sample size, power, and number of groups.  Also see {manhelp power PSS-2}
for a general introduction to the {cmd:power} command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerrepeatedQuickstart:Quick start}

        {mansection PSS-2 powerrepeatedRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerrepeatedMethodsandformulas:Methods and formulas}

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
are allowed.  This option implies a balanced design.  {opt npergroup()}
cannot be specified with {opt n()}, {cmd:n}{it:#}{cmd:()}, or 
{opt grweights()}.

{phang}
{cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)} specifies the size of the
{it:#}th group.  Only positive integers are allowed.  All groups sizes must
be specified.  For example, all three options {cmd:n1()}, {cmd:n2()}, and
{cmd:n3()} must be specified for a design with three groups.
{cmd:n}{it:#}{cmd:()} cannot be specified with {opt n()}, {opt npergroup()},
or {opt grweights()}.

{phang}
{cmd:grweights(}{it:{help power_repeated##wgtspec:wgtspec}}{cmd:)} specifies
J group weights for an unbalanced design.  The weights may be specified either
as a list of values or as a matrix, and multiple sets of weights are allowed;
see {it:{help power_repeated##wgtspec:wgtspec}} for details.  The weights
must be positive and must also be integers unless the {cmd:nfractional} option
is specified.  {cmd:grweights()} cannot be specified with 
{cmd:npergroup()} or {cmd:n}{it:#}{cmd:()}.

{phang}
{opt ngroups(#)} specifies the number of groups.  This option is required if 
{it:{help power_repeated##meanspec:meanspec}} is not specified.
This option is also required for effect-size determination unless
{cmd:grweights()} is specified.  For a one-way repeated-measures ANOVA,
specify {cmd:ngroups(1)}.

{phang}
{opt nrepeated(#)} specifies the number of repeated measurements within each
subject.  At least two repeated measurements must be specified.
This option is required if the {opt corr()} option is specified and 
{it:{help power_repeated##meanspec:meanspec}} is not specified.
This option is also required for effect-size determination unless
{opt covmatrix()} is specified.

{phang}
{opth corr(numlist)} specifies the correlation between repeated measurements.
{opt corr()} cannot be specified with {opt covmatrix()}.
This option requires the {opt nrepeated()} option unless
{it:{help power_repeated##meanspec:meanspec}} is specified.

{phang}
{opt covmatrix(matname)} specifies the covariance matrix between
repeated measurements.  {opt covmatrix()} cannot be specified with
{opt corr()} or {opt varerror()}.

{phang}
{cmd:factor(between}|{cmd:within}|{cmd:bwithin)} specifies the
effect of interest for which power and sample-size analysis is to be
performed.  For a one-way repeated-measures ANOVA, only {cmd:factor(within)}
is allowed and is implied when only one group is specified.  In a two-way
repeated-measures ANOVA, the tested effects include the between effect or
main effect of a between-subjects factor, the within effect or main effect of
a within-subject factor, and the between-within effect or interaction effect
of the between-subjects factor and the within-subject factor.  The default for
a two-way repeated design is {cmd:factor(between)}.

{phang}
{opth vareffect(numlist)} specifies the variance explained by the tested
effect specified in {opt factor()}.  For example, if {cmd:factor(between)} is
specified, {opt vareffect()} specifies the variance explained by the
between-subjects factor.  This option is required if the {opt factor()} option
is specified and
{it:{help power_repeated##meanspec:meanspec}} is not specified.
This option is not allowed with the effect-size determination.  Only one of
{opt vareffect()}, {opt varbetween()}, {opt varwithin()}, or
{opt varbwithin()} may be specified.

{phang}
{opth varbetween(numlist)} specifies the variance explained by the
between-subjects factor.  This option is equivalent to specifying
{cmd:factor(between)} and {opt vareffect(numlist)} and thus cannot be
combined with {opt factor()}.  This option is not allowed with the effect-size
determination.  Only one of {opt vareffect()}, {opt varbetween()},
{opt varwithin()}, or {opt varbwithin()} may be specified.  This option is not
allowed when only one group is specified.

{phang}
{opth varwithin(numlist)} specifies the variance explained by the
within-subject factor.  This option is equivalent to specifying
{cmd:factor(within)} and {opt vareffect(numlist)} and thus cannot be
combined with {opt factor()}.  This option is not allowed with the effect-size
determination.  Only one of {opt vareffect()}, {opt varbetween()},
{opt varwithin()}, or {opt varbwithin()} may be specified.

{phang}
{opth varbwithin(numlist)} specifies the variance explained by the
interaction between a between-subjects factor and a within-subject factor.
This option is equivalent to specifying {cmd:factor(bwithin)} and
{opt vareffect(numlist)} and thus cannot be combined with {opt factor()}.  This option is not allowed with the effect-size determination.  Only one of
{opt vareffect()}, {opt varbetween()}, {opt varwithin()}, or
{opt varbwithin()} may be specified.  This option is not allowed when only one
group is specified.

{phang}
{opth varerror(numlist)} specifies the error variance if
{opt covmatrix()} is not specified.  This option is allowed only if
{opt corr()} is specified.  When {opt corr()} is specified, the default is
{cmd:varerror(1)}.

{phang}
{opt showmatrices} specifies that the cell-means matrix and the covariance
matrix be displayed, when applicable.

{phang}
{opt showmeans} specifies that the cell means be reported.  For a text or
graphical output, this option is equivalent to {opt showmatrices} except only
the cell-mean matrix will be reported.  For a tabular output, the columns
containing cell means will be included in the default table.

{phang}
{cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powerrepeatedSyntaxcolumn:column} table in
{bf:[PSS-2] power twomean} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the effect size {it:delta}
for the effect-size determination.  The default uses a bisection algorithm
to bracket the solution.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power repeated} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power repeated}

{pstd}
{cmd:power repeated} computes sample size, power, or effect size for one-way
and two-way fixed-effects repeated-measures ANOVA models.  A one-way
repeated-measures ANOVA model includes one fixed within-subject factor.  The
supported two-way repeated-measures ANOVA includes one fixed between-subjects
factor and one fixed within-subject factor.  A one-way model is available as a
special case of a two-way model with one group.  At least one group and two
repeated measures must be specified.

{pstd}
All computations are performed assuming a significance level of 0.05.  You may
change the significance level by specifying the {cmd:alpha()} option.

{pstd}
The computations are performed for an {it:F} test of the effect of interest.
In a one-way model, the only effect of interest is a within-subject effect.
In a two-way model, you can choose between the three effects of interest:
between-subjects effect with {cmd:factor(between)} (the default),
within-subject effect with {cmd:factor(within)}, and between-within effect
with {cmd:factor(bwithin)}.

{pstd}
All computations require that you specify a residual covariance between
repeated measures.  You can either specify any unstructured covariance matrix
in {cmd:covmatrix()} or specify the correlation between repeated measures in
{cmd:corr()} and the error variance in {cmd:varerror()}.  If {cmd:corr()} is
specified, {cmd:varerror(1)} is assumed.  The latter specification implies a
residual covariance with compound-symmetry structure.

{pstd}
To compute the total sample size, you must also specify the alternative
{it:{help power_repeated##meanspec:meanspec}} and, optionally, the
power of the test in {cmd:power()}.  The default power is set to 0.8.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option and the alternative {it:{help power_repeated##meanspec:meanspec}}. 

{pstd}
Instead of the alternative cell means, you can specify the number of groups
(rows) in the {cmd:ngroups()} option, the number of repeated measures
(columns) in the {cmd:nrepeated()} option, and the variance explained by the
tested effect in the {cmd:vareffect()} option when computing sample size or
power.  See 
{it:{mansection PSS-2 powertwowayRemarksandexamplessub1:Alternative ways of specifying effect}} in 
{bf:[PSS-2] power twoway}; substitute {cmd:ngroups()} for
{cmd:nrows()}, {cmd:nrepeated()} for {cmd:ncols()}, {cmd:varbetween()} for
{cmd:varrow()}, {cmd:varwithin()} for {cmd:varcolumn()}, and
{cmd:varbwithin()} for {cmd:varrowcolumn()}.  If {cmd:covmatrix()} is
specified, the {cmd:nrepeated()} option is not required--the number of
repeated measures is determined by the dimensionality of the specified
covariance matrix.

{pstd}
To compute effect size, the square root of the ratio of the variance explained
by the tested factor to the comparison error variance, and the target variance
explained by the tested factor, in addition to the residual covariance, you
must specify the total sample size in {cmd:n()}, the power in {cmd:power()},
the number of groups in {cmd:ngroups()}, and the number of repeated measures
in {cmd:nrepeated()} if {cmd:corr()} is specified.

{pstd}
By default, all computations assume a balanced- or an equal-allocation design.
You can use {cmd:grweights()} to specify an unbalanced design for power,
sample-size, or effect-size computations.  For power and effect-size
computations, you can specify individual group sizes in {cmd:n1()},
{cmd:n2()}, and so on, instead of a combination of {cmd:n()} and
{cmd:grweights()} to accommodate an unbalanced design.  For a balanced design,
you can also specify {cmd:npergroup()} to specify a group size instead of a
total sample size in {cmd:n()}.

{pstd}
In repeated-measures ANOVA, sample size and effect size depend on the
noncentrality parameter of the {it:F} distribution, and their estimation
requires iteration.  The default initial values are obtained from a bisection
search that brackets the solution.  If you desire, you may change this by
specifying your own value in the {cmd:init()} option.  See
{manhelp power PSS-2} for the descriptions of other options that control the
iteration procedure.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
Calculate the sample size necessary to reject the null hypothesis that there
is no main effect of treatment and no interaction between treatment and
time{p_end}
{phang2}{cmd:. power repeated 145 135 130\145 130 120, covmat(225 158 158\158 225 158\158 158 225)}

{pstd}
Specify the data of the last analysis as matrices; compute the sample size
required to detect an interaction between treatment and time{p_end}
{phang2}{cmd:. matrix M = (145,135,130\145,130,120)}{p_end}
{phang2}{cmd:. matrix cov = (225,158,158\158,225,158\158,158,225)}{p_end}
{phang2}{cmd:. power repeated M, covmat(cov) factor(bwithin)}

{pstd}
Repeat the last example specifying the error variance and repeated 
measures correlation{p_end}
{phang2}{cmd:. power repeated M, varerr(225) corr(0.7) factor(bwithin)}


    {title:Examples: Computing power}

{pstd}
Using the same means and covariance matrix compute the power of the 
between-subjects effect using a balanced design and a total sample size of
200{p_end}
{phang2}{cmd:. power repeated M, covmat(cov) n1(100) n2(100) factor(between)}

{pstd}
Repeat, but now allocate the sample size differently among the two
treatments{p_end}
{phang2}{cmd:. power repeated M, covmat(cov) n1(80) n2(120) factor(between)}


    {title:Examples: Computing the effect size}

{pstd}
Inquire how large the between-subjects variance must be in order to achieve a
power of 80% with a total sample size of 200 using a balanced design{p_end}
{phang2}{cmd:. power repeated, covmat(cov) n(200) power(0.8) factor(between) ngroups(2)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power repeated} stores the following in {cmd:r()}:

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
{synopt:{cmd: r(N_rep)}}number of rows{p_end}
{synopt:{cmd: r(m}{it:#1}_{it:#2}{cmd:)}}cell mean ({it:#1}, {it:#2}){p_end}
{synopt:{cmd: r(Var_b)}}between-subjects variance{p_end}
{synopt:{cmd: r(Var_w)}}within-subject variance{p_end}
{synopt:{cmd: r(Var_bw)}}between-within subjects, interaction variance{p_end}
{synopt:{cmd: r(Var_be)}}between-subjects error variance{p_end}
{synopt:{cmd: r(Var_we)}}within-subject error variance{p_end}
{synopt:{cmd: r(Var_bwe)}}between-within subjects, interaction error variance{p_end}
{synopt:{cmd: r(Var_e)}}error variance{p_end}
{synopt:{cmd: r(spherical)}}{cmd:1} if covariance is spherical, {cmd:0}
        otherwise{p_end}
{synopt:{cmd: r(epsilon)}}nonsphericity correction{p_end}
{synopt:{cmd: r(epsilon_m)}}mean nonsphericity correction{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or effect size{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:repeated}{p_end}
{synopt:{cmd:r(factor)}}{cmd:between}, {cmd:within}, or {cmd:bwithin}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{synopt:{cmd:r(means)}}cell-means matrix{p_end}
{synopt:{cmd:r(Cov)}}repeated-measures covariance{p_end}
{p2colreset}{...}
