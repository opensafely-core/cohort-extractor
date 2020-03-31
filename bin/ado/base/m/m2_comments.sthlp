{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-2] Comments" "mansection M-2 Comments"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_comments##syntax"}{...}
{viewerjumpto "Description" "m2_comments##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_comments##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_comments##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-2] Comments} {hline 2}}Comments
{p_end}
{p2col:}({mansection M-2 Comments:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:/*} {it:enclosed comment} {cmd:*/}

	{cmd://} {it:rest-of-line comment}


{p 4 4 2}
Notes:

{p 8 12 2}
1.  
Comments may appear in do-files and ado-files; they are not allowed 
interactively.  

{p 8 12 2}
2.
Stata's beginning-of-the-line asterisk comment is not allowed in Mata:

		. {cmd:*} {it:valid in Stata but not in Mata}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:/*} and {cmd:*/} and {cmd://} are how you place comments in 
Mata programs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 CommentsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
There are two comment styles:  {cmd:/*} and {cmd:*/}, and {cmd://}.
You may use one, the other, or both.

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_comments##remarks1:The /* */ enclosed comment}
	{help m2_comments##remarks2:The // rest-of-line comment}


{marker remarks1}{...}
{title:The /* */ enclosed comment}

{p 4 4 2}
Enclosed comments may appear on a line:

	{cmd:/*} {it:What follows uses an approximation formula:} {cmd:*/}

{p 4 4 2}
Enclosed comments may appear within a line and even in the middle of a
Mata expression:
             
	{cmd:x = x + /*}{it:left-single quote}{cmd:*/ char(96)}

{p 4 4 2}
Enclosed comments may themselves contain multiple lines:

	{cmd:/*}
	    {it:We use the approximation based on sin(x) approximately}
            {it:equaling x for small x; x measure in radians}
	{cmd:*/}

{p 4 4 2}
Enclosed comments may be nested, which is useful for commenting out code that
itself contains comments:

	{cmd:/*}
	{it:for (i=1; i<=rows(x); i++) {c -(}}        {cmd:/*} {it:normalization} {cmd:*/}
		{it:x[i] = x[i] :/ value[i]}
	{it:{c )-}}
	{cmd:*/}


{marker remarks2}{...}
{title:The // rest-of-line comment}

{p 4 4 2}
The rest-of-line comment may appear by itself on a line

	{cmd://} {it:What follows uses an approximation formula:}

{p 4 4 2}
or it may appear at the end of a line:

	{cmd:x = x + char(96)      //} {it:append single quote}

{p 4 4 2}
In either case, the comment concludes when the line ends.
{p_end}
