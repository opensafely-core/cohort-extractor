{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog clonevar "dialog clonevar"}{...}
{vieweralsosee "[D] clonevar" "mansection D clonevar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[D] separate" "help separate"}{...}
{viewerjumpto "Syntax" "clonevar##syntax"}{...}
{viewerjumpto "Menu" "clonevar##menu"}{...}
{viewerjumpto "Description" "clonevar##description"}{...}
{viewerjumpto "Links to PDF documentation" "clonevar##linkspdf"}{...}
{viewerjumpto "Remarks" "clonevar##remarks"}{...}
{viewerjumpto "Examples" "clonevar##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] clonevar} {hline 2}}Clone existing variable{p_end}
{p2col:}({mansection D clonevar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 29 2}
{cmd:clonevar}
{newvar} 
{cmd:=} 
{varname} 
{ifin}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-creation commands >}
    {bf:Clone existing variable}


{marker description}{...}
{title:Description}

{pstd}
{cmd:clonevar} generates {newvar} as an exact copy of an existing variable,
{varname}, with the same storage type, values, and 
display format as {it:varname}.
{it:varname}'s variable label, value labels,
notes, and characteristics will also be copied.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D clonevarQuickstart:Quick start}

        {mansection D clonevarRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:clonevar} has various possible uses.  Programmers may desire that a
temporary variable appear to the user exactly like an existing variable.
Interactively, you might want a slightly modified copy of an original
variable, so the natural starting point is a clone of the original.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create {cmd:Mpg} variable as an exact copy of existing variable
{cmd:mpg}{p_end}
{phang2}{cmd:. clonevar Mpg = mpg}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse travel, clear}{p_end}
{phang2}{cmd:. describe mode}{p_end}
{phang2}{cmd:. label list travel}{p_end}

{pstd}Create {cmd:airtrain} to be a slightly modified copy of {cmd:mode}{p_end}
{phang2}{cmd:. clonevar airtrain = mode if mode==1 | mode==2}{p_end}

{pstd}List first through fifth observations on {cmd:mode} and {cmd:airtrain} variables{p_end}
{phang2}{cmd:. list mode airtrain in 1/5}{p_end}
    {hline}
