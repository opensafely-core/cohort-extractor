{smcl}
{* *! version 1.1.16  10dec2019}{...}
{vieweralsosee "[M-5] deriv()" "mansection M-5 deriv()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] Quadrature()" "help mf_quadrature"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{viewerjumpto "Syntax" "mf_deriv##syntax"}{...}
{viewerjumpto "Description" "mf_deriv##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_deriv##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_deriv##remarks"}{...}
{viewerjumpto "Conformability" "mf_deriv##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_deriv##diagnostics"}{...}
{viewerjumpto "Source code" "mf_deriv##source"}{...}
{viewerjumpto "Methods and formulas" "mf_deriv##methods"}{...}
{viewerjumpto "Reference" "mf_deriv##reference"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] deriv()} {hline 2}}Numerical derivatives
{p_end}
{p2col:}({mansection M-5 deriv():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 19 8 2}
{it:{help mf_deriv##D:D}} 
{cmd:=}
{cmd:deriv_init()}


{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_evaluator(}{it:{help mf_deriv##D:D}} [{cmd:,}
{cmd:&}{it:function}{cmd:()}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_evaluatortype(}{it:{help mf_deriv##D:D}} [{cmd:,}
{it:{help mf_deriv##evaluatortype:evaluatortype}}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_params(}{it:{help mf_deriv##D:D}} [{cmd:,}
{it:real rowvector parameters}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_argument(}{it:{help mf_deriv##D:D}}{cmd:,}
{it:real scalar k} [{cmd:,}
{it:X}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_narguments(}{it:{help mf_deriv##D:D}} [{cmd:,}
{it:real scalar K}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_weights(}{it:{help mf_deriv##D:D}} [{cmd:,}
{it:real colvector weights}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_h(}{it:{help mf_deriv##D:D}} [{cmd:,}
{it:real rowvector h}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_scale(}{it:{help mf_deriv##D:D}} [{cmd:,}
{it:real matrix scale}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_bounds(}{it:{help mf_deriv##D:D}} [{cmd:,}
{it:real rowvector minmax}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_search(}{it:{help mf_deriv##D:D}} [{cmd:,}
{it:{help mf_deriv##search:search}}] {cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv_init_verbose(}{it:{help mf_deriv##D:D}} [{cmd:,}
{c -(}{cmd:"on"} | {cmd:"off"}{c )-}] {cmd:)}


{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:deriv(}{it:{help mf_deriv##D:D}}{cmd:,} {c -(}{cmd:0} | {cmd:1} | {cmd:2}{c )-}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:  }
{cmd:_deriv(}{it:{help mf_deriv##D:D}}{cmd:,} {c -(}{cmd:0} | {cmd:1} | {cmd:2}{c )-}{cmd:)}


{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:deriv_result_value(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:real vector}
{cmd:deriv_result_values(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:void}{bind:         }
{cmd:_deriv_result_values(}{it:{help mf_deriv##D:D}}{cmd:,} {it:v}{cmd:)}

{p 8 25 2}
{it:real rowvector}
{cmd:deriv_result_gradient(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:void}{bind:         }
{cmd:_deriv_result_gradient(}{it:{help mf_deriv##D:D}}{cmd:,} {it:g}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:deriv_result_scores(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:void}{bind:         }
{cmd:_deriv_result_scores(}{it:{help mf_deriv##D:D}}{cmd:,} {it:S}{cmd:)}

{p 8 25 2}
{it:real matrix}
{cmd:deriv_result_Jacobian(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:void}{bind:         }
{cmd:_deriv_result_Jacobian(}{it:{help mf_deriv##D:D}}{cmd:,} {it:J}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:deriv_result_Hessian(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:void}{bind:         }
{cmd:_deriv_result_Hessian(}{it:{help mf_deriv##D:D}}{cmd:,} {it:H}{cmd:)}

{p 8 25 2}
{it:real rowvector}
{cmd:deriv_result_h(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:deriv_result_scale(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:deriv_result_delta(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:deriv_result_errorcode(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:string scalar}{bind: }
{cmd:deriv_result_errortext(}{it:{help mf_deriv##D:D}}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:deriv_result_returncode(}{it:{help mf_deriv##D:D}}{cmd:)}


{p 8 25 2}
{it:void}{bind:          }
{cmd:deriv_query(}{it:{help mf_deriv##D:D}}{cmd:)}


{marker D}{...}
{pstd}
where {it:D}, if it is declared, should be declared

		{cmd:transmorphic} {it:D}


{marker evaluatortype}{...}
{pstd}
and where {it:evaluatortype} optionally specified in 
{cmd:deriv_init_evaluatortype()} is

{p2colset 16 32 34 2}{...}
{p2col :{it:evaluatortype}}Description{p_end}
{p2line}
{p2col :{cmd:"d"}}{it:function}{cmd:()} returns {it:scalar} value{p_end}
{p2col :{cmd:"v"}}{it:function}{cmd:()} returns {it:colvector} value{p_end}
{p2col :{cmd:"t"}}{it:function}{cmd:()} returns {it:rowvector} value{p_end}
{p2line}
{col 16}The default is {cmd:"d"} if not set.
{p2colreset}{...}


{marker search}{...}
{pstd}
and where {it:search} optionally specified in 
{cmd:deriv_init_search()} is

{p2colset 16 32 34 2}{...}
{p2col :{it:search}}Description{p_end}
{p2line}
{p2col :{cmd:"interpolate"}}use
	linear and quadratic interpolation to search for an optimal
	delta{p_end}
{p2col :{cmd:"bracket"}}use
	a bracketed quadratic formula to search for an optimal delta{p_end}
{p2col :{cmd:"off"}}do not search for an optimal delta{p_end}
{p2line}
{col 16}The default is {cmd:"interpolate"} if not set.
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
These functions compute derivatives of the real function
{it:f}({it:p}) at the real parameter values {it:p}.

{pstd}
{cmd:deriv_init()} begins the definition of a problem and returns 
{it:D}, a problem-description handle set that contains default values.

{pstd}
The 
{cmd:deriv_init_}{it:*}{cmd:(}{it:D}{cmd:,} ...{cmd:)} functions then allow
you to modify those defaults.  You use these functions to describe your 
particular problem:  
to set the identity of function {it:f}(), 
to set parameter values, and the like.

{pstd}
{cmd:deriv}{cmd:(}{it:D}{cmd:,} {it:todo}{cmd:)}
then computes derivatives depending upon the value of {it:todo}.

{phang2}
{cmd:deriv}{cmd:(}{it:D}{cmd:, 0)}
returns the function value without computing derivatives.

{phang2}
{cmd:deriv}{cmd:(}{it:D}{cmd:, 1)}
returns the first derivatives, also known as the gradient vector for
scalar-valued functions (type {cmd:d} and {cmd:v}) or the Jacobian matrix for
vector-valued functions (type {cmd:t}).

{phang2}
{cmd:deriv}{cmd:(}{it:D}{cmd:, 2)}
returns the matrix of second derivatives, also known as the Hessian
matrix; the gradient vector is also computed.  This syntax is not allowed for
type {cmd:t} evaluators.

{pstd}
The {cmd:deriv_result_}{it:*}{cmd:(}{it:D}{cmd:)} functions can then be
used to access other values associated with the solution.

{pstd}
Usually you would stop there.  In other cases, you could compute derivatives
at other parameter values:

		{cmd:deriv_init_params(}{it:D}{cmd:,} {it:p_alt}{cmd:)}
		{cmd:deriv(}{it:D}{cmd:,} {it:todo}{cmd:)}

{pstd}
Aside:

{pstd}
The {cmd:deriv_init_}{it:*}{cmd:(}{it:D}{cmd:,} ...{cmd:)} functions have
two modes of operation.  Each has an optional argument that you specify to set
the value and that you omit to query the value.
For instance, the full syntax of
{cmd:deriv_init_params()} is

		{it:void} {cmd:deriv_init_params(}{it:D}{cmd:,} {it:real rowvector parameters}{cmd:)}

		{it:real rowvector} {cmd:deriv_init_params(}{it:D}{cmd:)}

{pstd}
The first syntax sets the parameter values and returns nothing.
The second syntax returns 
the previously set (or default, if not set) parameter values.

{pstd} All the {cmd:deriv_init_}{it:*}{cmd:(}{it:D}{cmd:,}
...{cmd:)} functions work the same way.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 deriv()Remarksandexamples:Remarks and examples}

        {mansection M-5 deriv()Methodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help mf_deriv##example1:First example}
	{help mf_deriv##notation:Notation and formulas}
	{help mf_deriv##type_d:Type d evaluators}
	{help mf_deriv##example2:Example of a type d evaluator}
	{help mf_deriv##type_v:Type v evaluators}
	{help mf_deriv##args:User-defined arguments}
	{help mf_deriv##example3:Example of a type v evaluator}
	{help mf_deriv##type_t:Type t evaluators}
	{help mf_deriv##example4:Example of a type t evaluator}

	{help mf_deriv##functions:Functions}
	    {help mf_deriv##i_:deriv_init()}
	    {help mf_deriv##i_evaluator:deriv_init_evaluator() and deriv_init_evaluatortype()}
	    {help mf_deriv##i_argument:deriv_init_argument() and deriv_init_narguments()}
	    {help mf_deriv##i_weights:deriv_init_weights()}
	    {help mf_deriv##i_params:deriv_init_params()}

	    {help mf_deriv##i_adv:Advanced init functions}
		{help mf_deriv##i_h:deriv_init_h(), ..._scale(), ..._bounds(), and ..._search()}
		{help mf_deriv##i_verbose:deriv_init_verbose()}

	    {help mf_deriv##deriv:deriv()}
	   {help mf_deriv##_deriv:_deriv()}

	    {help mf_deriv##r_value:deriv_result_value()}
	    {help mf_deriv##r_values:deriv_result_values() and _deriv_result_values()}
	    {help mf_deriv##r_gradient:deriv_result_gradient()}
	   {help mf_deriv##r_gradient:_deriv_result_gradient()}
	    {help mf_deriv##r_scores:deriv_result_scores()}
	   {help mf_deriv##r_scores:_deriv_result_scores()}
	    {help mf_deriv##r_Jacobian:deriv_result_Jacobian()}
	   {help mf_deriv##r_Jacobian:_deriv_result_Jacobian()}
	    {help mf_deriv##r_hessian:deriv_result_Hessian()}
	   {help mf_deriv##r_hessian:_deriv_result_Hessian()}
	    {help mf_deriv##r_delta:deriv_result_h()}
	    {help mf_deriv##r_delta:deriv_result_scale()}
	    {help mf_deriv##r_delta:deriv_result_delta()}
	    {help mf_deriv##r_error:deriv_result_errorcode()}
	    {help mf_deriv##r_error:deriv_result_errortext()}
	    {help mf_deriv##r_error:deriv_result_returncode()}

	    {help mf_deriv##query:deriv_query()}


{marker example1}{...}
{title:First example}

{pstd}
The derivative functions may be used interactively.

{pstd}
Below we use the functions to 
compute {it:f}'({it:x}) at {it:x}=0, where the function is

{pmore}
{it:f}({it:x}) = exp(-{it:x}^2+{it:x}-3)

{* deriv1.smcl from deriv.do}{...}
	{cmd:: void myeval(x, y)}
	> {cmd:{c -(}}
	>         {cmd:y = exp(-x^2 + x - 3)}
	> {cmd:{c )-}}

	{cmd:: D = deriv_init()}

	{cmd:: deriv_init_evaluator(D, &myeval())}

	{cmd:: deriv_init_params(D, 0)}

	{cmd:: dydx = deriv(D, 1)}

	{cmd:: dydx}
	  .0497870683

	{cmd:: exp(-3)}
	  .0497870684

{pstd}
The derivative, given the above function, is
{it:f}'({it:x}) = (-2*{it:x}+1)*exp(-{it:x}^2+{it:x}-3),
so {it:f}'(0) = exp(-3).


{marker notation}{...}
{title:Notation and formulas}

{pstd}
We wrote the above in the way that mathematicians think, that is, 
differentiate {it:y}={it:f}({it:x}).  Statisticians, on the other hand,
think differentiate {it:s}={it:f}({it:b}).  To avoid
favoritism, we will write {it:v}={it:f}({it:p}) and write
the general problem with the following notation:

{p 8 8 2}
Differentiate {it:v} = {it:f}({it:p}) with respect to {it:p}, where

		{it:v}:  a scalar 

		{it:p}:  1 {it:x} {it:np}

{p 8 8 2}
The gradient vector is 
{it:g} = {it:f'}({it:p}) = d{it:f}/d{it:p}, where

		{it:g}:  1 {it:x} {it:np}

{p 8 8 2}
and the Hessian matrix is 
{it:H} = {it:f''}({it:p}) = d^2{it:f}/d{it:p}d{it:p}', where

		{it:H}:  {it:np} {it:x} {it:np}

{pstd}
{cmd:deriv()} can also work with vector-valued functions.  Here is the
notation for vector-valued functions:

{p 8 8 2}
Differentiate {it:v} = {it:f}({it:p}) with respect to {it:p}, where

		{it:v}:  1 {it:x} {it:nv}, a vector 

		{it:p}:  1 {it:x} {it:np}

{p 8 8 2}
The Jacobian matrix is 
{it:J} = {it:f'}({it:p}) = d{it:f}/d{it:p}, where

		{it:J}:  {it:nv} {it:x} {it:np}

{p 8 8 2}
and where

		{it:J}[{it:i},{it:j}] = d{it:v}[{it:i}]/d{it:p}[{it:j}]

{p 8 8 2}
Second-order derivatives are not computed by {cmd:deriv()}
when used with vector-valued functions.

{pstd}
{cmd:deriv()} uses the following formula for computing the numerical
derivative of {it:f}() at {it:p}

			~   {it:f}({it:p}+{it:d}) - {it:f}({it:p}-{it:d})
		{it:f}'({it:p})   =   {hline 15}
			          2*{it:d}

{pstd}
where we refer to {it:d} as the delta used for computing numerical derivatives.
To search for an optimal delta, we decompose {it:d} into two parts.

		{it:d} = {it:h}*{it:scale}

{pstd}
By default, {it:h} is a fixed value that depends on the parameter value.

		{it:h} = {cmd:(abs(}{it:p}{cmd:)+1e-3)*1e-3}

{pstd}
{cmd:deriv()} searches for a value of {it:scale} that will result in
an optimal numerical derivative, that is, one where {it:d} is as small as
possible subject to the constraint that
{it:f}({it:x}+{it:d}) - {it:f}({it:x}-{it:d})
will be calculated to at least half the accuracy of a double-precision number.
This is accomplished by searching for {it:scale} such that
|{it:f}({it:x}) - {it:f}({it:x}-{it:d})| falls between {it:v0} and
{it:v1}, where

		{it:v0} = {cmd:(abs(}{it:f}{cmd:(}{it:x}{cmd:))}{cmd:+}{cmd:1e-8)*1e-8}
		{it:v1} = {cmd:(abs(}{it:f}{cmd:(}{it:x}{cmd:))}{cmd:+}{cmd:1e-7)*1e-7}

{pstd}
Use {helpb mf_deriv##i_h:deriv_init_h()} to change the default {it:h} values.
Use {helpb mf_deriv##i_h:deriv_init_scale()} to change the default initial
{it:scale} values.
Use {helpb mf_deriv##i_h:deriv_init_bounds()} to change the default bounds
({cmd:1e-8}, {cmd:1e-7}) used for determining the optimal {it:scale}.


{marker type_d}{...}
{title:Type d evaluators}

{pstd}
You must write an evaluator function to calculate {it:f}() before
you can use the derivative functions.  The example we showed above was of 
what is called a type {cmd:d} evaluator.  Let's stay with that.

{pstd}
The evaluator function we wrote was 

	{cmd:void myeval(x, y)}
	{cmd:{c -(}}
	        {cmd:y = exp(-x^2 + x - 3)}
	{cmd:{c )-}}

{pstd}
All type {cmd:d} evaluators open the same way, 

	{it:void} {it:evaluator}{cmd:(}{it:x}{cmd:,}  {it:y}{cmd:)}

{pstd}
although what you name the arguments is up to you.  We named the arguments the
way that mathematicians think, although we could just as well have named them
the way that statisticians think:

	{it:void} {it:evaluator}{cmd:(}{it:b}{cmd:,}  {it:s}{cmd:)}

{pstd}
To avoid favoritism, we will write them as 

	{it:void} {it:evaluator}{cmd:(}{it:p}{cmd:,}  {it:v}{cmd:)}

{pstd}
That is, we will think in terms of computing the derivative of 
{it:v}={it:f}({it:p}) with respect to the elements of {it:p}.

{pstd}
Here is the full definition of a type {cmd:d} evaluator:

	{hline 62}
	{it:void} {it:evaluator}{cmd:(}{...}
{it:real rowvector p}{cmd:,}  {it:v}{cmd:)}

	where {it:v} is the value to be returned:

		{it:v}:  {it:real scalar}

	{it:evaluator}{cmd:()} is to fill in {it:v} given the values in {it:p}.

	{it:evaluator}{cmd:()} may return {it:v}={cmd:.} if {it:f}() cannot be evaluated at {it:p}.
	{hline 62}


{marker example2}{...}
{title:Example of a type d evaluator}

{pstd}
We wish to compute the gradient of the following function at {it:p}_1=1 and
{it:p}_2=2:

                          2     2
		{it:v} = exp(-{it:p}  -  {it:p}  -  {it:p p}  +  {it:p}  -  {it:p}  -  3)
                          1     2     1 2     1     2

{pstd} 
Our numerical solution to the problem is

{* deriv2.smcl from deriv.do}{...}
	{cmd:: void eval_d(p, v)}
	> {cmd:{c -(}}
	>         {cmd:v = exp(-p[1]^2 - p[2]^2 - p[1]*p[2] + p[1] - p[2] - 3)}
	> {cmd:{c )-}}

	{cmd:: D = deriv_init()}

	{cmd:: deriv_init_evaluator(D, &eval_d())}

	{cmd:: deriv_init_params(D, (1,2))}

	{cmd:: grad = deriv(D, 1)}

	{cmd:: grad}
	       {txt}           1              2
	    {c TLC}{hline 31}{c TRC}
	  1 {c |}  -.0000501051   -.0001002102{txt}  {c |}
	    {c BLC}{hline 31}{c BRC}

	{cmd:: (-2*1 - 2 + 1)*exp(-1^2 - 2^2 - 1*2 + 1 - 2 - 3)}
	  -.0000501051

	{cmd:: (-2*2 - 1 - 1)*exp(-1^2 - 2^2 - 1*2 + 1 - 2 - 3)}
	  -.0001002102

{pstd}
For this problem, the elements of the gradient function are given by the
following formulas, and we see that {cmd:deriv()} computed values that are in
agreement with the analytical results (to the number of significant digits
being displayed).

	d{it:v}                       2     2
	{hline 3} = (-2{it:p} - {it:p} + 1)exp(-{it:p}  -  {it:p}  -  {it:p p}  +  {it:p}  -  {it:p}  -  3)
	d{it:p}        1   2          1     2     1 2     1     2
          1

	d{it:v}                       2     2
	{hline 3} = (-2{it:p} - {it:p} - 1)exp(-{it:p}  -  {it:p}  -  {it:p p}  +  {it:p}  -  {it:p}  -  3)
	d{it:p}        2   1          1     2     1 2     1     2
          2


{marker type_v}{...}
{title:Type v evaluators}

{pstd}
In some statistical applications, you will find type {cmd:v} evaluators
more convenient to code than type {cmd:d} evaluators.

{pstd}
In statistical applications, one tends to think of a dataset of values
arranged in matrix {it:X}, the rows of which are observations.  The function
{bind:{it:h}({it:p}, {it:X}{cmd:[}{it:i}{cmd:,.]})}
can be calculated for each row
separately, and it is the sum of those resulting values that forms the
function {it:f(}{it:p}) from which we would like to compute derivatives.

{pstd}
Type {cmd:v} evaluators are for such cases.

{pstd}
In a type {cmd:d} evaluator, you return scalar {it:v}={it:f}({it:p}).

{pstd}
In a type {cmd:v} evaluator, you return a column vector,
{it:v}, such that {cmd:colsum(}{it:v}{cmd:)}={it:f}({it:p}).

{pstd}
The code outline for type {cmd:v} evaluators is the same as those for {cmd:d}
evaluators.  All that differs is that {it:v}, which is a {it:real scalar} in
the {cmd:d} case, is now a {it:real colvector} in the {cmd:v} case.


{marker args}{...}
{title:User-defined arguments}

{pstd}
The type {cmd:v} evaluators arise in statistical applications and, in such
applications, there are data; that is, just knowing {it:p} is
not sufficient to calculate {it:v}, {it:g}, and {it:H}.
Actually, that same problem can also arise when coding type {cmd:d} evaluators.

{pstd}
You can pass extra arguments to evaluators.
The first line of all evaluators, regardless of type, is 

		{it:void} {it:evaluator}{cmd:(}{...}
{it:p}{cmd:,}  {it:v}{cmd:)}

{pstd}
If you code 

	{cmd:deriv_init_argument(}{it:D}{cmd:,} {cmd:1,} {it:X}{cmd:)} 

{pstd}
the first line becomes 

		{it:void} {it:evaluator}{cmd:(}{...}
{it:p}{cmd:,}  {it:X}{cmd:,}  {it:v}{cmd:)}

{pstd}
If you code 

	{cmd:deriv_init_argument(}{it:D}{cmd:,} {cmd:1,} {it:X}{cmd:)} 
	{cmd:deriv_init_argument(}{it:D}{cmd:,} {cmd:2,} {it:Y}{cmd:)} 

{pstd}
the first line becomes 

		{it:void} {it:evaluator}{cmd:(}{...}
{it:p}{cmd:,}  {it:X}{cmd:,} {it:Y}{cmd:,}  {it:v}{cmd:)}

{pstd}
and so on, up to nine extra arguments.  
That is, you can specify extra arguments to be passed to your function.


{marker example3}{...}
{title:Example of a type v evaluator}

{pstd}
You have the following data:

{* deriv3a.smcl from deriv.do}{...}
	{cmd:: x}
	        {txt}  1
	     {c TLC}{hline 7}{c TRC}
	   1 {c |}  .35{txt}  {c |}
	   2 {c |}  .29{txt}  {c |}
	   3 {c |}   .3{txt}  {c |}
	   4 {c |}   .3{txt}  {c |}
	   5 {c |}  .65{txt}  {c |}
	   6 {c |}  .56{txt}  {c |}
	   7 {c |}  .37{txt}  {c |}
	   8 {c |}  .16{txt}  {c |}
	   9 {c |}  .26{txt}  {c |}
	  10 {c |}  .19{txt}  {c |}
	     {c BLC}{hline 7}{c BRC}

{pstd}
You believe that the data are the result of a beta distribution process with
fixed parameters alpha and beta, and you wish to compute the gradient vector
and Hessian matrix associated with the log likelihood at some values of
those parameters alpha and beta ({it:a} and {it:b} in what follows).  The
formula for the density of the beta distribution is

			           Gamma({it:a}+{it:b})       {it:a}-1      {it:b}-1
		density({it:x}) =   -----------------   {it:x}    (1-{it:x})
			       Gamma({it:a}) Gamma({it:b})

{pstd}
In our type {cmd:v} solution to this problem, we compute the gradient and Hessian
at a=0.5 and b=2.

{* deriv3b.smcl from deriv.do}{...}
	{cmd:: void lnbetaden_v(p, x, lnf)}
	> {cmd:{c -(}}
	>         {cmd:a = p[1]}
	>         {cmd:b = p[2]}
	>         {cmd:lnf = lngamma(a+b) :- lngamma(a) :- lngamma(b) :+}
	>                 {cmd:(a-1)*log(x) :+ (b-1)*log(1:-x)}
	> {cmd:{c )-}}

	{cmd:: D = deriv_init()}

	{cmd:: deriv_init_evaluator(D, &lnbetaden_v())}

	{cmd:: deriv_init_evaluatortype(D, "v")}

	{cmd:: deriv_init_params(D, (0.5, 2))}

	{cmd:: deriv_init_argument(D, 1, x)} {right:// <- important        }

	{cmd:: deriv(D, 2)}
	{txt}[symmetric]
	                  1              2
	    {c TLC}{hline 31}{c TRC}
	  1 {c |}  -116.4988089               {txt}  {c |}
	  2 {c |}   8.724410052   -1.715062542{txt}  {c |}
	    {c BLC}{hline 31}{c BRC}

	{cmd:: deriv_result_gradient(D)}
	       {txt}           1              2
	    {c TLC}{hline 31}{c TRC}
	  1 {c |}   15.12578465   -1.701917722{txt}  {c |}
	    {c BLC}{hline 31}{c BRC}

{pstd}
Note the following:

{p 8 12 2}
1.  Rather than calling the returned value {cmd:v}, we called it 
    {cmd:lnf}.  You can name the arguments as you please.

{p 8 12 2}
2.  We arranged for an extra argument to be passed by coding 
    {cmd:deriv_init_argument(D,} {cmd:1,} {cmd:x)}.  The extra argument
    is the vector {cmd:x}, which we listed previously for you.
    In our function, we received the argument as {cmd:x}, but we 
    could have used a different name just as we used {cmd:lnf} 
    rather than {cmd:v}.

{p 8 12 2}
3.  We set the evaluator type to {cmd:"v"}.


{marker type_t}{...}
{title:Type t evaluators}

{pstd}
Type {cmd:t} evaluators are for when you need to compute the Jacobian matrix
from a vector-valued function.

{pstd}
Type {cmd:t} evaluators are different from type {cmd:v} evaluators in that the
resulting vector of values should not be summed.  One example is when the
function {it:f}() performs a nonlinear transformation from the domain of
{it:p} to the domain of {it:v}.


{marker example4}{...}
{title:Example of a type t evaluator}

{pstd}
Let's compute the Jacobian matrix for the following transformation:

		{it:v} = {it:p} + {it:p}
                 1   1   2

		{it:v} = {it:p} - {it:p}
                 2   1   2

{pstd}
Here is our numerical solution, evaluating the Jacobian at {it:p} = (0,0):

{* deriv4.smcl from deriv.do}{...}
	{cmd:: void eval_t1(p, v)}
	> {cmd:{c -(}}
	>         {cmd:v = J(1,2,.)}
	>         {cmd:v[1] = p[1] + p[2]}
	>         {cmd:v[2] = p[1] - p[2]}
	> {cmd:{c )-}}

	{cmd:: D = deriv_init()}

	{cmd:: deriv_init_evaluator(D, &eval_t1())}

	{cmd:: deriv_init_evaluatortype(D, "t")}

	{cmd:: deriv_init_params(D, (0,0))}

	{cmd:: deriv(D, 1)}
	{txt}[symmetric]
	        1    2
	    {c TLC}{hline 11}{c TRC}
	  1 {c |}   1     {txt}  {c |}
	  2 {c |}   1   -1{txt}  {c |}
	    {c BLC}{hline 11}{c BRC}


{pstd}
Now let's compute the Jacobian matrix for a less trivial transformation:

                     2
		{it:v} = {it:p}
                 1   1

		{it:v} = {it:p} * {it:p}
                 2   1   2

{pstd}
Here is our numerical solution, evaluating the Jacobian at {it:p} = (1,2):

{* deriv5.smcl from deriv.do}{...}
	{cmd:: void eval_t2(p, v)}
	> {cmd:{c -(}}
	>         {cmd:v = J(1,2,.)}
	>         {cmd:v[1] = p[1]^2}
	>         {cmd:v[2] = p[1] * p[2]}
	> {cmd:{c )-}}

	{cmd:: D = deriv_init()}

	{cmd:: deriv_init_evaluator(D, &eval_t2())}

	{cmd:: deriv_init_evaluatortype(D, "t")}

	{cmd:: deriv_init_params(D, (1,2))}

	{cmd:: deriv(D, 1)}
	       {txt}          1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  1.999999998             0{txt}  {c |}
	  2 {c |}            2             1{txt}  {c |}
	    {c BLC}{hline 29}{c BRC}


{marker functions}{...}
{title:Functions}

{marker i_}{...}
{title:deriv_init()}

{p 8 12 2}
{it:transmorphic} 
{cmd:deriv_init()}

{pstd}
{cmd:deriv_init()} is used to begin a derivative problem.  Store the
returned result in a variable name of your choosing; we have used 
{it:D} in this documentation.  You pass {it:D} 
as the first argument to the other {cmd:deriv}{it:*}{cmd:()} functions.

{pstd}
{cmd:deriv_init()} sets all {cmd:deriv_init_}{it:*}{cmd:()} values to
their defaults.  You may use the query form of
{cmd:deriv_init_}{it:*}{cmd:()} to determine an individual default, or you
can use {cmd:deriv_query()} to see them all.

{pstd}
The query form of 
{cmd:deriv_init_}{it:*}{cmd:()} 
can be used before or after calling
{cmd:deriv()}.


{marker i_evaluator}{...}
{title:deriv_init_evaluator() and deriv_init_evaluatortype()}

{p 8 12 2}
{it:void}
{cmd:deriv_init_evaluator(}{it:D}{cmd:,}
{it:pointer(function) scalar fptr}{cmd:)}

{p 8 25 2}
{it:void}
{cmd:deriv_init_evaluatortype(}{it:D}{cmd:,}
{it:evaluatortype}{cmd:)}


{p 8 12 2}
{it:pointer(function) scalar}
{cmd:deriv_init_evaluator(}{it:D}{cmd:)}

{p 8 25 2}
{it:string scalar}{bind:           }
{cmd:deriv_init_evaluatortype(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_init_evaluator(}{it:D}{cmd:,}
{it:fptr}{cmd:)} specifies the function to be called to evaluate 
{it:f}({it:p}).  Use of this function is required.
If your function is named {cmd:myfcn()}, you code 
{cmd:deriv_init_evaluator(}{it:D}{cmd:,} {cmd:&myfcn())}.

{pstd}
{cmd:deriv_init_evaluatortype(}{it:D}{cmd:,}
{it:evaluatortype}{cmd:)}
specifies the capabilities of the function that has been set using
{cmd:deriv_init_evaluator()}.
Alternatives for {it:evaluatortype} are 
{cmd:"d"},
{cmd:"v"},
and {cmd:"t"}.
The default is {cmd:"d"} if you do not invoke this function.

{pstd}
{cmd:deriv_init_evaluator(}{it:D}{cmd:)}
returns a pointer to the function that has been set.

{pstd}
{cmd:deriv_init_evaluatortype(}{it:D}{cmd:)}
returns the evaluator type currently set.


{marker i_argument}{...}
{title:deriv_init_argument() and deriv_init_narguments()}

{p 8 8 2}
{it:void}{bind:          }
{cmd:deriv_init_argument(}{it:D}{cmd:,}
{it:real scalar k}{cmd:,}
{it:X}{cmd:)}

{p 8 8 2}
{it:void}{bind:          }
{cmd:deriv_init_narguments(}{it:D}{cmd:,}
{it:real scalar K}{cmd:)}


{p 8 8 2}
{it:pointer scalar}
{cmd:deriv_init_argument(}{it:D}{cmd:,}
{it:real scalar k}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:   }
{cmd:deriv_init_narguments(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_init_argument(}{it:D}{cmd:,} {it:k}{cmd:,} {it:X}{cmd:)}
sets the {it:k}th extra argument of the evaluator function to be {it:X}.
{it:X} can be anything, including a view matrix or even a pointer to a
function.  No copy of {it:X} is made; it is a pointer to {it:X} that is
stored, so any changes you make to {it:X} between setting it and {it:X} being
used will be reflected in what is passed to the evaluator function.

{pstd}
{cmd:deriv_init_narguments(}{it:D}{cmd:,} {it:K}{cmd:)} sets the number of
extra arguments to be passed to the evaluator function.  This function is
useless and included only for completeness.  The number of extra arguments is
automatically set when you use {cmd:deriv_init_argument()}.

{pstd}
{cmd:deriv_init_argument(}{it:D}{cmd:,} {it:k}{cmd:)} returns a pointer to the
object that was previously set.

{pstd}
{cmd:deriv_init_narguments(}{it:D}{cmd:)} returns the number of extra arguments
that were passed to the evaluator function.


{marker i_weights}{...}
{title:deriv_init_weights()}

{p 8 8 2}
{it:void}{bind:          }
{cmd:deriv_init_weights(}{it:D}{cmd:,}
{it:real colvector weights}{cmd:)}

{p 8 8 2}
{it:pointer scalar}
{cmd:deriv_init_weights(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_init_weights(}{it:D}{cmd:,} {it:weights}{cmd:)}
sets the weights used with type {cmd:v} evaluators to produce the function
value.  By default, {cmd:deriv()} with a type {cmd:v} evaluator uses
{cmd:colsum}{cmd:(}{it:v}{cmd:)} to compute the function value.  With weights,
{cmd:deriv()} uses {cmd:cross}{cmd:(}{it:weights}{cmd:,} {it:v}{cmd:)}.
{it:weights} must be row conformable with the column vector returned by the
evaluator.

{pstd}
{cmd:deriv_init_weights(}{it:D}{cmd:)} returns a pointer to the weight vector
that was previously set.


{marker i_params}{...}
{title:deriv_init_params()}

{p 8 8 2}
{it:void}{bind:          }
{cmd:deriv_init_params(}{it:D}{cmd:,}
{it:real rowvector params}{cmd:)}

{p 8 8 2}
{it:real rowvector}
{cmd:deriv_init_params(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_init_params(}{it:D}{cmd:,}
{it:params}{cmd:)} sets the parameter values at which the derivatives will be
computed.
Use of this function is required.

{pstd}
{cmd:deriv_init_params(}{it:D}{cmd:)}
returns the parameter values at which the derivatives were computed.


{marker i_adv}{...}
{title:Advanced init functions}

{pstd}
The rest of the {cmd:deriv_init_}{it:*}{cmd:()} functions provide finer
control of the numerical derivative taker.


{marker i_h}{...}
{title:deriv_init_h()}
{title:deriv_init_scale()}
{title:deriv_init_bounds()}
{title:deriv_init_search()}

{p 8 8 2}
{it:void}{bind:          }
{cmd:deriv_init_h(}{it:D}{cmd:,}
{it:real rowvector h}{cmd:)}

{p 8 8 2}
{it:void}{bind:          }
{cmd:deriv_init_scale(}{it:D}{cmd:,}
{it:real rowvector s}{cmd:)}

{p 8 8 2}
{it:void}{bind:          }
{cmd:deriv_init_bounds(}{it:D}{cmd:,}
{it:real rowvector minmax}{cmd:)}

{p 8 8 2}
{it:void}{bind:          }
{cmd:deriv_init_search(}{it:D}{cmd:,}
{it:search}{cmd:)}

{p 8 8 2}
{it:real rowvector}
{cmd:deriv_init_h(}{it:D}{cmd:)}

{p 8 8 2}
{it:real rowvector}
{cmd:deriv_init_scale(}{it:D}{cmd:)}

{p 8 8 2}
{it:real rowvector}
{cmd:deriv_init_bounds(}{it:D}{cmd:)}

{p 8 8 2}
{it:string scalar}{bind: }
{cmd:deriv_init_search(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_init_h(}{it:D}{cmd:,} {it:h}{cmd:)}
sets the {it:h} values used to compute numerical derivatives.

{pstd}
{cmd:deriv_init_scale(}{it:D}{cmd:,} {it:s}{cmd:)}
sets the starting scale values used to compute numerical derivatives.

{pstd}
{cmd:deriv_init_bounds(}{it:D}{cmd:,} {it:minmax}{cmd:)}
sets the minimum and maximum values used to search for optimal scale
values.  The default is {it:minmax} = {cmd:(1e-8, 1e-7)}.

{pstd}
{cmd:deriv_init_search(}{it:D}{cmd:,} {cmd:"interpolate")}
causes {cmd:deriv()} to use linear and quadratic interpolation to search for
an optimal delta for computing the numerical derivatives.
This is the default search method.

{pstd}
{cmd:deriv_init_search(}{it:D}{cmd:,} {cmd:"bracket")}
causes {cmd:deriv()} to use a bracketed quadratic formula to search for
an optimal delta for computing the numerical derivatives.

{pstd}
{cmd:deriv_init_search(}{it:D}{cmd:,} {cmd:"off")}
prevents {cmd:deriv()} from searching for an optimal delta.

{pstd}
{cmd:deriv_init_h(}{it:D}{cmd:)}
returns the user-specified {it:h} values.

{pstd}
{cmd:deriv_init_scale(}{it:D}{cmd:)}
returns the user-specified starting scale values.

{pstd}
{cmd:deriv_init_bounds(}{it:D}{cmd:)}
returns the user-specified search bounds.

{pstd}
{cmd:deriv_init_search(}{it:D}{cmd:)}
returns the currently set search method.


{marker i_verbose}{...}
{title:deriv_init_verbose()}

{p 8 25 2}
{it:void}{bind:          }
{cmd:deriv_init_verbose(}{it:D}{cmd:,}
{it:verbose}{cmd:)}

{p 8 25 2}
{it:string scalar}{bind: }
{cmd:deriv_init_verbose(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_init_verbose(}{it:D}{cmd:,}
{it:verbose}{cmd:)} sets whether error messages that arise during the
execution of {cmd:deriv()} or {cmd:_deriv()} are to be displayed.
Setting {it:verbose} to {cmd:"on"} means that they are displayed;
{cmd:"off"} means that they are not displayed.
The default is {cmd:"on"}.  Setting {it:verbose} to {cmd:"off"} is of 
interest only to users of {cmd:_deriv()}.

{pstd}
{cmd:deriv_init_verbose(}{it:D}{cmd:)}
returns the current value of {it:verbose}.


{marker deriv}{...}
{title:deriv()}

{p 8 12 2}
{it:(varies)} 
{cmd:deriv(}{it:D}{cmd:,} {it:todo}{cmd:)}

{pstd}
{cmd:deriv(}{it:D}{cmd:,} {it:todo}{cmd:)}
invokes the derivative process.
If something goes wrong, {cmd:deriv()} aborts with error.

{phang2}
{cmd:deriv}{cmd:(}{it:D}{cmd:, 0)}
returns the function value without computing derivatives.

{phang2}
{cmd:deriv}{cmd:(}{it:D}{cmd:, 1)}
returns the gradient vector; the Hessian matrix is not computed.

{phang2}
{cmd:deriv}{cmd:(}{it:D}{cmd:, 2)}
returns the Hessian matrix; the gradient vector is also computed.

{pstd}
Before you can invoke {cmd:deriv()}, you must have defined your evaluator
function, {it:evaluator}{cmd:()}, and you must have set the parameter values at
which {cmd:deriv()} is to compute derivatives:

{col 17}{it:D} {cmd:= deriv_init()}
{col 17}{cmd:deriv_init_evaluator(}{it:D}{cmd:, &}{it:evaluator}{cmd:())}
{col 17}{cmd:deriv_init_params(}{it:D}{cmd:, (}...{cmd:))}

{pstd}
The above assumes that your evaluator function is type {cmd:d}.
If your evaluator function type is {cmd:v} (that is, it returns a column vector
of values instead of a scalar value), you will also have coded

{col 17}{cmd:deriv_init_evaluatortype(}{it:D}{cmd:, "v")}

{pstd}
and you may have coded other {cmd:deriv_init_}{it:*}{cmd:()} 
functions as well.

{pstd}
Once {cmd:deriv()} completes, you may use 
the {cmd:deriv_result_}{it:*}{cmd:()} functions.
You may also continue to use the 
{cmd:deriv_init_}{it:*}{cmd:()} functions 
to access initial settings, and you may use them to change settings 
and recompute derivatives (that is, invoke {cmd:deriv()} again) if you 
wish.


{marker _deriv}{...}
{title:_deriv()}

{p 8 12 2}
{it:real scalar} 
{cmd:_deriv(}{it:D}{cmd:,} {it:todo}{cmd:)}

{pstd}
{cmd:_deriv(}{it:D}{cmd:)} performs the same actions as
{cmd:deriv(}{it:D}{cmd:)} except that, rather than returning the requested
derivatives, {cmd:_deriv()} returns a real scalar and, rather than
aborting if numerical issues arise, {cmd:_deriv()} returns a nonzero value.
{cmd:_deriv()} returns 0 if all went well.  The returned value is called
an error code.

{pstd}
{cmd:deriv()} returns the requested result.  It can 
work that way because the numerical derivative calculation must have gone
well.  Had it not, {cmd:deriv()} would have aborted execution.

{pstd}
{cmd:_deriv()} returns an error code.  If it is 0, the numerical derivative
calculation went well, and you can obtain the gradient vector by using 
{bf:{help mf_deriv##r_gradient:deriv_result_gradient()}}.
If things did not go well, you can use the error code to diagnose what went
wrong and take the appropriate action.

{pstd}
Thus {cmd:_deriv(}{it:D}{cmd:)} is an alternative to
{cmd:deriv(}{it:D}{cmd:)}.
Both functions do the same thing.
The difference is what happens when there are numerical difficulties.

{pstd}
{cmd:deriv()} and {cmd:_deriv()} work around most numerical difficulties.
For instance, the evaluator function you write is allowed to return {it:v}
equal to missing if it cannot calculate the {it:f}() at {it:p}+{it:d}.
If that happens while computing the derivative, {cmd:deriv()} and
{cmd:_deriv()} will search for a better {it:d} for taking the derivative.
{cmd:deriv()}, however, cannot tolerate that happening at {it:p} (the
parameter values you set using {helpb mf_deriv##i_params:deriv_init_params()})
because the function value must exist at the point when you want {cmd:deriv()}
to compute the numerical derivative.  {cmd:deriv()} issues an error message and
aborts, meaning that execution is stopped.  There can be advantages in that.
The calling program need not include complicated code for such instances,
figuring that stopping is good enough because a human will know to address the
problem.

{pstd}
{cmd:_deriv()}, however, does not stop execution.
Rather than aborting, {cmd:_deriv()} 
returns a nonzero value to the caller, identifying what went wrong.
The only exception is that {cmd:_deriv()} will return a zero value to the
caller even when the evaluator function returns {it:v} equal to missing at
{it:p}, allowing programmers to handle this special case without having to
turn {helpb mf_deriv##i_verbose:deriv_init_verbose()} off.

{pstd}
Programmers implementing advanced systems will want to use {cmd:_deriv()}
instead of {cmd:deriv()}.  Everybody else should use {cmd:deriv()}.

{pstd}
Programmers using {cmd:_deriv()} will also be interested in the 
functions 
{helpb mf_deriv##i_verbose:deriv_init_verbose()},
{helpb mf_deriv##r_error:deriv_result_errorcode()},
{helpb mf_deriv##r_error:deriv_result_errortext()},
and
{helpb mf_deriv##r_error:deriv_result_returncode()}.

{pstd}
The error codes returned by {cmd:_deriv()} are
listed below, under the heading
{it:{help mf_deriv##r_error:deriv_result_errorcode(), ..._errortext(), and ..._returncode()}}.


{marker r_value}{...}
{title:deriv_result_value()}

{p 8 25 2}
{it:real scalar}
{cmd:deriv_result_value(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_result_value(}{it:D}{cmd:)} returns the value of {it:f}()
evaluated at {it:p}.


{marker r_values}{...}
{title:deriv_result_values() and _deriv_result_values()}

{p 8 25 2}
{it:real matrix}
{cmd:deriv_result_values(}{it:D}{cmd:)}

{p 8 25 2}
{it:void}{bind:      }
{cmd:_deriv_result_values(}{it:D}{cmd:,} {it:v}{cmd:)}

{pstd}
{cmd:deriv_result_values(}{it:D}{cmd:)}
returns the vector values returned by the evaluator.  For type {cmd:v}
evaluators, this is the column vector that sums to the value of {it:f}()
evaluated at {it:p}.  For type {cmd:t} evaluators, this is the rowvector
returned by the evaluator.

{pstd}
{cmd:_deriv_result_values(}{it:D}{cmd:,} {it:v}{cmd:)}
uses {helpb mf_swap:swap()} to interchange {it:v} with the vector values
stored in {it:D}.
This destroys the vector values stored in {it:D}.

{pstd}
These functions should be called only with type {cmd:v} evaluators.


{marker r_gradient}{...}
{title:deriv_result_gradient()}
{title:_deriv_result_gradient()}

{p 8 25 2}
{it:real rowvector}
{cmd:deriv_result_gradient(}{it:D}{cmd:)}

{p 8 25 2}
{it:void}{bind:         }
{cmd:_deriv_result_gradient(}{it:D}{cmd:,} {it:g}{cmd:)}

{pstd}
{cmd:deriv_result_gradient(}{it:D}{cmd:)}
returns the gradient vector evaluated at {it:p}.

{pstd}
{cmd:_deriv_result_gradient(}{it:D}{cmd:,} {it:g}{cmd:)}
uses {helpb mf_swap:swap()} to interchange {it:g} with the gradient vector
stored in {it:D}.  This destroys the gradient vector stored in {it:D}.


{marker r_scores}{...}
{title:deriv_result_scores()}
{title:_deriv_result_scores()}

{p 8 25 2}
{it:real matrix}
{cmd:deriv_result_scores(}{it:D}{cmd:)}

{p 8 25 2}
{it:void}{bind:      }
{cmd:_deriv_result_scores(}{it:D}{cmd:,} {it:S}{cmd:)}

{pstd}
{cmd:deriv_result_scores(}{it:D}{cmd:)}
returns the matrix of the scores evaluated at {it:p}.  The matrix of scores
can be summed over the columns to produce the gradient vector.

{pstd}
{cmd:_deriv_result_scores(}{it:D}{cmd:,} {it:S}{cmd:)}
uses {helpb mf_swap:swap()} to interchange {it:S} with the scores matrix
stored in {it:D}.  This destroys the scores matrix stored in {it:D}.

{pstd}
These functions should be called only with type {cmd:v} evaluators.


{marker r_Jacobian}{...}
{title:deriv_result_Jacobian()}
{title:_deriv_result_Jacobian()}

{p 8 25 2}
{it:real matrix}
{cmd:deriv_result_Jacobian(}{it:D}{cmd:)}

{p 8 25 2}
{it:void}{bind:      }
{cmd:_deriv_result_Jacobian(}{it:D}{cmd:,} {it:J}{cmd:)}

{pstd}
{cmd:deriv_result_Jacobian(}{it:D}{cmd:)}
returns the Jacobian matrix evaluated at {it:p}.

{pstd}
{cmd:_deriv_result_Jacobian(}{it:D}{cmd:,} {it:J}{cmd:)}
uses {helpb mf_swap:swap()} to interchange {it:J} with the Jacobian matrix
stored in {it:D}.  This destroys the Jacobian matrix stored in {it:D}.

{pstd}
These functions should be called only with type {cmd:t} evaluators.


{marker r_hessian}{...}
{title:deriv_result_Hessian()}
{title:_deriv_result_Hessian()}

{p 8 25 2}
{it:real matrix}
{cmd:deriv_result_Hessian(}{it:D}{cmd:)}

{p 8 25 2}
{it:void}{bind:      }
{cmd:_deriv_result_Hessian(}{it:D}{cmd:,} {it:H}{cmd:)}

{pstd}
{cmd:deriv_result_Hessian(}{it:D}{cmd:)}
returns the Hessian matrix evaluated at {it:p}.

{pstd}
{cmd:_deriv_result_Hessian(}{it:D}{cmd:,} {it:H}{cmd:)}
uses {helpb mf_swap:swap()} to interchange {it:H} with the Hessian matrix
stored in {it:D}.  This destroys the Hessian matrix stored in {it:D}.

{pstd}
These functions should not be called with type {cmd:t} evaluators.


{marker r_delta}{...}
{title:deriv_result_h()}
{title:deriv_result_scale()}
{title:deriv_result_delta()}

{p 8 25 2}
{it:real rowvector}
{cmd:deriv_result_h(}{it:D}{cmd:)}

{p 8 25 2}
{it:real rowvector}
{cmd:deriv_result_scale(}{it:D}{cmd:)}

{p 8 25 2}
{it:real rowvector}
{cmd:deriv_result_delta(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_result_h(}{it:D}{cmd:)}
returns the vector of {it:h} values that was used to compute the numerical
derivatives.

{pstd}
{cmd:deriv_result_scale(}{it:D}{cmd:)}
returns the vector of scale values that was used to compute the numerical
derivatives.

{pstd}
{cmd:deriv_result_delta(}{it:D}{cmd:)}
returns the vector of delta values used to compute the numerical derivatives.  


{marker r_error}{...}
{title:deriv_result_errorcode()}
{title:deriv_result_errortext()}
{title:deriv_result_returncode()}

{p 8 25 2}
{it:real scalar}{bind:  }
{cmd:deriv_result_errorcode(}{it:D}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:deriv_result_errortext(}{it:D}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:  }
{cmd:deriv_result_returncode(}{it:D}{cmd:)}

{pstd}
These functions are for use after {cmd:_deriv()}.

{pstd}
{cmd:deriv_result_errorcode(}{it:D}{cmd:)}
returns the same error code as {cmd:_deriv()}.
The value will be zero if there were no errors.
The error codes are listed in the table directly below.

{pstd}
{cmd:deriv_result_errortext(}{it:D}{cmd:)}
returns a string containing the error message corresponding to the error code.
If the error code is zero, the string will be {cmd:""}.

{pstd}
{cmd:deriv_result_returncode(}{it:D}{cmd:)}
returns the Stata return code corresponding to the error code.
The mapping is listed in the table directly below.  

{pstd}
In advanced code, these functions might be used as

		{cmd:(void) _deriv(D, todo)}
		...
		{cmd:if (ec = deriv_result_code(D)) {c -(}}
			{cmd:errprintf("{c -(}p{c )-}\n")}
			{cmd:errprintf("%s\n", deriv_result_errortext(D))}
			{cmd:errprintf("{c -(}p_end{c )-}\n")}
			{cmd:exit(deriv_result_returncode(D))}
			{cmd:/*NOTREACHED*/}
		{cmd:{c )-}}

{pstd}
The error codes and their corresponding Stata return codes are

	   Error   Return
	   code     code   Error text
	{hline 70}
	     1       198   invalid todo argument

             2       111   evaluator function required

             3       459   parameter values required

             4       459   parameter values not feasible

             5       459   could not calculate numerical derivatives --
			   discontinuous region with missing values
			   encountered

             6       459   could not calculate numerical derivatives -- 
			   flat or discontinuous region encountered

            16       111   {it:function}() not found

            17       459   Hessian calculations not allowed with type
	    		   {cmd:t} evaluators
	{hline 70}
	Note:  Error 4 can occur only when evaluating {it:f}() at the 
               parameter values.  This error occurs only with {cmd:deriv()}.


{marker query}{...}
{title:deriv_query()}

{p 8 25 2}
{it:void}
{cmd:deriv_query(}{it:D}{cmd:)}

{pstd}
{cmd:deriv_query(}{it:D}{cmd:)} displays a report on the current
{cmd:deriv_init_}{it:*}{cmd:()} values and some of the
{cmd:deriv_result_}{it:*}{cmd:()} values.
{cmd:deriv_query(}{it:D}{cmd:)} may be used before or after {cmd:deriv()}, and
it is useful when using {cmd:deriv()} interactively or when debugging a program
that calls {cmd:deriv()} or {cmd:_deriv()}.


{marker conformability}{...}
{title:Conformability}

{pstd}
All functions have 1 {it:x} 1 inputs and have 1 {it:x} 1 or {it:void} outputs,
except the following:

    {cmd:deriv_init_params(}{it:D}{cmd:,} {it:params}{cmd:)}:
		{it:D}:  {it:transmorphic}
           {it:params}:  1 {it:x np}
	   {it:result}:  {it:void}

    {cmd:deriv_init_params(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:deriv_init_argument(}{it:D}{cmd:,} {it:k}{cmd:,} {it:X}{cmd:)}:
		{it:D}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
		{it:X}:  {it:anything}
	   {it:result}:  {it:void}

    {cmd:deriv_init_weights(}{it:D}{cmd:,} {it:params}{cmd:)}:
		{it:D}:  {it:transmorphic}
  	   {it:params}:  {it:N x} 1
	   {it:result}:  {it:void}

    {cmd:deriv_init_h(}{it:D}{cmd:,} {it:h}{cmd:)}:
		{it:D}:  {it:transmorphic}
                {it:h}:  1 {it:x np}
	   {it:result}:  {it:void}

    {cmd:deriv_init_h(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:deriv_init_scale(}{it:D}{cmd:,} {it:scale}{cmd:)}:
		{it:D}:  {it:transmorphic}
            {it:scale}:  1 {it:x np} (type {cmd:d} and {cmd:v} evaluator)
		    {it:nv x np} (type {cmd:t} evaluator)
	   {it:result}:  {it:void}

    {cmd:deriv_init_bounds(}{it:D}{cmd:,} {it:minmax}{cmd:)}:
		{it:D}:  {it:transmorphic}
           {it:minmax}:  1 {it:x} 2
	   {it:result}:  {it:void}

    {cmd:deriv_init_bounds(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  1 {it:x} w

    {cmd:deriv(}{it:D}{cmd:, 0)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  1 {it:x} 1
		    1 {it:x nv}	(type {cmd:t} evaluator)

    {cmd:deriv(}{it:D}{cmd:, 1)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}
		    {it:nv x np} (type {cmd:t} evaluator)

    {cmd:deriv(}{it:D}{cmd:, 2)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:deriv_result_values(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  {it:N x} 1
		    1 {it:x nv}	(type {cmd:t} evaluator)
		    {it:N x} 1 (type {cmd:v} evaluator)

    {cmd:_deriv_result_values(}{it:D}{cmd:,} {it:v}{cmd:)}:
		{it:D}:  {it:transmorphic}
	        {it:v}:  {it:N x} 1
		    1 {it:x nv}	(type {cmd:t} evaluator)
	   {it:result}:  {it:void}

    {cmd:deriv_result_gradient(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:_deriv_result_gradient(}{it:D}{cmd:,} {it:g}{cmd:)}:
		{it:D}:  {it:transmorphic}
	        {it:g}:  1 {it:x np}
	   {it:result}:  {it:void}

    {cmd:deriv_result_scores(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  {it:N x np}

    {cmd:_deriv_result_scores(}{it:D}{cmd:,} {it:S}{cmd:)}:
		{it:D}:  {it:transmorphic}
	        {it:S}:  {it:N x np}
	   {it:result}:  {it:void}

    {cmd:deriv_result_Jacobian(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  {it:nv x np}

    {cmd:_deriv_result_Jacobian(}{it:D}{cmd:,} {it:J}{cmd:)}:
		{it:D}:  {it:transmorphic}
	        {it:J}:  {it:nv x np}
	   {it:result}:  {it:void}

    {cmd:deriv_result_Hessian(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:_deriv_result_Hessian(}{it:D}{cmd:,} {it:H}{cmd:)}:
		{it:D}:  {it:transmorphic}
	        {it:H}:  {it:np x np}
	   {it:result}:  {it:void}

    {cmd:deriv_result_h(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:deriv_result_scale(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
           {it:result}:  1 {it:x np} (type {cmd:d} and {cmd:v} evaluator)
		    {it:nv x np} (type {cmd:t} evaluator)

    {cmd:deriv_result_delta(}{it:D}{cmd:)}:
		{it:D}:  {it:transmorphic}
           {it:result}:  1 {it:x np} (type {cmd:d} and {cmd:v} evaluator)
		    {it:nv x np} (type {cmd:t} evaluator)


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
All functions abort with error when used incorrectly.

{pstd}
{cmd:deriv()} aborts with error if it runs into numerical difficulties.
{cmd:_deriv()} does not; it instead returns a nonzero error code.


{marker source}{...}
{title:Source code}

{pstd}
{view deriv_include.mata, adopath asis:deriv_include.mata},
{view deriv_calluser.mata, adopath asis:deriv_calluser.mata},
{view deriv.mata, adopath asis:deriv.mata}


{marker methods}{...}
{title:Methods and formulas}

{pstd}
See sections 1.3.4 and 1.3.5 of 
{help mf_deriv##GPP2010:Gould, Pitblado, and Poi (2010)} for an
overview of the methods and formulas {cmd:deriv()} uses to compute numerical
derivatives.


{marker reference}{...}
{title:Reference}

{marker GPP2010}{...}
{phang}
Gould, W. W., J. S. Pitblado, and B. P. Poi.  2010.
{browse "http://www.stata-press.com/books/ml4.html":{it:Maximum Likelihood Estimation with Stata}. 4th ed.}  College Station, TX: Stata Press.
{p_end}
