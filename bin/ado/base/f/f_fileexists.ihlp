{* *! version 1.1.1  02mar2015}{...}
    {cmd:fileexists(}{it:f}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{cmd:1} if the file specified by {it:f} exists;
	otherwise, {cmd:0}{p_end}

{p2col:}If the file exists but is not readable, {cmd:fileexists()}
	will still return {cmd:1}, because it does exist.  If the "file" is a
	directory, {cmd:fileexists()} will return {cmd:0}.{p_end}
{p2col: Domain:}filenames{p_end}
{p2col: Range:}0 and 1{p_end}
{p2colreset}{...}
