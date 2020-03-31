{smcl}
{* *! version 1.0.11  23aug2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] ml" "help _get_diparmopts"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Syntax" "_diparm##syntax"}{...}
{viewerjumpto "Description" "_diparm##description"}{...}
{viewerjumpto "Options" "_diparm##options"}{...}
{viewerjumpto "Remarks" "_diparm##remarks"}{...}
{viewerjumpto "Examples" "_diparm##examples"}{...}
{viewerjumpto "Stored results" "_diparm##results"}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col:{hi:[P] _diparm} {hline 2}}Programmer's utility for displaying
ancillary parameters{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Syntax for one ancillary parameter:

{p 8 26 2}
{cmd:_diparm} {it:eqname}
	[{cmd:,}
		[
			{cmd:exp} | {cmd:tanh} | {cmd:invlogit} |
			{cmdab:f:unction:(}{it:expr(@)}{cmd:)} 
			{cmdab:d:erivative:(}{it:expr(@)}{cmd:)}
		]
		{cmdab:lab:el:(}{it:string}{cmd:)}
		{cmdab:p:rob}
		{cmd:dof(}{it:#}{cmd:)}
		{cmdab:l:evel:(}{it:#}{cmd:)}
		{opt notab}
	]

{pstd}
where {it:expr(@)} is an expression with {it:@} substituted for the
parameter {cmd:[}{it:eqname}{cmd:]_cons}.


{pstd}
Syntax for a parameter that is a function of 2-9 ancillary parameters:

{p 8 26 2}
{cmd:_diparm} {it:eqname1} {it:eqname2} [{it:eqname3} ...] {cmd:,}
	{cmdab:f:unction:(}{it:expr(@1,@2,...)}{cmd:)}
	{cmdab:d:erivative:(}{it:expr1(@1,@2,...)} {it:expr2(@1,@2,...)}
		...{cmd:)}
	[
		{cmd:ci(logit} | {cmd:probit} | {cmd:atanh} |
		{cmd:log)} {cmdab:lab:el:(}{it:string}{cmd:)}
		{cmdab:p:rob} {cmd:dof(}{it:#}{cmd:)}
		{cmdab:l:evel:(}{it:#}{cmd:)}
		{opt notab}
	]

{pstd}
where {it:expr(@1,@2,...)} is an expression with {it:@1,@2,...} substituted
for the parameters {cmd:[}{it:eqname1}{cmd:]_cons},
{cmd:[}{it:eqname2}{cmd:]_cons},....


{pstd}
Syntax for drawing a separator line:

{p 8 26 2}
{cmd:_diparm} {cmd:__sep__}


{pstd}
Syntax for drawing the bottom line:

{p 8 26 2}
{cmd:_diparm} {cmd:__bot__}


{pstd}
Syntax for adding a labeled row:

{p 8 26 2}
{cmd:_diparm} {cmd:__lab__}{cmd:,}
	{opt lab:el(string)}
	[
		{opt eqlab:el}
		{opt value(#)}
		{opt comment(string)}
	]



{marker description}{...}
{title:Description}

{pstd}
Ancillary parameters are often estimated in a transformed metric; for example,
rather than estimating sigma, we estimate ln(sigma).  In an estimation output
table, we would like to display the transformed parameter with the
"{hi:/}" notation (for example, {hi:/lnsigma}) and display the parameter in its
natural metric (for example, sigma).

{pstd}
This command displays the ancillary parameter, its standard error,
confidence interval, and, optionally, the z or t statistic and p-value.
The confidence interval for one parameter in any metric other than the
estimation metric is obtained by taking the confidence interval in the
estimation metric and transforming the endpoints.

{pstd}
For a parameter that is a function of more than one estimated parameter,
the second syntax applies.  Here, confidence intervals can be optionally
transformed using the {cmd:ci()} option so that the endpoints lie within
certain bounds:

{col 13}(0, 1){col 25}{cmd:ci(logit)}
{col 13}(0, 1){col 25}{cmd:ci(probit)}
{col 13}(-1, 1){col 25}{cmd:ci(atanh)}
{col 13}(0, +inf){col 25}{cmd:ci(log)}

{pstd}
Thus, the CI is

{p 12 12 2}f^-1( f(b) +/- z*se*|f'(b)| )

{pstd}
where f() is either the logit, probit, atanh, or log transform.


{marker options}{...}
{title:Options}

{phang}
{cmd:label(}{it:string}{cmd:)} specifies how to label the parameter in the
output.  By default, the label is {hi:/}{it:eqname}, where {it:eqname} is
shortened to 12 characters if necessary.

{pmore}
The following options are allowed in addition to the required {opt label()}
option when {cmd:_diparm} {cmd:__lab__} is specified.

{phang2}
{opt eqlabel} indicates that the {opt label()} option contains the label for
an equation.  This changes the default alignment and color of the label to
that of an equation.

{phang2}
{opt value(#)} specifies a value to be placed in the coefficient column.

{phang2}
{opt comment(string)} specifies a comment to be placed in the standard error
column.

{phang}
{cmd:prob} requests that the test statistic and p-value be displayed.
If the parameter is being displayed in the estimation metric, then, by
default, these are displayed.  If the parameter is being displayed in another
metric, then, by default, these are not displayed.

{phang}
{cmd:dof(}{it:#}{cmd:)} specifies the degrees of freedom for a t
statistic.  If not specified, a z statistic is used for the confidence
interval, test statistic, and p-value.

{phang}
{cmd:level(}{it:#}{cmd:)} specifies the confidence level for the
confidence intervals; see {manhelp level R}.

{phang}
{opt notab} suppresses the table entry from being displayed.

{phang}
{cmd:exp} specifies that {cmd:exp(}estimated parameter{cmd:)} is to be
displayed; that is, the estimated parameter was the log of the natural
parameter.

{phang}
{cmd:tanh} specifies that {cmd:tanh}(estimated parameter{cmd:)} is to be
displayed; that is, the estimated parameter was the arctanh of the natural
parameter.

{phang}
{cmd:invlogit} specifies that {cmd:invlogit}(estimated parameter{cmd:)} is to
be displayed; that is, the estimated parameter was the logit of the natural
parameter.  Note that this option has {cmd:ilogit} as a synonym.

{phang}
{cmd:function(}{it:expr(@)}{cmd:)} specifies that expr(estimated
parameter) is to be displayed.  It is not optional when the parameter is a
function of more than one estimated parameter (second syntax).  See
{it:{help _diparm##remarks:Remarks}} below.

{phang}
{cmd:derivative(}{it:expr(@)}{cmd:)} specifies the derivative of the
function specified in {cmd:function()}.  This must be specified when
{cmd:function()} is specified.  It is not optional when the parameter is a
function of more than one estimated parameter (second syntax).  For functions
of more than one estimated parameter, {cmd:derivative()} must contain the
derivative w.r.t. each parameter; each derivative must be separated with a
space; no spaces are allowed within each derivative expression.  (For
functions of one parameter, spaces are allowed within the expression.)
See {it:{help _diparm##remarks:Remarks}} below.

{phang}
{cmd:ci(logit} | {cmd:probit} | {cmd:atanh} | {cmd:log)} specifies an
optional transformation so that the endpoints of the CI are bounded.  It is
ONLY allowed for functions of more than one estimated parameter.  See
"Description" above.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

            {help _diparm##remarks1:Specifying a function of one estimated parameter}
            {help _diparm##remarks2:Specifying a function of more than one estimated parameter}


{marker remarks1}{...}
{title:Specifying a function of one estimated parameter}

{pstd}
Let x be the estimated parameter.  Suppose that we wish to display
y = f(x).  The function {it:f(.)} is specified in the {cmd:function()} option
as {it:f(}{cmd:@}{it:)}.  That is, the option is specified as
{cmd:function(}{it:f(}{cmd:@}{it:)}{cmd:)}.

{pstd}
For example, suppose that x = lnsigma. We wish to display
sigma = exp(lnsigma).  The option is specified as {cmd:function(exp(@))}.
(Note that here we need not resort to the {cmd:function()} option; we
can merely use the {cmd:exp} option.)

{pstd}
Note that the function specified in {cmd:function()} is typically the
inverse of the transform used to create the estimated parameter, but it can be
any function.

{pstd}
Suppose that we wish to display 1/sigma = 1/exp(lnsigma).  The option is
specified as {cmd:function(1/exp(@))} or {cmd:function(exp(-@))}.

{pstd}
When specifying {cmd:function()}, the {cmd:derivative()} option must also be
specified.  It is the derivative f'(.) of the function f(.).

{pstd}
For example, if using {cmd:function(exp(-@))}, then you specify
{cmd:derivative(-exp(-@))}.

{pstd}
Note that multiple {cmd:@} are allowed.


{marker remarks2}{...}
{title:Specifying a function of more than one estimated parameter}

{pstd}
The same logic applies here.  The only difference is that the function must
be written as an expression using {cmd:@1}, {cmd:@2}, ... (a maximum of 9
parameters are allowed).  {cmd:@1} is substituted for the first parameter in
the argument list, {cmd:@2} for the second, etc.

{pstd}
{cmd:function()} supplies one expression, but note that
{cmd:derivative()} must supply the derivatives w.r.t. each parameter.  Hence,
{cmd:derivative()} contains multiple expressions; the first is the derivative
w.r.t. the first parameter in the argument list; the second is the derivative
w.r.t. the second parameter, etc.  These expressions must be separated by a
space.  No spaces are allowed within the expression.  (Note: Spaces are always
allowed in {cmd:function()}, and allowed in {cmd:derivative()} when there is
only one parameter.)


{marker examples}{...}
{title:Examples}

{pstd}
Here is how {cmd:_diparm} could be used in {cmd:weibull}.  It displays

{phang}(1) ln(p), the parameter in the estimation metric,

{phang}(2) p = exp(ln(p)), the natural parameter,

{phang}(3) 1/p = exp(-ln(p)).

	{cmd:program define weibull}
		{it:...}
		{it:[do estimation]}
		{it:...}

		{cmd:ml mlout, `eform' level(`level') first}

		{cmd:_diparm ln_p, level(`level')}
		{cmd:_diparm __sep__"}

		{cmd:_diparm ln_p, level(`level') exp label("p")}
		{cmd:_diparm ln_p, level(`level') f(exp(-@)) d(exp(-@)) label("1/p")}
		{cmd:_diparm __bot__}
	{cmd:end}

{pstd}
Note that in the last call of {cmd:_diparm}, {cmd:d(exp(-@))} is acceptable,
as is {cmd:d(-exp(-@))}, because {cmd:_diparm} only uses the absolute value of
the derivative.


{pstd}
Here is how {cmd:_diparm} could be used in {helpb heckman} to display
rho, sigma, and lambda:

{phang}{cmd:_diparm athrho, level(`level')}{p_end}
{phang}{cmd:_diparm lnsigma, level(`level')}

{phang}{cmd:_diparm __sep__}

{phang}{cmd:_diparm athrho, level(`level') tanh label("rho")}{p_end}
{phang}{cmd:_diparm lnsigma, level(`level') exp label("sigma")}

{phang}{cmd:_diparm athrho lnsigma, /*}{p_end}
{phang}{cmd:*/ func(exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) )/*}{p_end}
{phang}{cmd:*/ der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2) /*}{p_end}
{phang}{cmd:*/ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) label(lambda)}

{pstd}
Here is how {cmd:_diparm} could be used in {helpb xtreg:xtreg, mle} to
display rho using a probit transform to ensure that the endpoints lie between
0 and 1:

{phang}{cmd:_diparm sigma_u sigma_e, label(rho) func(@1^2/(@1^2+@2^2)) /*}{p_end}
{phang}{cmd:*/ der( 2*@1*(@2/(@1^2+@2^2))^2 -2*@2*(@1/(@1^2+@2^2))^2 ) ci(probit)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_diparm} stores the following in {hi:r()}:

{p 8 19 2}{hi:r(est)}{space 2}={space 2}parameter in the metric displayed{p_end}
{p 8 19 2}{hi:r(se)}{space 3}={space 2}standard error of the parameter in the
	metric displayed{p_end}
{p 8 19 2}{hi:r(lb)}{space 3}={space 2}lower bound of confidence interval{p_end}
{p 8 19 2}{hi:r(ub)}{space 3}={space 2}upper bound of confidence interval{p_end}
{p 8 19 2}{hi:r(p)}{space 4}={space 2}p-value for significance test if displayed
{p_end}
