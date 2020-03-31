{smcl}
{* *! version 1.6.5  11dec2018}{...}
{viewerdialog nl "dialog nl"}{...}
{viewerdialog "svy: nl" "dialog nl, message(-svy-) name(svy_nl)"}{...}
{vieweralsosee "[R] nl" "mansection R nl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nl postestimation" "help nl postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{vieweralsosee "[R] mlexp" "help mlexp"}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{vieweralsosee "[R] nlsur" "help nlsur"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "nl##syntax"}{...}
{viewerjumpto "Menu" "nl##menu"}{...}
{viewerjumpto "Description" "nl##description"}{...}
{viewerjumpto "Links to PDF documentation" "nl##linkspdf"}{...}
{viewerjumpto "Options" "nl##options"}{...}
{viewerjumpto "Remarks" "nl##remarks"}{...}
{viewerjumpto "Example" "nl##example"}{...}
{viewerjumpto "Stored results" "nl##results"}{...}
{viewerjumpto "References" "nl##references"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] nl} {hline 2}}Nonlinear least-squares estimation{p_end}
{p2col:}({mansection R nl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Interactive version
    
{p 8 11 2}
{opt nl} {cmd:(}{depvar}{cmd:=}<{it:sexp}>{cmd:)} {ifin}
[{it:{help nl##weight:weight}}]
   [{cmd:,} {it:{help nl##options_table:options}}]
   

{phang}
Programmed substitutable expression version
    
{p 8 23 2}
{cmd:nl }{it:sexp_prog} {cmd::} {depvar} [{varlist}] {ifin}
[{it:{help nl##weight:weight}}]
    [{cmd:,} {it:{help nl##options_table:options}}]


{phang}
Function evaluator program version
    
{p 8 23 2}
{cmd:nl} {it:func_prog} {cmd:@} {depvar} [{varlist}] {ifin} 
[{it:{help nl##weight:weight}}]{cmd:,}
   {c -(}{opt param:eters(namelist)}{c |}{opt nparam:eters(#)}{c )-} 
   [{it:{help nl##options_table:options}}]
   

{phang}
where

{phang2}
{it:depvar} is the dependent variable;{p_end}
{phang2}
{it:<sexp>} is a substitutable expression;{p_end}
{phang2}
{it:sexp_prog} is a substitutable expression program; and{p_end}
{phang2}
{it:func_prog} is a function evaluator program.

{synoptset 27 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opth va:riables(varlist)}}variables in model{p_end}
{synopt :{opth in:itial(nl##initial_values:initial_values)}}initial values for parameters{p_end}
{p2coldent :* {opt param:eters(namelist)}}parameters in model (function evaluator program version only){p_end}
{p2coldent :* {opt nparam:eters(#)}}number of parameters in model (function evaluator program version only){p_end}
{synopt :{it:sexp_options}}options for substitutable expression program{p_end}
{synopt :{it:func_options}}options for function evaluator program{p_end}

{syntab :Model 2}
{synopt :{opt ln:lsq(#)}}use log least-squares where ln({it:depvar - #}) is assumed to be normally distributed{p_end}
{synopt :{opt nocons:tant}}the model has no constant term; seldom used{p_end}
{synopt :{opt h:asconstant(name)}}use {it:name} as constant term; seldom used{p_end}

{syntab :SE/Robust}
{synopt :{cmd:vce(}{it:{help nl##vcetype:vcetype}}{cmd:)}}{it:vcetype}
    may be {opt gnr}, {opt r:obust}, {opt cl:uster} {it:clustvar},
    {opt boot:strap}, {opt jack:knife}, {opt hac} {help nl##kernel:{it:kernel}}, {opt hc2}, or
    {opt hc3} {p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt lea:ve}}create variables containing derivative of {it:E}(y){p_end}
{synopt :{opth title:(strings:string)}}display {it:string} as title above the table of parameter estimates{p_end}
{synopt :{opth title2:(strings:string)}}display {it:string} as subtitle{p_end}
{synopt :{it:{help nl##display_options:display_options}}}control column
         formats and line width{p_end}

{syntab :Optimization}
{synopt :{it:{help nl##optimization_options:optimization_options}}}control the
optimization process; seldom used{p_end}
{synopt :{opt eps(#)}}specify {it:#} for convergence criterion; default is
{cmd:eps(1e-5)}{p_end}
{synopt :{opt del:ta(#)}}specify {it:#} for computing derivatives; default is
{cmd:delta(4e-7)}{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}* For function evaluator program version, you must specify {opt parameters(namelist)} or {opt nparameters(#)}, or both.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, 
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt vce()}, {opt leave}, and weights are not allowed with the {helpb svy}
prefix.  {p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s, {cmd:fweight}s, and {cmd:iweight}s are allowed; see  
{help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp nl_postestimation R:nl postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Nonlinear least-squares estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nl} fits an arbitrary nonlinear regression function by least squares.
With the interactive version of the command, you enter the function directly
on the command line or in the dialog box by using a
{help nl##subexp:substitutable expression}.
If you have a function that you use regularly, you can write a
{help nl##subexppr:substitutable expression program}
and use the second syntax to avoid having to reenter the function every time.
The function evaluator program version gives you the most flexibility in
exchange for increased complexity; with this version, your program is given a
vector of parameters and a variable list, and your program computes the
regression function.

{pstd}
When you write a substitutable expression program or function evaluator 
program, the first two letters of the name must be {cmd:nl}.  {it:sexp_prog}
and {it:func_prog} refer to the name of the program without the first two
letters.  For example, if you wrote a function evaluator program named
{cmd:nlregss}, you would type {cmd:nl regss @ ...} to estimate the parameters.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nlQuickstart:Quick start}

        {mansection R nlRemarksandexamples:Remarks and examples}

        {mansection R nlMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth variables(varlist)} specifies the variables in the model.  {opt nl}
ignores observations for which any of these variables have missing values.  If
you do not specify {opt variables()}, then {cmd:nl} issues an error message with
return code 480 if the estimation sample contains any missing
values.

{marker initial_values}
{phang}
{opt initial(initial_values)} specifies the initial values to begin the
estimation.  You can specify a 1 x k matrix, where k is the number of
parameters in the model, or you can specify a parameter name, its initial
value, another parameter name, its initial value, and so on.  For example, to
initialize {opt alpha} to 1.23 and {opt delta} to 4.57, you would type

{pmore2}
{cmd:nl ... , initial(alpha 1.23 delta 4.57)...}

{pmore}
Initial values declared using this option override any that are declared within
substitutable expressions.  If you specify a parameter that does not appear in
your model, {cmd:nl} exits with error code 480.  If you specify a matrix, the
values must be in the same order that the parameters are declared in your
model.  {cmd:nl} ignores the row and column names of the matrix.

{phang}
{opt parameters(namelist)} specifies the names of the parameters in the model.
The names of the parameters must adhere to the naming conventions of Stata's
variables; see {findalias frnames}.  If you specify both 
{opt parameters()} and {opt nparameters()}, the number of names in the former must
match the number specified in the latter; if not, {cmd:nl} issues an error
message with return code 198.

{phang}
{opt nparameters(#)} specifies the number of parameters in the model.  If you do
not specify names with the {opt parameters()} option, {cmd:nl} names them 
{cmd:b1}, {cmd:b2}, ..., {cmd:b}{it:#}.  If you specify both {opt parameters()} and 
{opt nparameters()}, the number of names in the former must match the number
specified in the latter; if not, {cmd:nl} issues an error message with return
code 198.

{phang}
{it:sexp_options} refer to any options allowed by your 
{help nl##subexppr:{it:sexp_prog}}.

{phang}
{it:func_options} refer to any options allowed by your
{help nl##func_progs:{it:func_prog}}.

{dlgtab:Model 2}

{phang}
{opt lnlsq(#)} fits the model by using log least-squares, which we define as
least squares with shifted lognormal errors. In other words,
ln({depvar}-{it:#}) is assumed to be normally distributed.  Sums of squares
and deviance are adjusted to the same scale as {it:depvar}.

{phang}
{opt noconstant} indicates that the function does not include a constant term.
This option is generally not needed, even if there is no constant term in the
model, unless the coefficient of variation (over observations) of the partial
derivative of the function with respect to a parameter is less than 
{opt eps()} and that parameter is not a constant term.

{phang}
{opt hasconstant(name)} indicates that parameter {it:name} be treated as
the constant term in the model and that {opt nl} should not use its algorithm
to find a constant term.  As with {opt noconstant}, this option is seldom used.

{marker vcetype}{...}
{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:gnr}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(gnr)}, the default, uses the conventionally derived variance
estimator for nonlinear models fit using Gauss-Newton regression.

{pmore}
{opt nl} also allows the following:

{marker kernel}{...}
{phang2}
{cmd:vce(hac} {it:kernel} [{it:#}]{cmd:)} specifies that a
heteroskedasticity- and autocorrelation-consistent (HAC) variance estimate be
used.  HAC refers to the general form for combining weighted matrices
to form the variance estimate.  There are three kernels available for 
{cmd:nl}:

{center:{opt nw:est} | {opt ga:llant} | {opt an:derson}}

{pmore2}
{it:#} specifies the number of lags.  If {it:#} is not specified, N - 2 is
assumed.

{pmore2}
{cmd:vce(hac} {it:kernel} [{it:#}]{cmd:)} is not allowed if weights are specified.

{phang2}
{cmd:vce(hc2)} and {cmd:vce(hc3)} specify alternative bias corrections for the 
robust variance calculation.
{cmd:vce(hc2)} and {cmd:vce(hc3)} may not be specified with
the {cmd:svy} prefix.  By
default, {cmd:vce(robust)} uses sigma_j^2 = {c -(}n/(n-k){c )-}
u_j^2 as an estimate of the variance of the jth observation, where u_j is the
calculated residual and n/(n-k) is included to improve the overall estimate's
small-sample properties.

{pmore2}{cmd:vce(hc2)} instead uses u_j^2/(1-h_jj) as the observation's variance
estimate, where h_jj is the jth diagonal element of the hat (projection)
matrix.  This produces an unbiased estimate of the covariance matrix if the
model is homoskedastic.  {cmd:vce(hc2)} tends to produce slightly more
conservative confidence intervals than {cmd:vce(robust)}.

{pmore2}{cmd:vce(hc3)} uses u_j^2/(1-h_jj)^2 as suggested by Davidson and
MacKinnon ({help nl##DM1993:1993} and {help nl##DM2004:2004}),
who report that this often produces better results
when the model is heteroskedastic.  {cmd:vce(hc3)} produces confidence
intervals that tend to be even more conservative.

{pmore2}See, in particular, 
{help nl##DM2004:Davidson and MacKinnon (2004, 239)}, who advocate
the use of {cmd:vce(hc2)} or {cmd:vce(hc3)} instead of the plain robust
estimator for nonlinear least squares.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt leave} leaves behind after estimation a set of new variables with
the same names as the estimated parameters containing the derivatives of
{it:E}(y) with respect to the parameters.  If the dataset contains an existing
variable with the same name as a parameter, then using {opt leave} causes
{cmd:nl} to issue an error message with return code 110.

{pmore}
{opt leave} may not be specified with {cmd:vce(cluster} {it:clustvar}{cmd:)}
or the {cmd:svy} prefix.

{phang}
{opth title:(strings:string)} specifies an optional title that will be
displayed just above the table of parameter estimates.

{phang}
{opth title2:(strings:string)} specifies an optional subtitle that will be
displayed between the title specified in {opt title()} and the table of
parameter estimates.  If {opt title2()} is specified but {opt title()} is not,
{opt title2()} has the same effect as {opt title()}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{marker optimization_options}{...}
{dlgtab:Optimization}

{phang}
{it:optimization_options}: {opt iter:ate(#)}, [{cmd:no}]{cmd:log}, 
{opt tr:ace}.  {opt iterate(#)} specifies the maximum number of iterations,
{opt log}/{opt nolog} specifies whether to show the iteration log
(see {cmd:set iterlog} in {manhelpi set_iter R:set iter}), and
{opt trace} specifies that the iteration log should include the current
parameter vector.  These options are seldom used.

{phang}
{opt eps(#)} specifies the convergence criterion for successive parameter
estimates and for the residual sum of squares.  The default is {cmd:eps(1e-5)}.

{phang}
{opt delta(#)} specifies the relative change in a parameter to be used in
computing the numeric derivatives.  The derivative for parameter b_i is
computed as {c -(}f(X,b_1,b_2,...,b_i + d, b_[i+1],...) -
f(X, b_1,b_2,...,b_i,b_[i+1],...){c )-}/d,
where d is delta(b_i + delta).  The default is {cmd:delta(4e-7)}.

{pstd}
The following option is available with {cmd:nl} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help nl##subexp:Substitutable expressions}
            {help nl##examples_sexp:Examples}
        {help nl##models:Some commonly used models}
        {help nl##subexppr:Substitutable expression programs}
            {help nl##example_sexp_progs:Example}
        {help nl##func_progs:Function evaluator programs}
            {help nl##example_func_progs:Example} 


{marker subexp}{...}
{title:Substitutable expressions}

{pstd}
Using a substitutable expression is the easiest way to define your 
nonlinear function.  Substitutable expressions are just like any other
mathematical expression in Stata, except that the parameters of your 
model are bound in braces.  There are three rules to follow:

{phang2}
1.  Parameters of the model are bound in braces: {cmd:{c -(}b0{c )-}},
{cmd:{c -(}param{c )-}}, etc.

{phang2}
2.  Initial values for parameters are given by including an equal sign and the
initial value inside the braces:  {cmd:{c -(}b1=1.267{c )-}},
{cmd: {c -(}gamma=3{c )-}}, etc.  If you do not specify an initial value, that
parameter is initialized to zero.  The {cmd:initial()} option overrides
initial values provided in substitutable expressions.

{phang2}
3.  Linear combinations can be included using the notation 
{cmd:{c -(}}{it:eqname}{cmd::}{it:varlist}{cmd:{c )-}}:

{pmore3}
{cmd:{c -(}xb:mpg price weight{c )-}} is equivalent to{p_end}
{pmore3}
{cmd:{c -(}xb_mpg{c )-}*mpg + }
{cmd:{c -(}xb_price{c )-}*price + }
{cmd:{c -(}xb_weight{c )-}*weight}


{marker examples_sexp}{...}
    {title:Examples}

{phang2}
1.  To fit the model

{pmore3}
y = alpha + beta*x^gamma

{pmore2}
where alpha, beta, and gamma are parameters and a starting value for 
gamma is one, you would type

{pmore3}
{cmd:. nl (y = {c -(}alpha{c )-} + {c -(}beta{c )-}*x^{c -(}gamma=1{c )-})}

{phang2}
2.  To regress y on a constant and the reciprocal of x you could do

{pmore3}
{cmd:. nl (y = {b0} + {b1} / x), initial(b0 2 b1 3)}

{pmore2}
which obviates the need to generate a new variable equal to 1/x 
before calling {cmd:regress}.  Here b0 is initialized to two and
b1 is initialized to three.


{marker models}{...}
{title:Some commonly used models}

{pstd} 
The following models are used so often that they are built into {cmd:nl}.

{pmore}Exponential regression with one asymptote:{p_end}

{phang3}{cmd:exp3} {space 3} y = b0 + b1*b2^x{p_end}
{phang3}{cmd:exp2} {space 3} y = {space 4} b1*b2^x{p_end}
{phang3}{cmd:exp2a} {space 2} y = {space 4} b1*(1-b2^x){p_end}

{pmore}Logistic function (symmetric sigmoid shape)(*):{p_end}

{p 12 24 2}{cmd:log4} {space 3} y = b0 + b1/(1 + exp(-b2*(x-b3))){p_end}
{p 12 24 2}{cmd:log3} {space 3} y = {space 4} b1/(1 + exp(-b2*(x-b3))){p_end}

{pmore}Gompertz function (asymmetric sigmoid shape):{p_end}

{p 12 24 2}{cmd:gom4} {space 3} y = b0 + b1*exp(-exp(-b2*(x-b3))){p_end}
{p 12 24 2}{cmd:gom3} {space 3} y = {space 4} b1*exp(-exp(-b2*(x-b3)))

{pmore}(*) not to be confused with logistic regression

{pstd}
To use any of these, you type

{pmore}
{cmd:. nl} {it:model} {cmd::} {it:depvar} {it:indepvar}

{pstd}
For example,

{pmore}
{cmd:. nl exp3: y x}{p_end}
{pmore}
{cmd:. nl gom3: response dosage}

{pstd}
Initial values are chosen automatically, though you can override the 
defaults by using the {cmd:initial()} option.


{marker subexppr}{...}
{title:Substitutable expression programs -- {it:sexp_prog}s}

{pstd}
If you use the same nonlinear function repeatedly, then you can write a 
substitutable expression program so that you do not have to retype the 
expression every time.  The first two letters of the program name must 
by {cmd:nl}.  The {cmd:nl}{it:sexp_prog} is to accept a {it:varlist}, an 
{cmd:if} {it:exp}, and, optionally, weights.  The program will then 
return a substitutable expression in the r-class macro {cmd:r(eq)} and, 
optionally, a title in {cmd:r(title)}.

{pstd}
The outline of an {cmd:nl}{it:sexp_prog} program is

{p 8 14 2}{cmd:program nl}{it:sexp_prog}{cmd:, rclass}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:syntax }{it:varlist} {cmd:[aw fw iw]} {cmd:if}{p_end}
{p 12 18 2}{it:(obtain initial parameters if desired)}{p_end}
{p 12 18 2}{cmd:return local eq "}{it:<sexp>}{cmd:"}{p_end}
{p 12 18 2}{cmd:return local title "}{it:title}{cmd:"}{p_end}
{p 8 14 2}{cmd:end}


{marker example_sexp_progs}{...}
    {title:Example}

{pmore}
Returning to the model

{pmore2}
y = alpha + beta*x^gamma

{pmore}
one way to obtain initial values is to let gamma = 1 and then run a 
regression of x on y to obtain alpha and beta.  The substitutable 
expression program is

{p 12 18 2}{cmd:program nlmyreg, rclass}{p_end}
{p 16 22 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 22 2}{cmd:syntax varlist(min=2 max=2) [aw fw iw] if}{p_end}
{p 16 22 2}{cmd:local lhs: word 1 of `varlist'}{p_end}
{p 16 22 2}{cmd:local rhs: word 2 of `varlist'}{p_end}
{p 16 22 2}{cmd:regress `lhs' `rhs' [`weight'`exp'] `if'}{p_end}
{p 16 22 2}{cmd:tempname a b}{p_end}
{p 16 22 2}{cmd:scalar `a' = _b[_cons]}{p_end}
{p 16 22 2}{cmd:scalar `b' = _b[`rhs']}{p_end}
{p 16 22 2}{cmd:return local eq "`lhs' = {alpha=`=`a''}+{beta=`=`b''}*`rhs'^{gamma=1}"}{p_end}
{p 16 22 2}{cmd:return local title "`lhs' = alpha+beta*`rhs'^gamma"}{p_end}
{p 12 18 2}{cmd:end}{p_end}

{pmore}
To fit your model, you type

{p 12 18 2}{cmd:. nl myreg: y x}

{pmore}
(There is a space between {cmd:nl} and {cmd:myreg}, even though the 
program is named {cmd:nlmyreg}.)

{pstd}
The substitutable expression does not need to account for 
weights or the {cmd:if} {it:exp}, though you do need to use them in 
obtaining initial values.  Also, the substitutable expression is 
not bound in parentheses, unlike when typing it in interactively.


{marker func_progs}{...}
{title:Function evaluator programs -- {it:func_prog}s}

{pstd}
If your function is particularly complex, then you may find that writing 
one substitutable expression is impractical.  In those cases, you 
can write a function evaluator program instead.  Whenever {cmd:nl} needs 
to evaluate your function, it calls your program with a vector of 
parameters.  Your program then fills in the dependent variable with 
function values.

{pstd}
Function evaluator programs must accept a {it:varlist}, an {cmd:if} 
{it:exp}, and an option named {cmd:at()} that accepts the name of a 
matrix.  It may optionally accept weights as well.  Unlike substitutable
expression programs, a function evaluator program is not declared to be
r-class.  The outline of a {cmd:nl}{it:func_prog} program is

{p 8 14 2}{cmd:program nl}{it:func_prog}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:syntax} {it:varlist} {cmd:[aw fw iw] if, at(name)}{p_end}
{p 12 18 2}{cmd:local lhs: word 1 of `varlist'}{p_end}
{p 12 18 2}{cmd:local rhs: subinstr local varlist "`lhs'" "", word}{p_end}
{p 12 18 2}{it:(evaluate the function at matrix)}{p_end}
{p 12 18 2}{cmd:replace `lhs' = }{it: <the function values>} {cmd:`if'}{p_end}
{p 8 14 2}{cmd:end}

{pstd}
When evaluating your function, remember to restrict the estimation 
sample by using {cmd:`if'}.  Also, remember to include the weights if 
using commands such as {cmd:summarize} or {cmd:regress} if you intend 
to do weighted estimation.


{marker example_func_progs}{...}
    {title:Example}

{pmore}
The CES production function can be written

{pmore2}
ln Q = b0 - 1/rho*ln{delta*K^-rho + (1-delta)*L^-rho}

{pmore}
where Q denotes output and b0, rho, and delta are parameters to be 
estimated.  The function evaluator program is

{p 12 18 2}{cmd:program nlces}{p_end}
{p 16 22 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 22 2}{cmd:syntax varlist(min=3 max=3) [aw fw iw] if, at(name)}{p_end}
{p 16 22 2}{cmd:local logout: word 1 of `varlist'}{p_end}
{p 16 22 2}{cmd:local capital: word 2 of `varlist'}{p_end}
{p 16 22 2}{cmd:local labor: word 3 of `varlist'}{p_end}
{p 16 22 2}{cmd:// Retrieve parameters out of at matrix}{p_end}
{p 16 22 2}{cmd:tempname b0 rho delta}{p_end}
{p 16 22 2}{cmd:scalar `b0' = `at'[1,1]}{p_end}
{p 16 22 2}{cmd:scalar `rho' = `at'[1,2]}{p_end}
{p 16 22 2}{cmd:scalar `delta' = `at'[1,3]}{p_end}
{p 16 22 2}{cmd:// Some temporary variables}{p_end}
{p 16 22 2}{cmd:tempvar kterm lterm}{p_end}
{p 16 22 2}{cmd:generate double `kterm' = `delta'*`capital'^(-1*`rho') `if'}{p_end}
{p 16 22 2}{cmd:generate double `lterm' = (1-`delta')*`labor'^(-1*`rho') `if'}{p_end}
{p 16 22 2}{cmd:// Now fill in dependent variable}{p_end}
{p 16 22 2}{cmd:replace `logout' = `b0' - 1/`rho'*ln(`kterm'+`lterm') `if'}{p_end}
{p 12 18 2}{cmd:end}

{pmore}
If your variables are {cmd:logout}, {cmd:capital}, and {cmd:labor},
then any of the following methods can be used to estimate the parameters:

{phang3}
1.  This method uses b0 = 0 as an initial value by default:

{p 16 22 2}
{cmd:. nl ces @ logout capital labor, parameters(b0 rho delta) initial(rho 1 delta 0.5)}

{phang3}
2.  This method initializes b0 to 2, rho to 1, and delta to 0.5.  Because we
   do not give parameter names, nl names them b1, b2, and b3:

{p 16 22 2}
{cmd: . nl ces @ logout capital labor, nparameters(3) initial(b1 2 b2 1 b3 0.5)} 

{phang3}
3.  This method sets up a vector holding the initial values:

{p 16 22 2}
{cmd: . matrix ivals = (2, 1, 0.5)}{p_end}
{p 16 22 2}
{cmd: . nl ces @ logout capital labor, parameters(b0 rho delta) initial(ivals)}

{p 16 22 2}
or

{p 16 22 2}
{cmd: . nl ces @ logout capital labor, nparameters(3) initial(ivals)}


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse production}

{pstd}Fit CES production function with initial values {cmd:rho}=1 and
{cmd:delta}=.5{p_end}
{phang2}{cmd: . nl (lnoutput = {b0} - 1/{rho=1}*ln({delta=0.5}*capital^(-1*{rho}) + (1-{delta})*labor^(-1*{rho})))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:nl} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test; always
{cmd:0}{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(df_t)}}total degrees of freedom{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(tss)}}total sum of squares{p_end}
{synopt:{cmd:e(mms)}}model mean square{p_end}
{synopt:{cmd:e(msr)}}residual mean square{p_end}
{synopt:{cmd:e(ll)}}log likelihood assuming i.i.d. normal errors{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(dev)}}residual deviance{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(lnlsq)}}value of {cmd:lnlsq} if specified{p_end}
{synopt:{cmd:e(log_t)}}{cmd:1} if {cmd:lnlsq} specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(gm_2)}}square of geometric mean of (y-k) if {cmd:lnlsq},
{cmd:1} otherwise{p_end}
{synopt:{cmd:e(cj)}}position of constant in {cmd:e(b)} or {cmd:0} if no constant{p_end}
{synopt:{cmd:e(delta)}}relative change used to compute derivatives{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:nl}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title_2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(hac_kernel)}}HAC kernel{p_end}
{synopt:{cmd:e(hac_lag)}}HAC lag{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(type)}}{cmd:1} = interactively entered expression{p_end}
{synopt:}{cmd:2} = substitutable expression program{p_end}
{synopt:}{cmd:3} = function evaluator program{p_end}
{synopt:{cmd:e(sexp)}}substitutable expression{p_end}
{synopt:{cmd:e(params)}}names of parameters{p_end}
{synopt:{cmd:e(funcprog)}}function evaluator program{p_end}
{synopt:{cmd:e(rhs)}}contents of {cmd:variables()}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(init)}}initial values vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{marker references}{...}
{title:References}

{marker DM1993}{...}
{phang}
Davidson, R., and J. G. MacKinnon. 1993.
{browse "http://www.stata.com/bookstore/eie.html":{it:Estimation and Inference in Econometrics}.}
New York: Oxford University Press.

{marker DM2004}{...}
{phang}
------. 2004.
{browse "http://www.stata.com/bookstore/etm.html":{it:Econometric Theory and Methods}.}
New York: Oxford University Press.
{p_end}
