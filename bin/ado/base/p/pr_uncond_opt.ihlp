{* *! version 1.0.4  18mar2011}{...}
{phang}
{opt pr(a,b)} calculates the probability
Pr(a {ul:<} y {ul:<} b), where a and b are nonnegative integers that may be
specified as numbers or variables;

{pmore}
b missing {bind:(b {ul:>} .)} means plus infinity;{break}
{cmd:pr(20,.)}
calculates {bind:Pr(y {ul:>} 20)}; {break}
{cmd:pr(20,}{it:b}{cmd:)} calculates {bind:Pr(y {ul:>} 20)} in
observations for which {bind:b {ul:>} .}{break}
and calculates {bind:Pr(20 {ul:<} y {ul:<} b)} elsewhere.

{pmore}
{cmd:pr(.,}{it:b}{cmd:)} produces a syntax error.  A missing value in an
observation of the variable {it:a} causes a missing value in that
observation for {opt pr(a,b)}.{p_end}
