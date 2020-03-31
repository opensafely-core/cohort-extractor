{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] if" "mansection P if"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] continue" "help continue"}{...}
{vieweralsosee "[P] foreach" "help foreach"}{...}
{vieweralsosee "[P] forvalues" "help forvalues"}{...}
{vieweralsosee "[P] while" "help while"}{...}
{viewerjumpto "Syntax" "ifcmd##syntax"}{...}
{viewerjumpto "Description" "ifcmd##description"}{...}
{viewerjumpto "Links to PDF documentation" "ifcmd##linkspdf"}{...}
{viewerjumpto "Remarks" "ifcmd##remarks"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[P] if} {hline 2}}if programming command{p_end}
{p2col:}({mansection P if:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:if} {it:exp} {cmd:{c -(}}{...}
{col 42}or{col 52}{cmd:if} {it:exp} {it:single_command}
		{it:multiple_commands}
	{cmd:{c )-}}

{pstd}
which, in either case, may be followed by

	{cmd:else} {cmd:{c -(}}{...}
{col 42}or{col 52}{cmd:else} {it:single_command}
		{it:multiple_commands}
	{cmd:{c )-}}

{pstd}
If you put braces following the {cmd:if} or {cmd:else},

{phang2}
1.  the open brace must appear on the same line as the {cmd:if} or
    {cmd:else};

{phang2}
2.  nothing may follow the open brace except, of course, comments;
    the first command to be executed must appear on a new line;

{phang2}
3.  the close brace must appear on a line by itself.


{marker description}{...}
{title:Description}

{pstd}
The {cmd:if} command (not to be confused with the {cmd:if} qualifier; see
{helpb if}) evaluates {it:exp}.  If the result is true
(nonzero), the commands inside the braces are executed.  If the result is
false (zero), those statements are ignored, and the statement (or statements 
if enclosed in braces) following the {cmd:else} is executed.

{pstd}
See {help exp} for an explanation of expressions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P ifRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help ifcmd##remarks1:Typical use:  Example 1}
	{help ifcmd##remarks2:Typical use:  Example 2}
	{help ifcmd##remarks3:Typical use:  Example 3}
	{help ifcmd##remarks4:Avoid single-line if and else with ++ and -- macro expansion}


{marker remarks1}{...}
{title:Typical use:  Example 1}

    {cmd:program} {it:...}
	    {cmd:syntax varlist [, Report ]}
	    {it:...}
	    {cmd:if "`report'" != "" {c -(}}
		    {it:(logic for doing the optional report)}
	    {cmd:{c )-}}
	    {it:...}
    {cmd:end}


{marker remarks2}{...}
{title:Typical use:  Example 2}

    {cmd:program} {it:...}
	    {cmd:syntax varlist [, Adjust(string) ]}
	    {it:...}
	    {cmd:if "`adjust'" != "" {c -(}}
		    {cmd:if "`adjust'" == "means" {c -(}}
			    {it:...}
		    {cmd:{c )-}}
		    {cmd:else if "`adjust'" == "medians" {c -(}}
			    {it:...}
		    {cmd:{c )-}}
		    {cmd:else {c -(}}
			    {cmd:display as err /*}
			    {cmd:*/ "specify adjust(means) or adjust(medians)"}
			    {cmd:exit 198}
		    {cmd:{c )-}}
	    {cmd:{c )-}}
	    {it:...}
    {cmd:end}


{marker remarks3}{...}
{title:Typical use:  Example 3}

    {cmd:program} {it:...}
            {cmd:syntax} {it:...} {cmd:[,} {it:...} {cmd:n(integer 1)} {it:...} {cmd:]}
	    {it:...}
            {cmd}if `n'==1 {c -(}
                local word "one"
            {c )-}
            else if `n'==2 {c -(}
                local word "two"
            {c )-}
            else if `n'==3 {c -(}
                local word "three"
            {c )-}
            else {c -(}
                local word "big"
            {c )-}{txt}
	    {it:...}
    {cmd:end}


{marker remarks4}{...}
{title:Avoid single-line if and else with ++ and -- macro expansion}

{pstd}
Do not use the single-line forms of {cmd:if} and {cmd:else} -- do not omit
the braces -- when the action includes the {cmd:`++'} or {cmd:`--'}
macro-expansion operators.  For instance, do not code

	{cmd:if (}...{cmd:)} {it:somecommand} {cmd:`++i'}

{p 4 3 2}
Code instead,

	{cmd:if (}...{cmd:)} {cmd:{c -(}}
		{it:somecommand} {cmd:`++i'}
	{cmd:{c )-}}

{pstd}
In the first example, {cmd:i} will be incremented regardless of whether the
condition is true or false because macro expansion occurs before the line is
interpreted.  In the second example, if the condition is false, the line
inside the braces will not be macro expanded and so {cmd:i} will not be
incremented.

{pstd}
The same applies to the {cmd:else} statement; do not code

	{cmd:else} {it:somecommand} {cmd:`++i'}

{pstd}
Code instead,

	{cmd:else {c -(}}
		{it:somecommand} {cmd:`++i'}
	{cmd:{c )-}}

{title:Technical note}

    What was just said also applies to macro-induced execution of class
    programs that have side effects.  Consider

	    {cmd:if (}...{cmd:)} {it:somecommand} {cmd:`.clspgm.getnext'}

{pmore}
    Class member program {cmd:.getnext} would execute regardless of
    whether the condition were true or false.  In this case, code

	    {cmd:if (}...{cmd:) {c -(}}
		    {it:somecommand} {cmd:`.clspgm.getnext'}
	    {cmd:{c )-}}

{pmore}
    Understand that the problem only arises when macro substitution causes
    the invocation of the class program.  There would be nothing wrong with
    coding{p_end}

	    {cmd:if (}...{cmd:)} {cmd:`.clspgm.getnext'}
