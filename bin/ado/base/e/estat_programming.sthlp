{smcl}
{* *! version 1.3.3  10may2018}{...}
{vieweralsosee "[P] estat programming" "mansection P estatprogramming"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat" "help estat"}{...}
{viewerjumpto "Description" "estat_programming##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_programming##linkspdf"}{...}
{viewerjumpto "Remarks" "estat_programming##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[P] estat programming} {hline 2}}Controlling estat after
	community-contributed commands{p_end}
{p2col:}({mansection P estatprogramming:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Programmers of estimation commands can customize how {cmd:estat} works
after their commands.  If you want to use only the standard {cmd:estat}
subcommands, {cmd:ic}, {cmd:summarize}, and {cmd:vce}, you do not need to do
anything; see {manhelp estat R}.  Stata will automatically handle those cases.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P estatprogrammingRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{phang2}{help estat_programming##std:Standard subcommands}{p_end}
{phang2}{help estat_programming##add:Adding subcommands to estat}{p_end}
{phang2}{help estat_programming##override:Overriding standard behavior of a subcommand}


{marker std}{...}
{title:Standard subcommands}

{pstd}
For {cmd:estat} to work, your estimation command must be implemented as an
e-class program, and it must store its name in {cmd:e(cmd)}.

{pstd}
{cmd:estat vce} requires that the covariance matrix be stored in {cmd:e(V)},
and {cmd:estat summarize} requires that the estimation sample be marked by the
function {cmd:e(sample)}.  Both requirements can be met by using
{helpb ereturn post} with the {cmd:esample()} option in your program.

{pstd}
Finally, {cmd:estat ic} requires that your program store the final log
likelihood in {cmd:e(ll)} and the sample size in {cmd:e(N)}.  If your program
also stores the log likelihood of the null (constant only) model in
{cmd:e(ll_0)}, it will appear in the output of {cmd:estat ic}, as well.


{marker add}{...}
{title:Adding subcommands to estat}

{pstd}
To add new features (subcommands) to {cmd:estat} for use after a particular
estimation command, you write a handler, which is nothing more than an ado-file
command.  The standard is to name the new command {it:cmd}{cmd:_estat}, where
{it:cmd} is the name of the corresponding estimation command.  For instance,
the handler that provides the special {cmd:estat} features after {cmd:regress}
is named {cmd:regress_estat}, and the handler that provides the special features
after {cmd:pca} is named {cmd:pca_estat}.

{pstd}
Next you must let {cmd:estat} know about your new handler, which you do by
filling in {cmd:e(estat_cmd)} in the corresponding estimation command.  For
example, in the code that implements {cmd:pca} is the line

	{cmd:ereturn local estat_cmd "pca_estat"}

{pstd}
Finally, you must write {it:cmd}{cmd:_estat}.  The syntax of {cmd:estat} is

	{cmd:estat} {it:subcmd} ...

{pstd}
When the {cmd:estat} command is invoked, the first and only thing it does is
call {cmd:`e(estat_cmd)'} if {cmd:`e(estat_cmd)'} exists.  This way, your
handler can even do something special in the standard cases, if that is
necessary.  We will get to that, but in the meantime, understand that the
handler receives just what {cmd:estat} received, which is exactly what the user
typed.  The outline for a handler is
                                                                                
	{hline 11} begin {it:cmd}{cmd:_estat.ado} {hline -2}

	{cmd}*! version 1.0.0  {ccl current_date}
	program {txt}{it:cmd}{cmd}{cmd:_estat}, rclass
		version {ccl stata_version}

		if "`e(cmd)'" != "{txt}{it:cmd}{cmd}" {
			error 301
		}

		gettoken subcmd rest : 0, parse(" ,")
                if "`subcmd'"=="{txt}{it:first_special_subcmd}{cmd}" {
                        {txt}{it:First_special_subcmd}{cmd} `rest'
                }
                else if "`subcmd'"=="{txt}{it:second_special_subcmd}{cmd}" {
                        {txt}{it:Second_special_subcmd}{cmd} `rest'
                }
                ...
                else {
                        estat_default `0'
                }
                return add
	end

	program {txt}{it:First_special_subcmd}{cmd}, rclass
		syntax ...
		...
	end

	program {txt}{it:Second_special_subcmd}{cmd}, rclass
		syntax ...
		...
	end{reset}

	{hline 13} end {it:cmd}{cmd:_estat.ado} {hline -2}

{pstd}
The ideas underlying the above outline are simple:

{phang}
1.  You check that {cmd:e(cmd)} matches {it:cmd}.

{phang}
2.  You isolate the {it:subcmd} that the user typed and then see if it is one
of the special cases that you wish to handle.

{phang}
3.  If {it:subcmd} is a special case, you call the code you wrote to handle
it.

{phang}
4.  If {it:subcmd} is not a special case, you let Stata's {cmd:estat_default}
handle it.

{pstd}
When you check for the special cases, those special cases can be new
{it:subcmds} that you wish to add, or they can be standard {it:subcmds} whose
default behavior you wish to override.


{marker override}{...}
{title:Overriding standard behavior of a subcommand}

{pstd}
Occasionally, you may want to override the behavior of a subcommand normally
handled by {cmd:estat_default}.  This is accomplished by providing a
local handler.  Consider, for example, {cmd:summarize} after {cmd:pca}.  The
standard way of invoking {cmd:estat summarize} is not appropriate
here -- {cmd:estat summarize} extracts the list of variables to be
summarized from {cmd:e(b)}.  This does not work after {cmd:pca}.  Here 
the varlist has to be extracted from the column names of the correlation
or covariance matrix {cmd:e(C)}.  This varlist is transferred to
{cmd:estat summarize} (or more directly to {cmd:estat_summ}) as the argument
of the option {cmd:varlist()}.

	{cmd}program Summarize
                syntax [, *]
		tempname C
		matrix `C' = e(C)
		estat_summ, varlist(`:colnames `C'') `options'
	end{reset}

{pstd}
You add the local handler by inserting an additional switch in 
{it:cmd}{cmd:_estat} to ensure that the {cmd:summarize} subcommand is 
not handled by the default handler {cmd:estat_default}.  As a detail, 
we have to make sure that the minimal abbreviation is {cmdab:su:mmarize}.

	{hline 11} begin {cmd:pca_estat.ado} {hline -2}

	{cmd}program pca_estat, rclass
	version {ccl stata_version}

	gettoken subcmd rest : 0 , parse(", ")
	local lsubcmd= length("`subcmd'")

	if `"`subcmd'"' == substr("summarize", 1, max(2, `lsubcmd')) {c -(}
		Summarize `rest'
	{c )-}
	else {c -(}
		estat_default `0'
	{c )-}

	return add
	end

	program Summarize
		syntax ...
		...
	end{txt}
	{hline 13} end {cmd:pca_estat.ado} {hline -2}
