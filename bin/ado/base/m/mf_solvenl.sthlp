{smcl}
{* *! version 1.1.8  04feb2020}{...}
{vieweralsosee "[M-5] solvenl()" "mansection M-5 solvenl()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{vieweralsosee "[R] set iter" "help set_iter"}{...}
{viewerjumpto "Syntax" "mf_solvenl##syntax"}{...}
{viewerjumpto "Description" "mf_solvenl##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_solvenl##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_solvenl##remarks"}{...}
{viewerjumpto "Conformability" "mf_solvenl##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_solvenl##diagnostics"}{...}
{viewerjumpto "References" "mf_solvenl##references"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] solvenl()} {hline 2}}Solve systems of nonlinear equations{p_end}
{p2col:}({mansection M-5 solvenl():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 6 25 2}
{bind:          }
{it:{help mf_solvenl##S:S}}
{cmd:=}
{cmd:solvenl_init()}


{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_type:{bf:solvenl_init_type(}{it:S} [{bf:,} {c -(}{bf:"fixedpoint"} | {bf:"zero"}{c )-}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_startingvals:{bf:solvenl_init_startingvals(}{it:S} [{bf:,} {it:real colvector ivals}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_numeq:{bf:solvenl_init_numeq(}{it:S} [{bf:,} {it:real scalar nvars}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_technique:{bf:solvenl_init_technique(}{it:S} [{bf:,} {bf:"}{it:technique}{bf:"}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_conv_iterchng:{bf:solvenl_init_conv_iterchng(}{it:S} [{bf:,} {it:real scalar itol}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_conv_nearzero:{bf:solvenl_init_conv_nearzero(}{it:S} [{bf:,} {it:real scalar ztol}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_conv_maxiter:{bf:solvenl_init_conv_maxiter(}{it:S} [{bf:,} {it:real scalar maxiter}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_evaluator:{bf:solvenl_init_evaluator(}{it:S} [{bf:,} {bf:&}{it:evaluator}{bf:()}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_argument:{bf:solvenl_init_argument(}{it:S}{bf:,} {it:real scalar k} [{bf:,} {it:X}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_narguments:{bf:solvenl_init_narguments(}{it:S} [{bf:,} {it:real scalar K}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_damping:{bf:solvenl_init_damping(}{it:S} [{bf:,} {it:real scalar damp}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_iter_log:{bf:solvenl_init_iter_log(}{it:S} [{bf:,} {c -(}{bf:"on"} | {bf:"off"}{c )-}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_iter_dot:{bf:solvenl_init_iter_dot(}{it:S} [{bf:,} {c -(}{bf:"on"} | {bf:"off"}{c )-}]{bf:)}}

{p 6 25 2}
{it:(varies)}{bind:       }
{help mf_solvenl##init_iter_dot_indent:{bf:solvenl_init_iter_dot_indent(}{it:S} [{bf:,} {it:real scalar indent}]{bf:)}}


{p 6 25 2}
{it:real colvector}{bind: }
{help mf_solvenl##solve:{bf:solvenl_solve(}{it:S}{bf:)}}

{p 6 25 2}
{it:real scalar}{bind:   }
{help mf_solvenl##_solve:{bf:_solvenl_solve(}{it:S}{bf:)}}


{p 6 25 2}
{it:real scalar}{bind:    }
{help mf_solvenl##result_converged:{bf:solvenl_result_converged(}{it:S}{bf:)}}

{p 6 25 2}
{it:real scalar}{bind:    }
{help mf_solvenl##result_conv_iter:{bf:solvenl_result_conv_iter(}{it:S}{bf:)}}

{p 6 25 2}
{it:real scalar}{bind:    }
{help mf_solvenl##result_conv_iterchng:{bf:solvenl_result_conv_iterchng(}{it:S}{bf:)}}

{p 6 25 2}
{it:real scalar}{bind:    }
{help mf_solvenl##result_conv_nearzero:{bf:solvenl_result_conv_nearzero(}{it:S}{bf:)}}

{p 6 25 2}
{it:real colvector}{bind: }
{help mf_solvenl##result_values:{bf:solvenl_result_values(}{it:S}{bf:)}}

{p 6 25 2}
{it:real matrix}{bind:    }
{help mf_solvenl##result_Jacobian:{bf:solvenl_result_Jacobian(}{it:S}{bf:)}}

{p 6 25 2}
{it:real scalar}{bind:    }
{help mf_solvenl##result_error_code:{bf:solvenl_result_error_code(}{it:S}{bf:)}}

{p 6 25 2}
{it:real scalar}{bind:    }
{help mf_solvenl##result_return_code:{bf:solvenl_result_return_code(}{it:S}{bf:)}}

{p 6 25 2}
{it:string scalar}{bind:  }
{help mf_solvenl##result_error_text:{bf:solvenl_result_error_text(}{it:S}{bf:)}}


{p 6 25 2}
{it:void}{bind:           }
{help mf_solvenl##dump:{bf:solvenl_dump(}{it:S}{bf:)}}


{marker S}{...}
{pstd}
{it:S}, if it is declared, should be declared as

{pmore2}
{cmd:transmorphic} {it:S}

{marker technique}{...}
{pstd} 
and {it:technique} optionally specified in {cmd:solvenl_init_technique()} is one
of the following:

{col 12}{it:technique}{col 31}Description
{col 12}{hline 45}
{col 12}{cmdab:gau:ssseidel}{col 31}Gauss-Seidel
{col 12}{cmdab:dam:pedgaussseidel}{col 31}Damped Gauss-Seidel
{col 12}{cmdab:bro:ydenpowell}{col 31}Broyden-Powell
{col 10}* {cmdab:new:tonraphson}{col 31}Newton-Raphson
{col 12}{hline 45}
{col 12}*{cmd:newton} may also be abbreviated as {cmd:nr}.

{pstd}
For fixed-point problems, allowed {it:technique}s are {cmd:gaussseidel} and
{cmd:dampedgaussseidel}.  For zero-finding problems, allowed {it:technique}s
are {cmd:broydenpowell} and {cmd:newtonraphson}.  {cmd:solvenl_}{it:*}{cmd:()}
exits with an error message if you specify a {it:technique} that is
incompatible with the type of evaluator you declared by using
{cmd:solvenl_init_type()}.  The default technique for fixed-point problems is
{cmd:dampedgaussseidel} with a damping parameter of 0.1.  The default technique
for zero-finding problems is {cmd:broydenpowell}.


{marker description}{...}
{title:Description}

{pstd}
The {cmd:solvenl()} suite of functions finds solutions to systems of nonlinear
equations.

{pstd}
{cmd:solvenl_init()} initializes the problem and returns {it:S}, a structure that
contains information regarding the problem, including default values.  If you
declare a storage type for {it:S}, declare it to be a
{cmd:transmorphic scalar}.

{pstd}
The {cmd:solvenl_init_}{it:*}{cmd:(}{it:S}{cmd:,} ...{cmd:)} functions allow you
to modify those default values and specify other aspects of your problem,
including whether your problem refers to finding a fixed point or a zero
starting value to use, etc.

{pstd}
{cmd:solvenl_solve(}{it:S}{cmd:)} solves the problem.  {cmd:solvenl_solve()}
returns a vector that represents either a fixed point of your function or a
vector at which your function is equal to a vector of zeros.

{pstd}
The {cmd:solvenl_result_}{it:*}{cmd:(}{it:S}{cmd:)} functions let you access
other information associated with the solution to your problem, including
whether a solution was achieved, the final Jacobian matrix, and diagnostics.

{pstd}
Aside:

{pstd}
The {cmd:solvenl_init_}{it:*}{cmd:(}{it:S}{cmd:,} ...{cmd:)} functions have
two modes of operation.  Each has an optional argument that you specify to set
the value and that you omit to query the value.
For instance, the full syntax of
{cmd:solvenl_init_startingvals()} is

                {it:void} {cmd:solvenl_init_startingvals(}{it:S}{cmd:,} {it:real colvector ivals}{cmd:)}

                {it:real colvector} {cmd:solvenl_init_startingvals(}{it:S}{cmd:)}

{pstd}
The first syntax sets the parameter values and returns nothing.
The second syntax returns 
the previously set (or default, if not set) parameter values.

{pstd} All the {cmd:solvenl_init_}{it:*}{cmd:(}{it:S}{cmd:,}
...{cmd:)} functions work the same way.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 solvenl()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{space 8}{help mf_solvenl##intro:Introduction}
{space 8}{help mf_solvenl##exfixed:A fixed-point example}
{space 8}{help mf_solvenl##exzero:A zero-finding example}
{p 8 10 2}{help mf_solvenl##fpzero:Writing a fixed-point problem as a zero-finding problem and vice versa}{p_end}
{space 8}{help mf_solvenl##gsmethods:Gauss-Seidel methods}
{space 8}{help mf_solvenl##newton:Newton-type methods}
{space 8}{help mf_solvenl##convergence:Convergence criteria}
{space 8}{help mf_solvenl##earlyexit:Exiting early}
{space 8}{help mf_solvenl##functions:Functions}
{space 12}{help mf_solvenl##init:solvenl_init()}
{space 12}{help mf_solvenl##init_type:solvenl_init_type()}
{space 12}{help mf_solvenl##init_startingvals:solvenl_init_startingvals()}
{space 12}{help mf_solvenl##init_numeq:solvenl_init_numeq()}
{space 12}{help mf_solvenl##init_technique:solvenl_init_technique()}
{space 12}{help mf_solvenl##init_conv_iterchng:solvenl_init_conv_iterchng()}
{space 12}{help mf_solvenl##init_conv_nearzero:solvenl_init_conv_nearzero()}
{space 12}{help mf_solvenl##init_conv_maxiter:solvenl_init_conv_maxiter()}
{space 12}{help mf_solvenl##init_evaluator:solvenl_init_evaluator()}
{p 12 14 2}{help mf_solvenl##init_argument:solvenl_init_argument() and solvenl_init_narguments()}{p_end}
{space 12}{help mf_solvenl##init_damping:solvenl_init_damping()}
{space 12}{help mf_solvenl##init_iter_log:solvenl_init_iter_log()}
{space 12}{help mf_solvenl##init_iter_dot:solvenl_init_iter_dot()}
{space 12}{help mf_solvenl##init_iter_dot_indent:solvenl_init_iter_dot_indent()}
{space 12}{help mf_solvenl##solve:solvenl_solve() and _solvenl_solve()}
{space 12}{help mf_solvenl##result_converged:solvenl_result_converged()}
{space 12}{help mf_solvenl##result_conv_iter:solvenl_result_conv_iter()}
{space 12}{help mf_solvenl##result_conv_iterchng:solvenl_result_conv_iterchng()}
{space 12}{help mf_solvenl##result_conv_nearzero:solvenl_result_conv_nearzero()}
{space 12}{help mf_solvenl##result_values:solvenl_result_values()}
{space 12}{help mf_solvenl##result_Jacobian:solvenl_result_Jacobian()}
{p 12 14 2}{help mf_solvenl##result_error_code:solvenl_result_error_code(), ..._return_code(), and ..._error_text()}{p_end}
{space 12}{help mf_solvenl##dump:solvenl_dump()}


{marker intro}{...}
{title:Introduction}

{pstd} 
Let {bf:x} denote a {it:k} x 1 vector and let {cmd:F}:R^{it:k} -> R^{it:k}
denote a function that represents a system of equations.  The
{cmd:solvenl()} suite of functions can be used to find fixed-point solutions
{bf:x}* = {bf:F}({bf:x}*), and it can be used to find a zero of the function,
that is, a vector {cmd:x}* such that {bf:F}({bf:x}*) = {bf:0}.

{pstd}
Four solution methods are available: Gauss-Seidel (GS), damped Gauss-Seidel
(dGS), Newton's method (also known as the Newton-Raphson method), and the
Broyden-Powell (BP) method.  The first two methods are used to find fixed
points, and the latter two are used to find zeros.  However, as we discuss
below, fixed-point problems can be rewritten as zero-finding problems, and
many zero-finding problems can be rewritten as fixed-point problems.

{pstd}
Solving systems of nonlinear equations is inherently more difficult than
minimizing or maximizing a function.  The set of first-order conditions
associated with an optimization problem satisfies a set of integrability
conditions, while {cmd:solvenl_}{it:*}{cmd:()} works with arbitrary systems of
nonlinear equations.  Moreover, while one may be tempted to approach a
zero-finding problem by defining a function

{pmore}
{it:f}({bf:x}) = {bf:F}({bf:x})'{bf:F}({bf:x})

{pstd}
and minimizing {it:f}({bf:x}), there is a high probability that the minimizer
will find a local minimum for which {bf:F}({bf:x}) != {bf:0}
({help mf_solvenl##PressEtAl2007:Press et al. 2007}, 476).
Some problems may have multiple solutions.


{marker exfixed}{...}
{title:A fixed-point example}

{pstd}
We want to solve the system of equations

{space 8}{it:x} =  5/3 - 2/3*{it:y}
{space 8}{it:y} = 10/3 - 2/3*{it:x}

{pstd}
First, we write a program that takes two arguments: a column vector
representing the values at which we are to evaluate our function and a column
vector into which we are to place the function values.

{space 8}: {cmd:void function myfun(real colvector from, real colvector values)}
{space 8}>{cmd: {c -(}}
{space 8}>{cmd:         values[1] =  5/3 - 2/3*from[2]}
{space 8}>{cmd:         values[2] = 10/3 - 2/3*from[1]}
{space 8}>{cmd: {c )-}}

{pstd}
Our invocation of {cmd:solvenl_}{it:*}{cmd:()} proceeds as follows:

{space 8}: {cmd:S = solvenl_init()}

{space 8}: {cmd:solvenl_init_evaluator(S, &myfun())}

{space 8}: {cmd:solvenl_init_type(S, "fixedpoint")}

{space 8}: {cmd:solvenl_init_technique(S, "gaussseidel")}

{space 8}: {cmd:solvenl_init_numeq(S, 2)}

{space 8}: {cmd:solvenl_init_iter_log(S, "on")}

{space 8}: {cmd:x = solvenl_solve(S)}
{space 8}Iteration 1:    3.3333333
{space 8}Iteration 2:    .83333333
{space 8}(output omitted)

{space 8}: {cmd:x}
{space 8}                  1
{space 8}    {c TLC}{hline 16}{c TRC}
{space 8}  1 {c |}  -.9999999981  {c |}
{space 8}  2 {c |}             4  {c |}
{space 8}    {c BLC}{hline 16}{c BRC}

{pstd}
In our equation with {it:x} on the left-hand side, {it:x} did not appear on the
right-hand side, and similarly for the equation with {it:y}.  However, that is
not required.  Fixed-point problems with left-hand-side variables appearing on
the right-hand side of the same equation can be solved, though they typically
require more iterations to reach convergence.


{marker exzero}{...}
{title:A zero-finding example}

{pstd}
We wish to solve the following system of equations
({help mf_solvenl##BurdenFaires2016:Burden, Faires, and Burden 2016}, 657)
for the three unknowns {it:x}, {it:y}, and {it:z}:

{space 8}10 - {it:x}*exp({it:y}*1) -   {it:z} = 0
{space 8}12 - {it:x}*exp({it:y}*2) - 2*{it:z} = 0
{space 8}15 - {it:x}*exp({it:y}*3) - 3*{it:z} = 0

{pstd}
We will use Newton's method.  We cannot use {it:x} = {it:y} = {it:z} = 0 as
initial values because the Jacobian matrix is singular at that point; we will
instead use {it:x} = {it:y} = {it:z} = 0.2.  Our program is

{space 8}: {cmd:void function myfun2(real colvector x, real colvector values)}
{space 8}> {cmd:{c -(}}
{space 8}>         values[1] = 10 - x[1]*exp(x[2]*1) - x[3]*1
{space 8}>         values[2] = 12 - x[1]*exp(x[2]*2) - x[3]*2
{space 8}>         values[3] = 15 - x[1]*exp(x[2]*3) - x[3]*3
{space 8}> {cmd:{c )-}}
 
{space 8}: {cmd:S = solvenl_init()}

{space 8}: {cmd:solvenl_init_evaluator(S, &myfun2())}

{space 8}: {cmd:solvenl_init_type(S, "zero")}

{space 8}: {cmd:solvenl_init_technique(S, "newton")}

{space 8}: {cmd:solvenl_init_numeq(S, 3)}

{space 8}: {cmd:solvenl_init_startingvals(S, J(3,1,.2))}

{space 8}: {cmd:solvenl_init_iter_log(S, "on")}

{space 8}: {cmd:x = solvenl_solve(S)}
{space 8}Iteration 0:  function = 416.03613
{space 8}Iteration 1:  function = 63.014451  delta X = 1.2538445
{space 8}Iteration 2:  function = 56.331397  delta X = .70226488
{space 8}Iteration 3:  function = 48.572941  delta X = .35269647
{space 8}Iteration 4:  function = 37.434106  delta X = .30727054
{space 8}Iteration 5:  function = 19.737501  delta X = .38136739
{space 8}Iteration 6:  function = .49995202  delta X =  .2299557
{space 8}Iteration 7:  function = 1.164e-08  delta X = .09321045
{space 8}Iteration 8:  function = 4.154e-16  delta X = .00011039

{space 8}: {cmd:x}
{space 8}                  1
{space 8}    {c TLC}{hline 16}{c TRC}
{space 8}  1 {c |}   8.771286448  {c |}
{space 8}  2 {c |}   .2596954499  {c |}
{space 8}  3 {c |}  -1.372281335  {c |}
{space 8}    {c BLC}{hline 16}{c BRC}


{marker fpzero}{...}
{title:Writing a fixed-point problem as a zero-finding problem and vice versa}

{pstd}
Earlier, we solved the system of equations

{space 8}{it:x} =  5/3 - 2/3*{it:y}
{space 8}{it:y} = 10/3 - 2/3*{it:x}

{pstd}
by searching for a fixed point.  We can rewrite this system as

{space 8}{it:x} -  5/3 + 2/3*{it:y} = 0
{space 8}{it:y} - 10/3 + 2/3*{it:x} = 0

{pstd}
and then use BP or Newton's method to find the solution.  In general, we simply
rewrite {bf:x}* = {bf:F}({bf:x}*) as {bf:x}* - {bf:F}({bf:x}*) = {bf:0}.

{pstd}
Similarly, we may be able to rearrange the constituent equations of a system
of the form {bf:F}({bf:x}) = {bf:0} so that each variable is an explicit
function of the other variables in the system.  If that is the case, then
GS or dGS can be used to find the solution.


{marker gsmethods}{...}
{title:Gauss-Seidel methods}

{pstd}
Let {bf:x}({it:i}-1) denote the previous iteration's values or the initial
values, and let {bf:x}({it:i}) denote the current iteration's values.  The
Gauss-Jacobi method simply iterates on
{bf:x}({it:i}) = {bf:F}[{bf:x}({it:i}-1)]
by evaluating each equation in order.  The Gauss-Seidel method implemented
in {cmd:solvenl_}{it:*}{cmd:()} instead uses the new, updated values of
{bf:x}({it:i}) that are available for equations 1 through {it:j}-1 when
evaluating equation {it:j} at iteration {it:i}.

{pstd}
For damped Gauss-Seidel, again let {bf:x}({it:i}) denote the values obtained
from evaluating {bf:F}[{bf:x}({it:i}-1)].  However, after evaluating {bf:F},
dGS calculates the new parameter vector that is carried over to the next
iteration as

{pmore}
{bf:x}{it:#}({it:i}) = (1 - {it:d})*{bf:x}({it:i}) + {it:d}*{bf:x}({it:i}-1)

{pstd}
where {it:d} is the damping factor.  Not fully updating the parameter vector
at each iteration helps facilitate convergence in many problems.  The default
value of {it:d} for method dGS is 0.1, representing just a small amount of
damping, which is often enough to achieve convergence.  You can use
{cmd:solvenl_init_damping()} to change {it:d}; the current implementation
uses the same value of {it:d} for all iterations.  Increasing the damping
factor generally slows convergence by requiring more iterations.


{marker newton}{...}
{title:Newton-type methods}

{pstd}
Newton's method for solving {bf:F}({bf:x})={bf:0} is based on the approximation

{pmore}
{bf:F}[{bf:x}({it:i})] ~ {bf:F}[{bf:x}({it:i}-1)] + {bf:J}[{bf:x}({it:i}-1)]*[{bf:x}({it:i}) - {bf:x}({it:i}-1)] = 0

{pstd}
where {bf:J}[{bf:x}({it:i}-1)] is the Jacobian matrix of
{bf:F}[{bf:x}({it:i}-1)].  Rearranging and incorporating a step-length
parameter {it:alpha}, we have

{pmore}
{bf:x}({it:i}) - {bf:x}({it:i}-1) = -{it:alpha}*{bf:J}^{-1}[{bf:x}({it:i}-1)]*{bf:F}[{bf:x}({it:i}-1)] 

{pstd}
We calculate {bf:J} numerically by using the {cmd:deriv()}
(see {helpb mf_deriv:[M-5] deriv()}) suite of functions.  In fact, we do not
calculate the inverse of {bf:J}; we instead use LU decomposition to solve for
{bf:x}({it:i}) - {bf:x}({it:i}-1).

{pstd}
To speed up convergence, we define the function
{it:f}({bf:x}) = {bf:F}({bf:x})'{bf:F}({bf:x}) and then choose {it:alpha}
between 0 and 1 such that {it:f}[{bf:x}({it:i})] is minimized.  We use a
golden-section line search with a maximum of 20 iterations to find {it:alpha}.

{pstd}
Because we must compute a {it:k} x {it:k} Jacobian matrix at each iteration,
Newton's method can be slow.  The BP method, similar to
quasi-Newton methods for optimization, instead builds and updates an
approximation {bf:B} to the Jacobian matrix at each iteration.  The
BP update is

{col 26}{bf:y}({it:i}) - {bf:B}({it:i}-1){bf:d}({it:i})
{pmore}
{bf:B}({it:i}) = {bf:B}({it:i}-1) + {hline 19} {bf:d}({it:i})'{p_end}
{col 30}{bf:d}({it:i})'{bf:d}({it:i})

{pstd}
where {bf:d}({it:i}) = {bf:x}({it:i}) - {bf:x}({it:i}-1) and
{bf:y}({it:i}) = {bf:F}[{bf:x}({it:i})] - {bf:F}[{bf:x}({it:i}-1)].
Our initial estimate of the Jacobian matrix is calculated numerically at the
initial values by using {cmd:deriv()}.  Other than how the Jacobian matrix is
updated, the BP method is identical to Newton's method, including the use of a
step-length parameter determined by using a golden-section line search at each
iteration.


{marker convergence}{...}
{title:Convergence criteria}

{pstd}
{cmd:solvenl_}{it:*}{cmd:()} stops if more than {it:maxiter} iterations are
performed, where {it:maxiter} is {cmd:c(maxiter)} by default and can be changed
by using {cmd:solvenl_init_conv_maxiter()}.  Convergence is not declared after
{it:maxiter} iterations unless one of the following convergence criteria is
also met.

{pstd}
Let {bf:x}({it:i}) denote the proposed solution at iteration {it:i}, and
let {bf:x}({it:i}-1) denote the proposed solution at the previous iteration.
Then the parameters have converged when
{cmd:mreldif(}{bf:x}({it:i}), {bf:x}({it:i}-1){cmd:)} < {it:itol},
where {it:itol} is 1e-9 by default and can be changed by using
{cmd:solvenl_init_conv_iterchng()}.  Techniques GS and dGS use 
only this convergence criterion.

{pstd}
For BP and Newton's method, let
{it:f}({bf:x}) = {bf:F}({bf:x})'{bf:F}({bf:x}).  Then convergence is declared
if {cmd:mreldif(}{bf:x}({it:i}), {bf:x}({it:i}-1){cmd:)} < {it:itol} or
{it:f}({bf:x}) < {it:ztol}, where {it:ztol} is 1e-9 by default and can be
changed by using {cmd:solvenl_init_conv_nearzero()}.


{marker earlyexit}{...}
{title:Exiting early}

{pstd}
In some applications, you might have a condition that indicates your problem
either has no solution or has a solution that you know to be irrelevant.  In
these cases, you can return a column vector with zero rows.  {cmd:solvenl()}
will then exit immediately and return an error code indicating you have
requested an early exit.

{pstd}
To obtain this behavior, include the following code in your evaluator:

{space 8}: {cmd:void function myfun(real colvector from, real colvector values)}
{space 8}>{cmd: {c -(}}
{space 8}>         ...
{space 8}>{cmd:         if (}{it:condition}{cmd:) {c -(}}
{space 8}>{cmd:                 values = J(0, 1, .)}
{space 8}>{cmd:                 return}
{space 8}>{cmd:         {c )-}}
{space 8}>{cmd:         values[1] =  5/3 - 2/3*from[2]}
{space 8}>{cmd:         values[2] = 10/3 - 2/3*from[1]}
{space 8}>         ...
{space 8}>{cmd: {c )-}}

{pstd}
Then if {it:condition} is true, {cmd:solvenl()} exits,
{cmd:solvenl_result_error_code()} returns error code 27, and
{cmd:solvenl_result_converged()} returns 0 (indicating a solution has not
been found).


{marker functions}{...}
{title:Functions}

{marker init}{...}
{title:solvenl_init()}

{space 8}{cmd:solvenl_init()}

{pstd}
{cmd:solvenl_init()} is used to initialize the solver.  Store the returned
result in a variable name of your choosing; we use the letter {it:S}.
You pass {it:S} as the first argument to the other {cmd:solvenl()} suite of
functions.

{pstd}
{cmd:solvenl_init()} sets all {cmd:solvenl_init_}{it:*}{cmd:()} values to their
defaults.  You can use the query form of the {cmd:solvenl_init_}{it:*}{cmd:()}
functions to determine their values.  Use {cmd:solvenl_dump()} to see the
current state of the solver, including the current values of the
{cmd:solvenl_init_}{it:*}{cmd:()} parameters.


{marker init_type}{...}
{title:solvenl_init_type()}

{space 8}{it:void}{space 9} {cmd:solvenl_init_type(}{it:{help mf_solvenl##S:S}}{cmd:,} {c -(} {cmd:"fixedpoint"} {c |} {cmd:"zero"} {c )-} {cmd:)}

{space 8}{it:string scalar} {cmd:solvenl_init_type(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_type(}{it:S}{cmd:,} {it:type}{cmd:)} specifies whether to
find a fixed point or a zero of the function.  {it:type} may be
{cmd:fixedpoint} or {cmd:zero}.

{pstd}
If you specify {cmd:solvenl_init_type(}{it:S}{cmd:, "fixedpoint")} but have not
yet specified a {help mf_solvenl##technique:{it:technique}}, then {it:technique}
is set to {cmd:dampedgaussseidel}.

{pstd}
If you specify {cmd:solvenl_init_type(}{it:S}{cmd:, "zero")} but have not
yet specified a {help mf_solvenl##technique:{it:technique}}, then {it:technique}
is set to {cmd:broydenpowell}.

{pstd}
{cmd:solvenl_init_type(}{it:S}{cmd:)} returns {cmd:"fixedpoint"} or {cmd:"zero"}
depending on how the solver is currently set.


{marker init_startingvals}{...}
{title:solvenl_init_startingvals()}

{space 8}{it:void}{space 11}{cmd:solvenl_init_startingvals(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:real colvector ivals}{cmd:)}

{space 8}{it:real colvector} {cmd:solvenl_init_startingvals(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_startingvals(}{it:S}, {it:ivals}{cmd:)} sets the initial
values for the solver to {it:ivals}.  By default, {it:ivals} is set to the
zero vector.

{pstd}
{cmd:solvenl_init_startingvals(}{it:S}{cmd:)} returns the currently set initial
values.


{marker init_numeq}{...}
{title:solvenl_init_numeq()}

{space 8}{it:void}{space 8}{cmd:solvenl_init_numeq(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:real scalar k}{cmd:)}

{space 8}{it:real scalar} {cmd:solvenl_init_numeq(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_numeq(}{it:S}, {it:k}{cmd:)} sets the number of equations in
the system to {it:k}.

{pstd}
{cmd:solvenl_init_numeq(}{it:S}{cmd:)} returns the currently specified number
of equations.


{marker init_technique}{...}
{title:solvenl_init_technique()}

{space 8}{it:void}{space 10}{cmd:solvenl_init_technique(}{it:{help mf_solvenl##S:S}}{cmd:,} {help mf_solvenl##technique:{it:technique}}{cmd:)}

{space 8}{it:string scalar} {cmd:solvenl_init_technique(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_technique(}{it:S}{cmd:,} {it:technique}{cmd:)} specifies the
solver technique to use.  For more information, see
{help mf_solvenl##technique:{it:technique}} above.

{pstd}
If you specify {it:technique}s {cmd:gaussseidel} or {cmd:dampedgaussseidel}
but have not yet called {cmd:solvenl_init_type()}, {cmd:solvenl_}{it:*}{cmd:()}
assumes you are solving a fixed-point problem until you specify otherwise.

{pstd}
If you specify {it:technique}s {cmd:broydenpowell} or {cmd:newtonraphson}
but have not yet called {cmd:solvenl_init_type()}, {cmd:solvenl_}{it:*}{cmd:()}
assumes you have a zero-finding problem until you specify otherwise.

{pstd}
{cmd:solvenl_init_technique(}{it:S}{cmd:)} returns the currently set solver
technique.


{marker init_conv_iterchng}{...}
{title:solvenl_init_conv_iterchng()}

{space 8}{it:void}{space 8}{cmd:solvenl_init_conv_iterchng(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:itol}{cmd:)}

{space 8}{it:real scalar} {cmd:solvenl_init_conv_iterchng(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_conv_iterchng(}{it:S}{cmd:,} {it:itol}{cmd:)} specifies the
tolerance used to determine whether successive estimates of the solution
have converged.  Convergence is declared when
{cmd:mreldif(}{bf:x}({it:i}), {bf:x}({it:i}-1){cmd:)} < {it:itol}.
For more information, see
{it:{help mf_solvenl##convergence:Convergence criteria}} above.  The default is
1e-9.

{pstd}
{cmd:solvenl_init_conv_iterchng(}{it:S}{cmd:)} returns the currently set
value of {it:itol}.


{marker init_conv_nearzero}{...}
{title:solvenl_init_conv_nearzero()}

{space 8}{it:void}{space 8}{cmd:solvenl_init_conv_nearzero(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:ztol}{cmd:)}

{space 8}{it:real scalar} {cmd:solvenl_init_conv_nearzero(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_conv_nearzero(}{it:S}{cmd:,} {it:ztol}{cmd:)} specifies the
tolerance used to determine whether the proposed solution to a zero-finding
problem is sufficiently close to 0 based on the squared Euclidean distance.
For more information, see
{it:{help mf_solvenl##convergence:Convergence criteria}} above.  The default is
1e-9.

{pstd}
{cmd:solvenl_init_conv_nearzero(}{it:S}{cmd:)} returns the currently set value
of {it:ztol}.

{pstd}
{cmd:solvenl_init_conv_nearzero()} only applies to zero-finding problems.
{cmd:solvenl_}{it:*}{cmd:()} simply ignores this criterion when solving
fixed-point problems.


{marker init_conv_maxiter}{...}
{title:solvenl_init_conv_maxiter()}

{space 8}{it:void}{space 8}{cmd:solvenl_init_conv_maxiter(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:maxiter}{cmd:)}

{space 8}{it:real scalar} {cmd:solvenl_init_conv_maxiter(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_conv_maxiter(}{it:S}{cmd:,} {it:maxiter}{cmd:)} specifies the
maximum number of iterations to perform.  Even if {it:maxiter} iterations are
performed, convergence is not declared unless one of the other convergence
criteria is also met.  For more information, see
{it:{help mf_solvenl##convergence:Convergence criteria}} above.
The default {it:maxiter} is the number set using {helpb set maxiter}, which is
INCLUDE help maxiter
by default.

{pstd}
{cmd:solvenl_init_conv_maxiter(}{it:S}{cmd:)} returns the currently set value
of {it:maxiter}.


{marker init_evaluator}{...}
{title:solvenl_init_evaluator()}

{space 8}{it:void} {cmd:solvenl_init_evaluator(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:pointer(real function) scalar fptr}{cmd:)}

{space 8}{it:pointer(real function) scalar} {cmd:solvenl_init_evaluator(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_evaluator(}{it:S}{cmd:,} {it:fptr}{cmd:)} specifies the
function to be called to evaluate {bf:F}({bf:x}).  You must use this function.
If your function is named {cmd:myfcn()}, then you specify
{cmd:solvenl_init_evaluator(}{it:S}{cmd:, &myfcn())}.

{pstd}
{cmd:solvenl_init_evaluator(}{it:S}{cmd:)} returns a pointer to the function
that has been set.


{marker init_narguments}{...}
{marker init_argument}{...}
{title:solvenl_init_argument() and solvenl_init_narguments()}

{space 8}{it:void}{space 11}{cmd:solvenl_init_argument(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:real scalar k}{cmd:,} {it:X}{cmd:)}

{space 8}{it:void}{space 11}{cmd:solvenl_init_narguments(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:real scalar K}{cmd:)}

{space 8}{it:pointer scalar} {cmd:solvenl_init_argument(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:real scalar k}{cmd:)}

{space 8}{it:real scalar}{space 4}{cmd:solvenl_init_narguments(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_argument(}{it:S}{cmd:,} {it:k}{cmd:,} {it:X}{cmd:)} sets
the {it:k}th extra argument of the evaluator function as {it:X}, where
{it:k} can be 1, 2, or 3.  If you need to pass more items to your evaluator,
collect them into a structure and pass the structure.  {it:X} can be
anything, including a pointer, a view matrix, or simply a scalar.
No copy of {it:X} is made; it is passed by reference.  Any changes
you make to {it:X} elsewhere in your program will be reflected in what
is passed to your evaluator function.

{pstd}
{cmd:solvenl_init_narguments(}{it:S}{cmd:,} {it:K}{cmd:)} sets the number of
extra arguments to be passed to your evaluator function.  Use of this
function is optional; initializing an additional argument by using
{cmd:solvenl_init_argument()} automatically sets the number of arguments.

{pstd}
{cmd:solvenl_init_argument(}{it:S}{cmd:,} {it:k}{cmd:)} returns a pointer
to the previously set {it:k}th additional argument.

{pstd}
{cmd:solvenl_init_narguments(}{it:S}{cmd:)} returns the number of extra arguments
that are passed to the evaluator function.


{marker init_damping}{...}
{title:solvenl_init_damping()}

{space 8}{it:void}{space 8}{cmd:solvenl_init_damping(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:real scalar d}{cmd:)}

{space 8}{it:real scalar}{space 1}{cmd:solvenl_init_damping(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_damping(}{it:S}{cmd:,} {it:d}{cmd:)} sets the damping
parameter used by the damped Gauss-Seidel technique to {it:d}, where
0 <= {it:d} < 1.  That is, {it:d} = 0 corresponds to no damping, which is
equivalent to plain Gauss-Seidel.  As {it:d} approaches 1, more damping is
used.  The default is {it:d} = 0.1.  If the dGS technique is not being used,
this parameter is ignored.

{pstd}
{cmd:solvenl_init_damping(}{it:S}{cmd:)} returns the currently set damping
parameter.


{marker init_iter_log}{...}
{title:solvenl_init_iter_log()}

{space 8}{it:void}{space 10}{...}
{cmd:solvenl_init_iter_log(}{it:{help mf_solvenl##S:S}}{cmd:,} {c -(} {cmd:"on"} | {cmd:"off"} {c )-} {cmd:)}

{space 8}{it:string scalar} {...}
{cmd:solvenl_init_iter_log(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_iter_log(}{it:S}{cmd:,} {it:onoff}{cmd:)} {...}
specifies whether an iteration log should or should not be displayed.
{it:onoff} may be {cmd:on} or {cmd:off}.  By default, an iteration
log is displayed unless {cmd:set iterlog} is set to {cmd:off}; see
{manhelp set_iter R:{it:set iter}}.

{pstd}
{cmd:solvenl_init_iter_log(}{it:S}{cmd:)} returns the current status of the
iteration log indicator.


{marker init_iter_dot}{...}
{title:solvenl_init_iter_dot()}

{space 8}{it:void}{space 10}{...}
{cmd:solvenl_init_iter_dot(}{it:{help mf_solvenl##S:S}}{cmd:,} {c -(} {cmd:"on"} | {cmd:"off"} {c )-} {cmd:)}

{space 8}{it:string scalar} {...}
{cmd:solvenl_init_iter_dot(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_iter_dot(}{it:S}{cmd:,} {it:onoff}{cmd:)} {...}
specifies whether an iteration dot should or should not be displayed.
{it:onoff} may be {cmd:on} or {cmd:off}.  By default, an iteration
dot is not displayed.

{pstd}
Specifying {cmd:solvenl_init_iter_dot(}{it:S}{cmd:, on)} results in the 
display of a single dot without a new line after each iteration is completed.
This option can be used to create a compact status report when a full
iteration log is too detailed but some indication of activity is warranted.

{pstd}
{cmd:solvenl_init_iter_dot(}{it:S}{cmd:)} returns the current status of the
iteration dot indicator.


{marker init_iter_dot_indent}{...}
{title:solvenl_init_iter_dot_indent()}

{space 8}{it:void}{space 8}{...}
{cmd:solvenl_init_iter_dot_indent(}{it:{help mf_solvenl##S:S}}{cmd:,} {it:real scalar indent}{cmd:)}

{space 8}{it:real scalar} {...}
{cmd:solvenl_init_iter_dot_indent(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_init_iter_dot_indent(}{it:S}{cmd:,} {it:indent}{cmd:)} {...}
specifies how many spaces from the left edge iteration dots should begin.
This option is useful if you are writing a program that calls {cmd:solvenl()}
and if you want to control how the iteration dots appear to the user.  By
default, the dots start at the left edge ({it:indent} = 0).  If you do not
turn on iteration dots with {cmd:solvenl_init_iter_dot()}, this option is
ignored.

{pstd}
{cmd:solvenl_init_iter_dot_indent(}{it:S}{cmd:)} returns the current amount
of indentation.


{marker solve}{...}
{marker _solve}{...}
{title:solvenl_solve() and _solvenl_solve()}

{space 8}{it:real colvector}  {cmd:solvenl_solve(}{it:{help mf_solvenl##S:S}}{cmd:)}

{space 8}{it:void}{space 11}{cmd:_solvenl_solve(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_solve(}{it:S}{cmd:)} invokes the solver and returns the resulting
solution.  If an error occurs, {cmd:solvenl_solve()} aborts with error.

{pstd}
{cmd:_solvenl_solve(}{it:S}{cmd:)} also invokes the solver.  Rather than
returning the solution, this function returns an error code if something
went awry.  If the solver did find a solution, this function returns {cmd:0}.
See below for a list of the possible error codes.

{pstd}
Before calling either of these functions, you must have defined your problem.
At a minimum, this involves calling the following functions:

{space 8}{cmd:solvenl_init()}
{space 8}{cmd:solvenl_init_numeq()}
{space 8}{cmd:solvenl_init_evaluator()}
{space 8}{cmd:solvenl_init_type()}{space 3}or{space 3}{cmd:solvenl_init_technique()}


{marker result_converged}{...}
{title:solvenl_result_converged()}

{space 8}{it:real scalar} {cmd:solvenl_result_converged(}{...}
{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_result_converged(}{it:S}{cmd:)} returns {cmd:1} if the solver
found a solution to the problem and {cmd:0} otherwise.


{marker result_conv_iter} {...}
{title:solvenl_result_conv_iter()}

{space 8}{it:real scalar} {...}
{cmd:solvenl_result_conv_iter(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_result_conv_iter(}{it:S}{cmd:)} returns the number of iterations
required to obtain the solution.  If a solution was not found or the solver
has not yet been called, this function returns missing.


{marker result_conv_iterchng}{...}
{title:solvenl_result_conv_iterchng()}

{space 8}{it:real scalar} {...}
{cmd:solvenl_result_conv_iterchng(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_result_conv_iterchng(}{it:S}{cmd:)} returns the final tolerance
achieved for the parameters if a solution has been reached.  Otherwise, this
function returns missing.  For more information, see
{it:{help mf_solvenl##convergence:Convergence criteria}} above.


{marker result_conv_nearzero}{...}
{title:solvenl_result_conv_nearzero()}

{space 8}{it:real scalar} {...}
{cmd:solvenl_result_conv_nearzero(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_result_conv_nearzero(}{it:S}{cmd:)} returns the final distance
the solution lies from zero if a solution has been reached.  Otherwise,
this function returns missing.  This function also returns missing if
called after either GS or dGS was used because this criterion does
not apply.  For more information, see
{it:{help mf_solvenl##convergence:Convergence criteria}} above.


{marker result_values}{...}
{title:solvenl_result_values()}

{space 8}{it:real colvector} {...}
{cmd:solvenl_result_values(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_result_values(}{it:S}{cmd:)} returns the column vector representing
the fixed- or zero-point of the function if a solution was found.  Otherwise,
it returns a 0 x 1 vector of missing values.


{marker result_Jacobian}{...}
{title:solvenl_result_Jacobian()}

{space 8}{it:real matrix} {...}
{cmd:solvenl_result_Jacobian(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_result_Jacobian(}{it:S}{cmd:)} returns the last-calculated
Jacobian matrix if BP or Newton's method was used to
find a solution.  The Jacobian matrix is returned even if a solution was not
found because we have found the Jacobian matrix to be useful in pinpointing
problems.  This function returns a 1 x 1 matrix of missing values if called
after either GS or dGS was used.


{marker result_error_code}{...}
{marker result_return_code}{...}
{marker result_error_text}{...}
{title:solvenl_result_error_code(), ..._return_code(), and ..._error_text()}

{space 8}{it:real scalar}{space 3}{...}
{cmd:solvenl_result_error_code(}{it:{help mf_solvenl##S:S}}{cmd:)}

{space 8}{it:real scalar}{space 3}{...}
{cmd:solvenl_result_return_code(}{it:{help mf_solvenl##S:S}}{cmd:)}

{space 8}{it:string scalar} {...}
{cmd:solvenl_result_error_text(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_result_error_code(}{it:S}{cmd:)} returns the unique
{cmd:solvenl_}{it:*}{cmd:()} error code generated or zero if there was no error.
Each error that can be produced by the system is assigned its own unique code.

{pstd}
{cmd:solvenl_result_return_code(}{it:S}{cmd:)} returns the appropriate return
code to be returned to the user if an error was produced.

{pstd}
{cmd:solvenl_result_error_text(}{it:S}{cmd:)} returns an appropriate textual
description to be displayed if an error was produced.

{pstd}
The error codes, return codes, and error text are listed below.

{col 8}Error{space 2}Return
{col 8}code{space 3}code{col 25}Error text
{col 8}{hline 66}
{col 9}0{space 8}0{col 25}(no error encountered)
{col 9}1{space 8}0{col 25}(problem not yet solved)
{col 9}2{space 6}111{col 25}did not specify function
{col 9}3{space 6}198{col 25}invalid number of equations specified
{col 9}4{space 6}504{col 25}initial value vector has missing values
{col 9}5{space 6}503{col 25}initial value vector length does not equal number
{col 27}of equations declared 
{col 9}6{space 6}430{col 25}maximum iterations reached; convergence not achieved
{col 9}7{space 6}416{col 25}missing values encountered when evaluating function
{col 9}8{space 5}3498{col 25}invalid function type
{col 9}9{space 5}3498{col 25}function type ... cannot be used with technique ...
{col 8}10{space 5}3498{col 25}invalid log option
{col 8}11{space 5}3498{col 25}invalid solution technique
{col 8}12{space 5}3498{col 25}solution technique {it:technique} cannot be used with
{col 27}function type {c -(}{cmd:"fixedpoint"} | {cmd:"zero"}{c )-}
{col 8}13{space 5}3498{col 25}invalid iteration change criterion
{col 8}14{space 5}3498{col 25}invalid near-zeroness criterion
{col 8}15{space 5}3498{col 25}invalid maximum number of iterations criterion
{col 8}16{space 5}3498{col 25}invalid function pointer
{col 8}17{space 5}3498{col 25}invalid number of arguments
{col 8}18{space 5}3498{col 25}optional argument out of range
{col 8}19{space 5}3498{col 25}could not evaluate function at initial values
{col 8}20{space 5}3498{col 25}could not calculate Jacobian at initial values
{col 8}21{space 5}3498{col 25}iterations found local minimum of {bf:F}'{bf:F}; convergence
{col 27}not achieved
{col 8}22{space 5}3498{col 25}could not calculate Jacobian matrix
{col 8}23{space 6}198{col 25}damping factor must be in [0, 1)
{col 8}24{space 6}198{col 25}must specify a function type, technique, or both
{col 8}25{space 5}3498{col 25}invalid {cmd:solvenl_init_iter_dot()} option
{col 8}26{space 5}3498{col 25}{cmd:solvenl_init_iter_dot_indent()} must be a nonnegative
{col 27}integer less than 78
{col 8}27{space 6}498{col 25}the function evaluator requested that {cmd:solvenl_solve()}
{col 27}exit immediately


{marker dump}{...}
{title:solvenl_dump()}

{space 8}{it:void} {cmd:solvenl_dump(}{it:{help mf_solvenl##S:S}}{cmd:)}

{pstd}
{cmd:solvenl_dump(}{it:S}{cmd:)} displays the current status of the solver,
including initial values, convergence criteria, results, and error messages.
This function is particularly useful while debugging.


{marker conformability}
{title:Conformability}

{pstd}
All functions' inputs are 1 {it:x} 1 and return 1 {it:x} 1 or {it:void}
results except as noted below:

{space 4}{cmd:solvenl_init_startingvals(}{it:S}{cmd:,} {it:ivals}{cmd:)}:
{space 16}{it:S}:  {it:transmorphic}
{space 12}{it:ivals}:  {it:k x} 1
{space 11}{it:result}:  {it:void}

{space 4}{cmd:solvenl_init_startingvals(}{it:S}{cmd:)}:
{space 16}{it:S}:  {it:transmorphic}
{space 11}{it:result}:  {it:k x} 1

{space 4}{cmd:solvenl_init_argument(}{it:S}{cmd:,} {it:k}{cmd:,} {it:X}{cmd:)}:
{space 16}{it:S}:  {it:transmorphic}
{space 16}{it:k}:  1 {it:x} 1
{space 16}{it:X}:  {it:anything}
{space 11}{it:result}:  {it:void}

{space 4}{cmd:solvenl_init_argument(}{it:S}{cmd:,} {it:k}{cmd:)}:
{space 16}{it:S}:  {it:transmorphic}
{space 16}{it:k}:  1 {it:x} 1
{space 11}{it:result}:  {it:anything}

{space 4}{cmd:solvenl_solve(}{it:S}{cmd:)}:
{space 16}{it:S}:  {it:transmorphic}
{space 11}{it:result}:  {it:k x} 1

{space 4}{cmd:solvenl_result_values(}{it:S}{cmd:)}:
{space 16}{it:S}:  {it:transmorphic}
{space 11}{it:result}:  {it:k x} 1

{space 4}{cmd:solvenl_result_Jacobian(}{it:S}{cmd:)}:
{space 16}{it:S}:  {it:transmorphic}
{space 11}{it:result}:  {it:k x} {it:k}


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
All functions abort with an error if used incorrectly.

{pstd}
{cmd:solvenl_solve()} aborts with an error if it encounters difficulties.
{cmd:_solvenl_solve()} does not; instead, it returns a nonzero error code.

{pstd}
The {cmd:solvenl_result_}{it:*}{cmd:()} functions return missing values if the
solver encountered difficulties or else has not yet been invoked.


{marker references}{...}
{title:References}

{marker BurdenFaires2016}{...}
{phang}
Burden, R. L., D. J. Faires, and A. M. Burden. 2016. {it:Numerical Analysis}.
10th ed.  Boston: Cengage.
{p_end}

{marker PressEtAl2007}{...}
{phang}
Press, W. H., S. A. Teukolsky, W. T. Vetterling, and B. P. Flannery. 2007. 
{it:Numerical Recipes: The Art of Scientific Computing}. 3rd ed. 
New York: Cambridge University Press.
{p_end}
