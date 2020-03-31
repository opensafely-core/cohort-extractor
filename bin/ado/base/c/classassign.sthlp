{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[P] class" "mansection P class"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class: classman" "help classman"}{...}
{vieweralsosee "[P] class: classdeclare" "help classdeclare"}{...}
{vieweralsosee "[P] class: classmacro" "help classmacro"}{...}
{vieweralsosee "[P] class: classbi" "help classbi"}{...}
{viewerjumpto "Appendix C.2: Assignment" "classassign##app_c2"}{...}
{viewerjumpto "Description" "classassign##description"}{...}
{viewerjumpto "Links to PDF documentation" "classassign##linkspdf"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] class} {hline 2}}Class programming  (continuation of
        {manhelp classman P:class})
{p_end}
{p2col:}({mansection P class:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker app_c2}{...}
{title:Appendix C.2:  Assignment}

	{it:lvalue} {cmd:=} {it:rvalue}
	{it:lvalue}{cmd:.ref} {cmd:=} {it:lvalue}{cmd:.ref}{space 20}{it:[sic]}
	{it:lvalue}{cmd:.ref} {cmd:=} {it:rvalue}

{pstd}
where

{pmore}
{it:lvalue} is {cmd:.}{it:id}[{cmd:.}{it:id}[...]]

{p 8 12 2}
{it:rvalue} is{break}
	{cmd:"}[{it:string}]{cmd:"}{break}
	{cmd:`"}[{it:string}]{cmd:"'}{break}
	{it:#}{break}
	{it:exp}{break}
	{cmd:(}{it:exp}{cmd:)}{break}
	{cmd:.}{it:id}[{cmd:.}{it:id}[...]]{break}
	[{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.}{it:pgmname} [{it:pgm_arguments}]{break}
	[{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.Super}[{cmd:(}{it:classname}{cmd:)}]{cmd:.}{it:pgmname} [{it:pgm_arguments}]{break}
	{cmd:{c -(}}{cmd:{c )-}}{break}
	{cmd:{c -(}}{it:el} [{cmd:,}{it:el} [{cmd:,}...]]{cmd:{c )-}}

{pmore}
When {it:exp} evaluates to a string, the result will contain at most
{ccl maxstrvarlen} characters and will be terminated early if it
contains a binary 0.

{p 8 12 2}
The last two syntaxes concern assignment to arrays;
{it:el} may be{break}
	    {it:nothing}{break}
	    {cmd:"}[{it:string}]{cmd:"}{break}
	    {cmd:`"}[{it:string}]{cmd:"'}{break}
	    {it:#}{break}
	    {cmd:(}{it:exp}{cmd:)}{break}
	    {cmd:.}{it:id}[{cmd:.}{it:id}[...]]{break}
	    [{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.}{it:pgmname}{break}
	    {cmd:[}[{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.}{it:pgmname} [{it:pgm_arguments}]{cmd:]}{break}
	{cmd:[}[{cmd:.}{it:id}[{cmd:.}{it:id}[...]]]{cmd:.Super}[{cmd:(}{it:classname}{cmd:)}]{cmd:.}{it:pgmname} [{it:pgm_arguments}]{cmd:]}{break}

{pmore}
{it:id} is {c -(}{it:name} | {it:name}{cmd:[}{it:exp}{cmd:]}{c )-}, the
latter being how you refer to an array element; {it:exp} must evaluate to a
number.  If {it:exp} evaluates to a noninteger number, it is truncated.


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


