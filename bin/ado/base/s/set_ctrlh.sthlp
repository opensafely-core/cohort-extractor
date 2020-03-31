{smcl}
{* *! version 1.0.1  26sep2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_ctrlh##syntax"}{...}
{viewerjumpto "Description" "set_ctrlh##description"}{...}
{viewerjumpto "Option" "set_ctrlh##option"}{...}
{viewerjumpto "Remarks" "set_ctrlh##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] set ctrlh} {hline 2}}Set behavior of Ctrl+H for command-line editing in Unix (console){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:ctrlh}
{c -(}{cmd:default} | {cmd:erase} | {cmd:left}{c )-}
[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:ctrlh} allows you to control how Ctrl+H behaves for
command-line editing in Unix (console).  The default is
{cmd:set} {cmd:ctrlh} {cmd:erase}, which means that Ctrl+H will behave
the same as a backspace.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
Unix/Linux terminals differ in how they behave when Ctrl+H is pressed.
Stata allows you to control the behavior of Ctrl+H with the
{cmd:set} {cmd:ctrlh} command.  {cmd:set} {cmd:ctrlh} {cmd:erase},
which is the same as {cmd:set} {cmd:ctrlh} {cmd:default}, makes
Ctrl+H behave the same as the backspace key.  {cmd:set} {cmd:ctrlh}
{cmd:left} makes Ctrl+H behave the same as the left arrow.

{pstd}
If you prefer one mode over the other, specify the {cmd:permanently}
option, and Stata for Unix (console) will automatically use this
mode every time you start Stata.
{p_end}
