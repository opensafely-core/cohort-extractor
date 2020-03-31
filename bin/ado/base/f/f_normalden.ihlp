{* *! version 1.2.1  02mar2015}{...}
    {cmd:normalden(}{it:z}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the standard normal density{p_end}
{p2col: Domain:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 0.39894 ...{p_end}
{p2colreset}{...}

    {cmd:normalden(}{it:x}{cmd:,}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the normal density with mean 0 and
	standard deviation {it:s}{p_end}

{p2col:}{cmd:normalden(}{it:x}{cmd:,}{cmd:1)} =
	{cmd:normalden(}{it:x}{cmd:)} and{break}
	{cmd:normalden(}{it:x}{cmd:,}{it:s}{cmd:)} =
        {cmd:normalden(}{it:x}/{it:s}{cmd:)}/{it:s}{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:s}:}1e-308 to 8e+307{p_end}
{p2col: Range:}0 to 8e+307{p_end}
{p2colreset}{...}

    {cmd:normalden(}{it:x}{cmd:,}{it:m}{cmd:,}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the
	normal density with mean {it:m} and standard deviation {it:s}{p_end}

{p2col:}{cmd:normalden(}{it:x}{cmd:,0,}{it:s}{cmd:)} =
	{cmd:normalden(}{it:x}{cmd:,}{it:s}{cmd:)} and{break}
	{cmd:normalden(}{it:x}{cmd:,}{it:m}{cmd:,}{it:s}{cmd:)} =
	{cmd:normalden(}({it:x}-{it:m})/{it:s}{cmd:)}/{it:s}{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:m}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:s}:}1e-308 to 8e+307{p_end}
{p2col: Range:}0 to 8e+307{p_end}
{p2colreset}{...}
