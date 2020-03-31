{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] displayas()" "mansection M-5 displayas()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] display()" "help mf_display"}{...}
{vieweralsosee "[M-5] printf()" "help mf_printf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_displayas##syntax"}{...}
{viewerjumpto "Description" "mf_displayas##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_displayas##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_displayas##remarks"}{...}
{viewerjumpto "Conformability" "mf_displayas##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_displayas##diagnostics"}{...}
{viewerjumpto "Source code" "mf_displayas##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] displayas()} {hline 2}}Set display level
{p_end}
{p2col:}({mansection M-5 displayas():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void} {cmd:displayas(}{it:string scalar level}{cmd:)}

{p 4 4 2}
where {it:level} may be 

		{it:level}        Minimum abbreviation
		{hline 33}
		{cmd:"result"}          {cmd:"res"}
        	{cmd:"text"}            {cmd:"txt"}
        	{cmd:"error"}           {cmd:"err"}
        	{cmd:"input"}           {cmd:"inp"}
		{hline 33}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:displayas(}{it:level}{cmd:)} sets whether and how subsequent output is to
be displayed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 displayas()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If this function is never invoked, then the output level is {cmd:result}.
Say that Mata was invoked in such a way that all output except 
error messages is being suppressed (for example, {helpb quietly} was coded in
front of the {cmd:mata} command or in front of the ado-file that called 
your Mata function).  If output is being suppressed, then Mata output is being
suppressed, including any output created by your program.  Say that you reach a
point in your program where you wish to output an error message.  You coded

	{cmd:printf("{c -(}err:you made a mistake{c )-}\n")}

{p 4 4 2}
Even though you coded the {help smcl:SMCL} directive {cmd:{c -(}err:{c )-}},
the error message will still be suppressed.  SMCL determines how something is
rendered, not whether it is rendered.  What you need to code is

	{cmd:displayas("err")}
	{cmd:printf("{c -(}err:you made a mistake{c )-}\n")}

{p 4 4 2}
Actually, you could code 

	{cmd:displayas("err")}
	{cmd:printf("you made a mistake\n")}

{p 4 4 2}
because, in addition to setting the output level (telling Stata that 
all subsequent output is of the specified level), it also sets the 
current SMCL rendering to what is appropriate for that kind of output.
Hence, if you coded 

	{cmd:displayas("err")}
	{cmd:printf("{c -(}res:you made a mistake{c )-}\n")}

{p 4 4 2}
the text "you made a mistake" would appear in the style of results despite any
{cmd:quietly}s attempting to suppress output.  Coding the above is considered
bad style.


{marker conformability}{...}
{title:Conformability}

    {cmd:displayas(}{it:level}{cmd:)}:
	    {it:level}:  1 {it:x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    {cmd:displayas(}{it:level}{cmd:)} aborts with error if {it:level} contains
    an inappropriate string.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
