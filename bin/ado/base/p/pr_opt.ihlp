{* *! version 1.0.0  04may2007}{...}
{phang}
{opt pr(a,b)} calculates {bind:Pr({it:a} < xb + u < {it:b})}, the
probability that y|x would be observed in the interval ({it:a},{it:b}).

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names; {it:lb} and 
{it:ub} are variable names;{break}
{cmd:pr(20,30)} calculates {bind:Pr(20 < xb + u < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,}{it:ub}{cmd:)} calculates
{bind:Pr({it:lb} < xb + u < {it:ub})}; and{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(20 < xb + u < {it:ub})}.

{pmore}
{it:a} missing {bind:({it:a} {ul:>} .)} means minus infinity;
{cmd:pr(.,30)} calculates {bind:Pr(-infinity < xb + u < 30)};{break}
{cmd:pr(}{it:lb}{cmd:,30)} calculates
{bind:Pr(-infinity < xb + u < 30)} in
observations for which {bind:{it:lb} {ul:>} .}{break} 
and calculates {bind:Pr({it:lb} < xb + u < 30)} elsewhere.

{pmore}
{it:b} missing {bind:({it:b} {ul:>} .)} means plus infinity; {cmd:pr(20,.)} 
calculates {bind:Pr(+infinity > xb + u > 20)}; {break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(+infinity > xb + u > 20)} in
observations for which {bind:{it:ub} {ul:>} .}{break}
and calculates {bind:Pr(20 < xb + u < {it:ub})} elsewhere.
{p_end}
