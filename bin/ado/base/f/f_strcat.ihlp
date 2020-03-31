{* *! version 1.1.2  02mar2015}{...}
    {cmd:strcat(}{it:s1}{cmd:,}{it:s2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}there is no {cmd:strcat()} function; instead the
        addition operator is used to concatenate strings{p_end}

{p2col:}{cmd:"hello " + "world"} = {cmd:"hello world"}{break}
	{cmd:"a" + "b"} = {cmd:"ab"} {break}
	{cmd:"Café " + "de Flore"} = {cmd:"Café de Flore"}{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
