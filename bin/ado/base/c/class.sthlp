{smcl}
{* *! version 1.1.8  22mar2018}{...}
{vieweralsosee "[P] class" "mansection P class"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class exit" "help class exit"}{...}
{vieweralsosee "[P] classutil" "help classutil"}{...}
{vieweralsosee "[P] sysdir" "help sysdir"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] class" "help m2_class"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] class} {hline 2}}Class programming
{p_end}
{p2col:}({mansection P class:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Description}

{pstd}
Stata's two programming languages, ado and Mata, each support object-oriented
programming.  {manlink P class} explains object-oriented programming in
ado.  Most users interested in object-oriented programming will wish to do
the programming in Mata.  See {manhelp m2_class M-2:class} to learn about
object-oriented programming in Mata.

{pstd}
Ado classes are a programming feature of Stata that are especially useful for
dealing with graphics and GUI problems, although their use need not be
restricted to those topics.  Ado class programming is an advanced programming
topic and will not be useful to most programmers.

{pstd}
For information on class programming, see

	Full documentation:
		{help classman}             class programming
        	{helpb classutil}            {cmd:classutil} utility command
		{helpb class exit}           {cmd:class exit} programming command

	Quick reference and syntax diagrams:
		{help classdeclare}         the {cmd:class} command
		{help classassign}          {it:lvalue} {cmd:=} {it:rvalue} details
        	{help classmacro}           {cmd:`.}{it:id}[{cmd:.}{it:id}[...]] ...{cmd:'} substitution
		{help classbi}              built ins
