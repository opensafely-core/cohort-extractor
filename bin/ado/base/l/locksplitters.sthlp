{smcl}
{* *! version 1.1.1  11feb2011}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "locksplitters##syntax"}{...}
{viewerjumpto "Description" "locksplitters##description"}{...}
{viewerjumpto "Option" "locksplitters##option"}{...}
{title:Title}

{phang}
Specify whether to prevent docking splitters from resizing windows
(Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set locksplitters} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set locksplitters} specifies whether to prevent splitters (the edges that 
separate docked windows) from resizing docked windows.  This command
applies only to Windows computers.

{pstd}
When splitters are active, a splitter icon will appear when the cursor hovers
over a splitter.  The splitter icon appears as two parallel lines with opposing
perpendicular arrows.  Dragging the splitter will resize the adjacent dockable
windows.  Only dockable windows can have splitters.

{pstd}
{cmd:on} indicates that splitters are locked and cannot resize adjacent windows.
{cmd:off} indicates that splitters are unlocked and can resize adjacent windows.
The default value of {cmd:locksplitters} is {cmd:off}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
