{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[P] class exit" "mansection P classexit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class: classman" "help classman"}{...}
{vieweralsosee "[P] exit" "help exit_program"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] class" "help m2_class"}{...}
{viewerjumpto "Syntax" "class exit##syntax"}{...}
{viewerjumpto "Description" "class exit##description"}{...}
{viewerjumpto "Links to PDF documentation" "class_exit##linkspdf"}{...}
{viewerjumpto "Remarks" "class exit##remarks"}{...}
{viewerjumpto "Examples" "class exit##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[P] class exit} {hline 2}}Exit class-member program and return result{p_end}
{p2col:}({mansection P classexit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

        {cmd:class exit} [{it:rvalue}]

{phang}
where {it:rvalue} is

        {cmd:"}[{it:string}]{cmd:"}
        {cmd:`"}[{it:string}]{cmd:"'}
        {it:#}
        {it:exp}
        {cmd:(}{it:exp}{cmd:)}
        {cmd:.}{it:id}[{cmd:.}{it:id}[...]] [{it:program_arguments}]
        {cmd:{c -(}}{cmd:{c )-}}
        {cmd:{c -(}}{it:el}[{cmd:,}{it:el}[{cmd:,}...]]{cmd:{c )-}}

{phang}
See {help classassign} for more information on {it:rvalues}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:class exit} exits a class-member program and optionally returns the
specified result.

{pstd}
{cmd:class exit} may be used only from class-member programs; see 
{help classman}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P classexitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Do not confuse returned values with return codes, which all Stata programs
set, including member programs.  Member programs exit when they execute

	Condition                       Returned value    Return code
	{hline 64}
	{cmd:class exit} with arguments       as specified      0
	{cmd:class exit} without arguments    nothing           0
	{cmd:exit} without arguments          nothing           0
	{cmd:exit} with arguments             nothing           as specified
	{cmd:error}                           nothing           as specified
	command having error            nothing           as appropriate
	{hline 64}

{pstd}
Any of the preceding are valid ways of exiting a member program, although the
last is perhaps best avoided.  {cmd:class exit} without arguments has the same
effect as {cmd:exit} without arguments; it does not matter which you use.


{marker examples}{...}
{title:Examples}

	{cmd}class exit sqrt((`.c0.y'-`.c1.y')^2 + (`.c0.x'-`.c1.x')^2)
	class exit "`myresult'"
	class exit { `one', `two' }
	class exit .coord
	class exit .coord.x
	tempname a
	{txt:...}
	class exit .`a'{txt}
