{* *! version 1.1.1  02mar2015}{...}
    {cmd:rbeta(}{it:a}{cmd:,}{it: b}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}beta({it:a},{it:b}) random variates, where
	{it:a} and {it:b} are the beta distribution shape parameters{p_end}

{p2col:}Besides using the standard methodology for generating random 
	variates from a given distribution, {cmd:rbeta()} uses the 
	specialized algorithms of Johnk
        ({help rbeta()##G2003:Gentle 2003}),
	Atkinson and Wittaker ({help rbeta()##AW1970:1970},
                               {help rbeta()##AW1976:1976}),
        {help rbeta()##D1986:Devroye (1986)}, and 
	{help rbeta()##SB1980:Schmeiser and Babu (1980)}.{p_end}
{p2col: Domain {it:a}:}0.05 to 1e+5{p_end}
{p2col: Domain {it:b}:}0.15 to 1e+5{p_end}
{p2col: Range:}0 to 1 (exclusive){p_end}
{p2colreset}{...}
