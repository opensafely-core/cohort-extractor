{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[P] error" "mansection P error"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] break" "help break"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{vieweralsosee "[P] exit" "help exit"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{viewerjumpto "Syntax" "error##syntax"}{...}
{viewerjumpto "Description" "error##description"}{...}
{viewerjumpto "Links to PDF documentation" "error##linkspdf"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] error} {hline 2}}Display generic error message and exit{p_end}
{p2col:}({mansection P error:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmdab:err:or} {it:{help exp}}


{marker description}{...}
{title:Description}

{pstd}
{cmd:error} displays the most generic form of the error message associated
with expression and sets the return code to the evaluation of the expression.
If expression evaluates to 0, {cmd:error} does nothing.  Otherwise, the
nonzero return code will force an {cmd:exit} from the program or {cmd:capture}
block in which it occurs.  {cmd:error} sets the return code to 197 if there is
an error in using {cmd:error} itself.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P errorRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


