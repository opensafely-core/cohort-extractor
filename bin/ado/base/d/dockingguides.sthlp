{smcl}
{* *! version 1.1.2  13jun2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "dockingguides##syntax"}{...}
{viewerjumpto "Description" "dockingguides##description"}{...}
{viewerjumpto "Option" "dockingguides##option"}{...}
{title:Title}

{phang}
Specify whether to enable docking guides for dockable windows
   (Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set dockingguides} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set dockingguides} specifies whether to enable the use of docking guides
when repositioning a dockable window.  Docking guides are blue-colored arrow 
icons that hover above windows to aid the user when repositioning another
window.  This command applies only to Windows computers.

{pstd} 
If enabled, docking guides will appear whenever a dockable window is moved over
another dockable window.  The inner collection of icons consists of a tab icon
that is tightly surrounded by four arrow icons.  This group of inner icons 
specifies whether to tab the window into the other, or position the window to
the top, right, bottom, or left of the window's available space. 

{pstd} 
In addition to the inner icons, there is a set of outer icons that will always
reside on the edges of the main Stata window.  These four icons are similar to 
the arrow icons found on the inner group but correspond to the main Stata 
window.  Like the inner arrow icons, these will allow you to position the window
to the top, right, bottom, or left of the main Stata window's available space.

{pstd} 
To select a location to dock a window, drag the window you wish to move until
your cursor is selecting the icon you wish.  Release the mouse button to 
stop dragging the window and drop the window into place. 

{pstd}
{cmd:on} specifies that blue docking guides will be displayed to indicate
dockable regions.  {cmd:off} specifies that normal, window outlining will be
used to display dockable regions.  The default value of {cmd:dockingguides} is
{cmd:on}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke
Stata.
{p_end}
