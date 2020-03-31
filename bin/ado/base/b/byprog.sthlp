{smcl}
{* *! version 1.2.4  19oct2017}{...}
{vieweralsosee "[P] byable" "mansection P byable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] by" "help by"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{vieweralsosee "[P] sortpreserve" "help sortpreserve"}{...}
{viewerjumpto "Syntax" "byprog##syntax"}{...}
{viewerjumpto "Description" "byprog##description"}{...}
{viewerjumpto "Links to PDF documentation" "byprog##linkspdf"}{...}
{viewerjumpto "Option" "byprog##option"}{...}
{viewerjumpto "Remarks" "byprog##remarks"}{...}
{viewerjumpto "Examples" "byprog##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[P] byable} {hline 2}}Make programs byable{p_end}
{p2col:}({mansection P byable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:pr:ogram} [{cmdab:de:fine}] {it:program_name} [{cmd:,} {it:...}
{cmdab:by:able:(}{cmdab:r:ecall}[{cmd:,} {cmdab:noh:eader}] |
{cmdab:o:necall}{cmd:)} {it:...}]


{marker description}{...}
{title:Description}

{pstd}
Most Stata commands allow the use of the {cmd:by} prefix; see {manhelp by D}.
For example, the syntax diagram for the {cmd:regress} command could be
presented as

{phang2}[{cmd:by} {it:varlist}{cmd::}]  {cmdab:reg:ress} {it:...}

{pstd}
This entry describes the writing of programs (ado-files) so that they will
allow the use of Stata's {cmd:by} {it:varlist}{cmd::} prefix; see
{helpb by:[D] by}.  If you take no special actions and write the program
{cmd:myprog}, then {cmd:by} {it:varlist}{cmd::} cannot be used with it:

        {cmd:. by foreign:  myprog}
        {err:myprog may not be combined with by}
        {search r(190):r(190);}

{pstd}
By reading this entry, you will learn how to modify your program so that
{cmd:by} does work with it.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P byableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:byable(}{cmd:recall}[{cmd:, noheader}] | {cmd:onecall}{cmd:)} specifies
that the program is to allow the {cmd:by} prefix to be used with it and
specifies the style in which the program is coded.

{pmore}
There are two supported styles, known as {cmd:byable(recall)} and
{cmd:byable(onecall)}.  {cmd:byable(recall)} programs are usually -- not
always -- easier to write and {cmd:byable(onecall)} programs are
usually -- not always -- faster.

{pmore}
{cmd:byable(recall)} programs are executed repeatedly, once per by
group.  {cmd:byable(onecall)} programs are executed only once and it is the
program's responsibility to handle the implications of the {cmd:by} prefix if
it is specified.

{pmore}
{cmd:byable(recall, noheader)} programs are distinguished from
{cmd:byable(recall)} programs in that {cmd:by} will not display a by-group
header before each calling of the program.

{pmore}
{cmd:byable(onecall)} programs are required to handle the {cmd:by}
{it:...}{cmd::} prefix themselves, including displaying the header should they
wish that.  See
{mansection P byableRemarksandexamples:{it:Remarks and examples}} in 
{hi:[P] byable} for details.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {mansection P byableRemarksandexamples:{it:Remarks and examples}} in
{bf:[P] byable} for more information.


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
		{cmd:syntax newvarname =exp [if] [in]}
		{cmd:marksample touse, novarlist}
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
