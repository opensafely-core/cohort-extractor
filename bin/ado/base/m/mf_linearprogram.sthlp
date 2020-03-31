{smcl}
{* *! version 1.0.0  21may2019}{...}
{vieweralsosee "[M-5] LinearProgram()" "mansection M-5 LinearProgram()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] class" "help m2_class"}{...}
{vieweralsosee "[M-5] moptimize()" "help mf_moptimize"}{...}
{vieweralsosee "[M-5] optimize()" "help mf_optimize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] frontier" "help frontier"}{...}
{vieweralsosee "[LASSO] Lasso intro" "help lasso intro"}{...}
{vieweralsosee "[R] qreg" "help qreg"}{...}
{vieweralsosee "[R] regress " "help regress"}{...}
{viewerjumpto "Syntax" "mf_linearprogram##syntax"}{...}
{viewerjumpto "Description" "mf_linearprogram##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_linearprogram##linkspdf"}{...}
{viewerjumpto "Conformability" "mf_linearprogram##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_linearprogram##diagnostics"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[M-5] LinearProgram()} {hline 2}}Linear programming{p_end}
{p2col:}({mansection M-5 LinearProgram():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Syntax is presented under the following headings:

        {help mf_linearprogram##syn_step1:Step 1:  Initialization}
        {help mf_linearprogram##syn_step2:Step 2:  Definition of linear programming problem}
        {help mf_linearprogram##syn_step3:Step 3:  Perform optimization}
        {help mf_linearprogram##syn_step4:Step 4:  Display or obtain results}
        {help mf_linearprogram##syn_stepall:Utility function for use in all steps}
        {help mf_linearprogram##syn_q:Definition of q}
        {help mf_linearprogram##syn_linprprob:Functions defining the linear programming problem}
            {help mf_linearprogram##setCoefficients:q.setCoefficients() and q.getCoefficients()}
            {help mf_linearprogram##setMaxOrMin:q.setMaxOrMin() and q.getMaxOrMin()}
            {help mf_linearprogram##setEquality:q.setEquality() and q.getEquality()}
            {help mf_linearprogram##setInequality:q.setInequality() and q.getInequality()}
            {help mf_linearprogram##setBounds:q.setBounds() and q.getBounds()}
            {help mf_linearprogram##setMaxiter:q.setMaxiter() and q.getMaxiter()}
            {help mf_linearprogram##setTol:q.setTol() and q.getTol()}
            {help mf_linearprogram##setTrace:q.setTrace() and q.getTrace()}
        {help mf_linearprogram##syn_performopt:Performing optimization}
            {help mf_linearprogram##optimize:q.optimize()}
        {help mf_linearprogram##syn_obtainres:Functions for obtaining results}
            {help mf_linearprogram##parameters:q.parameters()}
            {help mf_linearprogram##value:q.value()}
            {help mf_linearprogram##iterations:q.iterations()}
            {help mf_linearprogram##converged:q.converged()}
            {help mf_linearprogram##errorcode:q.errorcode(), q.errortext(), and q.returncode()}
        {help mf_linearprogram##syn_utilfcn:Utility function}
            {help mf_linearprogram##query:q.query()}


{marker syn_step1}{...}
    {title:Step 1:  Initialization}

{p 8 25 1}
{it:{help mf_linearprogram##syn_q:q}} {cmd:= LinearProgram()}


{marker syn_step2}{...}
    {title:Step 2:  Definition of linear programming problem}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setCoefficients:{bf:.setCoefficients(}{it:real rowvector coef}{bf:)}}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setMaxOrMin:{bf:.setMaxOrMin(}{it:string scalar maxormin}{bf:)}}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setEquality:{bf:.setEquality(}{it:real matrix ecmat}{bf:,} {it:real colvector rhs}{bf:)}}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setInequality:{bf:.setInequality(}{it:real matrix iemat}{bf:,} {it:real colvector rhs}{bf:)}}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setBounds:{bf:.setBounds(}{it:real rowvector lowerbd}{bf:,} {it:real rowvector upperbd}{bf:)}}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setMaxiter:{bf:.setMaxiter(}{it:real scalar maxiter}{bf:)}}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setTol:{bf:.setTol(}{it:real scalar tol}{bf:)}}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setTrace:{bf:.setTrace(}{it:string scalar trace}{bf:)}}

      {it:real rowvector}{bind:   }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setCoefficients:{bf:.getCoefficients()}}

      {it:string scalar}{bind:    }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setMaxOrMin:{bf:.getMaxOrMin()}}

      {it:real matrix}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setEquality:{bf:.getEquality()}}

      {it:real matrix}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setInequality:{bf:.getInequality()}}

      {it:real matrix}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setBounds:{bf:.getBounds()}}

      {it:real scalar}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setMaxiter:{bf:.getMaxiter()}}

      {it:real scalar}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setTol:{bf:.getTol()}}

      {it:string scalar}{bind:    }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##setTrace:{bf:.getTrace()}}


{marker syn_step3}{...}
    {title:Step 3: Perform optimization}

      {it:real scalar}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##optimize:{bf:.optimize()}}


{marker syn_step4}{...}
    {title:Step 4:  Display or obtain results}

      {it:real rowvector}{bind:   }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##parameters:{bf:.parameters()}}

      {it:real scalar}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##value:{bf:.value()}}

      {it:real scalar}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##iterations:{bf:.iterations()}}

      {it:real scalar}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##converged:{bf:.converged()}}

      {it:real scalar}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##errorcode:{bf:.errorcode()}}

      {it:string scalar}{bind:    }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##errorcode:{bf:.errortext()}}

      {it:real scalar}{bind:      }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##errorcode:{bf:.returncode()}}


{marker syn_stepall}{...}
    {title:Utility function for use in all steps}

      {it:void}{bind:             }{...}
{it:{help mf_linearprogram##syn_q:q}}{help mf_linearprogram##query:{bf:.query()}}


{marker syn_q}{...}
    {title:Definition of q}

{pstd}
A variable of type {cmd:LinearProgram} is called an
{help m6_glossary##instance:instance} of the {cmd:LinearProgram()} class.
{it:q} is an instance of {cmd:LinearProgram()}, a vector of instances, or a
matrix of instances.  If you are working interactively, you can create an
instance of {cmd:LinearProgram()} by typing 

           {cmd}q = LinearProgram(){txt}

{pstd}
For a row vector of {it:n} {cmd:LinearProgram()} instances, type

           {cmd:q = LinearProgram(}{it:n}{cmd:)}

{pstd}
For an {it:m} x {it:n} matrix of {cmd:LinearProgram()} instances, type

           {cmd:q = LinearProgram(}{it:m}{cmd:,} {it:n}{cmd:)}

{pstd}
In a function, you would declare one instance of the {cmd:LinearProgram()}
class {it:q} as a {cmd:scalar}.

           {cmd}void myfunc()
           {
               class LinearProgram scalar   q
               q = LinearProgram()    
               ...
           }{txt}

{pstd}
Within a function, you can declare {it:q} as a row vector of {it:n} instances
by typing

           {cmd}void myfunc()
           {
               class LinearProgram rowvector   q
               q = LinearProgram({txt}{it:n}{cmd})
               ...
           }{txt}

{pstd}
For an {it:m} x {it:n} matrix of instances, type

           {cmd}void myfunc()
           {
               class LinearProgram matrix   q
               q = LinearProgram({txt}{it:m}{cmd:,} {it:n}{cmd})
               ...
           }{txt}


{marker syn_linprprob}{...}
    {title:Functions defining the linear programming problem}

{pstd}
At a minimum, you need to tell the {cmd:LinearProgram()} class about the
coefficients of the linear objective function you wish to optimize.
Optionally, you may specify whether to minimize or maximize the objective
function, any equality constraints, any inequality constraints, any lower
bounds, and any upper bounds.  You may also specify the maximum number of
iterations allowed, the convergence tolerance, and whether or not to print
computational details.

{pstd}
Each pair of functions includes a {it:q}{cmd:.set} function that
specifies a setting and a {it:q}{cmd:.get} function that returns the
current setting.

{marker setCoefficients}{...}
{pstd}
{bf:q.setCoefficients() and q.getCoefficients()}

{pmore}
{it:q}{cmd:.setCoefficients(}{it:coef}{cmd:)}
sets the linear objective function coefficients.  The coefficients must be
set before optimization.

{pmore}
{it:q}{cmd:.getCoefficients()}
returns the linear objective function coefficients (or an empty vector if not
specified).

{marker setMaxOrMin}{...}
{pstd}
{bf:q.setMaxOrMin() and q.getMaxOrMin()}

{pmore}
{it:q}{cmd:.setMaxOrMin(}{it:maxormin}{cmd:)}
sets whether to perform maximization or minimization. 
{it:maxormin} may be {cmd:"max"} or {cmd:"min"}.
The default is maximization ({cmd:"max"}).

{pmore}
{it:q}{cmd:.getMaxOrMin()}
returns {cmd:"max"} or {cmd:"min"} according to the current setting.

{marker setEquality}{...}
{pstd}
{bf:q.setEquality() and q.getEquality()}

{pstd}
The equality constraints for a linear programming problem are in the form of 
linear system {bf:A}_{EC} {bf:x} = {bf:b}_{EC}, where {bf:A}_{EC} is the 
equality-constraints (EC) matrix and {bf:b}_{EC} is the right-hand-side
(RHS) vector.

{pmore}
{it:q}{cmd:.setEquality(}{it:ecmat}{cmd:,} {it:rhs}{cmd:)} sets the EC
matrix and the RHS vector.

{pmore}
{it:q}{cmd:.getEquality()} returns a matrix containing both the EC matrix and
the RHS vector. The RHS vector is the last column of the returned matrix.  (An
empty matrix is returned if equality constraints were not specified.)

{marker setInequality}{...}
{pstd}
{bf:q.setInequality() and q.getInequality()}

{pstd}
The inequality constraints for a linear programming problem are in the form of
linear system {bf:A}_{IE} {bf:x} {ul:<} {bf:b}_{IE}, where {bf:A}_{IE} is the
inequality-constraints (IE) matrix and {bf:b}_{IE} is the RHS vector.

{pmore}
{it:q}{cmd:.setInequality(}{it:iemat}{cmd:,} {it:rhs}{cmd:)} sets the
IE matrix and the RHS vector.

{pmore}
{it:q}{cmd:.getInequality()} returns a matrix containing both the IE matrix
and the RHS vector. The RHS vector is the last column of the returned matrix.
(An empty matrix is returned if inequality constraints were not specified.)

{marker setBounds}{...}
{pstd}
{bf:q.setBounds() and q.getBounds()}

{pstd}
The parameters may have lower bounds or upper bounds. By default, the lower
bound is -infinity and the upper bound is infinity.

{pmore}
{it:q}{cmd:.setBounds(}{it:lowerbd}{cmd:,} {it:upperbd}{cmd:)} sets the lower
and upper bounds.  Using a missing value as the lower bound indicates
-infinity, and using a missing value as the upper bound indicates infinity.

{pmore}
{it:q}{cmd:.getBounds()} returns a two-row matrix containing the 
lower and upper bounds.

{marker setMaxiter}{...}
{pstd}
{bf:q.setMaxiter() and q.getMaxiter()}

{pmore}
{it:q}{cmd:.setMaxiter(}{it:maxiter}{cmd:)} specifies the maximum
number of iterations, which must be an integer greater than 0. The default
value of {it:maxiter} is {cmd:16000}.

{pmore}
{it:q}{cmd:.getMaxiter()} returns the current maximum number of iterations.

{marker setTol}{...}
{pstd}
{bf:q.setTol() and q.getTol()}

{pmore}
{it:q}{cmd:.setTol(}{it:tol}{cmd:)} specifies the
convergence-criterion tolerance, which must be greater than 0.  The default
value of {it:tol} is {cmd:1e-8}.

{pmore}
{it:q}{cmd:.getTol()} returns the currently specified tolerance.

{marker setTrace}{...}
{pstd}
{bf:q.setTrace() and q.getTrace()}

{pmore}
{it:q}{cmd:.setTrace(}{it:trace}{cmd:)} sets whether or not to 
print out computation details.  {it:trace} 
may be {cmd:"on"} or {cmd:"off"}.  The default value is {cmd:"off"}.

{pmore}
{it:q}{cmd:.getTrace()} returns the current trace status.


{marker syn_performopt}{...}
    {title:Performing optimization}

{marker optimize}{...}
{pstd}
{bf:q.optimize()}

{pmore}
{it:q}{cmd:.optimize()}
invokes the optimization process and returns the value of the objective
function at the optimum.


{marker syn_obtainres}{...}
    {title:Functions for obtaining results}

{pstd}
After performing optimization, the functions below provide results including 
parameters, the value at the optimum, the number of iterations, whether
convergence was achieved, error messages, and return codes.

{marker parameters}{...}
{pstd}
{bf:q.parameters()}

{pmore}
{it:q}{cmd:.parameters()} returns the parameter vector that optimizes the
objective function; it returns an empty vector prior to performing the
optimization.

{marker value}{...}
{pstd}
{bf:q.value()}

{pmore}
{it:q}{cmd:.value()} returns the value of the objective function at the
optimum; it returns a missing value prior to performing the optimization.

{marker iterations}{...}
{pstd}
{bf:q.iterations()}

{pmore}
{it:q}{cmd:.iterations()} returns the number of iterations.

{marker converged}{...}
{pstd}
{bf:q.converged()}

{pmore}
{it:q}{cmd:.converged()} returns {cmd:1} if the optimization converged
and {cmd:0} if not.

{marker errorcode}{...}
{pstd}
{bf:q.errorcode(), q.errortext(), and q.returncode()}

{pmore}
{it:q}{cmd:.errorcode()} returns the error code generated during the
computation; it returns {cmd:0} if no error is found.

{pmore}
{it:q}{cmd:.errortext()} returns an error message corresponding to the error
code generated during the computation; it returns an empty string if no error
is found.

{pmore}
{it:q}{cmd:.returncode()} returns the Stata return code corresponding to the
error code generated during the computation.

{marker errcodes}{...}
{pstd}
The error codes and the corresponding Stata return codes are as follows:

{p2colset 9 25 27 2}{...}
{p2col:Error{space 2}Return}{p_end}
{p2col:code{space 3}code}Error text{p_end}
{p2line}
{synopt:1{space 6}430}problem is infeasible{p_end}

{synopt:2{space 6}430}problem is unbounded{p_end}

{synopt:3{space 6}430}maximum number of iterations has been reached{p_end}

{synopt:4{space 6}3499}dimensions of coefficients, constraints, and bounds
do not conform{p_end}

{synopt:5{space 6}111}dimension of the parameters is 0{p_end}
{p2line}
{p2colreset}{...}


{marker syn_utilfcn}{...}
    {title:Utility function}

{pstd}
You can obtain a report of all settings and results currently stored 
in a class {cmd:LinearProgram()} instance.

{marker query}{...}
{pstd}
{bf:q.query()}

{pmore}
{it:q}{cmd:.query()} with no return value displays the information stored in
the class.


{marker description}{...}
{title:Description}

{pstd}
The {cmd:LinearProgram()} class finds the parameter vector that minimizes
or maximizes the linear objective function subject to some restrictions.
The restrictions may be linear equality constraints, linear inequality
constraints, lower bounds, or upper bounds.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 LinearProgram()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker conformability}{...}
{title:Conformability}

    {cmd:LinearProgram()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:LinearProgram(}{it:n}{cmd:)}:
       {it:input}:
                        {it:n}:  1 x 1
      {it:output}:
                   {it:result}:  1 x {it:n}

    {cmd:LinearProgram(}{it:m}{cmd:,} {it:n}{cmd:)}:
       {it:input}:
                        {it:m}:  1 x 1
                        {it:n}:  1 x 1
      {it:output}:
                   {it:result}:  {it:m} x {it:n}

    {cmd:setCoefficients(}{it:coef}{cmd:)}:
       {it:input}:
                     {it:coef}:  1 x {it:N}
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getCoefficients()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x {it:N}

    {cmd:setMaxOrMin(}{it:maxormin}{cmd:)}:
       {it:input}:
                   {it:object}:  1 x 1
      {it:output}:
                   {it:result}:  {it:void}

    {cmd:getMaxOrMin()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

    {cmd:setEquality(}{it:ecmat}{cmd:,} {it:rhs}{cmd:)}:
       {it:input}:
                    {it:ecmat}:  {it:M0} x {it:N}
                      {it:rhs}:  {it:M0} x 1
      {it:output}:
                   {it:result}:  {it:void}

     {cmd:getEquality()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  ({it:M0} + 1) x {it:N}

    {cmd:setInequality(}{it:iemat}{cmd:,} {it:rhs}{cmd:)}:
       {it:input}:
                    {it:iemat}:  {it:M1} x {it:N}
                      {it:rhs}:  {it:M1} x 1
      {it:output}:
                   {it:result}:  {it:void}

     {cmd:getInequality()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  ({it:M1} + 1) x {it:N}

    {cmd:setBounds(}{it:lowerbd}{cmd:,} {it:upperbd}{cmd:)}:
       {it:input}:
                  {it:lowerbd}:  1 x {it:N}
                  {it:upperbd}:  1 x {it:N}
      {it:output}:
                   {it:result}:  {it:void}

     {cmd:getBounds()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  2 x {it:N}

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

    {cmd:setTol(}{it:tol}{cmd:)}:
       {it:input}:
                      {it:tol}:  1 x 1
      {it:output}:
                   {it:result}:  {it:void}

     {cmd:getTol()}:
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

     {cmd:optimize()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x 1

     {cmd:parameters()}:
       {it:input}:
                            {it:void}
      {it:output}:
                   {it:result}:  1 x {it:N}

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
{cmd:LinearProgram()}, {it:q}{cmd:.set}{it:*}{cmd:()}, 
{it:q}{cmd:.get}{it:*}{cmd:()},
{it:q}{cmd:.parameters()}, {it:q}{cmd:.value()}, 
{it:q}{cmd:.iterations()}, {it:q}{cmd:.converged()}, 
{it:q}{cmd:.errorcode()}, {it:q}{cmd:.errortext()}, 
{it:q}{cmd:.returncode()}, and {it:q}{cmd:.query()} 
functions abort with an error message when used incorrectly.

{pstd}
{it:q}{cmd:.optimize()} aborts with an error message if it is used
incorrectly. If {it:q}{cmd:.optimize()} runs into numerical difficulties, it
returns a missing value and displays a warning message including some details
about the problem encountered.
{p_end}
