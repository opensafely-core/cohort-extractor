{* *! version 1.1.3  22may2018}{...}
    {cmd:el(}{it:s}{cmd:,}{it:i}{cmd:,}{it:j}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:s}{cmd:[floor(}{it:i}{cmd:),floor(}{it:j}{cmd:)]}, the
	  {it:i},{it:j} element of the matrix named {it:s};
	  missing if {it:i} or {it:j} are out of range or if matrix
          {it:s} does not exist{p_end}
{p2col: Domain {it:s}:}strings containing matrix name{p_end}
{p2col: Domain {it:i}:}scalars 1 to {cmd:c(max_matdim)}{p_end}
{p2col: Domain {it:j}:}scalars 1 to {cmd:c(max_matdim)}{p_end}
{p2col: Range:}scalars -8e+307 to 8e+307 or {it:missing}{p_end}
{p2colreset}{...}
