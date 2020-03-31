{* *! version 1.1.1  21may2018}{...}
{p2col :{opt pr(a,b)}}Pr({it:a} < y < {it:b}){p_end}
{p2col :{opt e(a,b)}}{it:E}(y {c |} {it:a} < y < {it:b}){p_end}
{p2col :{opt ys:tar(a,b)}}{it:E}(y*), y* = max{c -(}{it:a},min(y,{it:b}){c )-}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdf}}not allowed with {cmd:margins}{p_end}
