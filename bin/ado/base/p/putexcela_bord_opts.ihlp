{* *! version 1.0.3  30may2019}{...}
{* *! This ihlp is for putexcel advanced. If you make changes here, check}{...}
{* *! if similar changes need be made to putexcel_bord_opts.ihlp.}{...}
{marker border}{...}
{phang}
{cmd:border(}{it:border} [{cmd:,} {it:style} [{cmd:,} {it:color}]]{cmd:)}
sets the cell border, style, and color for a cell or range of cells.

{phang2}
{it:border}
may be {opt all}, {opt left}, {opt right}, {opt top}, or {opt bottom}.

{phang2}
{it:style} is a keyword specifying the look of the border.  The most common
styles are {opt thin}, {opt medium}, {opt thick}, and {opt double}.  The default
is {opt thin}.  For a complete list of border styles, see the
{help putexcel##style:{it:Appendix}} in
{bf:[RPT] putexcel}.
To remove an existing border, specify {cmd:none} as the {it:style}.

{phang2}
{it:color} may be
a valid RGB value in the form {cmd:"}{it:### ### ###}{cmd:"}
or may be one of the colors listed in the table of
colors in the {help putexcel##Colors:{it:Appendix}} in
{bf:[RPT] putexcel}.
If no {it:color} is specified, then Excel workbook defaults are used.

{marker dborder}{...}
{phang}
{cmd:dborder(}{it:direction} [{cmd:,} {it:style} [{cmd:,} {it:color}]]{cmd:)}
sets the cell diagonal border direction, style, and color for a
cell or range of cells.

{phang2}
{it:direction} may be {cmd:down}, {cmd:up}, or {cmd:both}.  {cmd:down} draws a
line from the upper-left corner of the cell to the lower-right corner of the
cell or, for a range of cells, from the upper-left corner of {it:ul_cell} to
the lower-right corner of {it:lr_cell}.  {cmd:up} draws a line from the
lower-left corner of the cell to the upper-right corner of the cell or, for a
range of cells, from the lower-left corner of the area defined by
{it:ul_cell}{cmd::}{it:lr_cell} to the upper-right corner.

{phang2}
{it:style} is a keyword specifying the look of the border.  The most common
styles are {cmd:thin}, {cmd:medium}, {cmd:thick}, and {cmd:double}.  The default
is {cmd:thin}.  For a
complete list of border styles, see 
the {help putexcel##style:{it:Appendix}} in
{bf:[RPT] putexcel}.
To remove an existing border, specify {cmd:none} as the {it:style}.

{phang2}
{it:color} may be 
a valid RGB value in the form {cmd:"}{it:### ### ###}{cmd:"} or 
may be one of the colors listed in the table of colors in the 
{help putexcel##Colors:{it:Appendix}} in {bf:[RPT] putexcel}.
If no {it:color} is specified, then Excel workbook defaults are used.
{p_end}
