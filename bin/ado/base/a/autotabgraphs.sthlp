{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "[R] set (autotabgraphs)" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{viewerjumpto "Syntax" "autotabgraphs##syntax"}{...}
{viewerjumpto "Description" "autotabgraphs##description"}{...}
{viewerjumpto "Option" "autotabgraphs##option"}{...}
{title:Title}

{pstd}Set whether multiple graphs are created as tabs in one window or as
separate windows (Windows only)


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
	{cmd:set autotabgraphs} {c -(} {cmd:on} | {cmd:off} {c )-}
	[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set autotabgraphs} sets whether multiple graphs are created as tabs
within one window or as separate windows.  You obtain multiple graphs
by naming them (see {manhelpi name_option G-3}).  This command applies
only to Stata for Windows.

{pstd}
{cmd:on} specifies that named graphs open as tabs in the same window.
{cmd:off} specifies that named graphs open in separate windows.  
The default value of {cmd:autotabgraphs} is {cmd:off}.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke
Stata.
{p_end}
