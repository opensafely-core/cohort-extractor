{* *! version 1.0.1  02mar2015}{...}
    {cmd:wordbreaklocale(}{it:loc}{cmd:,}{it:type}{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}the most closely related locale supported by ICU
	from {it:loc} if {it:type} is {cmd:1}, the actual locale where the
	word-boundary analysis data come from if {it:type} is {cmd:2}; or an
	empty string is returned for any other {it:type}{p_end}

{p2col:}{cmd:wordbreaklocale("en_us_texas", 1)} = {cmd:en_US}{break}
	{cmd:wordbreaklocale("en_us_texas", 2)} = {cmd:root}{p_end}
{p2col: Domain {it:loc}:}strings of locale name{p_end}
{p2col: Domain {it:type}:}integers{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
