{smcl}
{* *! version 1.0.4  19oct2017}{...}
{vieweralsosee "[P] sortpreserve" "mansection P sortpreserve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] byable" "help byprog"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{viewerjumpto "Syntax" "sortpreserve##syntax"}{...}
{viewerjumpto "Description" "sortpreserve##description"}{...}
{viewerjumpto "Links to PDF documentation" "sortpreserve##linkspdf"}{...}
{viewerjumpto "Option" "sortpreserve##option"}{...}
{viewerjumpto "Remarks" "sortpreserve##remarks"}{...}
{viewerjumpto "Examples" "sortpreserve##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[P] sortpreserve} {hline 2}}Sort within programs{p_end}
{p2col:}({mansection P sortpreserve:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:pr:ogram} [{cmdab:de:fine}] {it:program_name} [{cmd:,} {it:...}
{cmdab:sort:preserve} {it:...} ]


{marker description}{...}
{title:Description}

{pstd}
This entry discusses the use of {cmd:sort} (see {helpb sort:[D] sort}) within
programs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P sortpreserveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:sortpreserve} specifies that the program, during its execution,
will re-sort the data and that therefore Stata itself should take action to
preserve the order of the data so that the order can be reestablished
afterward.

{pmore}
{cmd:sortpreserve} is in fact independent of whether a program is
{cmd:byable()} but {cmd:byable()} programs often specify this option.

{pmore}
Pretend you are writing the program {cmd:myprog} and that, in performing
its calculations, it needs to sort the data.  It is very jolting for a user to
experience,

{phang3}{cmd:. by pid:  myprog} {it:...}

{phang3}{cmd:. by pid:  sum newvar}{p_end}
	    {err:not sorted}
	    {search r(5):r(5);}

{pmore}
Specifying {cmd:sortpreserve} will prevent this and still allow {cmd:myprog}
to sort the data freely.  {cmd:byable()} programs that sort the data should
specify {cmd:sortpreserve}.  It is not necessary to specify
{cmd:sortpreserve} if your program does not change the sort order of the
data and, in that case, things are a little better if you do not specify
{cmd:sortpreserve}.

{pmore}
{cmd:sortpreserve} takes time, although less than you might suspect.
{cmd:sortpreserve} does not actually have to re-sort the data at the conclusion
of your program -- an O(n ln n) operation -- it is able to arrange
things so that it can reassert the original order of the data in O(n) time,
and {cmd:sortpreserve} is, in fact, very quick about it.  Nonetheless, there
is no reason to waste the time if the data never got out of order.

{pmore}
Concerning sort order, when your {cmd:byable()} program is invoked for
the first time, it will be sorted on {cmd:_byvars} but, in subsequent calls
(in the case of {cmd:byable(recall)} programs), the sort order will be just as
your program leaves it even if you specify {cmd:sortpreserve}.
{cmd:sortpreserve} restores the original order after your program has been
called for the last time.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {mansection P sortpreserveRemarksandexamples:{it:Remarks and examples}} in
{bf:[P] sortpreserve} for more information.


{marker examples}{...}
{title:Example 1:}

	{cmd:program myprog1, byable(recall)}
		{cmd:syntax [varlist] [if] [in]}
		{cmd:marksample touse}
		{cmd:summarize `varlist' if `touse'}
	{cmd:end}

{pstd}
In the above program, it would be a mistake to code it

	{cmd:program myprog1, byable(recall)}
		{cmd:syntax [varlist] [if] [in]}
		{cmd:summarize `varlist' `if' `in'}
	{cmd:end}

{pstd}
because in that case, the sample would not be restricted to the appropriate
by-group when the user specified the {cmd:by} {it:...}{cmd::} prefix.
{cmd:marksample}, however, knows when a program is being by'd and so will set
the {cmd:`touse'} variable to reflect whatever restrictions the user specified
and the by-group restriction.

{pstd}
{cmd:syntax}, too, knows about {cmd:by} and it will automatically issue an
error message when the user specifies {cmd:by} {it:...}{cmd::} and an {cmd:in}
{it:range} together even though {cmd:in} {it:range} will be allowed when not
combined with {cmd:by}.


{title:Example 2:}

	{cmd:program myprog2, byable(recall) sortpreserve}
		{cmd:syntax varname [if] [in]}
		{cmd:marksample touse}
		{cmd:sort `touse' `varlist'}
		{it:...}
	{cmd:end}

{pstd}
This program specifies {cmd:sortpreserve} because it changes the sort order
of the data in order to make its calculations.


{title:Example 3:}

	{cmd:program myprog3, byable(onecall) sortpreserve}
		{cmd:syntax newvar =exp [if] [in]}
		{cmd:marksample touse}
		{cmd:tempvar rhs}
		{cmd:quietly {c -(}}
			{cmd:gen double `rhs' `exp' if `touse'}
			{cmd:sort `touse' `_byvars' `rhs'}
			{cmd:by `touse' `_byvars':  gen `type' `varlist' = /*}
				 {cmd:*/ `rhs' - `rhs'[_n-1] if `touse'}
		{cmd:{c )-}}
	{cmd:end}

{pstd}
This program specifies {cmd:sortpreserve} because it changes the sort order
of the data.

{pstd}
In addition, this program is {cmd:byable(onecall)} and, were we to change
{cmd:byable(onecall)} to {cmd:byable(recall)}, we would break the program.
This program creates a new variable and a variable can only be {cmd:generate}d
once; after that we would have to use {cmd:replace}.{p_end}
