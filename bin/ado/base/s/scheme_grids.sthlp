{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee "scheme axes" "help scheme axes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that control grid lines}

{p 3 3 2}
These settings control whether grid lines are drawn and how they look.  All
grid lines are associated with an axis, and their location is determined by
their association with major or minor axis labels or ticks.  See 
{help scheme axes} for entries that change axis labels and ticks.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_grids##remarks1:Look of grid lines}{p_end}
{p 8 12 0}{help scheme_grids##remarks2:Whether grid lines are drawn}{p_end}
{p 8 12 0}{help scheme_grids##remarks3:Construction of grid lines}{p_end}
{p 8 12 0}{help scheme_grids##remarks4:Overall grid styles}{p_end}


{marker remarks1}{...}
{title:Look of grid lines}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
These entries control how grid lines look.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linewidth     {space 2}major_grid} {space 1}{it:{help linewidthstyle:linewidth}}}
	line thickness for all grids{p_end}
{p2col:{cmd:color         {space 6}major_grid} {space 1}{it:{help colorstyle}}}
	line color for all grids{p_end}
{p2col:{cmd:linepattern   {space 0}major_grid} {space 1}{it:{help linepatternstyle}}}
	line pattern for all grids{p_end}

{p2col:{cmd:linestyle     {space 2}major_grid} {space 1}{it:{help linestyle}}}
	overall {it:linestyle} for all grids (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks2}{...}
{title:Whether grid lines are drawn}

{p2colset 4 43 46 0}{...}
{p 3 3 2}
These entries control whether grid lines are drawn for sets of axis ticks
and/or labels {c -} for example, major labels on the {it:x} axis or minor ticks
on the {it:y} axis.  Note that changes will have no effect unless the graph is
using the associated {help ticksetstyle:tickset style}.

{p 3 3 2}
The entries beyond the first 8 below are of interest primarily to programmers,
as they are used by default only to construct the compound axes of bar, box,
and dot graphs.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno draw_major_hgrid}       {space 6}{{cmd:yes}|{cmd:no}}}
	horizontal axes, major labels, default{p_end}
{p2col:{cmd:yesno draw_minor_hgrid}       {space 6}{{cmd:yes}|{cmd:no}}}
	horizontal axes, minor labels, default{p_end}
{p2col:{cmd:yesno draw_majornl_hgrid}     {space 4}{{cmd:yes}|{cmd:no}}}
	horizontal axes, major ticks, default{p_end}
{p2col:{cmd:yesno draw_minornl_hgrid}     {space 4}{{cmd:yes}|{cmd:no}}}
	horizontal axes, minor ticks, default{p_end}

{p2col:{cmd:yesno draw_major_vgrid}       {space 6}{{cmd:yes}|{cmd:no}}}
	vertical axes, major labels, default{p_end}
{p2col:{cmd:yesno draw_minor_vgrid}       {space 6}{{cmd:yes}|{cmd:no}}}
	vertical axes, minor labels, default{p_end}
{p2col:{cmd:yesno draw_majornl_vgrid}     {space 4}{{cmd:yes}|{cmd:no}}}
	vertical axes, major ticks, default{p_end}
{p2col:{cmd:yesno draw_minornl_vgrid}     {space 4}{{cmd:yes}|{cmd:no}}}
	vertical axes, major ticks, default{p_end}

{p2col:{cmd:yesno draw_major_nl_hgrid}    {space 3}{{cmd:yes}|{cmd:no}}}
	horizontal axes, major labels, no labels tickset{p_end}
{p2col:{cmd:yesno draw_minor_nl_hgrid}    {space 3}{{cmd:yes}|{cmd:no}}}
	horizontal axes, minor labels, no labels tickset{p_end}
{p2col:{cmd:yesno draw_majornl_nl_hgrid}  {space 1}{{cmd:yes}|{cmd:no}}}
	horizontal axes, major ticks, no labels tickset{p_end}
{p2col:{cmd:yesno draw_minornl_nl_hgrid}  {space 1}{{cmd:yes}|{cmd:no}}}
	horizontal axes, minor ticks, no labels tickset{p_end}

{p2col:{cmd:yesno draw_major_nl_vgrid}    {space 3}{{cmd:yes}|{cmd:no}}}
	vertical axes, major labels, no labels tickset{p_end}
{p2col:{cmd:yesno draw_minor_nl_vgrid}    {space 3}{{cmd:yes}|{cmd:no}}}
	vertical axes, minor labels, no labels tickset{p_end}
{p2col:{cmd:yesno draw_majornl_nl_vgrid}  {space 1}{{cmd:yes}|{cmd:no}}}
	vertical axes, major ticks, no labels tickset{p_end}
{p2col:{cmd:yesno draw_minornl_nl_vgrid}  {space 1}{{cmd:yes}|{cmd:no}}}
	vertical axes, minor ticks, no labels tickset{p_end}

{p2col:{cmd:yesno draw_major_nt_hgrid}    {space 3}{{cmd:yes}|{cmd:no}}}
	horizontal axes, major labels, no ticks tickset{p_end}
{p2col:{cmd:yesno draw_minor_nt_hgrid}    {space 3}{{cmd:yes}|{cmd:no}}}
	horizontal axes, minor labels, no ticks tickset{p_end}
{p2col:{cmd:yesno draw_majornl_nt_hgrid}  {space 1}{{cmd:yes}|{cmd:no}}}
	horizontal axes, major ticks, no ticks tickset{p_end}
{p2col:{cmd:yesno draw_minornl_nt_hgrid}  {space 1}{{cmd:yes}|{cmd:no}}}
	horizontal axes, minor ticks, no ticks tickset{p_end}

