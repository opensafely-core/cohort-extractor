{smcl}
{* *! version 1.3.7  16apr2018}{...}
{vieweralsosee "[R] ml" "mansection R ml"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "mlmethod" "help mlmethod"}{...}
{viewerjumpto "Syntax for subroutines for use by ml log-likelihood evaluators" "mleval##syntax"}{...}
{viewerjumpto "Description" "mleval##description"}{...}
{viewerjumpto "Links to PDF documentation" "mleval##linkspdf"}{...}
{viewerjumpto "Options for use with mleval" "mleval##options_mleval"}{...}
{viewerjumpto "Option for use with mlsum" "mleval##option_mlsum"}{...}
{viewerjumpto "Option for use with mlvecsum" "mleval##option_mlvecsum"}{...}
{viewerjumpto "Option for use with mlmatsum" "mleval##option_mlmatsum"}{...}
{viewerjumpto "Options for use with mlmatbysum" "mleval##options_mlmatbysum"}{...}
{viewerjumpto "Examples" "mleval##examples"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] ml} {hline 2}}Programs
for use by ml method d0, d1, d2, lf0, lf1, lf2,
and gf0 log-likelihood evaluators{p_end}
{p2col:}({mansection R ml:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax for subroutines for use by ml log-likelihood evaluators}

{p 8 19 2}
{cmd:mleval}{space 4}
{newvar} {cmd:=} {it:vecname} [{cmd:,}
{opt eq(#)}]

{p 8 19 2}
{cmd:mleval}{space 4} {it:scalarname} {cmd:=} {it:vecname}
{cmd:,} {opt scalar} [{opt eq(#)}]

{p 8 19 2}
{cmd:mlsum}{space 5} {it:scalarname_lnf} {cmd:=} {it:exp}
[{it:{help if}}] [{cmd:,} {opt nowei:ght}]

{p 8 19 2}
{cmd:mlvecsum}{space 3}{it:scalarname_lnf} {it:rowvecname} {cmd:=} {it:exp}
[{it:{help if}}] [{cmd:,} {opt eq(#)}]

{p 8 19 2}{cmd:mlmatsum}{space 3}{it:scalarname_lnf} {it:matrixname} {cmd:=} {it:exp}
[{it:{help if}}] [{cmd:,} {cmd:eq(}{it:#}[{cmd:,}{it:#}]{cmd:)}]

{p 8 19 2}{cmd:mlmatbysum}
	{it:scalarname_lnf}
	{it:matrixname} 
	{it:varname_a} 
	{it:varname_b} 
	[{it:varname_c}]
	[{it:{help if}}] {cmd:,}
	{opth by(varname)}
	[{cmd:eq(}{it:#}[{cmd:,}{it:#}]{cmd:)}]


{marker description}{...}
{title:Description}

{pstd}
These commands assist in coding the likelihood-evaluation program when using
{helpb ml} methods d0, d1, d2, lf0, lf1, lf2, and gf0.  They are of no
assistance when coding a method lf evaluator.

{pstd}
{opt mleval} is a subroutine used by method d0, d1, d2, lf0, lf1, lf2, and gf0
evaluators to evaluate the coefficient vector that they are passed.

{pstd}
{opt mlsum} is a subroutine used by method d0, d1, and d2 evaluators to
define the value ln L that is to be returned.

{pstd}
{opt mlvecsum} is a subroutine used by method d1 and d2
evaluators to define the gradient vector g that is to be returned.  It is
suitable for use only when the likelihood function meets the linear-form
restrictions.

{pstd}
{opt mlmatsum} is a subroutine for use by method d2 and lf2 evaluators to
define the Hessian matrix, H, that is to be returned.  It is
suitable for use only when the likelihood function meets the linear-form
restrictions.

{pstd}
{opt mlmatbysum} is a subroutine for use by method d2 evaluator to help
define the Hessian matrix, H, that is to be returned.  It is suitable
for use when the likelihood function contains terms made up of grouped sums,
such as in panel-data models.  For such models, use {opt mlmatsum} to compute
the observation-level outer products and {opt mlmatbysum} to compute the
group-level outer products.  {opt mlmatbysum} requires that the data be sorted
by the variable identified in the {opt by()} option.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R mlRemarksandexamples:Remarks and examples}

        {mansection R mlMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_mleval}{...}
{title:Options for use with mleval}

{phang}
{opt eq(#)} specifies the equation number, {it:i}, for which {it:theta_ij} =
{it:x_ij} * {it:b_i} is to be evaluated.  {cmd:eq(1)} is assumed if {opt eq()}
is not specified.

{phang}
{opt scalar} asserts that the {it:i}th equation is
known to evaluate to a constant, meaning that the equation was specified as {opt ()},
{cmd:(}{it:name}{cmd::)}, or {cmd:/}{it:name} on the {opt ml model} statement.
If you specify this option, the new variable created is created as a scalar.
If the {it:i}th equation does not evaluate to a scalar, an error message is issued.


{marker option_mlsum}{...}
{title:Option for use with mlsum}

{phang}
{opt noweight} specifies that weights ({cmd:$ML_w}) be ignored when summing
the likelihood function.


{marker option_mlvecsum}{...}
{title:Option for use with mlvecsum}

{phang}
{opt eq(#)} specifies the equation for
which a gradient vector {it:d}ln{it:L}/{it:db_i} is to be constructed.  The
default is {cmd:eq(1)}.


{marker option_mlmatsum}{...}
{title:Option for use with mlmatsum}

{phang}
{cmd:eq(}{it:#}[{cmd:,}{it:#}]{cmd:)} specifies the equations for which
the Hessian matrix is to be constructed.  The default is
{cmd:eq(1)}, which is the same as {cmd:eq(1,1)},
which means {it:d}^2ln{it:L}/({it:db_}1 {it:db}_1').  Specifying
{cmd:eq(}{it:i}{cmd:,}{it:j}{cmd:)} results in {it:d}^2ln{it:L}/({it:db_i}
{it:db_j}').


{marker options_mlmatbysum}{...}
{title:Options for use with mlmatbysum}

{phang}
{opth by(varname)} is required and specifies the group variable.

{phang}
{cmd:eq(}{it:#}[{cmd:,}{it:#}]{cmd:)} specifies the equations for which
the Hessian matrix is to be constructed.  The default is
{cmd:eq(1)}, which is the same as {cmd:eq(1,1)},
which means {it:d}^2ln{it:L}/({it:db_}1 {it:db}_1').  Specifying
{cmd:eq(}{it:i}{cmd:,}{it:j}{cmd:)} results in {it:d}^2ln{it:L}/({it:db_i}
{it:db_j}').


{marker examples}{...}
{title:Examples}

{pstd}
See {help mlmethod} for outlines of log-likelihood evaluators that use
the {opt mleval}, {opt mlsum}, {opt mlvecsum}, and {opt mlmatsum} commands.
{bf:[R] ml} contains more examples.  Further examples can be found in
    {it:{browse "http://www.stata-press.com/books/ml4.html":Maximum Likelihood Estimation with Stata, 4th Edition}}
(Gould, Pitblado, and Poi 2010) {c -} available from StataCorp.
{p_end}
