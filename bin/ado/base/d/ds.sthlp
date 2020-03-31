{smcl}
{* *! version 1.4.6  22mar2018}{...}
{viewerdialog ds "dialog ds"}{...}
{vieweralsosee "[D] ds" "mansection D ds"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cf" "help cf"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] compare" "help compare"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] format" "help format"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[D] lookfor" "help lookfor"}{...}
{vieweralsosee "[D] notes" "help notes"}{...}
{vieweralsosee "[D] order" "help order"}{...}
{vieweralsosee "[D] rename" "help rename"}{...}
{viewerjumpto "Syntax" "ds##syntax"}{...}
{viewerjumpto "Menu" "ds##menu"}{...}
{viewerjumpto "Description" "ds##description"}{...}
{viewerjumpto "Links to PDF documentation" "ds##linkspdf"}{...}
{viewerjumpto "Options" "ds##options"}{...}
{viewerjumpto "Examples" "ds##examples"}{...}
{viewerjumpto "Stored results" "ds##results"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[D] ds} {hline 2}}Compactly list variables with specified
	properties{p_end}
{p2col:}({mansection D ds:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Simple syntax

{p 8 17 2}
{cmd:ds} [{cmd:,} {opt a:lpha}]

{phang}
Advanced syntax

{p 8 17 2}
{cmd:ds} [{varlist}] [{cmd:,} {it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt not}}list variables not specified in {varlist}{p_end}
{synopt :{opt a:lpha}}list variables in alphabetical order{p_end}
{synopt :{opt d:etail}}display additional details{p_end}
{synopt :{opt v:arwidth(#)}}display width for variable names; default is
{cmd:varwidth(12)}{p_end}
{synopt :{opt skip(#)}}gap between variables; default is {cmd:skip(2)}{p_end}

{syntab :Advanced}
{synopt :{opt has(spec)}}describe subset that matches {it:spec}{p_end}
{synopt :{opt not(spec)}}describe subset that does not match {it:spec}{p_end}

{synopt :{opt inse:nsitive}}perform case-insensitive pattern 
matching{p_end}
{synopt :{opt indent(#)}}indent output; seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{opt insensitive} and {opt indent(#)} are not shown in the dialog
box.

{marker spec}{...}
{synoptset 24}{...}
{synopthdr :spec}
{synoptline}
{synopt :{opt t:ype} {it:typelist}}specified types{p_end}
{synopt :{opt f:ormat} {it:patternlist}}display format matching
{it:patternlist}{p_end}
{synopt :{opt varl:abel} [{it:patternlist}]}variable label or variable label
matching {it:patternlist}{p_end}
{synopt :{opt c:har} [{it:patternlist}]}characteristic or characteristic
matching {it:patternlist}{p_end}
{synopt :{opt vall:abel} [{it:patternlist}]}value label or value label matching
{it:patternlist}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
{it:typelist} used in {cmd:has(type} {it:typelist}{cmd:)} and 
{cmd:not(type} {it:typelist}{cmd:)} is a list of one or more 
types, each of which may be {cmd:numeric}, {cmd:string}, {cmd:str#}, {cmd:strL},
{cmd:byte}, {cmd:int}, {cmd:long}, {cmd:float}, or {cmd:double}, or may be a
{it:{help numlist}} such as {cmd:1/8} to mean 
{bind:"{cmd:str1} {cmd:str2} ...  {cmd:str8}"}.  Examples include{p_end}
{p2colset 13 43 45 2}
{p2col :{cmd:has(type int)}}is of type {opt int}{p_end}
{p2col :{cmd:has(type byte int long)}}is of integer {opt type}{p_end}
{p2col :{cmd:not(type int)}}is not of type {opt int}{p_end}
{p2col :{cmd:not(type byte int long)}}is not of the integer {opt type}s{p_end}
{p2col :{cmd:has(type numeric)}}is a numeric variable{p_end}
{p2col :{cmd:not(type string)}}is not a string ({opt str}{it:#} or {opt strL})
variable (same as above){p_end}
{p2col :{cmd:has(type 1/40)}}is {opt str1}, {opt str2}, ...,
{opt str40}{p_end}
{p2col :{cmd:has(type str#)}}is {opt str1}, {opt str2}, ...,
{opt str2045} but not {opt strL}{p_end}
{p2col :{cmd:has(type strL)}}is of type {opt strL} but not
{opt str}{it:#}{p_end}
{p2col :{cmd:has(type numeric 1/2)}}is numeric or {opt str1} or
{opt str2}{p_end}
{p2colreset}{...}

{phang}
{it:patternlist} used in, for instance, {cmd:has(format} 
{it:patternlist}{cmd:)}, is a list of one or more {it:patterns}.  A pattern is
the expected text with the addition of the characters {cmd:*} and {cmd:?}.
{cmd:*} indicates 0 or more characters go here, and {cmd:?} indicates exactly 1
character goes here.  Examples include{p_end}
{p2colset 13 43 45 2}
{p2col :{cmd:has(format *f)}}format is {cmd:%}{it:#}{cmd:.}{it:#}{cmd:f}{p_end}
{p2col :{cmd:has(format %t*)}}has time or date format{p_end}
{p2col :{cmd:has(format %-*s)}}is a left-justified string{p_end}
{p2col :{cmd:has(varl *weight*)}}variable label includes word {opt weight}
{p_end}
{p2col :{cmd:has(varl *weight* *Weight*)}}variable label has {opt weight} or
{opt Weight}{p_end}
{p2colreset}{...}

{phang}
To match a phrase, enclose the phrase in quotes.

	    {cmd:has(varl "*some phrase*")}    variable label has {opt some phrase}

{phang}
If instead you used {cmd:has(varl *some phrase*)}, then only variables having
labels ending in {opt some} or starting with {opt phrase} would be listed.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Describe data > Compactly list variable names}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ds} lists variable names of the dataset
currently in memory in a compact or detailed format, and lets you specify
subsets of variables to be listed, either by name or by properties (for
example, the variables are numeric).  In addition, {cmd:ds} leaves behind in
{cmd:r(varlist)} the names of variables selected so that you can use them in a
subsequent command.

{pstd}
{cmd:ds}, typed without arguments, lists all variable names of the dataset
currently in memory in a compact form.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D dsQuickstart:Quick start}

        {mansection D dsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt not} specifies that the variables in {varlist} not
be listed.  For instance, {bind:{cmd:ds pop*, not}} specifies that all
variables not starting with the letters {opt pop} be listed.  The default is
to list all the variables in the dataset or, if {it:varlist} is specified, the
variables specified.

{phang}
{opt alpha} specifies that the variables be listed in alphabetical order.
If the variable contains Unicode characters other than plain ASCII, the sort
order is determined strictly by the underlying byte order.
See {findalias frunicodesort}.

{phang}
{opt detail} specifies that detailed output identical to that of 
{cmd:describe} be produced.  If {opt detail} is specified, {opt varwidth()},
{opt skip()}, and {opt indent()} are ignored.

{phang}
{opt varwidth(#)} specifies the display width of the variable names; the
default is {cmd:varwidth(12)}.

{phang}
{opt skip(#)} specifies the number of spaces between variable names, where all
variable names are assumed to be the length of the longest variable name; the
default is {cmd:skip(2)}.

{dlgtab:Advanced}

{phang}
{cmd:has(}{it:{help ds##spec:spec}}{cmd:)} and 
{opt not(spec)} select from the dataset (or from {varlist}) the subset of
variables that meet or fail the specification {it:spec}.  Selection may be made
on the basis of storage type, variable label, value label, display format, or
characteristics.  Only one {opt not}, {opt has()}, or {opt not()} option may be
specified.

{pmore}
{cmd:has(type string)} selects all string variables.  Typing 
{cmd:ds, has(type string)} would list all string variables in the dataset,
and typing {bind:{cmd:ds pop*, has(type string)}} would list all string
variables whose names begin with the letters {opt pop}.

{pmore}
{cmd:has(varlabel)} selects variables with defined 
variable labels.  {cmd:has(varlabel *weight*)} selects variables
with variable labels including the word "weight".  {cmd:not(varlabel)}
would select all variables with no variable labels.

{pmore}
{cmd:has(vallabel)} selects variables with defined value labels.
{cmd:has(vallabel yesno)} selects variables whose value label is {opt yesno}.
{cmd:has(vallabel *no)} selects variables whose value label ends in the
letters {opt no}.

{pmore}
{cmd:has(format} {it:patternlist}{cmd:)} specifies variables whose 
format matches any of the patterns in {it:patternlist}.
{bind:{cmd:has(format *f)}} would select all variables with formats ending in
{cmd:f}, which presumably would be all {cmd:%}{it:#}{cmd:.}{it:#}{cmd:f},
{cmd:%0}{it:#}{cmd:.}{it:#}{cmd:f}, and {cmd:%-}{it:#}{cmd:.}{it:#}{cmd:f}
formats.  {cmd:has(format *f *fc)} would select all variables with formats
ending in {opt f} or {opt fc}.  {bind:{cmd:not(format %t* %-t*)}} would select
all variables except those with date or time-series formats.

{pmore}
{cmd:has(char)} selects all variables with defined 
characteristics. {cmd:has(char problem)} selects all variables
with a characteristic named {cmd:problem}.

{phang}
The following options are available with {cmd:ds} but are not shown in
the dialog box:

{phang}
{opt insensitive} specifies that the matching of the {it:pattern} in
{opt has()} and {opt not()} be case insensitive.  Note that the case
insensitivity applies only to ASCII characters.

{phang}
{opt indent(#)} specifies the amount the lines are indented.


{marker examples}{...}
{title:Examples}

{p 4 4 2}
List all variables{p_end}
	{cmd:. ds}

{p 4 4 2}
List all string variables and bring up Data Editor containing them{p_end}
	{cmd:. ds, has(type string)}
	{cmd:. edit `r(varlist)'}

{p 4 4 2}
List all {cmd:str1}, {cmd:str2}, {cmd:str3}, {cmd:str4} variables{p_end}
	{cmd:. ds, has(type 1/4)}

{p 4 4 2}
List all numeric variables and relocate them to the beginning of the dataset
{p_end}
	{cmd:. ds, has(type numeric)}
	{cmd:. order `r(varlist)'}

{p 4 4 2}
List all numeric variables and summarize them{p_end}
	{cmd:. ds, has(type numeric)}
	{cmd:. summarize `r(varlist)'}

{p 4 4 2}
List all {cmd:byte} or {cmd:int} variables{p_end}
	{cmd:. ds, has(type byte int)}

{p 4 4 2}
List all {cmd:float} variables{p_end}
	{cmd:. ds, has(type float)}

{p 4 4 2}
List all variables that are not {cmd:float}{p_end}
	{cmd:. ds, not(type float)}

{p 4 4 2}
List all variables with value labels attached{p_end}
	{cmd:. ds, has(vall)}

{p 4 4 2}
List all variables with the value label {cmd:origin} attached{p_end}
	{cmd:. ds, has(vall origin)}

{p 4 4 2}
List all date variables, that is, those with formats {cmd:%t*}
or {cmd:%-t*}{p_end}
	{cmd:. ds, has(format %t* %-t*)}

{p 4 4 2}
List variables with left-justified string formats{p_end}
	{cmd:. ds, has(format %-*s)}

{p 4 4 2}
List variables with comma formats{p_end}
	{cmd:. ds, has(format *c)}

{p 4 4 2}
List variables with characteristics defined{p_end}
	{cmd:. ds, has(char)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ds} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}the varlist of found variables{p_end}
{p2colreset}{...}
