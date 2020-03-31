{smcl}
{* *! version 1.1.1  11feb2011}{...}
{findalias asgsmprofile}{...}
{findalias asgsuprofile}{...}
{findalias asgswprofile}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] do" "help do"}{...}
{vieweralsosee "[R] doedit" "help doedit"}{...}
{title:Title}

{p 4 16 2}{findalias gsmprofile}{p_end}
{p 4 16 2}{findalias gsuprofile}{p_end}
{p 4 16 2}{findalias gswprofile}{p_end}


{title:Description}

{pstd}
Stata first looks for the file sysprofile.do when it is invoked.  After that,
Stata looks for the file profile.do.  If either of these files are found, Stata
executes the commands they contain.

{pstd}
For operating-system specific information, see

{p 10 34 2}help {help profilem} {space 8} (Stata for Mac){p_end}
{p 10 34 2}help {help profileu} {space 8} (Stata for Unix){p_end}
{p 10 34 2}help {help profilew} {space 8} (Stata for Windows){p_end}

{pstd}
See {findalias frdofiles} for an explanation of do-files.  They are
nothing more than text (ASCII) files containing a sequence of commands
for Stata to execute.
{p_end}
