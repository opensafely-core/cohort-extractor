{* *! version 1.0.3  30may2019}{...}
{* *! This ihlp is for putexcel advanced. If you make changes here, check}{...}
{* *! if similar changes need be made to putexcel_fill_opts.ihlp.}{...}
{marker fpattern}{...}
{phang}
{cmd:fpattern(}{it:pattern} [{cmd:,} {it:fgcolor} [{cmd:,}
{it:bgcolor}]]{cmd:)} sets the fill pattern, foreground color, and background
color for a cell or range of cells.

{phang2}
{it:pattern} is a keyword specifying the fill pattern.  The most common fill
patterns are {opt solid} for a solid color (determined by {it:fgcolor}),
{opt gray25} for 25% gray scale, {opt gray50} for 50% gray scale, and
{opt gray75} for 75% gray scale.  A complete list of fill patterns is shown in
the {help putexcel##pattern:{it:Appendix}} of {bf:[RPT] putexcel}.
To remove an existing fill pattern from the cell or cells, specify {opt none}
as the {it:pattern}.

{phang2}
{it:fgcolor} specifies the foreground color.  The default foreground color is
{opt black}.  {it:fgcolor} may be 
a valid RGB value in the form {cmd:"}{it:### ### ###}{cmd:"} or 
may be any of the colors listed in the table of colors in the 
{help putexcel##Colors:{it:Appendix}} in {bf:[RPT] putexcel}.

{phang2}
{it:bgcolor} specifies the background color.  {it:bgcolor} may be 
a valid RGB value in the form {cmd:"}{it:### ### ###}{cmd:"}
or may be any of the colors listed in the table of colors in the 
{help putexcel##Colors:{it:Appendix}} in {bf:[RPT] putexcel}.
If no {it:bgcolor} is specified, then Excel workbook defaults are used.
{p_end}
