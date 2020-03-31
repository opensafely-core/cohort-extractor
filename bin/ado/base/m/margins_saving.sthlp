{smcl}
{* *! version 1.2.0  11dec2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{viewerjumpto "Syntax" "margins_saving##syntax"}{...}
{viewerjumpto "Description" "margins_saving##description"}{...}
{viewerjumpto "Remarks" "margins_saving##remarks"}{...}
{title:Title}

{p2colset 4 26 28 2}{...}
{p2col:{hi:[R] margins, saving()}}{hline 2} Save margins results to a dataset
{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin} {weight}
[{cmd:,} 
{help prefix_saving_option:{bf:{ul:sav}ing(}{it:filename}{bf:, ...)}}
{it:{help margins##response_options:response_options}}
{it:{help margins##options:options}}] 


{marker description}{...}
{title:Description}

{pstd}
{cmd:margins,} {opt saving()} saves a dataset containing the statistics
reported in the output.


{marker remarks}{...}
{title:Remarks}

{pstd}
Each observation in the {cmd:margins,} {opt saving()} dataset corresponds with
a row in the output table.

{pstd}
The following variables are always present:

{phang2}
{cmd:_deriv} identifies the variable that the margin values were
differentiated with respect to.
The values in {cmd:_deriv} are labeled with the independent variables
specified in the {opt dydx()} options; otherwise, {cmd:_deriv} contains all
missing values.
For factor variables, the factor level is contained in the label.

{phang2}
{cmd:_term} identifies the factor variables participating in the
{it:marginlist} term associated with the estimated margin value.
The values in {cmd:_term} are labeled with a list of the names of the factor
variables present in the terms specified in {it:marginlist}; the grand margin
is labeled "_cons".

{phang2}
{cmd:_predict} identifies the {opt predict()} option associated with the
estimated margin value.
The values in {cmd:_predict} are labeled with the {opt predict()} option.
{cmd:_predict} contains missing values when the {cmd:expression()} option is
specified.

{pmore2}
The {cmd:_dta[k_predict]} characteristic identifies how many {opt predict()}
options were specified or implied.  This characteristic is empty when
the {opt expression()} option is specified with an expression that contains
more than just a reference to an equivalent {opt predict()} option.

{phang2}
{cmd:_margin} contains the estimated margin values.

{phang2}
{cmd:_se_margin} contains the estimated standard errors of the estimated margin
values.

{phang2}
{cmd:_statistic} contains the value of the {it:z} (or {it:t}) statistic for
testing the margin values against zero.

{phang2}
{cmd:_pvalue} contains the observed significance level for a two-sided test
of the marginal values against zero.

{phang2}
{cmd:_ci_lb} and {cmd:_ci_ub} contain the confidence interval limits for the
margin values.

{pstd}
A variable with the {cmd:_m} prefix is present for each unique factor variable
specified in {it:marginlist}.

{phang2}
{cmd:_m}{it:#} contains the levels of the {it:#}th unique factor variable in
{it:marginlist}, identifying the level corresponding with the estimated
margin value.
{cmd:_m}{it:#} is missing if the associated factor variable is not in the list
of factor variables corresponding with the term for a given estimated margin
value.

{pmore2}
The {cmd:_m}{it:#}{cmd:[varname]} characteristic identifies the factor
variable that {cmd:_m}{it:#} corresponds to.

{pmore2}
The {cmd:_dta[margin_vars]} characteristic contains the names of the factor
variables associated with the {cmd:_m}{it:#} variables.

{pstd}
A variable with the {cmd:_at} prefix is present for each unique independent
variable in the model when one or more independent variables is fixed because
of options {opt atmeans}, {opt asbalanced}, or {opt at()}.

{phang2}
{cmd:_at}{it:#} contains the value at which the {it:#}th independent variable
was fixed.
For factor variables, {cmd:_at}{it:#} contains the {cmd:.b} missing value if
the factor variable was treated as balanced.
{cmd:_at}{it:#} contains the {cmd:.o} missing value if the variable was
left as observed.

{pmore2}
The {cmd:_at}{it:#}{cmd:[varname]} characteristic identifies the independent
variable that {cmd:_at}{it:#} corresponds to.
The {cmd:_at}{it:#}{cmd:[stats]} characteristic identifies the statistic at
which the variable was set; there is one statistic for each {opt at()}
option.
In addition to the statistics documented with the
{helpb margins##atspec:at()} option, the following identifiers are used when
one or multiple values are specified in the {opt at()} option:
	{opt value} and
	{opt values}.

{pmore2}
The {cmd:_dta[at_vars]} characteristic contains the names of the independent
variables associated with the {cmd:_at}{it:#} variables.

{pmore2}
The {cmd:_dta[k_at]} characteristic identifies how many {opt at()} options
were specified/implied.
The {cmd:_dta[atopt}{it:#}{cmd:]} characteristic identifies the
specification of the {it:#}th {opt at()} option.
The {cmd:_dta[atstats}{it:#}{cmd:]} characteristic identifies the
specification attached to the variables in the {it:#}th {opt at()} option.

{phang2}
There will also be an {cmd:_at} variable that identifies groups of margin
values associated with patterns in the {cmd:_at}{it:#} variables and an
{cmd:_atopt} variable that identifies groups of margin values associated with
each {opt at()} option.

{pstd}
A variable with the {cmd:_by} prefix is present for each variable specified in
the {opt over()} and {opt within()} options.

{phang2}
{cmd:_by}{it:#} identifies the group level of the {it:#}th grouping variable
associated with the estimated margin value.

{pmore2}
The {cmd:_by}{it:#}{cmd:[varname]} characteristic identifies the group
variable that {cmd:_by}{it:#} corresponds to.

{pmore2}
The {cmd:_dta[by_vars]} characteristic contains the names of the group
variables associated with the {cmd:_by}{it:#} variables.
The {cmd:_dta[over]} characteristic identifies the {opt over()} variables, and
the {cmd:_dta[within]} characteristic identifies the {opt within()} variables.
{p_end}
