{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] unabcmd" "mansection P unabcmd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] findfile" "help findfile"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{viewerjumpto "Syntax" "unabcmd##syntax"}{...}
{viewerjumpto "Description" "unabcmd##description"}{...}
{viewerjumpto "Links to PDF documentation" "unabcmd##linkspdf"}{...}
{viewerjumpto "Examples" "unabcmd##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] unabcmd} {hline 2}}Unabbreviate command name{p_end}
{p2col:}({mansection P unabcmd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:unabcmd}
{it:commandname_or_abbreviation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:unabcmd} verifies that {it:commandname_or_abbreviation} is a
Stata command name or an abbreviation of a Stata command name.  {cmd:unabcmd}
makes this determination by looking at both built-in commands and ado-files.
If {it:commandname_or_abbreviation} is a valid command, {cmd:unabcmd} returns
in local {cmd:r(cmd)} the unabbreviated name.  If it is not a
valid command, {cmd:unabcmd} displays an appropriate error message.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P unabcmdRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    {cmd:. unabcmd gen}
    {cmd:. return list}

    {cmd:. unabcmd kappa}
    {cmd:. return list}

    {cmd:. unabcmd ka}
