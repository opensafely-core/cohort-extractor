{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[P] _return" "mansection P _return"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{viewerjumpto "Syntax" "_return##syntax"}{...}
{viewerjumpto "Description" "_return##description"}{...}
{viewerjumpto "Links to PDF documentation" "_return##linkspdf"}{...}
{viewerjumpto "Option" "_return##option"}{...}
{viewerjumpto "Remarks" "_return##remarks"}{...}
{viewerjumpto "Stored results" "_return##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] _return} {hline 2}}Preserve stored results{p_end}
{p2col:}({mansection P _return:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Set aside contents of r()

{p 8 16 2}
{cmdab:_ret:urn}
{cmd:hold}
{it:name}


    Restore contents of r() from name

{p 8 16 2}
{cmdab:_ret:urn}
{cmdab:res:tore}
{it:name}
[{cmd:,}
{cmdab:h:old}]


    Drop specified _return name

{p 8 16 2}
{cmdab:_ret:urn}
{cmd:drop}
{c -(}{it:name} | {cmd:_all}{c )-}


    List names currently stored by _return

{p 8 16 2}
{cmdab:_ret:urn}
{cmd:dir}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_return} sets aside and restores the contents of {helpb return:r()}.

{pstd}
{cmd:_return} {cmd:hold} stores under {it:name} the contents of {cmd:r()} and
clears {cmd:r()}.  If {it:name} is a name obtained from {help tempname},
{it:name} will be dropped automatically at the program's conclusion, if it is
not automatically or explicitly dropped before that.

{pstd}
{cmd:_return} {cmd:restore} restores from {it:name} the contents of {cmd:r()}
and, unless option {cmd:hold} is specified, drops {it:name}.

{pstd}
{cmd:_return} {cmd:drop} removes from memory (drops) {it:name} or, if
{cmd:_all} is specified, all {cmd:_return} names currently saved.

{pstd}
{cmd:_return} {cmd:dir} lists the names currently set aside by {cmd:_return}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P _returnRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:hold}, specified with {cmd:_return} {cmd:restore}, specifies that results
    continue to be held so that they can be {cmd:_return} {cmd:restore}d
    later, as well.  If the option is not specified, the specified results
    are restored and {it:name} is dropped.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:_return} is rarely necessary.  Most programs open with

	{cmd:program example}
		{cmd:version {ccl stata_version}}
		{cmd:syntax} ...
		{cmd:marksample touse}
		{cmd:if `"`exp'"' != "" {c -(}}
			{cmd:tempvar e}
			{cmd:qui gen double `e' = `exp' if `touse'}
		{cmd:{c )-}}
		...(code to calculate final results)...
	{cmd:end}

{pstd}
In the program above, no commands are given that change the contents of
{cmd:r()} until all parsing is complete and the {cmd:if} {it:exp} and
{cmd:=}{it:exp} are evaluated.  Thus the user can type

	{cmd:. summarize myvar}
	{cmd:. example} ... {cmd:if myvar>r(mean)} ...

{pstd}
and the results will be as the user expects.

{pstd}
Some programs, however, have nonstandard and complicated syntax, and in
the process of deciphering that syntax, other r-class commands might be
run before the user-specified expressions are evaluated.  Consider a command
that reads

	{cmd:program example2}
		{cmd:version {ccl stata_version}}
		...(commands that parse)...
		...({cmd:r()} might be reset at this stage)...

		...commands that evaluate user-specified expressions...
		{cmd:tempvar touse}
		{cmd:mark `touse' `if'}
		{cmd:tempvar v1 v2}
		{cmd:gen double `v1' = `exp1' if `touse'}
					{cmd:// `exp1' specified by user}
		{cmd:gen double `v2' = `exp2' if `touse'}
					{cmd:// `exp2' specified by user}

		...(code to calculate final results)...
	{cmd:end}

{pstd}
Here it would be a disaster if the user typed

	{cmd:. summarize myvar}
	{cmd:. example2} ... {cmd:if myvar>r(mean)} ...

{pstd}
because {cmd:r(mean)} would not mean what the user expected it to mean,
which is the mean of {cmd:myvar}.  The solution to this problem is to
code the following:

	{cmd:program example2}
		{cmd:version {ccl stata_version}}
					{cmd:// hold on to r()}
		{cmd:tempname myr}
		{cmd:_return hold `myr'}

		...(commands that parse)...
		...({cmd:r()} might be reset at this stage)...

		...commands that evaluate user-specified expressions...
					{cmd:// restore r()}
		{cmd:_return restore `myr'}

		{cmd:tempvar touse}
		{cmd:mark `touse' `if'}
		{cmd:tempvar v1 v2}
		{cmd:gen double `v1' = `exp1' if `touse'}
					{cmd:// `exp1' specified by user}
		{cmd:gen double `v2' = `exp2' if `touse'}
					{cmd:// `exp2' specified by user}

		...(code to calculate final results)...
	{cmd:end}

{pstd}
In the above example, we hold on to the contents of {cmd:r()} in {cmd:`myr'},
and then later bring them back.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_return restore} restores in {cmd:r()} those results that were
stored in {cmd:r()} when {cmd:_return hold} was executed.
{p_end}
