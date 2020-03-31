{smcl}
{* *! version 1.0.0  21mary019}{...}
{vieweralsosee "[M-5] Quadrature()" "mansection M-5 Quadrature()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] class" "help m2_class"}{...}
{vieweralsosee "[M-5] deriv()" "help mf_deriv"}{...}
{vieweralsosee "[M-5] moptimize()" "help mf_moptimize"}{...}
{vieweralsosee "[M-5] optimize()" "help mf_optimize"}{...}
{viewerjumpto "Syntax" "mf_quadrature##syntax"}{...}
{viewerjumpto "Description" "mf_quadrature##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_quadrature##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_quadrature##remarks"}{...}
{viewerjumpto "Conformability" "mf_quadrature##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_quadrature##diagnostics"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] Quadrature()} {hline 2}}Numerical integration
{p_end}
{p2col:}({mansection M-5 Quadrature():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
With the {cmd:Quadrature()} class, you can approximate an integral in as 
few as four steps -- create an instance of the class with {cmd:Quadrature()}, 
specify the evaluator function with {cmd:setEvaluator()}, set the limits 
with {cmd:setLimits()}, and perform the computation with {cmd:integrate()}.  
{help mf_quadrature##ex1:Example 1} demonstrates this basic procedure. 

{pstd}
The full syntax allows you to further define the integration problem and 
to obtain additional results. Syntax is presented under the following 
headings:

	{help mf_quadrature##syn_step1:Step 1:  Initialization}
        {help mf_quadrature##syn_step2:Step 2:  Definition of integration problem}
        {help mf_quadrature##syn_step3:Step 3:  Perform integration}
        {help mf_quadrature##syn_step4:Step 4:  Display or obtain results}
        {help mf_quadrature##syn_utilfunction_steps:Utility function for use in all steps}
        {help mf_quadrature##syn_defq:Definition of q}
        {help mf_quadrature##syn_functions_integration:Functions defining the integration problem}
                {help mf_quadrature##setEval:q.setEvaluator() and q.getEvaluator()}
                {help mf_quadrature##setLimits:q.setLimits() and q.getLimits()}
                {help mf_quadrature##setTech:q.setTechnique() and q.getTechnique()}
                {help mf_quadrature##setMaxiter:q.setMaxiter() and q.getMaxiter()}
                {help mf_quadrature##setAbstol:q.setAbstol(), q.getAbstol(), q.setReltol(), and q.getReltol()}
                {help mf_quadrature##setArgument:q.setArgument(), q.getArgument(), and q.getNarguments()}
                {help mf_quadrature##setTrace:q.setTrace() and q.getTrace()}
        {help mf_quadrature##syn_integration:Performing integration}
        {help mf_quadrature##syn_functions_results:Functions for obtaining results}
                {help mf_quadrature##value:q.value()}
                {help mf_quadrature##iterations:q.iterations()}
                {help mf_quadrature##converged:q.converged()}
                {help mf_quadrature##errorcode:q.errorcode(), q.errortext(), and q.returncode()}
        {help mf_quadrature##syn_utilfunction:Utility function}
                {help mf_quadrature##query:q.query()}


{marker syn_step1}{...}
    {title:Step 1:  Initialization}

{p 8 25 1}
{it:{help mf_quadrature##syn_defq:q}} {cmd:= Quadrature()}


{marker syn_step2}{...}
    {title:Step 2:  Definition of integration problem}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setEval:{bf:.setEvaluator(}{it:pointer(real function)}}
{col 55}{help mf_quadrature##setEval:{it:scalar fcn}{bf:)}}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setLimits:{bf:.setLimits(}{it:real rowvector limits}{bf:)}}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setTech:{bf:.setTechnique(}{it:string scalar technique}{bf:)}}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setMaxiter:{bf:.setMaxiter(}{it:real scalar maxiter}{bf:)}}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setAbstol:{bf:.setAbstol(}{it:real scalar abstol}{bf:)}}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{helpb mf_quadrature##setAbstol:{bf:.setReltol(}{it:real scalar reltol}{bf:)}}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setArgument:{bf:.setArgument(}{it:real scalar i}{bf:,} {it:arg}{bf:)}}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setTrace:{bf:.setTrace(}{it:string scalar trace}{bf:)}}

      {it:pointer(real function) scalar}{bind:  }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setEval:{bf:.getEvaluator()}}

      {it:real rowvector}{bind:                 }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setLimits:{bf:.getLimits()}}

      {it:string scalar}{bind:                  }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setTech:{bf:.getTechnique()}}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setMaxiter:{bf:.getMaxiter()}}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setAbstol:{bf:.getAbstol()}}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setAbstol:{bf:.getReltol()}}

      {it:pointer scalar}{bind:                 }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setArgument:{bf:.getArgument(}{it:real scalar i}{bf:)}}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setArgument:{bf:.getNarguments()}}

      {it:string scalar}{bind:                  }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##setTrace:{bf:.getTrace()}}


{marker syn_step3}{...}
    {title:Step 3: Perform integration}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##integrate:{bf:.integrate()}}


{marker syn_step4}{...}
    {title:Step 4:  Display or obtain results}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##value:{bf:.value()}}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##iterations:{bf:.iterations()}}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##converged:{bf:.converged()}}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##errorcode:{bf:.errorcode()}}

      {it:string scalar}{bind:                  }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##errorcode:{bf:.errortext()}}

      {it:real scalar}{bind:                    }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##errorcode:{bf:.returncode()}}


{marker syn_utilfunction_steps}{...}
    {title:Utility function for use in all steps}

      {it:void}{bind:                           }{...}
{it:{help mf_quadrature##syn_defq:q}}{help mf_quadrature##query:{bf:.query()}}


{marker syn_defq}
    {title:Definition of q}

{pstd}
A variable of type {cmd:Quadrature} is called an
{help m6_glossary##instance:instance} of the {cmd:Quadrature()} class.  {it:q}
is an instance of {cmd:Quadrature()}, a vector of instances, or a matrix of
instances.  If you are working interactively, you can create an instance of
{cmd:Quadrature()} by typing 

            {cmd}q = Quadrature(){txt}

{pstd}
For a row vector of {it:n} {cmd:Quadrature()} instances, type

            {cmd:q = Quadrature(}{it:n}{cmd:)}

{pstd}
For an {it:m} x {it:n} matrix of {cmd:Quadrature()} instances, type

            {cmd:q = Quadrature(}{it:m}{cmd:,} {it:n}{cmd:)}

{pstd}
In a function, you would declare one instance of the {cmd:Quadrature()} class
{it:q} as a {cmd:scalar}.

            {cmd}void myfunc()
            {
                class Quadrature scalar   q
                q = Quadrature()    
                ...
            }{txt}

{pstd}
Within a function, you can declare {it:q} as a row vector of {it:n} instances
by typing

            {cmd}void myfunc()
            {
                class Quadrature rowvector   q
                q = Quadrature({txt}{it:n}{cmd:)}
                ...
            {cmd}}{txt}

{pstd}
For an {it:m} x {it:n} matrix of instances, type

            {cmd}void myfunc()
            {
                class Quadrature matrix   q
                q = Quadrature({txt}{it:m}{cmd:,} {it:n}{cmd:)}
                ...
            {cmd}}{txt}


{marker syn_functions_integration}{...}
    {title:Functions defining the integration problem}

{pstd}
At a minimum, you need to tell the {cmd:Quadrature()} class about the 
function you wish to integrate and the limits of integration. You can 
also specify the technique used to compute the quadrature, the maximum
number of iterations allowed, the convergence criteria, the arguments to 
be passed to the evaluator, and whether or not to print computation details. 

{pstd}
Each pair of functions includes a {it:q}{cmd:.set} function that specifies
an integration setting and a {it:q}{cmd:.get} function that returns the 
current setting.

{marker setEval}{...}
{pstd}
{bf:q.setEvaluator() and q.getEvaluator()}

{pmore}
{it:q}{cmd:.setEvaluator(}{it:fcn}{cmd:)}
sets a pointer to the evaluator function, which has to be called before
any calculation. Additionally, the evaluator has a special format.
Namely, it has at least one {it:real scalar} argument
(first argument, corresponding to x) and returns
a {it:real scalar} value, f(x).

{pmore}
{it:q}{cmd:.getEvaluator(}{cmd:)}
returns a pointer to the evaluator ({it:NULL} if not specified).

{marker setLimits}{...}
{pstd}
{bf:q.setLimits() and q.getLimits()}

{pmore}
{it:q}{cmd:.setLimits(}{it:limits}{cmd:)} sets the integration limits as a
two-dimensional rowvector.  The limits can be finite or infinite. The lower
limit must be less than or equal to the upper limit.  Using a missing value as
the lower limit indicates -infinity, and using a missing value as the upper
limit indicates infinity.

{pmore}
{it:q}{cmd:.getLimits(}{cmd:)} returns the
integration limits (empty vector if not specified).

{marker setTech}{...}
{pstd}
{bf:q.setTechnique() and q.getTechnique()}

{pmore}
{it:q}{cmd:.setTechnique(}{it:technique}{cmd:)}
specifies the technique used to compute the quadrature.

{pmore}
{it:technique} specified in {cmd:setTechnique()} can be

              {it:technique}     Description
              {hline 60}
              {cmd:"gauss"}      adaptive Gauss-Kronrod method; the default
              {cmd:"simpson"}    adaptive Simpson method
              {hline 60}

{pmore}
{it:q}{cmd:.getTechnique(}{cmd:)}
returns the current technique.

{marker setMaxiter}{...}
{pstd}
{bf:q.setMaxiter() and q.getMaxiter()}

{pmore}
{it:q}{cmd:.setMaxiter(}{it:maxiter}{cmd:)}
specifies the maximum number of iterations, which must be an integer
greater than 0. The default value of {it:maxiter} is {cmd:16000}.

{pmore}
{it:q}{cmd:.getMaxiter(}{cmd:)}
returns the current maximum number of iterations.

{marker setAbstol}{...}
{pstd}
{bf:q.setAbstol(), q.getAbstol(), q.setReltol(), and q.getReltol()}

{pmore}
{it:q}{cmd:.setAbstol(}{it:abstol}{cmd:)}
and {it:q}{cmd:.setReltol(}{it:reltol}{cmd:)}
specify the convergence criteria with absolute and relative tolerances,
which must be greater than 0.
The default values of {it:abstol} and {it:reltol} are 1e-10 and 1e-8,
respectively.

{pmore}
The absolute tolerance gives an upper bound for the approximate measure
of the absolute difference between the computed solution and the exact
solution, while the relative tolerance gives an upper bound for the approximate
measure of the relative difference between the computed and the exact solution.

{pmore}
{it:q}{cmd:.getAbstol(}{cmd:)}
and {it:q}{cmd:.getReltol(}{cmd:)}
return the current absolute and relative tolerances, respectively.

{marker setArgument}{...}
{pstd}
{bf:q.setArgument(), q.getArgument(), and q.getNarguments()}

{pmore}
{it:q}{cmd:.setArgument(}{it:i}{cmd:,} {it:arg}{cmd:)}
specifies {it:arg} as the {it:i}th extra argument of the evaluator,
where {it:i} is an integer between 1 and 9. Here {it:arg} can be
anything. If {it:i} is greater than the current number of extra
arguments, then the number of extra arguments will be increased to {it:i}.

{pmore}
{it:q}{cmd:.getArgument(}{it:i}{cmd:)} returns
a pointer to the {it:i}th extra argument of the evaluator
({it:NULL} if not specified).

{pmore}
{it:q}{cmd:.getNarguments(}{cmd:)} returns the current number
of extra arguments.

{marker setTrace}{...}
{pstd}
{bf:q.setTrace() and q.getTrace()}

{pmore}
{it:q}{cmd:.setTrace()} sets whether or not to print out computation
details. {it:trace} specified in {cmd:setTrace()} can be
{cmd:"on"} or {cmd:"off"}. The default value is {cmd:"off"}.

{pmore}
{it:q}{cmd:.getTrace(}{cmd:)} returns the current trace status.


{marker syn_integration}{...}
    {title:Performing integration}

{marker integrate}{...}
{pstd}
{bf:q.integrate()}

{pmore}
{it:q}{cmd:.integrate()}
computes the numerical integration, that is, the approximation of the
integral of the evaluator from the lower limit to the upper limit.
{it:q}{cmd:.integrate()} returns the computed quadrature value.


{marker syn_functions_results}{...}
    {title:Functions for obtaining results}

{pstd}
After performing integration, the functions below provide results including
value of the integral, number of iterations, whether convergence was achieved,
error messages, and return codes.

{marker value}{...}
{pstd}
{bf:q.value()}

{pmore}
{it:q}{cmd:.value()}
returns the computed quadrature value; it returns a missing value if not yet
computed.

{marker iterations}{...}
{pstd}
{bf:q.iterations()}

{pmore}
{it:q}{cmd:.iterations()}
returns the number of iterations; it returns {cmd:0} if not yet computed.

{marker converged}{...}
{pstd}
{bf:q.converged()}

{pmore}
{it:q}{cmd:.converged()}
returns {cmd:1} if converged and {cmd:0} if not.

{marker errorcode}{...}
{pstd}
{bf:q.errorcode(), q.errortext(), and q.returncode()}

{pmore}
{it:q}{cmd:.errorcode()}
returns the error code generated during the computation;
it returns {cmd:0} if no error is found.

{pmore}
{it:q}{cmd:.errortext()}
returns an error message corresponding to the error code generated during the
computation; it returns an empty string if no error is found.

{pmore}
{it:q}{cmd:.returncode()}
returns the Stata return code corresponding to the error code
generated during the computation.

{marker errcodes}{...}
{pmore}
The error codes and the corresponding Stata return codes are as follows:

{p2colset 9 25 27 2}{...}
{p2col:Error{space 2}Return}{p_end}
{p2col:code{space 3}code}Error text{p_end}
{p2line}
{synopt:1{space 6}111}must specify an evaluator function to compute
numerical integration using {cmd:setEvaluator()}{p_end}

{synopt:2{space 6}111}must specify lower and upper integration limits as a
rowvector with 2 columns using {cmd:setLimits()}{p_end}

{synopt:3{space 6}111}You specified extra argument {it:n} but did not specify
extra argument {it:i}. When you specify extra argument {it:n}, you must also
specify all extra arguments less than {it:n}.{p_end}

{synopt:4{space 6}111}code distributed with Stata has been changed so that
a required subroutine cannot be found{p_end}

{synopt:5{space 6}416}evaluator function returned a missing value at one
or more quadrature points{p_end}

{synopt:6{space 6}430}subintervals cannot be further divided to achieve the
required accuracy{p_end}

{synopt:7{space 6}430}maximum number of iterations has been reached{p_end}
{p2line}
{p2colreset}{...}

{pmore}
Here {it:n} will be replaced by an actual number in the message, and
{it:i} will be replaced by an actual number less than {it:n} in the message.


{marker syn_utilfunction}{...}
    {title:Utility function}

{pstd}
At any stage of the integration problem, you can obtain a report of all
settings and results currently stored in a class {cmd:Quadrature()} instance.

{marker query}{...}
{pstd}
{bf:q.query()}

{pmore}
{it:q}{cmd:.query()} with no return value displays information stored in the
class.


{marker description}{...}
{title:Description}

{pstd}
The {cmd:Quadrature()} class approximates the integral int_a^b f(x) dx
by adaptive quadrature, where f(x) is a real-valued function, and a and
b are lower and upper limits.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 Quadrature()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

     {help mf_quadrature##remarks_intro:Introduction}
     {help mf_quadrature##remarks_ex:A basic example}


{marker remarks_intro}{...}
{title:Introduction}

{pstd}
The {cmd:Quadrature()} class is a Mata class for numerical integration. 

{pstd}
{cmd:Quadrature()} uses adaptive quadrature to approximate the integral
int_a^b f(x), dx, where f(x) is a real-valued function and 
a and b are lower and upper limits. {cmd:Quadrature()} approximates 
integrals for functions defined using an evaluator program.  
  
{pstd}
For an introduction to class programming in Mata, see
{helpb m2 class:[M-2] class}.


{marker remarks_ex}{...}
{title:A basic example}

{pstd}
To approximate an integral, you first use {cmd:Quadrature()} to get an
instance of the class.   At a minimum, you must also use {cmd:setEvaluator()}
to specify the evaluator function, {cmd:setLimits()} to specify the limits,
and {cmd:integrate()} to perform the computations. In the examples below, we
demonstrate both basic and more-advanced use of the {cmd: Quadrature()} class.


{marker ex1}{...}
    {title:Example 1: Approximate an integral}

{pstd}
We want to approximate int_0^{pi} sin(x) dx using {cmd:Quadrature()}.
We first define an evaluator function {cmd:f()} as a wrapper for the built-in 
{cmd:sin()} function:

        {cmd}: real scalar f(real scalar x) {
        >         return(sin(x))
        > }{txt}

{pstd}
We need this wrapper because we must put the address of the evaluator function
into an instance of {cmd:Quadrature()} and we are not able to get the address
of a built-in function.

{pstd}
Having defined the evaluator function, we follow the four steps that are 
required each time we use the {cmd:Quadrature()} class.
First, we create an instance {cmd:q} of the {cmd:Quadrature()} class:

        {cmd}: q = Quadrature(){txt}

{pstd}
Second, we use {cmd:setEvaluator()} to put a pointer to the evaluator
function {cmd:f()} into {cmd:q}.

        {cmd}: q.setEvaluator(&f()){txt}

{pstd}
Third, we use {cmd:setLimits()} to specify the lower and upper limits.

        {cmd}: q.setLimits((0, pi())){txt}

{pstd}
Fourth, we use {cmd:integrate()} to compute the approximation.

        {cmd}: q.integrate()
          2{txt}

{pstd}
We find that int_0^{pi} sin(x) dx = 2.


{marker conformability}{...}
{title:Conformability}

    {cmd:Quadrature()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1 

    {cmd:Quadrature(}{it:n}{cmd:)}:
       {it:input}:
                        {it:n}:  1 x 1
      {it:output}:
                   {it:result}:  1 x {it:n}

    {cmd:Quadrature(}{it:m}{cmd:,} {it:n}{cmd:)}:
       {it:input}:
                        {it:m}:  1 x 1
                        {it:n}:  1 x 1
      {it:output}:
                   {it:result}:  {it:m} x {it:n}

    {cmd:setEvaluator(}{it:fcn}{cmd:)}:
       {it:input}:
                      {it:fcn}:  1 x 1
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getEvaluator()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:setLimits(}{it:limits}{cmd:)}:
       {it:input}:
                   {it:limits}:  1 x 2
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getLimits()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 2

    {cmd:setTechnique(}{it:technique}{cmd:)}:
       {it:input}:
                {it:technique}:  1 x 1
      {it:output}:
                   {it:result}:  {it:void} 

    {cmd:getTechnique()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:setMaxiter(}{it:maxiter}{cmd:)}:
       {it:input}:
                  {it:maxiter}:  1 x 1
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getMaxiter()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:setAbstol(}{it:abstol}{cmd:)}:
       {it:input}:
                   {it:abstol}:  1 x 1
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getAbstol()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:setReltol(}{it:reltol}{cmd:)}:
       {it:input}:
                   {it:reltol}:  1 x 1
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getReltol()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:setArgument(}{it:i}{cmd:,} {it:arg}{cmd:)}:
       {it:input}:
                        {it:i}:  1 x 1
                      {it:arg}:  {it:anything}
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getArgument(}{it:i}{cmd:)}:
       {it:input}:
                        {it:i}:  1 x 1
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:getNarguments()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:setTrace(}{it:trace}{cmd:)}:
       {it:input}:
                    {it:trace}:  1 x 1
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getTrace()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:integrate()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:value()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:iterations()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:converged()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:errorcode()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:errortext()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:returncode()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:query()}:
       {it:input}:
                            {it:void}
      {it:output}:
                            {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
When used incorrectly, the following functions abort with error:
{cmd:Quadrature()}, {cmd:set}{it:*}{cmd:()}, {cmd:get}{it:*}{cmd:()},
{cmd:value()}, {cmd:iterations()}, {cmd:converged}, {cmd:errorcode()},
{cmd:errortext()}, {cmd:returncode()}, and {cmd:query()}.

{pstd}
{cmd:integrate()} also aborts with error if it is used incorrectly. If
{cmd:integrate()} runs into numerical difficulties, it returns a missing value
and displays a warning message that includes some details about the problem
encountered.
{p_end}
