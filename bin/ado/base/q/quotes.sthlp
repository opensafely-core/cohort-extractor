{smcl}
{* *! version 1.1.3  11feb2011}{...}
{findalias asfrlocal}{...}
{findalias asfrdoubleq}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 13 Functions and expressions" "help exp"}{...}
{viewerjumpto "Description" "quotes##description"}{...}
{viewerjumpto "Remarks" "quotes##remarks"}{...}
{viewerjumpto "Examples" "quotes##examples"}{...}
{title:Title}

{pstd}
{findalias frlocal} and
{findalias frdoubleq} 


{marker description}{...}
{title:Description}

{pstd}
This help file documents the use of left and right single quotes in 
macros and the use of double quotes to enclose strings, in Stata commands,
and in macros.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help quotes##single:Single quotes}
	{help quotes##double:Double quotes}


{marker single}{...}
{title:Single quotes}

{pstd}
An important note is on the way we use left and right single quotes within
Stata, which you will especially deal with when working with macros (see
{findalias frmacros}).  Single quotes (and double quotes, for that matter) may
look different on your keyboard, your monitor, and our printed documentation,
making it difficult to determine which key to press on your keyboard to
replicate what we have shown you.

{pstd}
For the left single quote, we use the grave accent, which occupies a key by
itself on most computer keyboards. On U.S. keyboards, the grave accent is
located at the top left, next to the numeral 1. On some non-U.S. keyboards, the
grave accent is produced by a dead key. For example, pressing the grave accent
dead key followed by the letter a would produce {c a'g}; to get the grave accent
by itself, you would press the grave accent dead key followed by a space. This
accent mark appears in our help files as {cmd:`}.

{pstd}
For the right single quote, we use the standard single quote, or apostrophe. On
U.S. keyboards, the single quote is located on the same key as the double quote,
on the right side of the keyboard next to the Enter key.


{marker double}{...}
{title:Double quotes}

{pstd}
Double quotes are used to enclose strings:  {cmd:"yes"}, {cmd:"no"},
{cmd:"my dir\my file"}, {cmd:"`answ'"} (meaning the contents of local macro
{cmd:answ}, treated as a string), and so on.  Double quotes are used by many
Stata commands,

	    . {cmd:regress lnwage age ed if sex=="female"}

	    . {cmd:gen outa = outcome if drug=="A"}

	    . {cmd:use "person file"}

{pstd}
and double quotes are used with macros,

	    {cmd:local a "example"}

	    {cmd:if "`answ'" == "yes" {c -(}}
		    ...
	    {cmd:{c )-}}

{pstd}
In fact, Stata has two sets of double-quote characters, of which {cmd:""} is
one.  The other is {cmd:`""'}, and they work the same way as {cmd:""}:

	    . {cmd:regress lnwage age ed if sex==`"female"'}

	    . {cmd:gen outa = outcome if drug==`"A"'}

	    . {cmd:use `"person file"'}

{pstd}
No rational user would use {cmd:`""'} (called compound double quotes)
instead of {cmd:""} (called simple double quotes), but smart programmers
do use them:

	    {cmd:local a `"example"'}

	    {cmd:if `"`answ'"' == `"yes"' {c -(}}
		    ...
	    {cmd:{c )-}}

{pstd}
Why is {cmd:`"example"'} better than {cmd:"example"}, {cmd:`"`answ'"'} better
than {cmd:"`answ'"}, and {cmd:`"yes"'} better than {cmd:"yes"}?  
Only {cmd:`"`answ'"'} is better than {cmd:"`answ'"}; {cmd:`"example"'}
and {cmd:`"yes"'} are no better - and no worse - than {cmd:"example"} and
{cmd:"yes"}.

{pstd}
{cmd:`"`answ'"'} is better than {cmd:"`answ'"} because the macro {cmd:answ}
might itself contain (simple or compound) double quotes.  The really great
thing about compound double quotes is that they nest.  Pretend that {cmd:`answ'}
contained the string ``{cmd:I "think" so}''.  Then,

    Stata would find{col 45}{cmd:if "`answ'"=="yes"}
    confusing because it would expand to{col 45}{cmd:if "I "think" so"=="yes"}

    Stata would not find{col 45}{cmd:if `"`answ'"'==`"yes"'}
    confusing because it would expand to{col 45}{cmd:if `"I "think" so"'==`"yes"'}

{pstd}
Open and close double quote in the simple form look the same; open quote is
{cmd:"} and so is close quote.  Open and close double quote in the compound
form are distinguishable; open quote is {cmd:`"} and close quote is {cmd:"'},
and so Stata can pair the close with the corresponding open double quote.
{cmd:`"I "think" so"'} is easy for Stata to understand, whereas
{cmd:"I "think" so"} is a hopeless mishmash.  (If you disagree, consider what
{cmd:"A"B"C"} might mean.  Is it the quoted string {cmd:A"B"C} or is it quoted
string {cmd:A} followed by {cmd:B} followed by quoted string {cmd:C}?)

{pstd}
Because Stata can distinguish open from close quotes, even nested compound
double quotes are understandable:  {cmd:`"I `"think"' so"'}.  (What
does {cmd:"A"B"C"} mean?  Either it means {cmd:`"A`"B"'C"'} or it means
{cmd:`"A"'B`"C"'}.)

{pstd}
Yes, compound double quotes make you think that your vision is stuttering,
especially when combined with the macro substitution {cmd:`'} characters.
That is why we rarely use them, even when writing programs.  You do not have
to use exclusively one or the other style of quotes.  It is perfectly
acceptable to code

	    {cmd:local a "example"}

	    {cmd:if `"`answ'"' == "yes" {c -(}}
		    ...
	    {cmd:{c )-}}

{pstd}
using compound double quotes where it might be necessary ({cmd:`"`answ'"'})
and using simple double quotes in other places ({cmd:"yes"}).  It is
also acceptable to use simple double quotes around macros ({cmd:"`answ'"}) if
you are certain that the macros themselves do not contain double quotes or if
you do not care what happens if they do.

{pstd}
Sometimes careful programmers should use compound double
quotes, however.  Stata's {helpb syntax} command interprets standard Stata
syntax, which makes it easy to write programs that understand things like

	    . {cmd:myprog mpg weight if strpos(make,"VW")!=0}

{pstd}
{cmd:syntax} works by placing the {cmd:if} {it:exp} typed by the user in the
local macro {cmd:if}.  Thus, {cmd:`if'} will contain
``{cmd:if strpos(make,"VW")!=0}'' here.  Now, say that you are at a point
in your program where you want to know whether the user specified an {cmd:if}
{it:exp}.  It would be natural to code

	    {cmd:if `"`if'"' != "" {c -(}}
		    {cmd://} {it:the if exp was specified}
		    ...
	    {cmd:{c )-}}
	    {cmd:else {c -(}}
		    {cmd://} {it:it was not}
		    ...
	    {cmd:{c )-}}

{pstd}
We used compound double quotes around the macro {cmd:`if'}.
The local macro {cmd:`if'} might contain double quotes, so we placed
compound double quotes around it.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse hbp2}{p_end}
{phang}{cmd:. count if sex=="male"}{p_end}
{phang}{cmd:. label variable age_grp "age groups in 5-year increments"}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. char mpg[one] "this"}{p_end}
{phang}{cmd:. local x: char mpg[one]}{p_end}
{phang}{cmd:. display "`x'"}{p_end}
