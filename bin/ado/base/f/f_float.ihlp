{* *! version 1.1.1  02mar2015}{...}
    {cmd:float(}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the value of {it:x} rounded to {cmd:float} precision{p_end}

{p2col:}Although you may store your numeric variables as {cmd:byte},
{cmd:int}, {cmd:long}, {cmd:float}, or {cmd:double}, Stata converts all
numbers to {cmd:double} before performing any calculations.  Consequently,
difficulties can arise in comparing numbers that have no finite binary
representations.

{p2col:}For example, if the variable {cmd:x} is stored as a
{cmd:float} and contains the value {cmd:1.1} (a repeating "decimal" in
binary), the expression {cmd:x==1.1} will evaluate to {it:false} because the
literal {cmd:1.1} is the {cmd:double} representation of 1.1, which is
different from the {cmd:float} representation stored in {cmd:x}.
(They differ by 2.384 x 10^(-8).)
The expression {cmd:x==float(1.1)} will evaluate to {it:true} because the
{cmd:float()} function converts the literal {cmd:1.1} to its {cmd:float}
representation before it is compared with {cmd:x}. (See
{findalias frprecision} for more information.){p_end}
{p2col: Domain:}-1e+38 to 1e+38{p_end}
{p2col: Range:}-1e+38 to 1e+38{p_end}
{p2colreset}{...}