{p2col:{cmd:yesno draw_major_nt_vgrid}    {space 3}{{cmd:yes}|{cmd:no}}}
	vertical axes, major labels, no ticks tickset{p_end}
{p2col:{cmd:yesno draw_minor_nt_vgrid}    {space 3}{{cmd:yes}|{cmd:no}}}
	vertical axes, minor labels, no ticks tickset{p_end}
{p2col:{cmd:yesno draw_majornl_nt_vgrid}  {space 1}{{cmd:yes}|{cmd:no}}}
	vertical axes, major ticks, no ticks tickset{p_end}
{p2col:{cmd:yesno draw_minornl_nt_vgrid}  {space 1}{{cmd:yes}|{cmd:no}}}
	vertical axes, minor ticks, no ticks tickset{p_end}

{p2col:{cmd:yesno draw_major_nlt_hgrid}   {space 2}{{cmd:yes}|{cmd:no}}}
	horizontal axes, major labels, no labels or ticks tickset{p_end}
{p2col:{cmd:yesno draw_minor_nlt_hgrid}   {space 2}{{cmd:yes}|{cmd:no}}}
	horizontal axes, minor labels, no labels or ticks tickset{p_end}
{p2col:{cmd:yesno draw_majornl_nlt_hgrid} {space 0}{{cmd:yes}|{cmd:no}}}
	horizontal axes, major ticks, no labels or ticks tickset{p_end}
{p2col:{cmd:yesno draw_minornl_nlt_hgrid} {space 0}{{cmd:yes}|{cmd:no}}}
	horizontal axes, minor ticks, no labels or ticks tickset{p_end}

{p2col:{cmd:yesno draw_major_nlt_vgrid}   {space 2}{{cmd:yes}|{cmd:no}}}
	vertical axes, major labels, no labels or ticks tickset{p_end}
{p2col:{cmd:yesno draw_minor_nlt_vgrid}   {space 2}{{cmd:yes}|{cmd:no}}}
	vertical axes, minor labels, no labels or ticks tickset{p_end}
{p2col:{cmd:yesno draw_majornl_nlt_vgrid} {space 0}{{cmd:yes}|{cmd:no}}}
	vertical axes, major ticks, no labels or ticks tickset{p_end}
{p2col:{cmd:yesno draw_minornl_nlt_vgrid} {space 0}{{cmd:yes}|{cmd:no}}}
	vertical axes, minor ticks, no labels or ticks tickset{p_end}
{p2line}


{marker remarks3}{...}
{title:Construction of grid lines}

{p2colset 4 41 44 0}{...}
{p 3 3 2}
These entries control whether grid lines extend through the plot region's
margin and whether they are drawn for extreme values of ticks.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno extend_majorgrid_low} {space 0}{{cmd:yes}|{cmd:no}}}
        extend grid lines for major ticks or labels through the plot region
        margin to the bounding box of the plot region ({cmd:yes}), or only to
        the lower inner margin of the plot region ({cmd:no}){p_end}
{p2col:{cmd:yesno extend_majorgrid_high} {space 0}{{cmd:yes}|{cmd:no}}}
        extend grid lines for major ticks or labels through the plot region
        margin to the bounding box of the plot region ({cmd:yes}), or only to
        the upper inner margin of the plot region ({cmd:no}){p_end}
{p2col:{cmd:yesno extend_minorgrid_low} {space 0}{{cmd:yes}|{cmd:no}}}
        extend grid lines for minor ticks or labels through the plot region
        margin to the bounding box of the plot region ({cmd:yes}), or only to
        the lower inner margin of the plot region ({cmd:no}){p_end}
{p2col:{cmd:yesno extend_minorgrid_high} {space 0}{{cmd:yes}|{cmd:no}}}
        extend grid lines for minor ticks or labels through the plot region
        margin to the bounding box of the plot region ({cmd:yes}), or only to
        the upper inner margin of the plot region ({cmd:no}){p_end}

{p2col:{cmd:yesno grid_draw_min}      {space 5}{{cmd:yes}|{cmd:no}}}
	always draw the smallest grid line, even if the standard rules for
	drawing grid lines would leave it undrawn{p_end}
{p2col:{cmd:yesno grid_draw_max}      {space 5}{{cmd:yes}|{cmd:no}}}
	always draw the largest grid line, even if the standard rules for
	drawing grid lines would leave it undrawn{p_end}
{p2col:{cmd:yesno grid_force_nomin}   {space 2}{{cmd:yes}|{cmd:no}}}
	never draw the smallest grid line{p_end}
{p2col:{cmd:yesno grid_force_nomax}   {space 2}{{cmd:yes}|{cmd:no}}}
	never draw the largest grid line{p_end}

{p2col:{cmd:numstyle grid_outer_tol}  {space 2}{it:#}}
	tolerance for drawing top and bottom grid lines (usually < 1
	and rarely used){p_end}
{p2line}


{marker remarks4}{...}
{title:Overall grid styles}

{p2colset 4 38 41 0}{...}
{p 3 3 2}
These composite entries specify the overall look of grids; see
{manhelpi gridstyle G-4}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gridstyle major} {space 0}{it:{help gridstyle}}}
	default grid lines of major ticks{p_end}
{p2col:{cmd:gridstyle minor} {space 0}{it:{help gridstyle}}}
	default grid lines of minor ticks{p_end}
{p2line}
{p2colreset}{...}
