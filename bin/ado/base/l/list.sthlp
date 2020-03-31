{smcl}
{* *! version 1.1.15  17may2019}{...}
{viewerdialog list "dialog list"}{...}
{vieweralsosee "[D] list" "mansection D list"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] display" "help display"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[P] tabdisp" "help tabdisp"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{viewerjumpto "Syntax" "list##syntax"}{...}
{viewerjumpto "Menu" "list##menu"}{...}
{viewerjumpto "Description" "list##description"}{...}
{viewerjumpto "Links to PDF documentation" "list##linkspdf"}{...}
{viewerjumpto "Options" "list##options"}{...}
{viewerjumpto "Remarks" "list##remarks"}{...}
{viewerjumpto "Examples" "list##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] list} {hline 2}}List values of variables{p_end}
{p2col:}({mansection D list:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{opt l:ist} [{it:{help varlist}}] {ifin} [{cmd:,} {it:options}]

{p 8 14 2}
{opt fl:ist} is equivalent to {cmd:list} with the {opt fast} option.

{synoptset 21 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt c:ompress}}compress width of columns in both table and display
formats{p_end}
{synopt :{opt noc:ompress}}use display format of each variable{p_end}
{synopt :{opt fast}}synonym for {opt nocompress}; no delay in output of large
datasets{p_end}
{synopt :{opt ab:breviate(#)}}abbreviate variable names to {it:#} 
{help u_glossary##disambig:display columns};
default is {cmd:ab(8)}{p_end}
{synopt :{opt str:ing(#)}}truncate string variables to {it:#} 
{help u_glossary##disambig:display columns}{p_end}
{synopt :{opt noo:bs}}do not list observation numbers{p_end}
{synopt :{opt fvall}}display all levels of factor variables{p_end}

{syntab :Options}
{synopt :{opt t:able}}force table format{p_end}
{synopt :{opt d:isplay}}force display format{p_end}
{synopt :{opt h:eader}}display variable header once; default is table
mode{p_end}
{synopt :{opt noh:eader}}suppress variable header{p_end}
{synopt :{opt h:eader(#)}}display variable header every {it:#} lines{p_end}
{synopt :{opt clean}}force table format with no divider or separator
lines{p_end}
{synopt :{opt div:ider}}draw divider lines between columns{p_end}
{synopt :{opt sep:arator(#)}}draw a separator line every {it:#} lines; default is 
{cmd:separator(5)}{p_end}
{synopt :{opth sepby:(varlist:varlist2)}}draw a separator line whenever
           {it:varlist2} values change{p_end}
{synopt :{opt nol:abel}}display numeric codes rather than label values{p_end}

{syntab :Summary}
{synopt :{opt mean}[{cmd:(}{it:{help varlist:varlist2}}{cmd:)}]}add line
    reporting the mean for the (specified) variables{p_end}
{synopt :{opt sum}[{cmd:(}{it:{help varlist:varlist2}}{cmd:)}]}add line
           reporting the sum for the (specified) variables{p_end}
{synopt :{opt N}[{cmd:(}{it:{help varlist:varlist2}}{cmd:)}]}add line reporting
            the number of nonmissing values for the (specified) variables{p_end}
{synopt :{opth labv:ar(varname)}}substitute {opt Mean}, {opt Sum}, or 
{opt N} for value of {it:varname} in last row of table{p_end}

{syntab :Advanced}
{synopt :{opt con:stant}[{cmd:(}{it:{help varlist:varlist2}}{cmd:)}]}separate
             and list variables that are constant only once{p_end}
{synopt :{opt notr:im}}suppress string trimming{p_end}
{synopt :{opt abs:olute}}display overall observation numbers when using
   {help by:{bf:by} {it:varlist}{bf::}}{p_end}
{synopt :{opt nodotz}}display numerical values equal to {cmd:.z} as field of
blanks{p_end}
{synopt :{opt subvar:name}}substitute characteristic for variable name in
header{p_end}
{synopt :{opt line:size(#)}}columns per line; default is
{cmd:linesize(79)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}{it:varlist} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{opt by} is allowed with {cmd:list}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Describe data > List data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:list} displays the values of variables.  If no {varlist} is specified,
the values of all the variables are displayed.  Also see {cmd:browse} in
{manhelp edit D}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D listQuickstart:Quick start}

        {mansection D listRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt compress} and {opt nocompress} change the width of the columns in both
table and display formats.  By default, {cmd:list} examines the data and
allocates the needed width to each variable.  For instance, a variable might
be a string with a %18s format, and yet the longest string will be only 12
characters long.  Or a numeric variable might have a %9.0g format, and yet,
given the values actually present, the widest number needs only four columns.

{pmore}
{opt nocompress} prevents {cmd:list} from examining the data.  Widths will be
set according to the {help format:display format} of each variable.  Output
generally looks better when {opt nocompress} is not specified, but for very
large datasets (say 1,000,000 observations or more), {opt nocompress} can
speed up the execution of {cmd:list}.

{pmore}
{opt compress} allows {cmd:list} to engage in a little more compression than
it otherwise would by telling {cmd:list} to abbreviate variable names to fewer
than eight characters.

{phang}
{opt fast} is a synonym for {opt nocompress}.  {opt fast} may be of interest
to those with very large datasets who wish to see output appear without delay.

{phang}
{opt abbreviate(#)} is an alternative to {opt compress} that allows you to
specify the minimum abbreviation of variable names to be considered.
For example, you could specify {cmd:abbreviate(16)}  if you never wanted
variables abbreviated to less than 16
{help u_glossary##disambig:display columns}.
For most users, the number of display columns is equal to the number of
characters.  However, some languages, such as Chinese, Japanese, and Korean
(CJK), require two display columns per character.

{phang}
{opt string(#)} specifies that when string variables are listed, they be
truncated to {it:#}
{help u_glossary##disambig:display columns} in the
output.  Any value that is truncated will be appended with "{cmd:..}" to
indicate the truncation.  {opt string()} is useful for displaying just a part
of long strings. 

{phang}
{opt noobs} suppresses the listing of the observation numbers.

{phang}
{opt fvall} specifies that the entire dataset be used to determine how many
levels are in any factor variables specified in {varlist}.
The default is to determine the number of levels by using only the observations
in the {cmd:if} and {cmd:in} qualifiers.

{dlgtab:Options}

{phang}
{opt table} and {opt display} determines the style of output.  By default,
{cmd:list} determines whether to use {opt table} or {opt display} on the basis
of the width of your screen and the {opt linesize()} option, if you specify
it.

{pmore}
{opt table} forces table format.  Forcing table format when {cmd:list} would
have chosen otherwise generally produces impossible-to-read output because of
the linewraps.  However, if you are {help log:logging output} in SMCL format
and plan to print the output on wide paper later, specifying {opt table} can
be a reasonable thing to do.

{pmore}
{opt display} forces display format.

{phang}
{opt header}, {opt noheader}, and {opt header(#)} specify how the variable
header is to be displayed.

{pmore}
{opt header} is the default in table mode and displays the variable header
once, at the top of the table.  

{pmore}
{opt noheader} suppresses the header altogether.

{pmore}
{opt header(#)} redisplays the variable header every {it:#} observations.  For
example, {cmd:header(10)} would display a new header every 10 observations.

{pmore}
The default in display mode is to display the variable names interweaved with
the data:

	     {txt}{c TLC}{hline 13}{c TT}{hline 7}{c TT}{hline 5}{c TT}{hline 8}{c TT}{hline 11}{c TT}{hline 8}{c TRC}
	  1. {c |} make        {c |} price {c |} mpg {c |} rep78  {c |} headroom  {c |} trunk  {c |}
	     {c |} {res}AMC Concord {txt}{c |} {res}4,099 {txt}{c |} {res} 22 {txt}{c |} {res}    3  {txt}{c |} {res}     2.5  {txt}{c |} {res}   11  {txt}{c |}
	     {c LT}{hline 8}{c TT}{hline 4}{c BT}{hline 3}{c TT}{hline 3}{c BT}{hline 2}{c TT}{hline 2}{c BT}{hline 7}{c TT}{c BT}{hline 9}{c TT}{hline 1}{c BT}{hline 8}{c RT}
	     {c |} weight {c |} length {c |} turn {c |} displa~t {c |} gear_r~o {c |}  foreign {c |}
	     {c |} {res} 2,930 {txt}{c |} {res}   186 {txt}{c |} {res}  40 {txt}{c |} {res}     121 {txt}{c |} {res}    3.58 {txt}{c |} {res}Domestic {txt}{c |}
	     {c BLC}{hline 8}{c BT}{hline 8}{c BT}{hline 6}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BRC}

{pmore}
However, if you specify {opt header}, the header is displayed once, at the top
of the table:

	     {txt}{c TLC}{hline 13}{c TT}{hline 7}{c TT}{hline 5}{c TT}{hline 8}{c TT}{hline 11}{c TT}{hline 8}{c TRC}
	     {c |} make        {c |} price {c |} mpg {c |} rep78  {c |} headroom  {c |} trunk  {c |}
	     {c LT}{hline 8}{c TT}{hline 4}{c BT}{hline 3}{c TT}{hline 3}{c BT}{hline 2}{c TT}{hline 2}{c BT}{hline 7}{c TT}{c BT}{hline 9}{c TT}{hline 1}{c BT}{hline 8}{c RT}
	     {c |} weight {c |} length {c |} turn {c |} displa~t {c |} gear_r~o {c |}  foreign {c |}
	     {c BLC}{hline 8}{c BT}{hline 8}{c BT}{hline 6}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BRC}

	     {c TLC}{hline 13}{c TT}{hline 7}{c TT}{hline 5}{c TT}{hline 8}{c TT}{hline 11}{c TT}{hline 8}{c TRC}
	  1. {c |} {res}AMC Concord {txt}{c |} {res}4,099 {txt}{c |} {res} 22 {txt}{c |} {res}    3  {txt}{c |} {res}     2.5  {txt}{c |} {res}   11  {txt}{c |}
	     {c LT}{hline 8}{c TT}{hline 4}{c BT}{hline 3}{c TT}{hline 3}{c BT}{hline 2}{c TT}{hline 2}{c BT}{hline 7}{c TT}{c BT}{hline 9}{c TT}{hline 1}{c BT}{hline 8}{c RT}
	     {c |} {res} 2,930 {txt}{c |} {res}   186 {txt}{c |} {res}  40 {txt}{c |} {res}     121 {txt}{c |} {res}    3.58 {txt}{c |} {res}Domestic {txt}{c |}
	     {c BLC}{hline 8}{c BT}{hline 8}{c BT}{hline 6}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BRC}

{phang}
{opt clean} is a better alternative to {opt table} when you want to force
table format and your goal is to produce more readable output on the screen.
{opt clean} implies {opt table}, and it removes all dividing and separating
lines, which is what makes wrapped table output nearly impossible to read.

{phang}
{opt divider}, {opt separator(#)}, and {opth sepby:(varlist:varlist2)} specify
how dividers and separator lines should be displayed.  These three options
affect only table format.

{pmore}
{opt divider} specifies that divider lines be drawn between columns.  The
default is {opt nodivider}.

{pmore}
{opt separator(#)} and {opt sepby(varlist2)} indicate when separator lines
should be drawn between rows.

{pmore}
{opt separator(#)} specifies how often separator lines should be drawn between
rows.  The default is {cmd:separator(5)}, meaning every 5 observations.  You
may specify {cmd:separator(0)} to suppress separators altogether.

{pmore}
{opt sepby(varlist2)} specifies that a separator line be drawn whenever any of
the variables in {opt sepby(varlist2)} change their values; up to 10 variables
may be specified.  You need not make sure the data were sorted on 
{opt sepby(varlist2)} before issuing the {cmd:list} command.  The variables in 
{opt sepby(varlist2)} also need not be among the variables being listed.

{phang}
{opt nolabel} specifies that the numeric codes be displayed rather than label
values.

{dlgtab:Summary}

{phang}
{opt mean}, {opt sum}, {opt N}, {opth mean:(varlist:varlist2)},
{opt sum(varlist2)}, and {opt N(varlist2)} all specify
that lines be added to the output reporting the
mean, sum, or number of nonmissing values for the (specified) variables.  If
you do not specify the variables, all numeric variables in the {it:varlist}
following {cmd:list} are used.

{phang}
{opth labvar(varname)} is for use with {opt mean}[{cmd:()}],
{opt sum}[{cmd:()}], and {opt N}[{cmd:()}].  {cmd:list} displays {opt Mean},
{opt Sum}, or {opt N} where the observation number would usually appear to
indicate the end of the table--where a row represents the calculated mean,
sum, or number of observations.

{pmore}
{opt labvar(varname)} changes that.  Instead, {opt Mean}, {opt Sum}, or 
{opt N} is displayed where the value for {it:varname} would be displayed.  For
instance, you might type

  	    {cmd}. list group costs profits, sum(costs profits) labvar(group)
	{txt}
	         {c TLC}{hline 7}{c -}{hline 7}{c -}{hline 9}{c TRC}
	         {c |} {res}group   costs   profits {txt}{c |}
    	         {c LT}{hline 7}{c -}{hline 7}{c -}{hline 9}{c RT}
	      1. {c |} {res}    1      47         5 {txt}{c |}
	      2. {c |} {res}    2     123        10 {txt}{c |}
	      3. {c |} {res}    3      22         2 {txt}{c |}
	         {c LT}{hline 7}{c -}{hline 7}{c -}{hline 9}{c RT}
	         {c |}   Sum   {res}  192        17 {txt}{c |}
	         {c BLC}{hline 7}{c -}{hline 7}{c -}{hline 9}{c BRC}

{pmore}
and then also specify the {opt noobs} option to suppress the observation
numbers. 

{dlgtab:Advanced}

{phang}
{opt constant} and {opth constant:(varlist:varlist2)} specify that variables
that do not vary observation by observation be separated out and listed only
once.

{pmore}
{opt constant} specifies that {cmd:list} determine for itself which
variables are constant.

{pmore}
{opt constant(varlist2)} allows you to specify which of the constant variables
you want listed separately.  {cmd:list} verifies that the variables you
specify really are constant and issues an error message if they are not.

{pmore}
{opt constant} and {opt constant()} respect {help if:{bf:if} {it:exp}} and
{help in:{bf:in} {it:range}}.  If you type

{pmore2}
{cmd:. list if group==3}

{pmore}
variable {opt x} might be constant in the selected observations, even though
the variable varies in the entire dataset.

{phang}
{opt notrim} affects how string variables are listed.  The default is to trim
strings at the width implied by the widest possible column given your screen
width (or {opt linesize()}, if you specified that).  {opt notrim} specifies
that strings not be trimmed.  {opt notrim} implies {opt clean} (see above)
and, in fact, is equivalent to the {opt clean} option, so specifying
either makes no difference.

{phang}
{opt absolute} affects output only when {cmd:list} is prefixed with
{help by:{bf:by} {it:varlist}{bf::}}.  Observation numbers are displayed, but
the overall observation numbers are used rather than the observation numbers
within each by-group.  For example, if the first group had 4 observations and
the second had 2, by default the observations would be numbered 1, 2, 3, 4 and
1, 2.  If {opt absolute} is specified, the observations will be numbered 1, 2,
3, 4 and 5, 6.

{phang}
{opt nodotz} is a programmer's option that specifies that numerical values
equal to {cmd:.z} be listed as a field of blanks rather than {cmd:.z}.

{phang}
{opt subvarname} is a programmer's option.  If a variable has the 
characteristic {it:var}{cmd:[varname]} set, then the contents of
that characteristic will be used in place of the variable's name in the
headers.

{phang}{marker linesize()}
{opt linesize(#)} specifies the width of the page to be used for determining
whether table or display format should be used and for formatting the
resulting table.  Specifying a value of {opt linesize()} that is wider than
your screen width can produce truly ugly output on the screen, but that output
can nevertheless be useful if you are logging output and plan to print the log
later on a wide printer.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:list}, typed by itself, lists all the observations and variables
in the dataset. If you specify {it:varlist}, only those variables are listed.
Specifying one or both of {help in:{bf:in} {it:range}} and
{help if:{bf:if} {it:exp}} limits the observations listed.

{pstd}
{cmd:list} respects line size.  That is, if you resize the Results window (in
windowed versions of Stata) before running {cmd:list}, it will take advantage
of the available horizontal space.  Stata for Unix(console) users can instead
use the {helpb linesize:set linesize} command to take advantage of this
feature.

{pstd}
{cmd:list} may not display all the large strings.  You have 2 choices: 
1) you can specify the {cmd:clean} option, which makes a different, less
attractive listing, or 2) you can increase line size, as discussed
{help list##linesize():above}.

{pstd}
{cmd:list} has two output formats, known as table and display.  The table
format is suitable for listing a few variables, whereas the display
format is suitable for listing an unlimited number of variables.  Stata
chooses automatically between those two formats, or you may specify the
{opt table} or {opt display} options.  The table format looks
like this:

	{cmd}. list make-rep78 in 1/4, table
	{txt}
	     {c TLC}{hline 15}{c -}{hline 7}{c -}{hline 5}{c -}{hline 7}{c TRC}
	     {c |} {res}make            price   mpg   rep78 {txt}{c |}
	     {c LT}{hline 15}{c -}{hline 7}{c -}{hline 5}{c -}{hline 7}{c RT}
	  1. {c |} {res}AMC Concord     4,099    22       3 {txt}{c |}
	  2. {c |} {res}AMC Pacer       4,749    17       3 {txt}{c |}
	  3. {c |} {res}AMC Spirit      3,799    22       . {txt}{c |}
	  4. {c |} {res}Buick Century   4,816    20       3 {txt}{c |}
	     {c BLC}{hline 15}{c -}{hline 7}{c -}{hline 5}{c -}{hline 7}{c BRC}

{pstd}
The display format looks like this:

	{cmd}. list in 1/2, display

	     {txt}{c TLC}{hline 13}{c TT}{hline 7}{c TT}{hline 5}{c TT}{hline 8}{c TT}{hline 11}{c TT}{hline 8}{c TRC}
	  1. {c |} make        {c |} price {c |} mpg {c |} rep78  {c |} headroom  {c |} trunk  {c |}
	     {c |} {res}AMC Concord {txt}{c |} {res}4,099 {txt}{c |} {res} 22 {txt}{c |} {res}    3  {txt}{c |} {res}     2.5  {txt}{c |} {res}   11  {txt}{c |}
	     {c LT}{hline 8}{c TT}{hline 4}{c BT}{hline 3}{c TT}{hline 3}{c BT}{hline 2}{c TT}{hline 2}{c BT}{hline 7}{c TT}{c BT}{hline 9}{c TT}{hline 1}{c BT}{hline 8}{c RT}
	     {c |} weight {c |} length {c |} turn {c |} displa~t {c |} gear_r~o {c |}  foreign {c |}
	     {c |} {res} 2,930 {txt}{c |} {res}   186 {txt}{c |} {res}  40 {txt}{c |} {res}     121 {txt}{c |} {res}    3.58 {txt}{c |} {res}Domestic {txt}{c |}
	     {c BLC}{hline 8}{c BT}{hline 8}{c BT}{hline 6}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BRC}

	     {c TLC}{hline 13}{c TT}{hline 7}{c TT}{hline 5}{c TT}{hline 8}{c TT}{hline 11}{c TT}{hline 8}{c TRC}
	  2. {c |} make        {c |} price {c |} mpg {c |} rep78  {c |} headroom  {c |} trunk  {c |}
	     {c |} {res}AMC Pacer   {txt}{c |} {res}4,749 {txt}{c |} {res} 17 {txt}{c |} {res}    3  {txt}{c |} {res}     3.0  {txt}{c |} {res}   11  {txt}{c |}
	     {c LT}{hline 8}{c TT}{hline 4}{c BT}{hline 3}{c TT}{hline 3}{c BT}{hline 2}{c TT}{hline 2}{c BT}{hline 7}{c TT}{c BT}{hline 9}{c TT}{hline 1}{c BT}{hline 8}{c RT}
	     {c |} weight {c |} length {c |} turn {c |} displa~t {c |} gear_r~o {c |}  foreign {c |}
	     {c |} {res} 3,350 {txt}{c |} {res}   173 {txt}{c |} {res}  40 {txt}{c |} {res}     258 {txt}{c |} {res}    2.53 {txt}{c |} {res}Domestic {txt}{c |}
	     {c BLC}{hline 8}{c BT}{hline 8}{c BT}{hline 6}{c BT}{hline 10}{c BT}{hline 10}{c BT}{hline 10}{c BRC}


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. list}{p_end}
{phang}{cmd:. list in 1/10}{p_end}
{phang}{cmd:. list mpg weight}{p_end}
{phang}{cmd:. list mpg weight in 1/20}{p_end}
{phang}{cmd:. list if mpg>20}{p_end}
{phang}{cmd:. list mpg weight if mpg>20}{p_end}
{phang}{cmd:. list mpg weight if mpg>20 in 1/10}

{phang}{cmd:. by rep78, sort: list, constant}{p_end}
