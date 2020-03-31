{* *! version 1.1.1  02mar2015}{...}
    {cmd:fileread(}{it:f}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the contents of the file specified by {it:f}{p_end}

{p2col:}If the file does not exist or an I/O error occurs while
	reading the file, then "{cmd:fileread() error} {it:#}" is returned,
	where {it:#} is a standard Stata error return code.{p_end}
{p2col: Domain:}filenames{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
