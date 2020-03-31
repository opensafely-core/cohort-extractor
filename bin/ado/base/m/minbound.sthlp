{smcl}
{* *! version 1.1.6  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Syntax" "minbound##syntax"}{...}
{viewerjumpto "Description" "minbound##description"}{...}
{viewerjumpto "Options" "minbound##options"}{...}
{viewerjumpto "Examples" "minbound##examples"}{...}
{viewerjumpto "Stored results" "minbound##results"}{...}
{viewerjumpto "References" "minbound##references"}{...}
{title:Title}

{p 4 16 2}
{hi:[R] minbound} {hline 2} Minimize a scalar function on a range{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 27 2}
{cmd:minbound} {it:progname}{cmd:,} {opt ran:ge(#1 #2)}
[
   {opt from(#)}
   {opt arg:uments(str)}
   {opt tol:erance(#)}
   {opt iter:ate(#)}
   {opt miss:ing}
   {opt tr:ace}
]


{marker description}{...}
{title:Description}

{pstd}
{cmd:minbound} minimizes a smooth scalar function on a range using function
values only ({help minbound##B1973:Brent 1973}).
The function {it:progname} should be implemented
as an {help program:rclass} program; it should accept as the first argument
the value x with respect to which the function is to be evaluated, as well as
optional other arguments transferred with the option {cmd:arguments()}; and it
should return the function value in {cmd:r(fx)}.


{marker options}{...}
{title:Options}

{phang}{opt range(#1 #2)}
is not optional; it specifies the range over which the function is to be
minimized.  #1 and #2 may be literals or expressions and should be
separated by a comma or space.

{phang}{opt from(#)}
specifies an initial value.  It should satisfy the range conditions.

{phang}{opt arguments(str)}
specifies optional arguments for {it:progname}.  Multiple arguments are
separated by spaces.

{phang}{opt tolerance(#)}
specifies the tolerance for the minimizer x.  The default is 1e-5.

{phang}{opt iterate(#)}
specifies the maximum number of iterations.  The default is 100.

{phang}{opt missing}
specifies that missing values returned by {it:progname} be treated
as ordinary values (that is, larger than any nonmissing values).  The default
behavior is that missing function values are an error.

{phang}{opt trace}
displays an iteration trace.


{marker examples}{...}
{title:Examples}

{pstd}
We want to minimize the quadratic function f(x) = x^2.

{tab}{cmd:. program quadratic, rclass}
{tab}{cmd:          return scalar fx = (`1')^2}
{tab}{cmd:  end}

{tab}{cmd:. minbound quadratic, range(0 2)}
{tab}{cmd:. minbound quadratic, range(-4 4) from(2) trace}

{pstd}
Note: We suggest that you code the program {cmd:quadratic} somewhat less
concisely as

{tab}{cmd:. program quadratic, rclass}
{tab}{cmd:          version 9}
{tab}{cmd:          args x}
{tab}{cmd:          return scalar fx = (`x')^2}
{tab}{cmd:  end}

{pstd}
We can also write a more general function that minimizes a general quadratic
function ax^2+bx+c with respect to x.

{tab}{cmd:. program quadratic2, rclass}
{tab}{cmd:          version 9}
{tab}{cmd:          args x a b c}
{tab}{cmd:          return scalar fx = `a'*(`x')^2 + `b'*`x' + `c'}
{tab}{cmd:  end}

{pstd}
To minimize 2x^2-3x+1 with respect to x on [-100,100], you type

{tab}{cmd:. minbound quadratic2, range(-100 100) arg(2 -3 1)}

{pstd}
We can also minimize the inverted U-shaped parabola -2x^2+3x+1 with respect to
x on [-1,1] -- the minimizer is at the boundary of the range,

{tab}{cmd:. minbound quadratic2, range(-1 1) arg(-2 3 1)}


{marker results}{...}
{title:Stored results}

{pstd}{cmd:minbound} stores the following in {cmd:r()}:

{tab}{cmd:r(x)}   minimizer
{tab}{cmd:r(fx)}  function value in x
{tab}{cmd:r(gx)}  first-order derivative of f with respect to x
{tab}{cmd:r(hx)}  second-order derivative of f with respect to x


{marker references}{...}
{title:References}

{marker B1973}{...}
{phang}
Brent, R. P. 1973.
{it:Algorithms for Minimization without Derivatives}.
Englewood Cliffs, NJ: Prentice Hall.  (Reprinted in paperback by Dover
Publications, Mineola, NY, January 2002.)

{phang}
Press, W. H., B. P. Flannery, S. A. Teukolsky, and W. T. Vetterling. 1989.
{it:Numerical Recipes in Pascal: The Art of Scientific Computing}.
Cambridge: Cambridge University Press.
{p_end}
