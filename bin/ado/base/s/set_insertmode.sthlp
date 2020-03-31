{smcl}
{* *! version 1.0.1  26sep2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_insertmode##syntax"}{...}
{viewerjumpto "Description" "set_insertmode##description"}{...}
{viewerjumpto "Option" "set_insertmode##option"}{...}
{viewerjumpto "Remarks" "set_insertmode##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[R] set insertmode} {hline 2}}Set behavior of command-line editing in Unix (console){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:insertmode}
{c -(}{cmd:on} | {cmd:off}{c )-}
[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:insertmode} allows you to control how command-line editing
behaves in Unix (console).  The default is {cmd:set} {cmd:insertmode}
{cmd:off}, which is the same thing as overwrite mode.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
By default, the command line for Stata for Unix (console) is in overwrite
mode.  If you use the left arrow to go into the middle of a command
line you are typing, any characters you type will overwrite the
characters at the cursor position.

{pstd}
If you {cmd:set} {cmd:insertmode} {cmd:on}, then any characters
you type will be inserted at the cursor position without overwriting
other characters.

{pstd}
If you prefer insert mode to be on, specify the {cmd:permanently}
option, and Stata for Unix (console) will automatically use this
mode every time you start Stata.
{p_end}
