{smcl}
{* *! version 1.0.15  29jan2019}{...}
{vieweralsosee "[P] window programming" "mansection P windowprogramming"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] Dialog programming" "help dialog_programming"}{...}
{viewerjumpto "Syntax" "window programming##syntax"}{...}
{viewerjumpto "Description" "window programming##description"}{...}
{viewerjumpto "Remarks" "window programming##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[P] window programming} {hline 2}}Programming menus and windows{p_end}
{p2col:}({mansection P windowprogramming:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p2colset 5 35 37 2}{...}
{p2col :{helpb window fopen} ...}Display open dialog box{p_end}
{p2col :{helpb window fsave} ...}Display save dialog box{p_end}
{p2col :{helpb window manage} {it:subcmd} ...}Manage window characteristics{p_end}
{p2col :{helpb window menu} {it:subcmd} ...}Create menus{p_end}
{p2col :{helpb window push} {it:command_line}}Copy command into History window{p_end}
{p2col :{helpb window stopbox} {it:subcmd} ...}Display message box{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:window} command lets you open, close, and manage the windows in
Stata's interface.  Using the subcommands of {bind:{cmd:window menu}}, you
can also add and delete menu items from the {hi:User} menu from Stata's main
menu bar.  {bind:{cmd:window push}} adds {it:command_line} to the History
window.


{marker remarks}{...}
{title:Remarks}

{pstd}
Complete documentation for programming windows and menus is provided in the
system help.

{pstd}
For documentation on creating dialog boxes, see
{manhelp dialog_programming P:Dialog programming}.
{p_end}
