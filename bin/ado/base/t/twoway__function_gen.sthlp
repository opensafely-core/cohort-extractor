{smcl}
{* *! version 1.0.8  04nov2014}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway function" "help twoway_function"}{...}
{viewerjumpto "Syntax" "twoway__function_gen##syntax"}{...}
{viewerjumpto "Description" "twoway__function_gen##description"}{...}
{viewerjumpto "Options" "twoway__function_gen##options"}{...}
{viewerjumpto "Examples" "twoway__function_gen##examples"}{...}
{viewerjumpto "Stored results" "twoway__function_gen##results"}{...}
{title:Title}

{p 4 34 2}
{hi:[G-2] twoway__function_gen} {hline 2} twoway function subroutine


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:twoway__function_gen}
	[[{it:y}] =]
	{it:f}({it:x})
	[{cmd:if} {it:exp}]
	{cmd:,}{break}
	{cmdab:r:ange:(}{it:range}{cmd:)}{break}
	{cmdab:x:is:(}{it:name}{cmd:)}{break}
	[
	{cmd:n(}{it:#}{cmd:)}
	{cmdab:gen:erate:(}{it:yvar} {it:xvar} [, {cmd:replace} ]{cmd:)}
	{cmdab:drop:lines:(}{it:numlist}{cmd:)}
	]

{pstd}
where {it:f}({it:x}) is a "mathematical" expression with only one "mathematical"
variable that is identified in {cmd:xis()}.


{marker description}{...}
{title:Description}

{pstd}
Suppose that you wanted to plot {it:y} = {it:f}({it:x}), where by
{it:f}({it:x}) we mean some function of {it:x}.  {it:x} is not really a Stata
variable (neither is {it:y}), but {cmd:twoway__function_gen} can be used to
generate Stata variables (usually {cmd:tempvar}s) that may represent {it:x}
and {it:y} on an evenly spaced grid of values over a specified range.

{pstd}
{cmd:twoway__function_gen} was written to help in parsing and generating
variables for {cmd:graph} {cmd:twoway} {cmd:function}; see
{manhelp twoway_function G-2:graph twoway function}.  The expression in
{it:f}({it:x}) will only be evaluated if at least one of the {cmd:generate()}
or {cmd:droplines()} options is specified.


{marker options}{...}
{title:Options}

{phang}
{cmd:range(}{it:range}{cmd:)} specifies the range of values for {it:x}.  Here
{it:range} can be a pair of numbers identifying the minimum and maximum, or
{it:range} can be a variable.  If {it:range} is a variable, the range is
determined by the values of {cmd:r(min)} and {cmd:r(max)} after

{pmore}
{cmd}. summarize {it:range} if {it:exp}, meanonly{text}

{phang}
{cmd:xis(}{it:name}{cmd:)} specifies a valid Stata name for {it:x} in
{it:f}({it:x}).

{phang}
{cmd:n(}{it:#}{cmd:)} specifies the number of evaluation points.  The default
is {cmd:n(1)}.

{phang}
{cmd:generate(}{it:yvar} {it:xvar} [{cmd:,} {cmd:replace}]{cmd:)} specifies
the names of the variables to generate.  The grid of values is placed in
{it:xvar}, and the values of {it:f}({it:xvar}) are placed in {it:yvar}.  The
{cmd:replace} option indicates that these variables may be replaced if they
already exist.

{phang}
{cmd:droplines(}{it:numlist}{cmd:)} builds a list of {it:x y} pairs on the
function {it:f}({it:x}), where each {it:x} is an element of {it:numlist} and
{it:y} is the value of {it:f}({it:x}).  The list of {it:x y} pairs are
returned in {cmd:r(dropxy)}.  This option facilitates the {cmd:droplines()}
option of {cmd:twoway} {cmd:graph} {cmd:function}; see
{manhelp twoway_function G-2:graph twoway function}.


{marker examples}{...}
{title:Examples}

    {cmd}. clear
    {txt}
    {cmd}. set obs 10
    {txt}number of observations (_N) was 0, now 10

{phang}
    {cmd}. twoway__function_gen y = sin(c(pi)*x), r(-2 2) x(x) gen(y x, replace) n(`c(N)')

    {cmd}. list y x
    {txt}
	 {c TLC}{hline 12}{c -}{hline 12}{c TRC}
	 {c |} {res}         y            x {txt}{c |}
	 {c LT}{hline 12}{c -}{hline 12}{c RT}
      1. {c |} {res} 2.449e-16           -2 {txt}{c |}
      2. {c |} {res} .98480775   -1.5555556 {txt}{c |}
      3. {c |} {res} .34202014   -1.1111111 {txt}{c |}
      4. {c |} {res} -.8660254   -.66666667 {txt}{c |}
      5. {c |} {res}-.64278761   -.22222222 {txt}{c |}
	 {c LT}{hline 12}{c -}{hline 12}{c RT}
      6. {c |} {res} .64278761    .22222222 {txt}{c |}
      7. {c |} {res}  .8660254    .66666667 {txt}{c |}
      8. {c |} {res}-.34202014    1.1111111 {txt}{c |}
      9. {c |} {res}-.98480775    1.5555556 {txt}{c |}
     10. {c |} {res}-1.133e-15            2 {txt}{c |}
	 {c BLC}{hline 12}{c -}{hline 12}{c BRC}

    {cmd}. sysuse auto, clear
    {txt}(1978 Automobile Data)

    {cmd}. sum mpg if for

    {txt}    Variable {c |}       Obs        Mean    Std. Dev.       Min        Max
    {hline 13}{c +}{hline 56}
	     mpg {c |}{res}        22    24.77273    6.611187         14         41
    {txt}
    {cmd}. return list
    
    {txt}scalars:
		     r(N) =  {res}22
		 {txt}r(sum_w) =  {res}22
		  {txt}r(mean) =  {res}24.77272727272727
		   {txt}r(Var) =  {res}43.70779220779221
		    {txt}r(sd) =  {res}6.611186898567625
		   {txt}r(min) =  {res}14
		   {txt}r(max) =  {res}41
		   {txt}r(sum) =  {res}545

{phang}
    {cmd}. twoway__function_gen y = normden(x,`r(mean)',`r(sd)') if for, r(mpg) x(x) gen(y x, replace) n(5)

    {cmd}. list y x in 1/5
    {txt}
	 {c TLC}{hline 11}{c -}{hline 7}{c TRC}
	 {c |} {res}        y       x {txt}{c |}
	 {c LT}{hline 11}{c -}{hline 7}{c RT}
      1. {c |} {res}.01599807      14 {txt}{c |}
      2. {c |} {res}.05014576   20.75 {txt}{c |}
      3. {c |} {res}.05542139    27.5 {txt}{c |}
      4. {c |} {res}.02159718   34.25 {txt}{c |}
      5. {c |} {res}.00296752      41 {txt}{c |}
	 {c BLC}{hline 11}{c -}{hline 7}{c BRC}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:twoway__function_gen} stores the following in {cmd:r()}:

{pstd}
Scalars:

	 {cmd:r(n)}        number of evaluation points
	 {cmd:r(min)}      minimum of {cmd:range()}
	 {cmd:r(max)}      maximum of {cmd:range()}
	 {cmd:r(delta)}    distance between grid points

{pstd}
Macros:

	 {cmd:r(yis)}      {it:y} or "y" if not specified
	 {cmd:r(xis)}      {it:x} from {cmd:xis(}{it:x}{cmd:)} option
	 {cmd:r(exp)}      the expression {it:f}({it:x})
	 {cmd:r(range)}    {it:range} from {cmd:range(}{it:range}{cmd:)} option
	 {cmd:r(yformat)}  from {cmd:yformat()} option
	 {cmd:r(xformat)}  from {cmd:xformat()} option
	 {cmd:r(dropxy)}   {it:x y} pairs from {cmd:droplines()} option
