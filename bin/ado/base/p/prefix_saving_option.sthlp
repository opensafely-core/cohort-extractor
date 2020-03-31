{smcl}
{* *! version 1.0.9  09dec2014}{...}
{viewerjumpto "Syntax" "prefix_saving_option##syntax"}{...}
{viewerjumpto "Description" "prefix_saving_option##description"}{...}
{viewerjumpto "Option" "prefix_saving_option##option"}{...}
{viewerjumpto "Suboptions" "prefix_saving_option##suboptions"}{...}
{title:Title}

{p2colset 5 33 35 2}{...}
{p2col :{hi:[R]} {it:prefix_saving_option} {hline 2}}Option for saving data from a prefix command{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p2colset 9 42 46 2}{...}
{p2col :{it:prefix_saving_option}}Description{p_end}
{p2line}
{p2col :{cmdab:sa:ving(}{it:filename}[{cmd:,} {it:suboptions}]{cmd:)}}save
	data to disk{p_end}
{p2line}
{p2colreset}{...}

{p2colset 9 42 46 2}{...}
{p2col :{it:suboptions}}Description{p_end}
{p2line}
{p2col :{opt doub:le}}save variables in double precision{p_end}
{p2col :{opt ev:ery(#)}}write results every {it:#}th replication{p_end}
{p2col :{opt replace}}overwrite {it:filename}{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:saving()} option saves data to disk.  This option is common among the
prefix commands that repeatedly call other commands and collect user-specified
results.


{marker option}{...}
{title:Option}

INCLUDE help prefix_saving_option

{pmore}
Statistics are implied or are specified by the user of the prefix command.


{marker suboptions}{...}
{title:Suboptions}

{phang}
{opt double} specifies that the results for each replication be saved as
{opt double}s, meaning 8-byte reals.  By default, they are saved as
{opt float}s, meaning 4-byte reals.  This option may be used without the
{opt saving()} option to compute the variance estimates by using double
precision. 

{phang}
{opt every(#)} specifies that results be written to disk every {it:#}th
replication.  {opt every()} should be specified in conjunction
with {opt saving()} only when {it:command} takes a long time for each
replication.  This option will allow recovery of partial results should some
other software crash your computer.  See {manhelp postfile P}.

{phang}
{opt replace} specifies that {it:filename} be overwritten if it exists.
This option does not appear in the dialog box.
{p_end}
