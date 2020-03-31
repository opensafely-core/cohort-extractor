{smcl}
{* *! version 1.0.16  27feb2019}{...}
{viewerdialog power "dialog power_twoway"}{...}
{vieweralsosee "[PSS-2] power twoway" "mansection PSS-2 powertwoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power oneway" "help power oneway"}{...}
{vieweralsosee "[PSS-2] power repeated" "help power repeated"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{viewerjumpto "Syntax" "power_twoway##syntax"}{...}
{viewerjumpto "Menu" "power_twoway##menu"}{...}
{viewerjumpto "Description" "power_twoway##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_twoway##linkspdf"}{...}
{viewerjumpto "Options" "power_twoway##options"}{...}
{viewerjumpto "Remarks: Using power twoway" "power_twoway##remarks"}{...}
{viewerjumpto "Examples" "power_twoway##examples"}{...}
{viewerjumpto "Stored results""power_twoway##stored_results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[PSS-2] power twoway} {hline 2}}Power analysis for two-way
analysis of variance{p_end}
{p2col:}({mansection PSS-2 powertwoway:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 20 2}
{opt power} {opt twoway} 
{it:{help power_twoway##meanspec:meanspec}} 
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_twoway##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt twoway} 
{it:{help power_twoway##meanspec:meanspec}}{cmd:,}
{opth n(numlist)}
[{it:{help power_twoway##synoptions:options}}]


{phang}
Compute effect size and target effect variance 

{p 8 20 2}
{opt power} {opt twoway}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} {opt nr:ows(#)} {opt nc:ols(#)}
[{it:{help power_twoway##synoptions:options}}]

{marker meanspec}{...}
{phang}
where {it:meanspec} is either a matrix {it:matname} containing cell means or
individual cell means in a matrix form:

{phang3}
{it:m1_1} {it:m1_2} [...] {cmd:\} {it:m2_1} {it:m2_2} [...] [{cmd:\}...{cmd:\} {it:mJ_1} ... {it:mJ_K}]

{pmore}
{it:mj_k}, where j = 1, 2, ..., J and k = 1, 2, ..., K, is the alternative
cell mean or the cell mean of the {it:j}th row and {it:k}th column under the
alternative hypothesis.

{pmore}
{it:matname} is the name of a Stata matrix with {it:J} rows and {it:K} columns
containing values of alternative cell means.


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
{p2coldent:* {opth nperc:ell(numlist)}}number of subjects per cell; implies 
balanced design{p_end}
{synopt:{cmdab:cellw:eights(}{it:{help power_twoway##wgtspec:wgtspec}}{cmd:)}}cell weights; default is one for each cell, meaning equal cell sizes{p_end}
{synopt:{opt nr:ows(#)}}number of rows{p_end}
{synopt:{opt nc:ols(#)}}number of columns{p_end}
{synopt:{cmd:{ul on}f{ul off}actor(row}|{cmd:{ul on}col{ul off}umn}|{cmd:rowcol)}}tested effect{p_end}
{p2coldent:* {opth vareff:ect(numlist)}}variance explained by the tested
	effect in {cmd:factor()}{p_end}
{p2coldent:* {opth varrow(numlist)}}variance explained by the row effect;
	synonym for {cmd:factor(row)} and {opt vareffect(numlist)}{p_end}
{p2coldent:* {opth varcol:umn(numlist)}}variance explained by the column 
	effect; synonym for {cmd:factor(column)} and 
	{opt vareffect(numlist)}{p_end}
{p2coldent:* {opth varrowcol:umn(numlist)}}variance explained by the row-column
	interaction effect; synonym for {cmd:factor(rowcol)} and 
	{opt vareffect(numlist)}{p_end}
{p2coldent:* {opth varerr:or(numlist)}}error variance; default is 
	{cmd:varerror(1)}{p_end}
{synopt: {opt showmat:rices}}display cell means and sample sizes as matrices{p_end}
{synopt: {opt showmea:ns}}display cell means{p_end}
{synopt: {opt showcells:izes}}display cell sample sizes{p_end}
{synopt: {opt par:allel}}treat number lists in starred options or in command
arguments as parallel when multiple values per option or argument are
specified (do not enumerate all possible combinations of values)


{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_twoway##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
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
{synoptset 35}{...}
{synopthdr:wgtspec}
{synoptline}
{synopt:{it:#1_1} ... {it:#1_K} {cmd:\}...{cmd:\} {it:#J_1} ... {it:#J_K}}
{it:J}x{it:K} cell weights; weights must be positive and must be integers
unless option {cmd:nfractional} is specified{p_end}
{synopt: {it:matname}}{it:J}x{it:K} matrix containing cell weights{p_end}
{synoptline}
{p2colreset}{...}


{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_twoway##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt N_per_cell}}number of subjects per cell{p_end}
{synopt :{opt N_avg}}average number of subjects per cell{p_end}
{synopt :{opt N}{it:#1}{cmd:_}{it:#2}}number of subjects in cell ({it:#1,#2}){p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt N_rc}}number of cells{p_end}
{synopt :{opt N_r}}number of rows{p_end}
{synopt :{opt N_c}}number of columns{p_end}
{synopt :{opt m}{it:#1}{cmd:_}{it:#2}}cell mean ({it:#1},{it:#2}){p_end}
{synopt :{opt Var_r}}variance explained by the row effect{p_end}
{synopt :{opt Var_c}}variance explained by the column effect{p_end}
{synopt :{opt Var_rc}}variance explained by the row-column interaction{p_end}
{synopt :{opt Var_e}}error variance{p_end}
{synopt :{opt cwgt}{it:#1}{cmd:_}{it:#2}}cell weight ({it:#1},{it:#2}){p_end}
{synopt :{opt target}}target parameter; synonym for target effect variance
{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}
Column {cmd:N_per_cell} is available and is shown in the default table only 
for balanced designs.{p_end}
{p 4 6 2}
Column {cmd:N_avg} is shown in the default table only for unbalanced designs.
{p_end}
{p 4 6 2}
Columns {cmd:N}{it:#1}{cmd:_}{it:#2}, {cmd:N_rc},
{cmd:m}{it:#1}{cmd:_}{it:#2}, and {cmd:cwgt}{it:#1}{cmd:_}{it:#2} are not
shown in the default table.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power twoway} computes sample size, power, or effect size for two-way
analysis of variance (ANOVA).  By default, it computes sample size for given
power and effect size.  Alternatively, it can compute power for given sample
size and effect size or compute effect size for given sample size, power, and
number of cells.  You can choose between testing for main row or column effect
or their interaction.  Also see {manhelp power PSS-2} for a general introduction
to the {cmd:power} command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powertwowayQuickstart:Quick start}

        {mansection PSS-2 powertwowayRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powertwowayMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; see
{manhelp power##mainopts PSS-2: power}.

{phang}
{opth npercell(numlist)} specifies the cell size.  Only positive integers are
allowed.  This option implies a balanced design.  {opt npercell()}
cannot be specified with {opt n()} or {opt cellweights()}.

{phang}
{cmd:cellweights(}{it:{help power_twoway##wgtspec:wgtspec}}{cmd:)} specifies 
{it:J}x{it:K} cell weights for an unbalanced design.  The weights must be
positive and must also be integers unless the {cmd:nfractional} option is
specified.  {cmd:cellweights()} cannot be specified with {cmd:npercell()}.

{phang}
{opt nrows(#)} specifies the number of rows or the number of levels of the row
factor in a two-way ANOVA.  At least two rows must be specified.
This option is required if
{it:{help power_twoway##meanspec:meanspec}} is not specified.  This option is
also required for effect-size determination unless {cmd:cellweights()} is
specified.

{phang}
{opt ncols(#)} specifies the number of columns or the number of levels of the
column factor in a two-way ANOVA.  At least two columns must be specified.
This option is required if
{it:{help power_twoway##meanspec:meanspec}} is not specified.  This option is
also required for effect-size determination unless {cmd:cellweights()} is
specified.

{phang}
{cmd:factor(row}|{cmd:column}|{cmd:rowcol)} specifies the effect of interest
for which power and sample-size analysis is to be performed.  In a two-way
ANOVA, the tested effects include the main effects of a row factor (row
effect), the main effects of a column factor (column effect), or the
interaction effects between the row and column factors (row-column effect).
The default is {cmd:factor(row)}.

{phang}
{opth vareffect(numlist)} specifies the variance explained by the tested
effect specified in {cmd:factor()}.  For example, if {cmd:factor(row)} is
specified, {cmd:vareffect()} specifies the variance explained by the row
factor.  This option is required if the {cmd:factor()} option is specified and
cell means are not specified.  This option is not allowed with the effect-size
determination.  Only one of {cmd:vareffect()}, {cmd:varrow()},
{cmd:varcolumn()}, or {cmd:varrowcolumn()} may be specified.

{phang}
{opth varrow(numlist)} specifies the variance explained by the row factor.
This option is equivalent to specifying {cmd:factor(row)} and 
{opt vareffect(numlist)} and thus cannot be combined with {cmd:factor()}.
This option is not allowed with the effect-size determination.  Only one of
{cmd:vareffect()}, {cmd:varrow()}, {cmd:varcolumn()}, or {cmd:varrowcolumn()}
may be specified.

{phang}
{opth varcolumn(numlist)} specifies the variance explained by the column
factor.  This option is equivalent to specifying {cmd:factor(column)} and 
{opt vareffect(numlist)} and thus cannot be combined with {cmd:factor()}.
This option is not allowed with the effect-size determination.  Only one of
{cmd:vareffect()}, {cmd:varrow()}, {cmd:varcolumn()}, or {cmd:varrowcolumn()}
may be specified.

{phang}
{opth varrowcolumn(numlist)} specifies the variance explained by the
interaction between row and column factors.  This option is equivalent to
specifying {cmd:factor(rowcol)} and {opt vareffect(numlist)} and thus cannot
be combined with {cmd:factor()}.  This option is not allowed with the
effect-size determination.  Only one of {cmd:vareffect()}, {cmd:varrow()},
{cmd:varcolumn()}, or {cmd:varrowcolumn()} may be specified.

{phang}
{opth varerror(numlist)} specifies the error (within-cell) variance.  The
default is {cmd:varerror(1)}.

{phang}
{opt showmatrices} specifies that the matrices of cell means and cell sizes be
displayed, when applicable.  The cell means will be displayed only if
specified.  The cell sizes will be displayed only for an unbalanced design.

{phang}
{opt showmeans} specifies that the cell means be reported.  For a text or
graphical output, this option is equivalent to {cmd:showmatrices} except only
the cell-mean matrix will be reported.  For a tabular output, the columns
containing cell means will be included in the default table.

{phang}
{opt showcellsizes} specifies that the cell sizes be reported.  For a text or
graphical output, this option is equivalent to {cmd:showmatrices} except only
the cell-sizes matrix will be reported.  For a tabular output, the columns
containing cell sizes will be included in the default table.

{phang}
{cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powertwowaySyntaxcolumn:column} table in
{bf:[PSS-2] power twoway} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the effect size {it:delta}
for the effect-size determination.  The default uses a bisection algorithm to
bracket the solution.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power twoway} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power twoway}

{pstd}
{cmd:power twoway} computes sample size, power, or effect size and target
variance of the effect for a two-way fixed-effects ANOVA.  All
computations are performed assuming a significance level of 0.05.  You may
change the significance level by specifying the {cmd:alpha()} option.

{pstd}
By default, the computations are performed for an F test of the main row
effects; {cmd:factor(row)} is assumed.  You can instead request a test of the
main column effects by specifying {cmd:factor(column)} or a test of the
row-by-column interaction effects by specifying {cmd:factor(rowcol)}.  The
error variance for all tests is assumed to be 1 but may be changed by
specifying the {cmd:varerror()} option.

{pstd}
To compute the total sample size, you must specify the alternative
{it:{help power_twoway##meanspec:meanspec}} and, optionally, the power of the
test in the {cmd:power()} option.  The default power is set to 0.8.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option and the alternative
{it:{help power_twoway##meanspec:meanspec}}.

{pstd}
Instead of the alternative cell means, you can specify the number of rows in
the {cmd:nrows()} option, the number of columns in the {cmd:ncols()} option,
and the variance explained by the tested effect in the {cmd:vareffect()}
option when computing sample size or power.

{pstd}
To compute effect size, the square root of the ratio of the variance explained
by the tested factor to the error variance, and the target variance explained
by the tested factor, you must specify the total sample size in the {cmd:n()}
option, the power in the {cmd:power()} option, and the number of rows and
columns in {cmd:nrows()} and {cmd:ncols()}, respectively.

{pstd}
By default, all computations assume a balanced- or an equal-allocation design.
You can use the {cmd:cellweights()} option to specify an unbalanced design for
power, sample-size, or effect-size computations.  For power and effect-size
computations of a balanced design, you can also specify the {cmd:npercell()}
option to specify a cell size instead of a total sample size in {cmd:n()}.

{pstd}
In a two-way ANOVA, sample size and effect size depend on the
noncentrality parameter of the F distribution, and their estimation
requires iteration.  The default initial values are obtained from a bisection
search that brackets the solution.  If you desire, you may change this by
specifying your own value in the {cmd:init()} option.  See
{manhelp power PSS-2} for the descriptions of other options that control the
iteration procedure.


{marker examples}{...}
{title:Examples}

{pstd}
In the examples below, we consider a two-by-three two-way fixed-effects ANOVA
model with the postulated cell-matrix means and the error variance of 1417.

                   |      Column
                   |   1   2   3 
            -------|-----------
            Row  1 | 134 143  91
                 2 | 106 173 145


    {title:Examples: Computing sample size}

{pstd} 
Compute sample size for testing the row effect for a 5%-level test with 80%
power{p_end}
{phang2}{bf:. power twoway 134 143 91 \ 106 173 145, varerror(1417)}

{pstd} 
Compute the required sample size for the test of a column effect{p_end}
{phang2}{bf:. power twoway 134 143 91 \ 106 173 145, varerror(1417) factor(column)}

{pstd} 
Compute the required sample size for the test of a row-by-column
effect{p_end}
{phang2}{bf:. power twoway 134 143 91 \ 106 173 145, varerror(1417) factor(rowcol)}

{pstd}
Specify the variance of the row effect instead of individual cell
means{p_end}
{phang2}{bf:. power twoway, varerror(1417) varrow(87.1111) nrows(2) ncols(3)}

{pstd}
Specify an unbalanced design{p_end}
{phang2}{bf:. power twoway 134 143 91 \ 106 173 145, varerror(1417) cellweights(2 2 2 \ 1 1 1) showcellsizes}


    {title:Examples: Computing power}

{pstd}
Compute power for the row effect assuming a total sample size of 90{p_end}
{phang2}{bf:. power twoway 134 143 91 \ 106 173 145, n(90) varerror(1417)}

{pstd}
Specify the cell-means matrix instead of individual cell means{p_end}
{phang2}{bf:. matrix meanmat = (134, 143, 91 \ 106, 173, 145)}{p_end}
{phang2}{bf:. power twoway meanmat, n(90) varerror(1417)}


    {title:Examples: Computing the effect size}

{pstd}
Compute the minimum detectable effect size for a sample size of 90 and a power
of 80%{p_end}
{phang2}{cmd:. power twoway, n(90) power(.80) nrows(2) ncols(3)}

{pstd}
Specify error variance to compute the corresponding variance explained by the
row effect{p_end}
{phang2}{cmd:. power twoway, n(90) power(.80) varerror(1417) nrows(2) ncols(3)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power twoway} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}total sample size{p_end}
{synopt:{cmd: r(N_a)}}actual sample size{p_end}
{synopt:{cmd: r(N_avg)}}average sample size{p_end}
{synopt:{cmd: r(N}{it:#1}{cmd:_}{it:#2}{cmd:)}}number of subjects in cell
({it:#1},{it:#2}){p_end}
{synopt:{cmd: r(N_per_cell)}}number of subjects per cell{p_end}
{synopt:{cmd: r(N_rc)}}number of cells{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified,
{cmd:0} otherwise{p_end}
{synopt:{cmd: r(balanced)}}{cmd:1} for a balanced design, {cmd:0} otherwise
{p_end}
{synopt:{cmd: r(cwgt}{it:#1}{cmd:_}{it:#2}{cmd:)}}cell weight 
({it:#1},{it:#2}){p_end}
{synopt:{cmd: r(N_r)}}number of rows{p_end}
{synopt:{cmd: r(N_c)}}number of columns{p_end}
{synopt:{cmd: r(m}{it:#1}{cmd:_}{it:#2}{cmd:)}}cell mean 
({it:#1},{it:#2}){p_end}
{synopt:{cmd: r(Var_r)}}row variance{p_end}
{synopt:{cmd: r(Var_c)}}column variance{p_end}
{synopt:{cmd: r(Var_rc)}}row-by-column variance{p_end}
{synopt:{cmd: r(Var_e)}}error variance{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or effect size{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:twoway}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{synopt:{cmd:r(Nij)}}cell-sizes matrix{p_end}
{synopt:{cmd:r(means)}}cell-means matrix{p_end}
{synopt:{cmd:r(cwgt)}}cell-weights matrix{p_end}
