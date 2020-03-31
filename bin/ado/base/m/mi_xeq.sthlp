{smcl}
{* *! version 1.0.11  15may2018}{...}
{vieweralsosee "[MI] mi xeq" "mansection MI mixeq"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi passive" "help mi_passive"}{...}
{viewerjumpto "Syntax" "mi_xeq##syntax"}{...}
{viewerjumpto "Description" "mi_xeq##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_xeq##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_xeq##remarks"}{...}
{viewerjumpto "Stored results" "mi_xeq##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MI] mi xeq} {hline 2}}Execute command(s) on individual
     imputations{p_end}
{p2col:}({mansection MI mixeq:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{cmd:mi xeq}
[{it:{help numlist}}]{cmd::}
{it:command}
[{cmd:;} {it:command} 
[{cmd:;} ...]]


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:xeq:} {it:XXX} executes {it:XXX} on {it:m}=0, {it:m}=1, ...,
{it:m}={it:M}.

{p 4 4 2}
{cmd:mi} {cmd:xeq} {it:{help numlist}}{cmd::} {it:XXX} executes {it:XXX} on
{it:m}={it:numlist}.

{p 4 4 2}
{it:XXX} can be any single command or it can be multiple commands 
separated by a semicolon.  If specifying multiple commands, the delimiter must
not be set to semicolon; see {bf:{help delimit:[P] #delimit}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mixeqRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_xeq##reporting:Using mi xeq with reporting commands}
	{help mi_xeq##modification:Using mi xeq with data-modification commands}
	{help mi_xeq##flongsep:Using mi xeq with data-modification commands on flongsep data}


{marker reporting}{...}
{title:Using mi xeq with reporting commands}

{p 4 4 2}
By reporting commands, we mean any general Stata command that reports
results but leaves the data unchanged.  {bf:{help summarize}} is
an example.  {cmd:mi} {cmd:xeq} is especially useful with such commands.  If
you wanted to see the summary statistics for variables {cmd:outcome} and
{cmd:age} among the females in your {cmd:mi} data, you could type

	. {cmd:mi xeq: summarize outcome age if sex=="female"}

	{it:m}=0 data:
	-> summarize outcome age if sex=="female"
           {it:(output omitted)}

	{it:m}=1 data:
	-> summarize outcome age if sex=="female"
           {it:(output omitted)}

	{it:m}=2 data:
	-> summarize outcome age if sex=="female"
           {it:(output omitted)}

{p 4 4 2}
{it:M}=2 in the data above.  

{p 4 4 2}
If you wanted to see a particular regression run on the {it:m}=2 data, 
you could type 

	. {cmd:mi xeq 2: regress outcome age bp}

	{it:m}=2 data:
	-> regress outcome age bp
           {it:(output omitted)}

{p 4 4 2}
In both cases, once the command executes, the entire {cmd:mi} dataset is 
brought back into memory.


{marker modification}{...}
{title:Using mi xeq with data-modification commands}

{p 4 4 2}
You can use data-modification commands with {cmd:mi} {cmd:xeq} but
doing that is not especially useful unless you are using flongsep data.

{p 4 4 2}
If variable {cmd:lnage} were registered as passive and you wanted to update its
values, you could type

	. {cmd:mi xeq: replace lnage = ln(age)}
	  {it:(output omitted)}

{p 4 4 2}
That would work regardless of style, although it is just as easy to update 
the variable using {bf:{help mi_passive:mi passive}}:

	. {cmd:mi passive: replace lnage = ln(age)}
	  {it:(output omitted)}

{p 4 4 2}
If what you are doing depends on the sort order of the data, include 
the {cmd:sort} command among the commands to be executed; do not assume 
that the individual datasets will be sorted the way the data in memory 
are sorted.  For instance, if you have passive variable {cmd:totalx}, do not
type

	. {cmd:sort id time}

	. {cmd:mi xeq: by id: replace totalx = sum(x)}

{p 4 4 2}
That will not work.  Instead, type 

	. {cmd:mi xeq: sort id time;  by id: replace totalx = sum(x)}

	{it:m}=0 data:
	-> sort id time
	-> by id: replace total x = sum(x)
	(8 changes made)

	{it:m}=1 data:
	-> sort id time
	-> by id: replace total x = sum(x)
	(8 changes made)

	{it:m}=2 data:
	-> sort id time
	-> by id: replace total x = sum(x)
	(8 changes made)


{p 4 4 2}
Again we note that it would be just as easy to update this variable 
with {cmd:mi} {cmd:passive}:

	. {cmd:mi passive: by id (time): replace totalx = sum(x)}
	{it:m}=0:
	(8 changes made)
	{it:m}=1:
	(8 changes made)
	{it:m}=2:
	(8 changes made)

{p 4 4 2}
With the wide, mlong, and flong styles, there is always another way to proceed,
and often the other way is easier.


{marker flongsep}{...}
{title:Using mi xeq with data-modification commands on flongsep data}

{p 4 4 2}
With flongsep data, {cmd:mi} {cmd:xeq} is especially useful.
Consider the case where you want to add new variable {cmd:lnage} 
= {cmd:ln(age)} to your data, and {cmd:age} is just a regular or 
unregistered variable.  With flong, mlong, or wide data, you would 
just type 

	. {cmd:generate lnage = ln(age)}

{p 4 4 2}
and be done with it.

{p 4 4 2}
With flongsep data, you have multiple datasets to update.  Of course, you
could {bf:{help mi_convert:mi convert}} your data to one of the other
styles, but we will assume that if you had sufficient memory to do that, you
would have done that long ago and so would not be using flongsep data.

{p 4 4 2}
The easy way to create {cmd:lnage} with flongsep data is by typing

	. {cmd:mi xeq: generate lnage = ln(age)}
	  {it:(output omitted)}

{p 4 4 2}
You could use the {cmd:mi} {cmd:xeq} approach with any of the styles, but 
with flong, mlong, or wide data, it is not necessary.  With flongsep, 
it is.


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:mi} {cmd:xeq} 
stores in {cmd:r()} whatever the last command run on the last 
imputation or specified imputation returns.  For instance, 

	. {cmd:mi xeq: tabulate g ;  summarize x}

{p 4 4 2}
returns the stored results for {cmd:summarize} {cmd:x} run on {it:m}={it:M}.  

	. {cmd:mi xeq 1 2: tabulate g ;  summarize x}

{p 4 4 2}
returns the stored results for {cmd:summarize} {cmd:x} run on {it:m}=2.  

	. {cmd:mi xeq 0: summarize x}

{p 4 4 2}
returns the stored results for {cmd:summarize} {cmd:x} run on {it:m}=0.  
{p_end}
