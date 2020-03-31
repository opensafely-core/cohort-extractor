{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[P] foreach" "mansection P foreach"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] continue" "help continue"}{...}
{vieweralsosee "[P] forvalues" "help forvalues"}{...}
{vieweralsosee "[P] while" "help while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] if" "help ifcmd"}{...}
{vieweralsosee "[P] levelsof" "help levelsof"}{...}
{viewerjumpto "Syntax" "foreach##syntax"}{...}
{viewerjumpto "Description" "foreach##description"}{...}
{viewerjumpto "Links to PDF documentation" "foreach##linkspdf"}{...}
{viewerjumpto "Examples" "foreach##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] foreach} {hline 2}}Loop over items{p_end}
{p2col:}({mansection P foreach:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:foreach} {it:lname} {c -(}{cmd:in}|{cmd:of} {it:listtype}{c )-} {it:list} {cmd:{c -(}}
		{it:commands referring to} {cmd:`}{it:lname}{cmd:'}
	{cmd:{c )-}}

    Allowed are

	{cmd:foreach} {it:lname} {cmd:in} {it:any_list} {cmd:{c -(}}

	{cmd:foreach} {it:lname} {cmd:of} {cmdab:loc:al}    {it:lmacname}   {cmd:{c -(}}

	{cmd:foreach} {it:lname} {cmd:of} {cmdab:glo:bal}   {it:gmacname}   {cmd:{c -(}}

	{cmd:foreach} {it:lname} {cmd:of} {cmdab:var:list}  {it:varlist}    {cmd:{c -(}}

	{cmd:foreach} {it:lname} {cmd:of} {cmdab:new:list}  {it:newvarlist} {cmd:{c -(}}

	{cmd:foreach} {it:lname} {cmd:of} {cmdab:num:list}  {it:numlist}    {cmd:{c -(}}

{pstd}Braces must be specified with {cmd:foreach}, and

{phang2}1.  the open brace must appear on the same line as the {cmd:foreach};

{phang2}2.  nothing may follow the open brace except, of course, comments; the first command to be executed must appear on a new line;

{phang2}3.  the close brace must appear on a line by itself.


{marker description}{...}
{title:Description}

{pstd}
{cmd:foreach} repeatedly sets local macro {it:lname} to each element of the
list and executes the commands enclosed in braces.  The loop is executed zero
or more times; it is executed zero times if the list is null or empty.  Also
see {manhelp forvalues P}, which is the fastest way to loop over consecutive
values, such as looping over numbers from 1 to {it:k}.

{pstd}
{cmd:foreach} {it:lname} {cmd:in} {it:list} {cmd:{c -(}} {it:...} {cmd:{c )-}}
allows a general list.  Elements are separated from each other by one or more
blanks.

{pstd}
{cmd:foreach} {it:lname} {cmd:of} {cmd:local} {it:list} {cmd:{c -(}}
{it:...} {cmd:{c )-}} and
{cmd:foreach} {it:lname} {cmd:of} {cmd:global} {it:list} {cmd:{c -(}}
{it:...} {cmd:{c )-}} obtain the list from the indicated place.  This
method of using {cmd:foreach} produces the fastest executing code.

{pstd}
{cmd:foreach} {it:lname} {cmd:of} {cmd:varlist} {it:list} {cmd:{c -(}}
{it:...} {cmd:{c )-}},
{cmd:foreach} {it:lname} {cmd:of} {cmd:newlist} {it:list} {cmd:{c -(}}
{it:...} {cmd:{c )-}}, and
{cmd:foreach} {it:lname} {cmd:of} {cmd:numlist} {it:list} {cmd:{c -(}}
{it:...} {cmd:{c )-}} are much like {cmd:foreach} {it:lname} {cmd:in}
{it:list} {cmd:{c -(}} {it:...} {cmd:{c )-}}, except that the {it:list} is
given the appropriate interpretation.  For instance,

        {cmd}foreach x in mpg weight-turn {c -(}
                ...
        {c )-}{txt}

{pstd}
has two elements, {cmd:mpg} and {cmd:weight-turn}, so the loop will be executed twice. 

        {cmd}foreach x of varlist mpg weight-turn {c -(}
                ...
        {c )-}{txt}

{pstd}
has four elements, {cmd:mpg}, {cmd:weight}, {cmd:length}, and
{cmd:turn}, because {it:list} was given the interpretation of a varlist.

{pstd}
{cmd:foreach} {it:lname} {cmd:of} {cmd:varlist} {it:list} {cmd:{c -(}}
{it:...} {cmd:{c )-}}
gives {it:list} the interpretation of a varlist.  The {it:list} is
expanded according to standard variable abbreviation rules, and the existence
of the variables is confirmed.

{pstd}
{cmd:foreach} {it:lname} {cmd:of} {cmd:newlist} {it:list} {cmd:{c -(}}
{it:...} {cmd:{c )-}}
indicates that the {it:list} is to be interpreted as new variable names;
see {varlist}.  A check is performed to see that the named variables could be
created, but they are not automatically created.

{pstd}
{cmd:foreach} {it:lname} {cmd:of} {cmd:numlist} {it:list} {cmd:{c -(}}
{it:...} {cmd:{c )-}}
indicates a number list and allows standard number-list notation; see 
{it:{help numlist}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P foreachRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Loop over an arbitrary list.  In this case, append a list of files to the
current dataset.

	{cmd:foreach file in this.dta that.dta theother.dta {c -(}}
		{cmd:append using "`file'"}
	{cmd:{c )-}}

{pstd}
Quotes may be used to allow elements with blanks.

	{cmd:foreach name in "Annette Fett" "Ashley Poole" "Marsha Martinez" {c -(}}
		{cmd:display length("`name'") " characters long -- `name'"}
	{cmd:{c )-}}

{pstd}
Loop over the elements of a local macro.

	{cmd:local grains "rice wheat corn rye barley oats"}
	{cmd:foreach x of local grains {c -(}}
		{cmd:display "`x'"}
	{cmd:{c )-}}

{pstd}
Loop over the elements of a global macro.

	{cmd:global money "Franc Dollar Lira Pound"}
	{cmd:foreach y of global money {c -(}}
		{cmd:display "`y'"}
	{cmd:{c )-}}

{pstd}
Loop over existing variables.

	{cmd:foreach var of varlist pri-rep t* {c -(}}
		{cmd:quietly summarize `var'}
		{cmd:summarize `var' if `var' > r(mean)}
	{cmd:{c )-}}

{pstd}
{cmd:foreach} {it:lname} {cmd:of varlist} {it:varlist} {cmd:{c -(}}
{it:...} {cmd:{c )-}} can be useful interactively but is rarely used in
programming contexts.  Instead of coding,

	{cmd:syntax [varlist]} {it:...}
	{cmd:foreach var of varlist `varlist' {c -(}}
		{it:...}
	{cmd:{c )-}}

{pstd}
it is more efficient to code

	{cmd:syntax [varlist]} {it:...}
	{cmd:foreach var of local varlist {c -(}}
		{it:...}
	{cmd:{c )-}}

{pstd}
because {hi:`varlist'} has already been expanded by the {helpb syntax} command.

{pstd}
Loop over new variables.

	{cmd:foreach var of newlist z1-z20 {c -(}}
		{cmd:gen `var' = runiform()}
	{cmd:{c )-}}

{pstd}
Loop over a numlist.

	{cmd:foreach num of numlist 1 4/8 13(2)21 103 {c -(}}
		{cmd:display `num'}
	{cmd:{c )-}}

{pstd}
If you wish to loop over many equally spaced values, do not
code, for instance, 

	{cmd:foreach x in 1/1000 {c -(}}
		{it:...}
	{cmd:{c )-}}

{pstd}
Instead code

	{cmd:forvalues x = 1/1000 {c -(}}
		{it:...}
	{cmd:{c )-}}

{pstd}
{cmd:foreach} must store the
list of elements, whereas {cmd:forvalues} obtains the elements
one at a time by calculation; see {manhelp forvalues P}.

{pstd}
The macro {hi:`ferest()'} may be used in the body of the {cmd:foreach} loop
to obtain the unprocessed list elements.  {hi:`ferest()'} is available only
within the body of the loop; outside of that, {hi:`ferest()'} evaluates to
{hi:""}.

	{cmd:foreach x in alpha "one two" three four {c -(}}
		{cmd:display}
		{cmd:display `"       x is |`x'|"'}
		{cmd:display `"ferest() is |`ferest()'|"'}
	{cmd:{c )-}}

{pstd}
The {helpb continue} command provides a method of prematurely terminating a
loop.
{p_end}
