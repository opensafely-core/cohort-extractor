{* *! version 1.0.0  28dec2018}{...}
    {cmd:lndirichletden(}{it:A}{cmd:,}{it:X}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the natural logarithm of the density of the Dirichlet
distribution with vector {it:A} of shape parameters and random vector {it:X};
{it:missing} if any element of {it:A} or {it:X} is not positive; {it:missing}
if the sum of elements of {it:X} is greater or equal to 1{p_end}

{p2col:}The probability density function of the Dirichlet distribution is

	                         1
		               {hline 5} P(A,X) {1 - S(X)}^(A[n+1] - 1) 
	                        B(A)

{p2col:}where B(A) is the multivariate beta function, which can be expressed in terms of the gamma function:

	  		      gamma(A[1]) gamma(A[2]) ... gamma(A[n+1])
		       B(A) = {hline 41}
			   	      gamma(A[1] + A[2] + ... + A[n+1])

		     P(A,X) = X[1]^(A[1]-1) X[2]^(A[2]-1) ... X[n]^(A[n]-1)

		       S(X) = X[1] + X[2] + ... + X[n]

{p2col: Domain {it:A}:}1 x {it:n}+1 and {it:n}+1 x 1 vectors{p_end}
{p2col: Domain {it:X}:}1 x {it:n} and {it:n} x 1 vectors{p_end}
{p2col: Range:}-8e+307 to 8e+307{p_end}
{p2colreset}{...}
