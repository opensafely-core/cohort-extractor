{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] display()" "mansection M-5 display()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] displayas()" "help mf_displayas"}{...}
{vieweralsosee "[M-5] displayflush()" "help mf_displayflush"}{...}
{vieweralsosee "[M-5] printf()" "help mf_printf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_display##syntax"}{...}
{viewerjumpto "Description" "mf_display##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_display##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_display##remarks"}{...}
{viewerjumpto "Conformability" "mf_display##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_display##diagnostics"}{...}
{viewerjumpto "Source code" "mf_display##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] display()} {hline 2}}Display text interpreting SMCL
{p_end}
{p2col:}({mansection M-5 display():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:display(}{it:string colvector s}{cmd:)}

{p 8 12 2}
{it:void}
{cmd:display(}{it:string colvector s}{cmd:,}
{it:real scalar asis}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:display(}{it:s}{cmd:)} 
displays the string or strings contained in {it:s}.

{p 4 4 2}
{cmd:display(}{it:s}{cmd:,} {it:asis}{cmd:)}
does the same thing but allows you to control how SMCL codes are treated.
{cmd:display(}{it:s}{cmd:,} {cmd:0)} is equivalent to 
{cmd:display(}{it:s}{cmd:)}; any SMCL codes are honored.

{p 4 4 2}
{cmd:display(}{it:s}{cmd:,} {it:asis}{cmd:)}, {it:asis}!=0, displays the
contents of {it:s} exactly as they are.  For instance, when {it:asis}!=0, 
"{c -(}it{c )-}" is just the string of characters {c -(}, i, t, and {c )-} and
those characters are displayed; {c -(}it{c )-} is not given the SMCL
interpretation of enter italic mode.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 display()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
When {it:s} is a scalar, the differences between coding 

	: {cmd:display(}{it:s}{cmd:)}

{p 4 4 2}
and coding 

	: {it:s}

{p 4 4 2}
are

{p 8 12 2}
    1.  {cmd:display(}{it:s}{cmd:)} will not indent {it:s}; 
        {it:s} by itself causes {it:s} to be indented by two spaces.

{p 8 12 2}
    2.  {cmd:display(}{it:s}{cmd:)} will honor any SMCL codes contained 
        in {it:s}; {it:s} by itself is equivalent to 
        {cmd:display(}{it:s}{cmd:,} {cmd:1)}.  For example, 

		: {cmd:s = "this is an {c -(}it:example{c )-}"}

		: {cmd:display(s)}
        	this is an {it:example}
	 
		: {cmd:s}
		  this is an {c -(}it:example{c )-}

{p 8 12 2}
    3.  When {it:s} is a vector, {cmd:display(}{it:s}{cmd:)}
        simply displays the lines, whereas {it:s} by itself adorns the lines
        with row and column numbers:

        	{cmd:: s = ("this is line 1" \ "this is line 2")}

		{cmd:: display(s)}
		this is line 1
		this is line 2

		{cmd:: s}
                                    1
                    {c TLC}{hline 18}{c TRC}
                  1 {c |}  this is line 1  {c |}
                  2 {c |}  this is line 2  {c |}
                    {c BLC}{hline 18}{c BRC}

{p 4 4 2}
Another alternative to {cmd:display()} is {cmd:printf()}; see 
{bf:{help mf_printf:[M-5] printf()}}.
When {it:s} is a scalar, {cmd:display()} and {cmd:printf()} do the same 
thing:

	: {cmd:display("this is an {c -(}it:example{c )-}")}
	this is an {it:example}
	
	: {cmd:printf("%s\n", "this is an {c -(}it:example{c )-}")}
	this is an {it:example}

{p 4 4 2}
{cmd:printf()}, however, will not allow {it:s} to be nonscalar; it 
has other capabilities.


{marker conformability}{...}
{title:Conformability}

    {cmd:display(}{it:s}{cmd:,} {it:asis}{cmd:)}
		{it:s}:  {it:k x} 1
	     {it:asis}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
