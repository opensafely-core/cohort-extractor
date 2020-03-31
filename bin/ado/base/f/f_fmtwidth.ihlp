{* *! version 1.1.1  02mar2015}{...}
    {cmd:fmtwidth(}{it:fmtstr}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the output length of the 
	{cmd:%}{it:fmt} contained in {it:fmtstr};
	{it:missing} if {it:fmtstr} does not contain a valid
	{cmd:%}{it:fmt}{p_end}

{p2col:}For example, {cmd:fmtwidth("%9.2f")} returns {cmd:9} and
	{cmd:fmtwidth("%tc")} returns {cmd:18}.{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
