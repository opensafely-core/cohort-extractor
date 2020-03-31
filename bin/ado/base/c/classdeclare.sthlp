{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] class" "mansection P class"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class: classman" "help classman"}{...}
{vieweralsosee "[P] class: classassign" "help classassign"}{...}
{vieweralsosee "[P] class: classmacro" "help classmacro"}{...}
{vieweralsosee "[P] class: classbi" "help classbi"}{...}
{viewerjumpto "Appendix C.1: Class declaration" "classdeclare##app_c1"}{...}
{viewerjumpto "Description" "classdeclare##description"}{...}
{viewerjumpto "Links to PDF documentation" "classdeclare##linkspdf"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] class} {hline 2}}Class programming  (continuation of
        {manhelp classman P:class})
{p_end}
{p2col:}({mansection P class:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker app_c1}{...}
{title:Appendix C.1:  Class declaration}

	{cmd:class} [{it:newclassname}] {cmd:{c -(}}

	    [{opt class:wide}{cmd::}]

		[{it:type} {it:mvname} [{cmd:=} {it:rvalue}]]

		[     {it:mvname}  {cmd:=} {it:rvalue} ]

		[...]

	    [{opt instance:specific}{cmd::}]

		[{it:type} {it:mvname} [{cmd:=} {it:rvalue}]]

		[     {it:mvname}  {cmd:=} {it:rvalue} ]

		[...]

	{cmd:{c )-}} [{cmd:, inherit(}{txt:{it:classnamelist}}{cmd:)} ]


{pstd}
where

{pmore}
{it:mvname} stands for member variable name;

{pmore}
{it:rvalue} is defined in {help classassign}; and

{pmore}
{it:type} is {c -(}{it:classname} | {cmd:double} | {cmd:string} | {cmd:array}{c )-}.


{pstd}
The {cmd:.Declare} built-in may be used to add a member variable
to an existing class instance:

	{cmd:.}{it:id}[{cmd:.}{it:id}[...]] {cmd:.Declare} {it:type} {it:newmvname} [{cmd:=} {it:rvalue}]

	{cmd:.}{it:id}[{cmd:.}{it:id}[...]] {cmd:.Declare} {it:newmvname} {cmd:=} {it:rvalue}

{pstd}
where {it:id} is {c -(}{it:name} | {it:name}{cmd:[}{it:exp}{cmd:]}{c )-}, the
latter being how you refer to an array element; {it:exp} must evaluate to a
number.  If {it:exp} evaluates to a noninteger number, it is truncated.


{marker description}{...}
{title:Description}

{pstd}
Class {it:classname} is defined in file {it:classname}{cmd:.class}.  Its
structure is

	{hline 40} {it:classname}{cmd:.class} {hline}
	{cmd:version} ...           // Part 1:  version statement

	{cmd:class} {it:classname} {cmd:{c -(}}     // Part 2:  declaration of member variables
		...
	{cmd:{c )-}}

	{cmd:program} ...           // Part 3:  code for member programs
		...
	{cmd:end}

	{cmd:program} ...
		...
	{cmd:end}

	...
	{hline 40} {it:classname}{cmd:.class} {hline}

{pstd}
See {help classman} for more information.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P classRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


