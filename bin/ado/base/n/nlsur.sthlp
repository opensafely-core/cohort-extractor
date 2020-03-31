{smcl}
{* *! version 1.4.7  04feb2020}{...}
{viewerdialog nlsur "dialog nlsur"}{...}
{vieweralsosee "[R] nlsur" "mansection R nlsur"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nlsur postestimation" "help nlsur postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{vieweralsosee "[R] mlexp" "help mlexp"}{...}
{vieweralsosee "[R] nl" "help nl"}{...}
{vieweralsosee "[R] reg3" "help reg3"}{...}
{vieweralsosee "[R] sureg" "help sureg"}{...}
{viewerjumpto "Syntax" "nlsur##syntax"}{...}
{viewerjumpto "Menu" "nlsur##menu"}{...}
{viewerjumpto "Description" "nlsur##description"}{...}
{viewerjumpto "Links to PDF documentation" "nlsur##linkspdf"}{...}
{viewerjumpto "Options" "nlsur##options"}{...}
{viewerjumpto "Remarks" "nlsur##remarks"}{...}
{viewerjumpto "Example" "nlsur##example"}{...}
{viewerjumpto "Stored results" "nlsur##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] nlsur} {hline 2}}Estimation of nonlinear systems of equations{p_end}
{p2col:}({mansection R nlsur:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Interactive version
    
{p 8 11 2}
{opt nlsur} {cmd:(}{it:{help depvar:depvar_1}}{cmd:=}<{it:sexp_1}>{cmd:)} 
   {cmd:(}{it:{help depvar:depvar_2}}{cmd:=}<{it:sexp_2}>{cmd:)} 
   ...
   {ifin}
   [{it:{help nlsur##weight:weight}}]
   [{cmd:,} {it:{help nlsur##options_table:options}}]
   

{phang}
Programmed substitutable expression version
    
{p 8 23 2}
{cmd:nlsur} {it:sexp_prog} {cmd::} {it:{help depvar:depvar_1}} 
     {it:{help depvar:depvar_2}} ... [{varlist}] {ifin}
     [{it:{help nlsur##weight:weight}}]
     [{cmd:,} {it:{help nlsur##options_table:options}}]


{phang}
Function evaluator program version
    
{p 8 23 2}
{cmd:nlsur} {it:func_prog} {cmd:@} {it:{help depvar:depvar_1}}
           {it:{help depvar:depvar_2}} ...
   [{varlist}] {ifin} 
    [{it:{help nlsur##weight:weight}}] {cmd:,}
   {opt neq:uations(#)}
   {c -(}{opt param:eters(namelist)}{c |}{opt nparam:eters(#)}{c )-} 
   [{it:{help nlsur##options_table:options}}]
   

{phang}
where

{phang2}
{it:depvar_j} is the dependent variable for equation {it:j};{p_end}
{phang2}
{it:<sexp>_j} is the substitutable expression for equation {it:j};{p_end}
{phang2}
{it:sexp_prog} is a substitutable expression program; and{p_end}
{phang2}
{it:func_prog} is a function evaluator program.

{synoptset 27 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt fgnls}}use two-step FGNLS estimator; the default{p_end}
{synopt :{opt ifgnls}}use iterative FGNLS estimator{p_end}
{synopt :{opt nls}}use NLS estimator{p_end}
{synopt :{opth va:riables(varlist)}}variables in model{p_end}
{synopt :{opth in:itial(nlsur##initial_values:initial_values)}}initial values for parameters{p_end}
{p2coldent :* {opt neq:uations(#)}}number of equations in model (function evaluator program version only){p_end}
{p2coldent :* {opt param:eters(namelist)}}parameters in model (function evaluator program version only){p_end}
{p2coldent :* {opt nparam:eters(#)}}number of parameters in model (function evaluator program version only){p_end}
{synopt :{it:sexp_options}}options for substitutable expression program{p_end}
{synopt :{it:func_options}}options for function evaluator program{p_end}

{syntab :SE/Robust}
{synopt :{cmd:vce(}{it:{help nlsur##vcetype:vcetype}}{cmd:)}}{it:vcetype} may be {opt gnr}, {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opth title:(strings:string)}}display {it:string} as title above the table of parameter estimates{p_end}
{synopt :{opth title2:(strings:string)}}display {it:string} as subtitle{p_end}
{synopt :{it:{help nlsur##display_options:display_options}}}control columns
         and column formats and line width{p_end}

{syntab :Optimization}
{synopt :{it:{help nlsur##optimization_options:optimization_options}}}control the optimization process; seldom used{p_end}
{synopt :{opt eps(#)}}specify {it:#} for convergence criteria; default is {cmd:eps(1e-5)}{p_end}
{synopt :{opt ifgnlsi:terate(#)}}set maximum number of FGNLS iterations{p_end}
{synopt :{opt ifgnlseps(#)}}specify {it:#} for FGNLS convergence criterion; default is {cmd:ifgnlseps(1e-10)}{p_end}
{synopt :{opt del:ta(#)}}specify stepsize {it:#} for computing derivatives; default is {cmd:delta(4e-7)}{p_end}
{synopt :{opt nocons:tants}}no equations have constant terms{p_end}
{synopt :{opt h:asconstants(namelist)}}use {it:namelist} as constant terms{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}* You must specify {opt nequations(#)} and one of
{opt parameters(namelist)} or {opt nparameters(#)} or both.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, 
and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and 
{cmd:pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp nlsur_postestimation R:nlsur postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Multiple-equation models >}
     {bf:Nonlinear seemingly unrelated regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nlsur} fits a system of nonlinear equations by feasible generalized
nonlinear least squares (FGNLS).  With the interactive version of the command,
you enter the system of equations directly on the command line or in the dialog
box by using {help nlsur##subexp:substitutable expressions}.
If you have a system that you use regularly, you can write a
{help nlsur##subexppr:substitutable expression program}
and use the second syntax to avoid having to reenter the system every time.
The function evaluator program version gives you the most flexibility in
exchange for increased complexity; with this version, your program is given a
vector of parameters and a variable list, and your program computes the system
of equations.

{pstd}
When you write a substitutable expression program or a function evaluator
program, the first five letters of the name must be {cmd:nlsur}. 
{it:sexp_prog} and {it:func_prog} refer to the name of the program
without the first five letters.  For example, if you wrote a function
evaluator program named {cmd:nlsurregss}, you would type 
{cmd:nlsur regss @ ...} to estimate the parameters.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nlsurQuickstart:Quick start}

        {mansection R nlsurRemarksandexamples:Remarks and examples}

        {mansection R nlsurMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt fgnls} requests the two-step FGNLS estimator; this is the default.

{phang}
{opt ifgnls} requests the iterative FGNLS estimator. For the nonlinear systems
estimator, this is equivalent to maximum likelihood estimation.

{phang}
{opt nls} requests the nonlinear least-squares (NLS) estimator.

{phang}
{opth variables(varlist)} specifies the variables in the system.  
{opt nlsur} ignores observations for which any of these variables has
missing values.  If you do not specify {opt variables()}, {cmd:nlsur}
issues an error message if the estimation sample contains any missing values.

{marker initial_values}
{phang}
{opt initial(initial_values)} specifies the initial values to begin the
estimation.  You can specify a 1 x k matrix, where k is the total 
number of parameters in the system, or you can specify a parameter name, 
its initial value, another parameter name, its initial value, and so 
on.  For example, to initialize {opt alpha} to 1.23 and {opt delta} to 
4.57, you would type

{pmore2}
{cmd:nlsur ... , initial(alpha 1.23 delta 4.57) ...}

{pmore}
Initial values declared using this option override any that are declared within
substitutable expressions.  If you specify a matrix, the values must be in the
same order in which the parameters are declared in your model.  {cmd:nlsur}
ignores the row and column names of the matrix.

{phang}
{opt nequations(#)} specifies the number of equations in the system.

{phang}
{opt parameters(namelist)} specifies the names of the parameters in the
system. The names of the parameters must adhere to the naming
conventions of Stata's variables; see {findalias frnames}.
If you specify both {opt parameters()} and 
{opt nparameters()}, the number of names in the former must match the number
specified in the latter. 

{phang}
{opt nparameters(#)} specifies the number of parameters in the system. 
If you do not specify names with the {opt parameters()} option,
{cmd:nlsur} names them {cmd:b1}, {cmd:b2}, ..., {cmd:b}{it:#}.  If you
specify both {opt parameters()} and {opt nparameters()}, the number of
names in the former must match the number specified in the latter.

{phang}
{it:sexp_options} refer to any options allowed by your
{help nlsur##subexppr:{it:sexp_prog}}. 

{phang}
{it:func_options} refer to any options allowed by your
{help nlsur##func_prog:{it:func_prog}}.

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

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

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
{opt noci},
{opt nopv:alues},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{marker optimization_options}{...}
{dlgtab:Optimization}

{phang}
{it:optimization_options}: {cmdab:it:erate(}{it:#}{cmd:)},
[{cmd:no}]{cmd:log},
{cmdab:tr:ace}.  {cmd:iterate()} specifies the maximum number of
iterations to use for NLS at each round of FGNLS estimation.
This option is different from {opt ifgnlsiterate()}, which controls
the maximum rounds of FGNLS estimation to use when the 
{opt ifgnls} option is specified. {opt log}/{opt nolog} specifies 
whether to show the iteration log; see {cmd:set iterlog} in
{manhelpi set_iter R:set iter}. {opt trace} specifies that the iteration log
should include the current parameter vector.

{phang}
{opt eps(#)} specifies the convergence criterion for successive parameter
estimates and for the residual sum of squares.  The default is {cmd:eps(1e-5)}
(0.00001).  {opt eps()} also specifies the convergence criterion for 
successive parameter estimates between rounds of iterative FGNLS 
estimation when {opt ifgnls} is specified.

{phang}
{opt ifgnlsiterate(#)} specifies the maximum number of FGNLS iterations to 
perform.  The default is the number set using {helpb set maxiter}, which is
INCLUDE help maxiter
by default.  To use this option, you must also specify the {opt ifgnls}
option.

{phang}
{opt ifgnlseps(#)} specifies the convergence criterion for successive 
estimates of the error covariance matrix during iterative FGNLS 
estimation.  The default is {cmd:ifgnlseps(1e-10)}.  To use this option,
you must also specify the {opt ifgnls} option.

{phang}
{opt delta(#)} specifies the relative change in a parameter to be used in
computing the numeric derivatives.  The derivative for parameter b_i is
computed as {c -(}f_i(x_i,b_1,b_2,...,b_i + d, b_[i+1],...) -
f_i(x_i, b_1,b_2,...,b_i, b_[i+1],...){c )-}/d,
where d is delta*(b_i + delta).  The default is {cmd:delta(4e-7)}.

{phang}
{opt noconstants} indicates that none of the equations in the system 
includes constant terms.  This option is generally not needed, even if 
there are no constant terms in the system; though in rare cases 
without this option, {cmd:nlsur} may claim that there is one or more constant 
terms even if there are none.

{phang}
{opt hasconstants(namelist)} indicates the parameters that are to be 
treated as constant terms in the system of equations.  The number of 
elements of {it:namelist} must equal the number of equations in the 
system.  The {it:i}th entry of {it:namelist} specifies the constant term 
in the {it:i}th equation.  If an equation does not include a constant 
term, specify a period ({cmd:.}) instead of a parameter name.  This option is 
seldom needed with the interactive and programmed substitutable 
expression versions, because in those cases {cmd:nlsur} can almost 
always find the constant terms automatically.

{pstd}
The following option is available with {cmd:nlsur} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help nlsur##subexp:Substitutable expressions}
            {help nlsur##examples_sexp:Examples}
        {help nlsur##subexppr:Substitutable expression programs}
            {help nlsur##example_sexp_progs:Example}
        {help nlsur##func_prog:Function evaluator programs}


{marker subexp}{...}
{title:Substitutable expressions}

{pstd}
You use substitutable expressions with the interactive and programmed 
substitutable expression versions of {cmd:nlsur} to define your system 
of equations.  Substitutable expressions are just like any other 
mathematical expression in Stata, except that the parameters of your 
model are bound in braces.

{pstd}
You specify a substitutable expression for each equation in your 
system, and you must follow three rules:

{phang2}
1.  Parameters of the model are bound in braces: {cmd:{c -(}b0{c )-}},
{cmd:{c -(}param{c )-}}, etc.

{phang2}
2.  Initial values are given by including an equal sign and the initial
value inside the braces:  {cmd:{c -(}b1=1.267{c )-}}, 
{cmd: {c -(}gamma=3{c )-}}, etc.  If you do not specify an initial 
value, that parameter is initialized to zero.  The {cmd:initial()} 
option overrides initial values provided in substitutable 
expressions.

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
1.  To fit the system of equations

{pmore3}
y1 = a1 + b1*x^g1

{pmore3}
y2 = a2 + b2*x^g2

{pmore2}
by iterative FGNLS, where a1, a2, b1, b2, g1, and g2 are parameters and 
1 is a reasonable starting value for both g1 and g2, you would type

{pmore3}
{cmd:. nlsur (y1 = {c -(}a1{c )-} + {c -(}b1{c )-}*x^{c -(}g1=1{c )-}) (y2 = {c -(}a2{c )-} + {c -(}b2{c )-}*x^{c -(}g2=1{c )-}), ifgnls}

{phang2}
2.  {cmd:nlsur} makes imposing cross-equation parameter restrictions 
easy.  Say that you want to fit a pair of exponential growth equations with 
the restriction that the constant terms in the two equations are equal,

{pmore3}
y1 = a + b1*b2^x

{pmore3}
y2 = a + c1*c2^x

{pmore2}
where a, b1, b2, c1, and c2 are the parameters.  To fit this model,
you would type

{pmore3}
{cmd:. nlsur (y1 = {c -(}a{c )-} + {c -(}b1{c )-}*{c -(}b2{c )-}^x) (y2 = {c -(}a{c )-} + {c -(}c1{c )-}*{c -(}c2{c )-}^x)}{p_end}


{marker subexppr}{...}
{title:Substitutable expression programs -- {it:sexp_prog}s}

{pstd}
If you intend to fit the same nonlinear system multiple times, then you 
can write a substitutable expression program and avoid having to reenter 
the equations every time.  The first five letters of the program name 
must be {cmd:nlsur}, and the program is to accept a {it:varlist}, an 
{cmd:if} {it:exp}, and, optionally, weights.  The program must return in 
{cmd:r(n_eq)} the number of equations in the system and in 
{cmd:r(eq_1)} through {cmd:r(eq_}{it:m}{cmd:)} the {it:m} 
equations in the system.  You can add a title to the output by storing a 
string in {cmd:r(title)}.

{pstd}
The outline of an {cmd:nlsur}{it:sexp_prog} program is

{p 8 14 2}{cmd:program nlsur}{it:sexp_prog}{cmd:, rclass}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:syntax }{it:varlist} {cmd:[aw fw iw]} {cmd:[if]}{p_end}
{p 12 18 2}{it:(obtain initial parameters if desired)}{p_end}
{p 12 18 2}{cmd:return scalar n_eq = }{it:<neqn>}{p_end}
{p 12 18 2}{cmd:return local eq_1 "}{it:<sexp>_1}{cmd:"}{p_end}
{p 12 18 2}{cmd:...}{p_end}
{p 12 18 2}{cmd:return local eq_}{it:m}{cmd: "}{it:<sexp>_m}{cmd:"}{p_end}
{p 12 18 2}{cmd:return local title "}{it:title}{cmd:"}{p_end}
{p 8 14 2}{cmd:end}


{marker example_sexp_progs}{...}
    {title:Example}

{pmore}
Returning to the model

{pmore3}
y1 = a1 + b1*x^g1

{pmore3}
y2 = a2 + b2*x^g2

{pmore}
one way to obtain initial values is to let g1 = g2 = 1 and then 
fit a regression of y1 on x to obtain initial values for a1 and b1 and,
similarly, fit a regression of y2 on x to obtain initial values for a2 
and b2.  The substitutable expression program is

{p 12 18 2}{cmd:program nlsurmyreg, rclass}{p_end}

{p 16 22 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 22 2}{cmd:syntax varlist(min=3 max=3) [aw fw iw] [if]}{p_end}
{p 16 22 2}{cmd:local y1: word 1 of `varlist'}{p_end}
{p 16 22 2}{cmd:local y2: word 2 of `varlist'}{p_end}
{p 16 22 2}{cmd:local x : word 3 of `varlist'}{p_end}

{p 16 22 2}{cmd:// Obtain starting values assuming g1=g2=1}{p_end}
{p 16 22 2}{cmd:regress `y1' `x' [`weight'`exp'] `if'}{p_end}
{p 16 22 2}{cmd:local a1 = _b[_cons]}{p_end}
{p 16 22 2}{cmd:local b1 = _b[`x']}{p_end}
{p 16 22 2}{cmd:regress `y2' `x' [`weight'`exp'] `if'}{p_end}
{p 16 22 2}{cmd:local a2 = _b[_cons]}{p_end}
{p 16 22 2}{cmd:local b2 = _b[`x']}{p_end}

{p 16 22 2}{cmd:return scalar n_eq = 2}{p_end}
{p 16 22 2}{cmd:return local eq_1 "`y1' = {a1=`a1'} + {b1=`b1'}*`x'^{g1=1}"}{p_end}
{p 16 22 2}{cmd:return local eq_2 "`y2' = {a2=`a2'} + {b2=`b2'}*`x'^{g2=1}"}{p_end}

{p 12 18 2}{cmd:end}{p_end}

{pmore}
To fit your model, you type

{p 12 18 2}{cmd:. nlsur myreg: y1 y2 x}

{pmore}
(There is a space between {cmd:nlsur} and {cmd:myreg}, even though the 
program is named {cmd:nlsurmyreg}.)

{pstd}
The substitutable expression does not need to account for 
weights or the {cmd:if} {it:exp}, though we did need to use them in 
obtaining initial values.


{marker func_prog}{...}
{title:Function evaluator programs -- {it:func_prog}s}

{pstd}
If your system of equations is particularly complex, then you may find
that writing a substitutable expression for each equation is
impractical.  In those cases, you can write a function evaluator program
instead.  Whenever {cmd:nlsur} needs to evaluate the system of
equations, it calls your program with a vector of parameters.  Your
program then fills in the dependent variables with the corresponding
function values.

{pstd}
Function evaluator programs must accept a {it:varlist}, an {cmd:if} 
{it:exp}, and an option named {cmd:at()} that accepts the name of a 
matrix.  They may optionally accept weights as well.  

{pstd}
To illustrate the mechanics of a function evaluator program, we focus on 
a straightforward example.  We want to fit the model

{pmore2}
y1 = b0 + b1*x1 + b2*x2

{pmore2}
y2 = c0 + c1*x2 + c2*x3

{pstd}
(Because this system is linear, we could in fact just use {helpb sureg}.)  Our 
function evaluator program is

{p 12 18 2}{cmd:program nlsursur}{p_end}

{p 16 22 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 22 2}{cmd:syntax varlist(min=5 max=5) [if], at(name)}{p_end}
{p 16 22 2}{cmd:local y1: word 1 of `varlist'}{p_end}
{p 16 22 2}{cmd:local y2: word 2 of `varlist'}{p_end}
{p 16 22 2}{cmd:local x1: word 3 of `varlist'}{p_end}
{p 16 22 2}{cmd:local x2: word 4 of `varlist'}{p_end}
{p 16 22 2}{cmd:local x3: word 5 of `varlist'}{p_end}

{p 16 22 2}{cmd:// Retrieve parameters out of `at'}{p_end}
{p 16 22 2}{cmd:tempname b0 b1 b2 c0 c1 c2}{p_end}
{p 16 22 2}{cmd:scalar `b0' = `at'[1,1]}{p_end}
{p 16 22 2}{cmd:scalar `b1' = `at'[1,2]}{p_end}
{p 16 22 2}{cmd:scalar `b2' = `at'[1,3]}{p_end}
{p 16 22 2}{cmd:scalar `c0' = `at'[1,4]}{p_end}
{p 16 22 2}{cmd:scalar `c1' = `at'[1,5]}{p_end}
{p 16 22 2}{cmd:scalar `c2' = `at'[1,6]}{p_end}

{p 16 22 2}{cmd:// Fill in dependent variables}{p_end}
{p 16 22 2}{cmd:quietly replace `y1' = `b0' + `b1'*`x1' + `b2'*`x2' `if'}{p_end}
{p 16 22 2}{cmd:quietly replace `y2' = `c0' + `c1'*`x2' + `c2'*`x3' `if'}{p_end}

{p 12 18 2}{cmd:end}

{pstd}
Our model has a total of five variables, so we made the {cmd:syntax} 
statement accept five variables.  {cmd:nlsur} requires that our program 
accept an {cmd:if} clause and an option named {opt at()} by which 
{cmd:nlsur} passes a matrix holding the parameter values.  The order in 
which you store the elements of the {it:varlist} will determine the 
order in which you specify the variables when calling {cmd:nlsur}.

{pstd}
Because we do not plan to use weighted estimation 
with this model, we did not make our {cmd:syntax} statement accept 
weights.  If you do intend to perform weighted estimation, the 
{cmd:syntax} statement must accept them.  When you replace the dependent 
variables with the values of the functions, you do not need to do 
anything with the weights, though if you use estimation or descriptive 
statistical commands when evaluating your functions, the weight 
expression must be passed onto those commands.

{pstd}
Our model has six parameters, so our program will receive a 1 x 6 row
vector named `at'.  We extract the six parameters from that vector and
store them in temporary scalars.  We could have referred directly to the
elements of the `at' vector when evaluating the functions of our model,
but storing the parameters in appropriately named scalars makes the
process more transparent.  The final part of our program computes the
two equations.

{pstd}
There are several different ways we can call {cmd:nlsur} to fit our 
model.

{phang2}
1.  This method uses the shortest syntax and initializes all the 
parameters to zero, which is the default:

{p 16 22 2}
{cmd:. nlsur sur @ y1 y2 x1 x2 x3, nparameters(6) nequations(2)}

{pmore2}
Because we did not specify names for the parameters, they will be 
labeled b1 through b6 in the output.

{phang2}
2.  Here we give names to the parameters and initialize the two constant 
terms to be 10:

{p 16 22 2}
{cmd:. nlsur sur @ y1 y2 x1 x2 x3, parameters(b0 b1 b2 c0 c1 c2)} 
         {cmd:initial(b0 10 c0 10) nequations(2)}

{phang2}
3.  When you use a function evaluator program, {cmd:nlsur} does not 
attempt to identify a constant term in each equation, so the 
R-squared statistics reported in the header of the output are 
uncentered.  You use the {opt hasconstants()} option to indicate 
which parameter in each equation is a constant:

{p 16 22 2}
{cmd:. nlsur sur @ y1 y2 x1 x2 x3, parameters(b0 b1 b2 c0 c2 c2)}
         {cmd:initial(b0 10 c0 10) nequations(2) hasconstant(b0 c0)}

{pmore2}
Now {cmd:nlsur} takes b0 to be the constant in the first equation and c0 
in the second, and centered R-squared statistics will be reported.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse petridish}

{pstd}Model growth of two bacteria populations over time; allow for correlation
   between error terms{p_end}
{phang2}{cmd:. nlsur (p1 = {b1}*{b2}^t) (p2 = {g1}*{g2}^t)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:nlsur} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 17 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_}{it:#}{cmd:)}}number of parameters for equation
                 {it:#}{p_end}
{synopt:{cmd:e(k_eq)}}number of equation names in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(n_eq)}}number of equations{p_end}
{synopt:{cmd:e(mss_}{it:#}{cmd:)}}model sum of squares for equation
                 {it:#}{p_end}
{synopt:{cmd:e(rss_}{it:#}{cmd:)}}RSS for equation {it:#}{p_end}
{synopt:{cmd:e(rmse_}{it:#}{cmd:)}}root mean squared error for equation
                 {it:#}{p_end}
{synopt:{cmd:e(r2_}{it:#}{cmd:)}}R squared for equation {it:#}{p_end}
{synopt:{cmd:e(ll)}}Gaussian log likelihood ({cmd:iflgs} version only){p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 15 17 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:nlsur}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(method)}}{cmd:fgnls}, {cmd:ifgnls}, or {cmd:nls}{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(depvar_}{it:#}{cmd:)}}dependent variable for equation
                {it:#}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(title_2)}}secondary title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(type)}}{cmd:1} = interactively entered expression{p_end}
{p2col 5 21 23 2: } {cmd:2} = substitutable expression program{p_end}
{p2col 5 21 23 2: } {cmd:3} = function evaluator program{p_end}
{synopt:{cmd:e(sexpprog)}}substitutable expression program{p_end}
{synopt:{cmd:e(sexp_}{it:#}{cmd:)}}substitutable expression for equation
                {it:#}{p_end}
{synopt:{cmd:e(params)}}names of all parameters{p_end}
{synopt:{cmd:e(params_}{it:#}{cmd:)}}parameters in equation {it:#}{p_end}
{synopt:{cmd:e(funcprog)}}function evaluator program{p_end}
{synopt:{cmd:e(rhs)}}contents of {cmd:variables()}{p_end}
{synopt:{cmd:e(constants)}}identifies constant terms{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}

{p2col 5 15 17 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(init)}}initial values vector{p_end}
{synopt:{cmd:e(Sigma)}}error covariance matrix (Sigma hat matrix){p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 15 17 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
