{smcl}
{* *! version 1.0.4  11feb2011}{...}
{* this hlp file called by testnl.dlg}{...}
{vieweralsosee "[R] testnl" "help testnl"}{...}
{title:Examples of nonlinear expressions for testnl}


{title:One specification only for single-equation models:}

{pstd}
Coefficients are referred to as _b[varname].  With only one
specification, parentheses around the specification are optional.

    {cmd:_b[x]/_b[y] = _b[z]}

    {cmd:_b[x] = exp((_b[y]+_b[z])/2)}


{title:Multiple specifications for single-equation models:}

{pstd}
Parentheses around each specification are required.

{phang}
{cmd:(_b[x]/ _b[y] = _b[z]/2) (log(_b[a]) = _b[b])}

{phang}
{cmd:(exp(_b[y]) = _b[z]/2) (log(_b[x]) = log(_b[a])) (_b[c]/_b[d] = _b[b])}


{title:Multiple specifications for multiple-equation models:}

{pstd}
To specify a coefficient of an equation, use [equation]_b[varname].
In these examples,equations are A and B.  Parentheses around each
specification are required.

{phang}
{cmd:([A]_b[x]/ [A]_b[y] = [B]_b[x]/[B]_b[y]) (log([A]_b[a]) = log([B]_b[a]))}

{phang}
{cmd:(exp([A]_b[y]) = exp([B]_b[y]) (log([A]_b[x]) = [B]_b[a]))}
{p_end}
