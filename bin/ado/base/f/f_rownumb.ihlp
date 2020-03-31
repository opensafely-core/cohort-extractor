{* *! version 1.1.3  22may2018}{...}
    {cmd:rownumb(}{it:M}{cmd:,}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the row number of {it:M} associated with row name {it:s};
	{it:missing} if the row cannot be found{p_end}
{p2col: Domain {it:M}:}matrices{p_end}
{p2col: Domain {it:s}:}strings{p_end}
{p2col: Range:}integer scalars 1 to {cmd:c(max_matdim)} or {it:missing}{p_end}
{p2colreset}{...}
