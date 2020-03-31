{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] factorial()" "mansection M-5 factorial()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_factorial##syntax"}{...}
{viewerjumpto "Description" "mf_factorial##description"}{...}
{viewerjumpto "Conformability" "mf_factorial##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_factorial##diagnostics"}{...}
{viewerjumpto "Source code" "mf_factorial##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] factorial()} {hline 2}}Factorial and gamma function
{p_end}
{p2col:}({mansection M-5 factorial():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real{bind:    }matrix}{bind:  }
{cmd:factorial(}{it:real matrix R}{cmd:)}

{p 8 12 2}
{it:real{bind:    }matrix}
{cmd:lnfactorial(}{it:real matrix R}{cmd:)}

{p 8 12 2}
{it:numeric matrix}{bind:    }
{cmd:lngamma(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:numeric matrix}{bind:      }
{cmd:gamma(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
{it:real{bind:    }matrix}{bind:    }
{cmd:digamma(}{it:real matrix R}{cmd:)}

{p 8 12 2}
{it:real{bind:    }matrix}{bind:   }
{cmd:trigamma(}{it:real matrix R}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:factorial(}{it:R}{cmd:)} returns the elementwise factorial of {it:R}.  

{p 4 4 2}
{cmd:lnfactorial(}{it:R}{cmd:)} returns the elementwise
ln(factorial({it:R}{cmd:))}, calculated differently.  Very large values of
{it:R} may be evaluated.

{p 4 4 2}
{cmd:lngamma(}{it:Z}{cmd:)}, for {it:Z} real, returns the elementwise 
real result 
{cmd:ln(abs(gamma(}{it:Z}{cmd:)))}, but calculated differently.  
{cmd:lngamma(}{it:Z}{cmd:)}, for {it:Z} complex, returns the elementwise 
{cmd:ln(gamma(}{it:Z}{cmd:))}, calculated differently.  
Thus, 
{cmd:lngamma(}-2.5{cmd:)} = -0.056244,
whereas 
{cmd:lngamma(}-2.5+0i{cmd:)} = -0.056244 + 3.1416i.
In both cases, 
very large values of {it:Z} may be evaluated.

{p 4 4 2}
{cmd:gamma(}{it:Z}{cmd:)} returns {cmd:exp(lngamma(}{it:Z}{cmd:))} for complex
arguments and {cmd:Re(exp(lngamma(C(}{it:Z}{cmd:))))} for real arguments.
Thus, {cmd:gamma()} can correctly calculate, say, 
{cmd:gamma(}-2.5{cmd:)} even for real arguments.

{p 4 4 2}
{cmd:digamma(}{it:R}{cmd:)} returns the derivative of {cmd:lngamma()}
for {it:R}>0, sometimes called the psi function.  
{cmd:digamma()} requires a real argument.

{p 4 4 2}
{cmd:trigamma(}{it:R}{cmd:)} returns the second derivative of {cmd:lngamma()}
for {it:R}>0.  
{cmd:trigamma()} requires a real argument.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
All functions return a matrix of the same dimension as input,
containing element-by-element calculated results.


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:factorial()} returns missing for noninteger arguments, negative
arguments, and arguments > 167.

{p 4 4 2}
{cmd:lnfactorial()} returns missing for noninteger arguments, negative
arguments, and arguments > 1e+305.

{p 4 4 2}
{cmd:lngamma()} returns missing for 0, negative integer arguments, negative
arguments {ul:<} -2,147,483,648, and arguments > 1e+305.

{p 4 4 2}
{cmd:gamma()} returns missing for real arguments > 171 and
for negative integer arguments.

{p 4 4 2}
{cmd:digamma()} returns missing for 0 and negative integer arguments
and for arguments < -10,000,000.

{p 4 4 2}
{cmd:trigamma()} returns missing for 0 and negative integer arguments
and for arguments < -10,000,000.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view gamma.mata, adopath asis:gamma.mata};
other functions are built in.
{p_end}
