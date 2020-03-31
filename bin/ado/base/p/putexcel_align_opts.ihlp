{* *! version 1.0.0  22oct2015}{...}
{* *! This ihlp is for putexcel. If you make changes here, check}{...}
{* *! if similar changes need be made to putexcela_align_opts.ihlp.}{...}
{phang}
{opt left} sets the specified cells to have contents left-aligned within the
cell.  {opt left} may not be combined with {opt right} or {opt hcenter}.
Right-alignment is the Excel default for numeric values and need not be
specified when outputting numbers.

{phang}
{opt hcenter} sets the specified cells to have contents horizontally centered
within the cell.  {opt hcenter} may not be combined with {opt left} or
{opt right}.

{phang}
{opt right} sets the specified cells to have contents right-aligned within the
cell.  {opt right} may not be combined with {opt left} or {opt hcenter}.
Left-alignment is the Excel default for text and need not be specified when
outputting strings.

{phang}
{opt top} sets the specified cells to have contents vertically aligned with the
top of the cell.  {opt top} may not be combined with {opt bottom} or
{opt vcenter}.

{phang}
{opt vcenter} sets the specified cells to have contents vertically aligned with
the center of the cell.  {opt vcenter} may not be combined with {opt top} or
{opt bottom}.

{phang}
{opt bottom} sets the specified cells to have contents vertically aligned with
the bottom of the cell.  {opt bottom} may not be combined with {opt top} or
{opt vcenter}.

{phang}
{opt txtindent(#)} sets the text indention in each cell in a cell
range.  {it:#} must be an integer between 0 and 15.

{phang}
{opt txtrotate(#)} sets the text rotation in each cell in a cell range.
{it:#} must be an integer between 0 and 180 or equal to 255.
{cmd:txtrotate(0)} is equal to no rotation and is the default.
{cmd:txtrotate(255)} specifies vertical text.  Values {cmd:1}-{cmd:90}
rotate the text counterclockwise 1 to 90 degrees.  Values {cmd:91}-{cmd:180}
rotate the text clockwise 1 to 90 degrees.

{phang}
{opt txtwrap} and {opt notxtwrap} specify whether or not the text is to be
wrapped in a cell or within each cell in a range of cells.
The default is no wrapping.  {cmd:notxtwrap} has an effect only if the cell or
cells were previously formatted to wrap.  {opt txtwrap} may not be specified
with {opt shrinkfit}.

{phang}
{opt shrinkfit} and {opt noshrinkfit} specify whether or not the text is to be
shrunk to fit in the cell width of a cell or in each cell of a range of cells.
The default is no shrinking.  {cmd:noshrinkfit} has an effect only if the cell
or cells were previously formatted to shrink text to fit.
{opt shrinkfit} may not be specified with {opt txtwrap}.

{phang}
{opt merge} tells Excel that cells in the specified cell range should be merged.
{opt merge} may be combined with {opt left}, {opt right}, {opt hcenter},
{opt top}, {opt bottom}, and {opt vcenter} to format the merged cell.
Merging cells that contain data in each cell will result in the
upper-leftmost data being kept.

{pmore}
Once you have merged cells, you can refer to the merged cell by using any single
cell from the specified
{help putexcel##cellrange:{it:cellrange}}.
For example, if you specified a {it:cellrange} of {cmd:A1:B2}, you could refer
to the merged cell using {cmd:A1}, {cmd:B1}, {cmd:A2}, or {cmd:B2}.

{phang}
{cmd:unmerge} tells Excel to unmerge previously merged cells.  When using
{cmd:unmerge}, you only need to use a single cell from the merged cell in the
previously specified
{help putexcel##cellrange:{it:cellrange}}.
{p_end}
