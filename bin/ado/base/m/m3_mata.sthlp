{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-3] mata" "mansection M-3 mata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "m3_mata##syntax"}{...}
{viewerjumpto "Description" "m3_mata##description"}{...}
{viewerjumpto "Links to PDF documentation" "m3_mata##linkspdf"}{...}
{viewerjumpto "Remarks" "m3_mata##remarks"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[M-3] mata} {hline 2}}Mata invocation command
{p_end}
{p2col:}({mansection M-3 mata:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
The {cmd:mata} command documented here is for use from Stata.
It is how you enter Mata.
You type {cmd:mata} at a Stata dot prompt, not a Mata colon prompt.


{marker syntax1}{...}
	Syntax 1{col 41}Comment
	{hline 70}
	{cmd:mata}{col 41}no colon following {cmd:mata}
		{it:istmt}
		{it:istmt}{col 41}if an error occurs, you stay in 
		..{col 41}{cmd:mata} mode
		{it:istmt}
	{cmd:end}{col 41}you exit when you type {cmd:end}
	{hline 70}
	Syntax 1 is the best way to use Mata interactively.


{marker syntax2}{...}
	Syntax 2{col 41}Comment
	{hline 70}
	{cmd:mata:}{col 41}colon following {cmd:mata}
		{it:istmt}
		{it:istmt}{col 41}if an error occurs, you are 
		..{col 41}dumped from {cmd:mata}
		{it:istmt}
	{cmd:end}{col 41}otherwise, you exit when you type {cmd:end}
	{hline 70}
	Syntax 2 is mostly used by programmers in ado-files.
	Programmers want errors to stop everything.


{marker syntax3}{...}
	Syntax 3{col 41}Comment
	{hline 70}
	{cmd:mata}  {it:istmt}{col 41}rarely used
	{hline 70}
	Syntax 3 is the single-line variant of syntax 1, but it is not
	useful.


{marker syntax4}{...}
	Syntax 4{col 41}Comment
	{hline 70}
	{cmd:mata:} {it:istmt}{col 41}for use by programmers
	{hline 70}
	Syntax 4 is the single-line variant of syntax 2, and it exists for
	the same reason as syntax 2:  for use by programmers in ado-files.


{marker description}{...}
{title:Description}

{p 4 4 2}
The {cmd:mata} command invokes Mata.
An {it:istmt} is something Mata understands; {it:istmt} stands for 
interactive statement of Mata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 mataRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}Remarks are presented under the following headings:

        {help m3_mata##remarks1:Introduction}
	{help m3_mata##remarks2:The fine distinction between syntaxes 3 and 4}
	{help m3_mata##remarks3:The fine distinction between syntaxes 1 and 2}


{marker remarks1}{...}
{title:Introduction}

{p 4 4 2}
For interactive use, use {help m3_mata##syntax1:syntax 1}.  Type {cmd:mata} (no
colon), press {hi:Enter}, and then use Mata freely.  Type {cmd:end} to return
to Stata.  (When you exit from Mata back into Stata, Mata does not clear
itself; so if you later type {cmd:mata}-followed-by-enter again, you will be
right back where you were.)

{p 4 4 2}
For programming use, use {help m3_mata##syntax2:syntax 2} or
{help m3_mata##syntax4:syntax 4}.
Inside a program or an ado-file, you can just call a Mata function

	{cmd}program myprog
		{txt:...}
		mata: utility("`varlist'")
		{txt:...}
	end{txt}

{p 4 4 2}
and you can even include that Mata function in your ado-file

	{hline 43} begin myprog.ado {hline 6}
	{cmd}program myprog
		{txt:...}
		mata: utility("`varlist'")
		{txt:...}
	end

	mata:
	function utility(string scalar varlist)
	{
		{txt:...}
	}
	end{txt}
	{hline 43} end myprog.ado {hline 8}
		
{p 4 4 2}
or you could separately compile {cmd:utility()} and put it in a
{cmd:.mo} file or in a Mata library.


{marker remarks2}{...}
{title:The fine distinction between syntaxes 3 and 4}

{p 4 4 2}
Syntaxes {help m3_mata##syntax3:3} and {help m3_mata##syntax4:4} are both
single-line syntaxes.  You type {cmd:mata}, perhaps a colon, and follow that
with the Mata {it:istmt}.

{p 4 4 2}
The differences between the two syntaxes is whether they allow 
continuation lines.  With a colon, no continuation line is allowed.
Without a colon, you may have continuation lines.

{p 4 4 2}
For instance, let's consider 

	{cmd}function renorm(scalar a, scalar b)
	{c -(}
		...
	{c )-}{txt}

{p 4 4 2}
No matter how long the function, it is one {it:istmt}.
Using {cmd:mata:}, if you were to try to enter that {it:istmt}, 
here is what would happen:

	. {cmd:mata: function renorm(scalar a, scalar b)}
	{err:<istmt> incomplete}
	r(197);

{p 4 4 2}
When you got to the end of the first line and pressed {hi:Enter}, you got an 
error message.  Using the {cmd:mata:} command, the {it:istmt} must 
all fit on one line.

{p 4 4 2}
Now try the same thing using {cmd:mata} without the colon:

	. {cmd:mata function renorm(scalar a, scalar b)}
	> {cmd:{c -(}}
	>     ...
	> {cmd:{c )-}}

	. 

{p 4 4 2}
That worked!  Single-line {cmd:mata} without the colon allows continuation
lines and, on this score at least, seems better than single-line {cmd:mata}
with the colon.  In programming contexts, however, this feature can bite.
Consider the following program fragment:

	{cmd}program example
		{txt:...}
		mata utility("`varlist'"
		replace `x' = ...
		{txt:...}
	end{txt}

{p 4 4 2}
We used {cmd:mata} without the colon, and we made an error:  we
forgot the close parenthesis.  {cmd:mata} without the colon will be looking
for that close parenthesis and so will eat the next line -- a line not
intended for Mata.  Here we will get an error message because
"{cmd:replace `x' = }..." will make no sense to Mata, but that error will be
different from the one we should have gotten.  In the unlikely worse case,
that next line will make sense to Mata.

{p 4 4 2}
Ergo, programmers want to include the colon.  It will make your programs
easier to debug.

{p 4 4 2}
There is, however, a programmer's use for single-line {cmd:mata} without the
colon.  In our sample ado-file above when we included the routine
{cmd:utility()}, we bound it in {cmd:mata:} and {cmd:end}.  It would be
satisfactory if instead we coded

	{hline 43} begin myprog.ado {hline 6}
	{cmd}program myprog
		{txt:...}
		mata: utility("`varlist'")
		{txt:...}
	end

	mata function utility(string scalar varlist)
	{
		{txt:...}
	{c )-}{txt}
	{hline 43} end myprog.ado {hline 8}

{p 4 4 2}
Using {cmd:mata} without the colon, we can omit the {cmd:end}.
We admit we sometimes do that.


{marker remarks3}{...}
{title:The fine distinction between syntaxes 1 and 2}

{p 4 4 2}
Nothing said above about continuation lines applies to syntaxes
{help m3_mata##syntax1:1} and {help m3_mata##syntax2:2}.
The multiline {cmd:mata}, with or without colon, always allows continuation
lines because where the Mata session ends is clear enough:  {cmd:end}.

{p 4 4 2}
The difference between the two multiline syntaxes is whether Mata 
tolerates errors or instead dumps you back into Stata.
Interactive users appreciate tolerance.  Programmers want strictness.
Programmers, consider the following (using {cmd:mata} without the colon):

	{cmd:program example2}
		...
		{cmd:mata}
			{cmd:result = myfunc("`varlist'")}
			{cmd:st_local("n" result)}           /* <- mistake here */
			{cmd:result = J(0,0,"")}
		{cmd:end}
		...
	{cmd:end}

{p 4 4 2}
In the above example, we omitted the comma between {cmd:"n"} and
{cmd:result}.  We also used multiline {cmd:mata} without the colon. 
Therefore, the incorrect line will be tolerated by Mata, which will 
merrily continue executing our program until the {cmd:end} statement, 
at which point Mata will return control to Stata and not tell Stata that 
anything went wrong!  This could have serious consequences, all of which 
could be avoided by substituting multiline {cmd:mata} with the colon.
{p_end}
