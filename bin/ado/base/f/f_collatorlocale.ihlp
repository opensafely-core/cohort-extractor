{* *! version 1.0.1  02mar2015}{...}
    {cmd:collatorlocale(}{it:loc}{cmd:,}{it:type}{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}the most closely related locale supported by ICU from
	{it:loc} if {it:type} is {bf:1}; the actual locale where the collation
	data comes from if {it:type} is {bf:2}{p_end}

{p2col:}For any other {it:type}, {it:loc} is returned in a canonicalized
form.{p_end}

{p2col:}{cmd:collatorlocale("en_us_texas", 0)} = {cmd:en_US_TEXAS}{break}
	{cmd:collatorlocale("en_us_texas", 1)} = {cmd:en_US}{break}
	{cmd:collatorlocale("en_us_texas", 2)} = {cmd:root}{p_end}
{p2col: Domain {it:loc}:}strings of locale name{p_end}
{p2col: Domain {it:type}:}integers{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
