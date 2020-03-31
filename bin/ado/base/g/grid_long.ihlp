{* *! version 1.0.0  22jun2019}{...}
{marker grid()}{...}
{phang}
{cmd:grid(}{it:#_g} [{cmd:,} {opt ratio(#)} {opt min(#)}]{cmd:)} specifies the
set of possible lambdas using a logarithmic grid with {it:#_g} grid points.

{phang2}
{it:#_g} is the number of grid points for lambda.  The default is {it:#_g} =
100.  The grid is logarithmic with the ith grid point (i = 1, ..., n =
{it:#_g}) given by ln lambda_i = [(i - 1)/(n - 1)] ln r + ln lambda_{gmax},
where lambda_{gmax} = lambda_1 is the maximum, lambda_{gmin} = lambda_n =
{opt min(#)} is the minimum, and r = lambda_{gmin}/lambda_{gmax} = 
{opt ratio(#)} is the ratio of the minimum to the maximum.

{phang2}
{opt ratio(#)} specifies lambda_{gmin}/lambda_{gmax}.  The maximum of the
grid, lambda_{gmax}, is set to the smallest lambda for which all the
coefficients in the lasso are estimated to be zero (except the coefficients of
the {it:alwaysvars}).  lambda_{gmin} is then set based on {opt ratio(#)}.
When p < N, where p is the total number of {it:othervars} and {it:alwaysvars}
(not including the constant term) and N is the number of observations, the
default value of {opt ratio(#)} is 1e-4.  When p >= N, the default is 1e-2.

{phang2}
{opt min(#)} sets lambda_{gmin}. By default, lambda_{gmin} is based on
{opt ratio(#)} and lambda_{gmax}, which is computed from the data.
