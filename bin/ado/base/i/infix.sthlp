{smcl}
{* *! version 1.1.20  22mar2018}{...}
{viewerdialog infix "dialog infix"}{...}
{vieweralsosee "[D] infix (fixed format)" "mansection D infix(fixedformat)"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] infile (fixed format)" "help infile2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "infix##syntax"}{...}
{viewerjumpto "Menu" "infix##menu"}{...}
{viewerjumpto "Description" "infix##description"}{...}
{viewerjumpto "Links to PDF documentation" "infix##linkspdf"}{...}
{viewerjumpto "Options" "infix##options"}{...}
{viewerjumpto "Specifications" "infix##specifications"}{...}
{viewerjumpto "Examples" "infix##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[D] infix (fixed format)} {hline 2}}Import text data in
fixed format{p_end}
{p2col:}({mansection D infix(fixedformat):View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:infix}
{cmd:using}
{it:dfilename}
{ifin}
[{cmd:,} {opth using:(filename:filename2)} {opt clear}]

{p 8 14 2}
{cmd:infix}
{it:specifications}
{cmd:using}
{it:{help filename}}
{ifin}
[{cmd:,} {opt clear}]

{phang}
If {it:dfilename} is specified without an extension, {opt .dct} is assumed.
If {it:dfilename} contains embedded spaces, remember to enclose it in
double quotes.  {it:dfilename}, if it exists, contains

	{hline 21} begin dictionary file {hline 3}
	{opt infix dictionary} [{opt using} {it:filename}] {cmd:{c -(}}
		{opt * comments preceded by}
		{opt * asterisk may appear freely}
		{it:specifications}
	{cmd:{c )-}}
	{it:(your data might appear here)}
	{hline 23} end dictionary file {hline 3}

{phang}
If {it:{help filename}} is specified without an extension, {opt .raw} is
assumed.  If {it:filename} contains embedded spaces, remember to enclose it in
double quotes.

{pstd}
{it:specifications} is

{p 8 14 2}{it:#} {opt first:lineoffile}{p_end}
{p 8 14 2}{it:#} {opt lines}{p_end}
{p 8 14 2}{it:#}{cmd::}{p_end}
{p 8 14 2}{cmd:/}{p_end}
{p 8 14 2}[{opt byte}|{opt int}|{opt float}|{opt long}|{opt double}|{opt str}]
{it:varlist} [{it:#}{cmd::}]{it:#}[{cmd:-}{it:#}]{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > Text data in fixed format}


{marker description}{...}
{title:Description}

{pstd}
{opt infix} reads into memory from a disk dataset that is not in Stata format.
{opt infix} requires that the data be in fixed-column format. Note that
the column is byte based.  The number of columns means the number of bytes in
the file.  The text file {it:filename} is treated as a stream of bytes, no
{mansection U 12.4.2.3Encodings:encoding} is assumed.
If string data are encoded as ASCII or UTF-8, they will be imported correctly.

{pstd}
In the first syntax, if {cmd:using} {it:filename2} is not specified on the
command line and {cmd:using} {it:filename} is not specified in the dictionary,
the data are assumed to begin on the line following the closing brace.
{opt infix} reads the data in a two-step process.  You first create a disk
file describing how the data are recorded.  You tell {opt infix} to read that
file -- called a dictionary -- and from there, {opt infix} reads the data.
The data can be in the same file as the dictionary or in a different file.

{pstd}
In its second syntax, you tell {opt infix}  how to read the data right on the
command line with no intermediate file.

{pstd}
{opt infile} and {opt import delimited} are alternatives to {opt infix}.
{opt infile}
can also read data in fixed format -- see {help infile2} -- and it
can read data in free format -- see {help infile1}.  Most people think
that {opt infix} is easier to use for reading fixed-format data, but
{opt infile} has more features.  If your data are not fixed format, you can use
{opt import delimited}; see {manhelp import_delimited D:import delimited}.  
{opt import delimited} allows you to specify the source file's encoding and
then performs a conversion to UTF-8 encoding during import. If you are not
certain that {opt infix} will do what you are looking for, see
{manhelp import D} and {findalias frdatain}.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D infix(fixedformat)Quickstart:Quick start}

        {mansection D infix(fixedformat)Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth using:(filename:filename2)} specifies the name of a file
containing the data.  If {opt using()} is not specified, the data are assumed
to follow the dictionary in {it:dfilename}, or if the dictionary specifies the
name of some other file, that file is assumed to contain the data.  If
{opt using(filename2)} is specified, {it:filename2} is used to
obtain the data, even if the dictionary says otherwise.
If {it:filename2} is specified without an extension, {opt .raw} is assumed.
If {it:filename2} contains embedded spaces, remember to enclose it in double
quotes.

{phang}{opt clear} specifies that it is okay for the new data to replace what
is currently in memory.  To ensure that you do not lose something important, 
{opt infix} will refuse to read new data if data are already in memory.
{opt clear} allows {opt infix} to replace the data in memory.  You can also
drop the data yourself by typing {cmd:drop _all} before reading new data.


{marker specifications}{...}
{title:Specifications}

{phang}
{cmd:#} {cmd:firstlineoffile} (abbreviation {cmd:first}) is rarely
    specified.  It states the line of the file at which the data begin.
    You need not specify {cmd:first} when the data follow the dictionary; 
    {cmd:infix} can figure that out for itself.  You can specify {cmd:first} 
    when only the data appear in a file and the first few lines of
    that file contain headers or other markers.

{pmore} 
    {cmd:first} appears only once in the specifications.

{phang} 
{it:#} {cmd:lines} states the number of lines per observation in the file.
    Simple datasets typically have "{cmd:1} {cmd:lines}".  Large datasets
    often have many lines (sometimes called records) per observation.
    {cmd:lines} is optional, even when there is more than one line per
    observation, because {cmd:infix} can sometimes figure it out for itself.
    Still, if {cmd:1} {cmd:lines} is not right for your data, it is best to
    specify the appropriate number of lines.

{pmore}
    {cmd:lines} appears only once in the specifications.

{phang} 
{it:#}{cmd::} tells {cmd:infix} to jump to line {it:#} of the
    observation.  Consider a file with {cmd:4} {cmd:lines}, meaning four lines
    per observation.  {cmd:2:} says to jump to the second line of the
    observation.  {cmd:4:} says to jump to the fourth line of the observation.
    You may jump forward or backward: {cmd:infix} does not care, and there is
    no inefficiency in going forward to {cmd:3:}, reading a few variables,
    jumping back to {cmd:1:}, reading another variable, and jumping back again
    to {cmd:3:}.

{pmore}
    You need not ensure that, at the end of your specification, you are on the
    last line of the observation.  {cmd:infix} knows how to get to the next
    observation because it knows where you are and it knows {cmd:lines}, the
    total number of lines per observation.

{pmore}
    {it:#}{cmd::} may appear many times in the specifications.

{phang}
{cmd:/} is an alternative to {it:#}{cmd::}.  {cmd:/} goes forward one line.
    {cmd://} goes forward two lines.  We do not recommend using {cmd:/}
    because {it:#}{cmd::} is better.  If you are currently on line 2 of
    an observation and want to get to line 6, you could type {cmd:////}, but
    your meaning is clearer if you type {cmd:6:}.

{pmore}
    {cmd:/} may appear many times in the specifications.

{phang}
[ {cmd:byte} | {cmd:int} | {cmd:float} | {cmd:long} | {cmd:double} | {cmd:str} ]
{varlist} 
[{it:#}{cmd::}]{it:#}[{cmd:-}{it:#}]
instructs {cmd:infix} to read a variable or, sometimes, more than one.  

{pmore}
    The simplest form of this is {varname} {it:#}, such as {cmd:sex}
    {cmd:20}.  That says that variable {it:varname} be read from column
    {it:#} of the current line; that variable {cmd:sex} be read from
    column 20; and that here, sex is a one-digit number.

{pmore}
    {it:varname} {it:#}{cmd:-}{it:#}, such as {cmd:age} {cmd:21-23}, 
    says that {it:varname} be read from the column range specified; that
    {cmd:age} be read from columns 21 through 23; and that here, age is a
    three-digit number.

{pmore} 
    You can prefix the variable with a storage type.  {cmd:str} {cmd:name}
    {cmd:25-44} means to read the string variable {cmd:name} from columns 25
    through 44.  Note that the string variable {cmd:name} consists of 
    44-25+1 = 20 bytes.  If you do not specify {cmd:str}, the variable is
    assumed to be numeric.  You can specify the numeric subtype if you wish.
    If you specify {cmd:str}, {cmd:infix} will automatically assign the
    appropriate string variable type, {cmd:str}{it:#} or {cmd:strL}.  Imported
    strings may be up to 100,000 bytes.

{pmore} 
    You can specify more than one variable, with or without a type.
    {cmd:byte} {cmd:q1-q5} {cmd:51-55} means read variables 
    {cmd:q1}, {cmd:q2}, {cmd:q3}, {cmd:q4}, and {cmd:q5} from columns 
    51 through 55 and store the five variables as {cmd:byte}s.

{pmore}
    Finally, you can specify the line on which the variable(s) appear.
    {cmd:age} {cmd:2:21-23} says that age is to be obtained from the 
    second line, columns 21 through 23.  Another way to do this 
    is to put together the {it:#}{cmd::} directive with the 
    input-variable directive:  
    {cmd:: age 21-23}.
    There is a difference, but not with respect to reading the variable 
    {cmd:age}.  Let's consider two alternatives:

            {cmd:1:  str name 25-44     age 2:21-23   q1-q5 51-55}

            {cmd:1:  str name 25-44  2: age 21-23     q1-q5 51-55}

{pmore}
    The difference is that the first directive says that variables {cmd:q1}
    through {cmd:q5} are on line 1, whereas the second says that they are on 
    line 2.  

{pmore} 
    When the colon is put in front, it indicates the line on which variables
    are to be found when we do not explicitly say otherwise.  When the colon
    is put inside, it applies only to the variable under consideration.


{marker examples}{...}
{title:Examples of first syntax}

{phang2}{cmd:. infix rate 1-4 speed 6-7 acc 9-11 using highway.raw}{p_end}
{phang2}{cmd:. infix rate 1-4 speed 6-7 acc 9-11 using highway.raw if rate>2}{p_end}
{phang2}{cmd:. infix rate 1-4 speed 6-7 acc 9-11 using highway.raw in 1/100}


{title:Examples of second syntax}

{phang2}{cmd:. infix using highway.dct}{p_end}
{phang2}{cmd:. infix using highway.dct if rate>2}{p_end}
{phang2}{cmd:. infix using highway.dct in 1/100}

{pstd}
where {hi:highway.dct} contains

	{hline 13} begin highway.dct {hline 4}
	{cmd:infix dictionary using highway.raw {c -(}}
		{cmd:rate  1-4}
		{cmd:speed 6-7}
		{cmd:acc 9-11}
	{cmd:{c )-}}
	{hline 13} end highway.dct {hline 6}


{title:Example reading string variables and multiple lines}

{phang2}{cmd:. infix 2 lines 1: id 1-6 str name 7-36 2: age 1-2 sex 4 using emp.raw}{p_end}
    or
{phang2}{cmd:. infix using emp.dct}

{pstd}
where {bf:emp.dct} contains

	{hline 13} begin emp.dct {hline 4}
	{cmd:infix dictionary using emp.raw {c -(}}
		{cmd:2 lines}
		{cmd:1:}
			{cmd:id        1-6}
			{cmd:str name  7-36}
		{cmd:2:}
			{cmd:age       1-2}
			{cmd:sex       4}
	{cmd:{c )-}}
	{hline 13} end emp.dct {hline 6}
