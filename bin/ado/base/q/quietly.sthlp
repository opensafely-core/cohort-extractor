{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] quietly" "mansection P quietly"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{viewerjumpto "Syntax" "quietly##syntax"}{...}
{viewerjumpto "Description" "quietly##description"}{...}
{viewerjumpto "Links to PDF documentation" "quietly##linkspdf"}{...}
{viewerjumpto "Example of interactive use" "quietly##example"}{...}
{viewerjumpto "Note for programmers" "quietly##note"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] quietly} {hline 2}}Quietly and noisily perform Stata command{p_end}
{p2col:}({mansection P quietly:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Perform command but suppress terminal output

	{cmdab:qui:etly} [{cmd::}] {it:command}


    Perform command and ensure terminal output

	{cmdab:n:oisily} [{cmd::}] {it:command}


    Specify type of output to display

{phang2}{cmd:set} {cmdab:ou:tput} {c -(} {cmdab:p:roc} | {cmdab:i:nform} |
{cmdab:e:rror} {c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:quietly} suppresses all terminal output for the duration of {it:command}.
It is useful both interactively and in programs.

{pstd}
{cmd:noisily} turns back on terminal output, if appropriate, for the
duration of {it:command}.  It is useful only in programs.

{pstd}
{cmd:set output} specifies the output to be displayed.  It is useful only
in programs and even then is seldom used.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P quietlyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example of interactive use}

{pstd}
You do not care to see the output from a particular regression, but instead
want to silently run the regression so that you may access some of its
returned results.

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. quietly regress mpg weight foreign headroom}

{pstd}
No output is presented, but the {hi:e()} returned results from the
regression are now available.


{marker note}{...}
{title:Note for programmers}

{pstd}
If you write a program or ado-file, say, {cmd:mycmd}, there is nothing special
you need to do so that your command can be prefixed with {cmd:quietly}.  That
said, c-class value {cmd:c(noisily)} (see {helpb creturn:[P] creturn})
will return {cmd:0} if output is being suppressed and {cmd:1} otherwise.  Thus
your program might read

	{cmd:program mycmd}
		...
		{cmd:display} ...
		{cmd:display} ...
		...
	{cmd:end}

{pstd} or

	{cmd:program mycmd}
		...
		{cmd:if c(noisily) {c -(}}
			{cmd:display} ...
			{cmd:display} ...
		{cmd:{c )-}}
		...
	{cmd:end}

{pstd}
The first style is preferred.  If the user executes {cmd:quietly} {cmd:mycmd},
the output from {cmd:display} itself, along with the output of all other
commands, will be automatically suppressed.

{pstd}
If the program must work substantially to produce what is being displayed,
however, and the only reason for doing that work is because of the display,
then the second style is preferred.  In such cases, you can include the extra
work within the block of code executed only when {cmd:c(noisily)} is true and
thus make your program execute more quickly when it is invoked {cmd:quietly}.
{p_end}
