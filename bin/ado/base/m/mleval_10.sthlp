{smcl}
{* *! version 1.0.4  18jan2010}{...}
{cmd:help mleval_10}, {cmd:help mlsum_10}, {cmd:help mlvecsum_10}, {cmd:help mlmatsum_10}, {cmd:help mlmatbysum_10}{right:{help prdocumented:previously documented}}
{hline}

{title:Title}

{p2colset 4 14 16 2}{...}
{p2col:{hi:[R] ml} {hline 2}}Programs for use by ml method d0, d1, and d2
log-likelihood evaluators{p_end}
{p2colreset}{...}

{p 12 12 8}
{it}[{bf:ml} syntax was changed as of version 11.
This help file documents {cmd:ml}'s old syntax and as such is 
probably of no interest to you.  You do not have to translate calls to
{cmd:ml} in old do-files to modern syntax because Stata continues
to understand both old and new syntaxes.   This help file is 
provided for those wishing to debug or understand old code.
Click {help ml:here} for the help file of the modern 
{cmd:ml} command.]{rm}


{title:Syntax for subroutines for use by method d0, d1, and d2 evaluators}

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


{title:Description}

{pstd}
These commands assist in coding the likelihood-evaluation program when using
{help ml_10} methods d0, d1, and d2.  They are of no assistance
when coding a method lf evaluator.

{pstd}
{opt mleval} is a subroutine used by method d0, d1, and
d2 evaluators to evaluate the coefficient vector that they are passed.

{pstd}
{opt mlsum} is a subroutine used by method d0, d1, and d2 evaluators to define
the value ln L that is to be returned.

{pstd}
{opt mlvecsum} is a subroutine used by method d1 and d2
evaluators to define the gradient vector g that is to be returned.  It is
suitable for use only when the likelihood function meets the linear-form
restrictions.

{pstd}
{opt mlmatsum} is a subroutine for use by method d2 evaluators to
define the negative Hessian matrix, -H, that is to be returned.  It is
suitable for use only when the likelihood function meets the linear-form
restrictions.

{pstd}
{opt mlmatbysum} is a subroutine for use by method d2 evaluators to help
define the negative Hessian matrix, -H, that is to be returned.  It is suitable
for use when the likelihood function contains terms made up of grouped sums,
such as in panel-data models.  For such models, use {opt mlmatsum} to compute
the observation-level outer products and {opt mlmatbysum} to compute the
group-level outer products.  {opt mlmatbysum} requires that the data be sorted
by the variable identified in the {opt by()} option.


{title:Options for use with mleval}

{phang}
{opt eq(#)} specifies the equation number {it:i} for which {it:theta_ij} =
{it:x_ij} * {it:b_i} is to be evaluated.  {cmd:eq(1)} is assumed if {opt eq()}
is not specified.

{phang}
{opt scalar} asserts that the {it:i}th equation is
known to evaluate to a constant, meaning that the equation was specified as {opt ()},
{opt (name:)}, or {cmd:/}{it:name} on the {opt ml model} statement.
If you specify this option, the new variable created is created as a scalar.
If the {it:i}th equation does not evaluate to a scalar, an error message is issued.


{title:Option for use with mlsum}

{phang}
{opt noweight} specifies that weights ({cmd:$ML_w}) be ignored when summing
the likelihood function.


{title:Option for use with mlvecsum}

{phang}
{opt eq(#)} specifies the equation for
which a gradient vector {it:d}ln{it:L}/{it:db_i} is to be constructed.  The
default is {cmd:eq(1)}.


{title:Option for use with mlmatsum}

{phang}
{cmd:eq(}{it:#}[{cmd:,}{it:#}]{cmd:)} specifies the equations for which
the negative Hessian matrix is to be constructed.  The default is
{cmd:eq(1)}, which is the same as {cmd:e(1,1)},
which means -{it:d}^2ln{it:L}/({it:db_}1 {it:db}_1').  Specifying
{cmd:eq(}{it:i}{cmd:,}{it:j}{cmd:)} results in -{it:d}^2ln{it:L}/({it:db_i}
{it:db_j}').


{title:Options for use with mlmatbysum}

{phang}
{opth by(varname)} is required and specifies the group variable.  {it:varname}
must be a numeric variable.

{phang}
{cmd:eq(}{it:#}[{cmd:,}{it:#}]{cmd:)} specifies the equations for which
the negative Hessian matrix is to be constructed.  The default is
{cmd:eq(1)}, which is the same as {cmd:e(1,1)},
which means -{it:d}^2ln{it:L}/({it:db_}1 {it:db}_1').  Specifying
{cmd:eq(}{it:i}{cmd:,}{it:j}{cmd:)} results in -{it:d}^2ln{it:L}/({it:db_i}
{it:db_j}').


{title:Examples}

{pstd}
See {help mlmethod_10} for outlines of log-likelihood evaluators that use
the {opt mleval}, {opt mlsum}, {opt mlvecsum}, and {opt mlmatsum} commands.
{bf:[R] ml} contains more examples.  Further examples can be found in
    {it:{browse "http://www.stata.com/bookstore/mle.html":Maximum Likelihood Estimation with Stata, 3rd Edition}}
(Gould, Pitblado, and Sribney 2006) {c -} available from StataCorp.


{title:Also see}

{psee}
Manual:  {bf:[R] ml}

{psee}
Online:  {manhelp ml R}, {help mlmethod_10}
{p_end}
