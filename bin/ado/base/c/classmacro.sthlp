{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] class" "mansection P class"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class: classman" "help classman"}{...}
{vieweralsosee "[P] class: classdeclare" "help classdeclare"}{...}
{vieweralsosee "[P] class: classassign" "help classassign"}{...}
{vieweralsosee "[P] class: classbi" "help classbi"}{...}
{viewerjumpto "Appendix C.3: Macro substitution" "classmacro##app_c3"}{...}
{viewerjumpto "Description" "classmacro##description"}{...}
{viewerjumpto "Links to PDF documentation" "classmacro##linkspdf"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] class} {hline 2}}Class programming  (continuation of
        {manhelp classman P:class})
{p_end}
{p2col:}({mansection P class:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker app_c3}{...}
{title:Appendix C.3:  Macro substitution}

{pstd}
Values of member variables or values returned by member programs can be
substituted in any Stata command line in any context using macro quoting.
The syntax is

{p 8 12 2}
...{cmd:`}{cmd:.}{it:id}[{cmd:.}{it:id}[...]]{cmd:'}...

{p 8 12 2}
...{cmd:`}[{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.}{it:pgmname}{cmd:'}...{break}

{p 8 12 2}
...{cmd:`}[{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.}{it:pgmname} {it:pgm_arguments}{cmd:'}...

{p 8 12 2}
...{cmd:`}[{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.Super}[{cmd:(}{it:classname}{cmd:)}]{cmd:.}{it:pgmname}{cmd:'}...

{p 8 12 2}
...{cmd:`}[{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.Super}[{cmd:(}{it:classname}{cmd:)}]{cmd:.}{it:pgmname} {it:pgm_arguments}{cmd:'}...

{p 4 8 2}
Nested substitutions are allowed.  For example,

{p 8 12 2}
	...{cmd:`.`tmpname'.x'}...

{p 8 12 2}
	...{cmd:``ref''}...

{pstd}
In the above, perhaps local {cmd:tmpname} was obtained from {helpb tempname}
and perhaps local {cmd:ref} contains "{cmd:.myobj.cvalue}".

{pstd}
When a class object is quoted, its printable form is substituted.  This is
defined:

	Object type      printable form
	{hline 61}
	{cmd:string}           contents of the string
	{cmd:double}           number printed using {cmd:%18.0g}, spaces stripped
	{cmd:array}            nothing
	{it:classname}        nothing or, if member program {cmd:.macroexpand}
			 is defined, the {cmd:string} or {cmd:double} returned
	{hline 61}

{pstd}
If the quoted reference results in an error, the error message is suppressed and
nothing is substituted.


{marker description}{...}
{title:Description}

{pstd}
See {help classman} for more information.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P classRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


