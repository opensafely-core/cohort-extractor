{smcl}
{* *! version 2.1.18  15may2018}{...}
{viewerdialog "Variables Manager" "stata varmanage"}{...}
{vieweralsosee "[D] format" "mansection D format"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime business calendars" "help datetime_business calendars"}{...}
{vieweralsosee "[D] Datetime display formats" "help datetime_display_formats"}{...}
{vieweralsosee "[P] display" "help display"}{...}
{vieweralsosee "[D] list" "help list"}{...}
{vieweralsosee "[D] varmanage" "help varmanage"}{...}
{viewerjumpto "Syntax" "format##syntax"}{...}
{viewerjumpto "Menu" "format##menu"}{...}
{viewerjumpto "Description" "format##description"}{...}
{viewerjumpto "Links to PDF documentation" "format##linkspdf"}{...}
{viewerjumpto "Option" "format##option"}{...}
{viewerjumpto "Remarks" "format##remarks"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] format} {hline 2}}Set variables' output format{p_end}
{p2col:}({mansection D format:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Set formats

{p 8 15 2}
{opt form:at} {varlist} {cmd:%}{it:fmt}

{p 8 15 2}
{opt form:at} {cmd:%}{it:fmt} {varlist}


{phang}
Set style of decimal point

{p 8 15 2}
{opt se:t} {opt dp}  {c -(}{opt com:ma}|{opt per:iod}{c )-}
[{cmd:,} {opt perm:anently}]


{phang}
Display long formats

{p 8 15 2}
{opt form:at} [{varlist}]


{p 4 4 2}
where {cmd:%}{it:fmt} can be a numerical, date,
business calendar, or string format.

	    Numerical
	      {cmd:%}{it:fmt}            Description              Example
	{hline 55}
	right-justified
	      {cmd:%}{it:#}{cmd:.}{it:#}{cmd:g}           general                  {cmd:%9.0g}
	      {cmd:%}{it:#}{cmd:.}{it:#}{cmd:f}           fixed                    {cmd:%9.2f}
	      {cmd:%}{it:#}{cmd:.}{it:#}{cmd:e}           exponential              {cmd:%10.7e}
	      {cmd:%21x}            hexadecimal              {cmd:%21x}
	      {cmd:%16H}            binary, hilo             {cmd:%16H}
	      {cmd:%16L}            binary, lohi             {cmd:%16L}
	      {cmd:%8H}             binary, hilo             {cmd:%8H}
	      {cmd:%8L}             binary, lohi             {cmd:%8L}

	right-justified with commas
	      {cmd:%}{it:#}{cmd:.}{it:#}{cmd:gc}          general                  {cmd:%9.0gc}
	      {cmd:%}{it:#}{cmd:.}{it:#}{cmd:fc}          fixed                    {cmd:%9.2fc}

	right-justified with leading zeros
	      {cmd:%0}{it:#}{cmd:.}{it:#}{cmd:f}          fixed                    {cmd:%09.2f}

	left-justified
	      {cmd:%-}{it:#}{cmd:.}{it:#}{cmd:g}          general                  {cmd:%-9.0g}
	      {cmd:%-}{it:#}{cmd:.}{it:#}{cmd:f}          fixed                    {cmd:%-9.2f}
	      {cmd:%-}{it:#}{cmd:.}{it:#}{cmd:e}          exponential              {cmd:%-10.7e}

	left-justified with commas
	      {cmd:%-}{it:#}{cmd:.}{it:#}{cmd:gc}         general                  {cmd:%-9.0gc}
	      {cmd:%-}{it:#}{cmd:.}{it:#}{cmd:fc}         fixed                    {cmd:%-9.2fc}
	{hline 55}
{p 8 8 2}
You may substitute comma ({cmd:,}) for period ({cmd:.}) in any of{break}
the above formats to make comma the decimal point.  In{break}
{cmd:%9,2fc}, 1000.03 is 1.000,03.  Or you can
{cmd:set} {cmd:dp} {cmd:comma}.


	      date
	      %fmt            Description              Example
	{hline 55}
	right-justified
	      {cmd:%tc}             date/time                {cmd:%tc}
	      {cmd:%tC}             date/time                {cmd:%tC}
	      {cmd:%td}             date                     {cmd:%td}
	      {cmd:%tw}             week                     {cmd:%tw}
	      {cmd:%tm}             month                    {cmd:%tm}
	      {cmd:%tq}             quarter                  {cmd:%tq}
	      {cmd:%th}             half-year                {cmd:%th}
	      {cmd:%ty}             year                     {cmd:%ty}
	      {cmd:%tg}             generic                  {cmd:%tg}

	left-justified
	      {cmd:%-tc}            date/time                {cmd:%-tc}
	      {cmd:%-tC}            date/time                {cmd:%-tC}
	      {cmd:%-td}            date                     {cmd:%-td}
	      etc.
	{hline 55}
{p 8 8 2}
There are many variations allowed.  See{break}
{manhelp datetime_display_formats D:Datetime display formats}.


	business calendar
	      %fmt               Description           Example
	{hline 55}
	{cmd:%tb}{it:calname}               a business calendar  {cmd:%tbsimple}
          [{cmd::}{it:datetime-specifiers}]   defined in
                                   {it:calname}{cmd:.stbcal}
	{hline 55}
{p 8 8 2}
See {manhelp datetime_business_calendars D:Datetime business calendars}.


	     string
	      %fmt            Description              Example
	{hline 55}
	right-justified
	      {cmd:%}{it:#}{cmd:s}             string                   {cmd:%15s}

	left-justified
	      {cmd:%-}{it:#}{cmd:s}            string                   {cmd:%-20s}

	centered
	      {cmd:%~}{it:#}{cmd:s}            string                   {cmd:%~12s}
	{hline 55}
{p 8 8 2}
The centered format is for use with {helpb display} only.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Variables Manager}


{marker description}{...}
{title:Description}

{pstd}
{cmd:format} {varlist} {cmd:%}{it:fmt} and {cmd:format} {cmd:%}{it:fmt}
{it:varlist} are the same commands.  They set the display format associated
with the variables specified.  The default formats are a function of the type
of the variable:

			{cmd:byte}{space 4}{cmd:%8.0g}
			{cmd:int}{space 5}{cmd:%8.0g}
			{cmd:long}{space 4}{cmd:%12.0g}
			{cmd:float}{space 3}{cmd:%9.0g}
			{cmd:double}{space 2}{cmd:%10.0g}

			{cmd:str}{it:#}{space 4}{cmd:%}{it:#}{cmd:s}
			{cmd:strL}{space 4}{cmd:%9s}

{pstd}
{opt set dp} sets the symbol that Stata uses to represent the
decimal point.  The default is {cmd:period}, meaning that one and a
half is displayed as 1.5.

{pstd}
{cmd:format} [{it:varlist}] displays the current formats associated with the
variables.  {cmd:format} by itself lists all variables that have formats too
long to be listed in their entirety by {cmd:describe}. {cmd:format}
{it:varlist} lists the formats for the specified variables regardless of their
length. {cmd:format} {cmd:*} lists the formats for all the variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D formatQuickstart:Quick start}

        {mansection D formatRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt permanently} specifies that, in addition to making the change right now,
the {opt dp} setting be remembered and become the default
setting when you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help format##fformat:The %f format}
	{help format##fcformat:The %fc format}
	{help format##gformat:The %g format}
	{help format##gcformat:The %gc format}
	{help format##eformat:The %e format}
	{help format##xformat:The %21x format}
	{help format##16format:The %16H and %16L formats}
	{help format##8format:The %8H and %8L formats}
	{help format##tformat:The %t format}
	{help format##sformat:The %s format}
	{help format##examples:Examples}
	{help format##video:Video example}


{marker fformat}{...}
{title:The %f format}

{pstd}
In {cmd:%}{it:w}{cmd:.}{it:d}{cmd:f}, {it:w} is the total output width, 
including sign and decimal point, and {it:d} is the number of digits 
to appear to the right of the decimal point.  The result is right-justified.

{pstd}
The number 5.139 in {cmd:%12.2f} format displays as

	----+----1--
                5.14
	

{pstd}
When {it:d}==0, the decimal point is not displayed.  The number 5.14 in
{cmd:%12.0f} format displays as

	----+----1--
                   5

{pstd} 
{cmd:%-}{it:w}{cmd:.}{it:d}{cmd:f} works the same way, except that the
output is left-justified in the field.  The number 5.139 in {cmd:%-12.2f}
displays as

	----+----1--
	5.14


{marker fcformat}{...}
{title:The %fc format}

{pstd}
{cmd:%}{it:w}{cmd:.}{it:d}{cmd:fc} works like 
{cmd:%}{it:w}{cmd:.}{it:d}{cmd:f} except that commas are inserted
to make larger numbers more readable.  {it:w} records the total width 
of the result, including commas.

{pstd}
The number 5.139 in {cmd:%12.2fc} format displays as 

	----+----1--
                5.14

{pstd}
The number 5203.139 in {cmd:%12.2fc} format displays as 

	----+----1--
	    5,203.14

{pstd}
As with {cmd:%f}, if {it:d}==0, the decimal point is not displayed.
The number 5203.139 in {cmd:%12.0fc} format displays as

	----+----1--
	       5,203

{pstd}
As with {cmd:%f}, a minus sign may be inserted to left justify the output.
The number 5203.139 in {cmd:%-12.0fc} format displays as 

	----+----1--
	5,203


{marker gformat}{...}
{title:The %g format}

{pstd}
In {cmd:%}{it:w}{cmd:.}{it:d}{cmd:g}, {it:w} is the overall width, and {it:d}
is usually specified as 0, which leaves up to the format the number of digits
to be displayed to the right of the decimal point.  If {it:d}!=0 is specified,
then not more than {it:d} digits will be displayed.
As with {cmd:%f}, a minus sign may be inserted to left-justify results.

{pstd}
{cmd:%g} differs from {cmd:%f} in that (1) it decides how many 
digits to display to the right of the decimal point, and (2) it will 
switch to a {cmd:%e} format if the number is too large or too small.

{pstd}
The number 5.139 in {cmd:%12.0g} format displays as

	----+----1--
	       5.139

{pstd}
The number 5231371222.139 in {cmd:%12.0g} format displays as

	----+----1--
          5231371222

{pstd} 
The number 52313712223.139 displays as

	----+----1--
         5.23137e+10

{pstd}
The number 0.0000029394 displays as 

	----+----1--
         2.93940e-06


{marker gcformat}{...}
{title:The %gc format}

{pstd}
{cmd:%}{it:w}{cmd:.}{it:d}{cmd:gc} is 
{cmd:%}{it:w}{cmd:.}{it:d}{cmd:g}, with commas.
It works in the same way as the {cmd:%g} and {cmd:%fc} formats.


{marker eformat}{...}
{title:The %e format}

{pstd}
{cmd:%}{it:w}{cmd:.}{it:d}{cmd:e} displays numeric values in
exponential format.  {it:w} records the width of the format.  {it:d} records
the number of digits to be shown after the decimal place.  {it:w} should be
greater than or equal to {it:d}+7 or, if 3-digit exponents are expected, 
{it:d}+8.

{pstd}
The number 5.139 in {cmd:%12.4e} format is

	----+----1--
	  5.1390e+00

{pstd}
The number 5.139*10^220 is

	----+----1--
         5.1390e+220


{marker xformat}{...}
{title:The %21x format}

{pstd}
The {cmd:%21x} format is for those, typically programmers, who wish to 
analyze routines for numerical roundoff error.  There is no better way 
to look at numbers than how the computer actually records them.

{pstd}
The number 5.139 in {cmd:%21x} format is 

	----+----1----+----2-
        +1.48e5604189375X+002

{pstd}
The number 5.125 is

	----+----1----+----2-
        +1.4800000000000X+002

{pstd}
Reported is a signed, base-16 number with base-16 point, the letter {cmd:X},
and a signed, 3-digit base-16 integer.  Call the two numbers {it:f} and
{it:e}.  The interpretation is {it:f}*2^{it:e}.


{marker 16format}{...}
{title:The %16H and %16L formats}

{pstd}
The {cmd:%16H} and {cmd:%16L} formats show the value in the IEEE 
floating point, double-precision form.  {cmd:%16H} shows the 
value in most-significant-byte-first (hilo) form.  
{cmd:%16L} shows the number in least-significant-byte-first (lohi) form.

{pstd}
The number 5.139 in {cmd:%16H} is 

	----+----1----+-
        40148e5604189375

{pstd}
The number 5.139 in {cmd:%16L} is 

	----+----1----+-
	75931804568e1440

{pstd}
The format is sometimes used by programmers who are simultaneously 
studying a hexadecimal dump of a binary file.


{marker 8format}{...}
{title:The %8H and %8L formats}

{pstd}
{cmd:%8H} and {cmd:%8L} are similar to {cmd:%16H} and {cmd:%16L} but show the
number in IEEE single-precision form.

{pstd}
The number 5.139 in {cmd:%8H} is 

	----+---
        40a472b0

{pstd}
The number 5.139 in {cmd:%8L} is 

	----+---
	b072a440


{marker tformat}{...}
{title:The %t format}

{pstd}
The {cmd:%t} format displays numerical variables as dates and times.
See 
{manhelp datetime_display_formats D:Datetime display formats}.


{marker sformat}{...}
{title:The %s format}

{pstd}
The {cmd:%}{it:w}{cmd:s} format displays a string in a right-justified field
of width {it:w}.  {cmd:%-}{it:w}{cmd:s} displays the string left-justified.

{pstd}
"Mary Smith" in {cmd:%16s} format is

        ----+----1----+-
	      Mary Smith

{pstd}
"Mary Smith" in {cmd:%-16s} format is

        ----+----1----+-
	Mary Smith

{pstd}
In addition, in some contexts, particularly {cmd:display} (see
{manhelp display P}), 
{cmd:%~}{it:w}{cmd:s} is allowed, which centers the string.
"Mary Smith" in {cmd:%~16s} format is

        ----+----1----+-
	   Mary Smith


{marker examples}{...}
{title:Examples}

    {bf:Four values displayed in different numeric display formats}
    {c TLC}{hline 69}{c TRC}
    {c |}   %9.0g   %9.0gc     %9.2f     %9.2fc %-9.0g       %09.2f     %9.2e {c |}
    {c LT}{hline 69}{c RT}
    {c |}   12345   12,345  12345.00  12,345.00  12345    012345.00  1.23e+04 {c |}
    {c |}  37.916   37.916     37.92      37.92  37.916   000037.92  3.79e+01 {c |}
    {c |} 3567890  3567890  3.57e+06   3.57e+06  3567890   3.57e+06  3.57e+06 {c |}
    {c |}   .9165    .9165      0.92       0.92  .9165    000000.92  9.16e-01 {c |}
    {c BLC}{hline 69}{c BRC}

    {bf:Left-aligned and right-aligned string display formats}
    {c TLC}{hline 31}{c TRC}
    {c |} %-17s                    %17s {c |}
    {c LT}{hline 31}{c RT}
    {c |} AMC Concord       AMC Concord {c |}
    {c |} AMC Pacer           AMC Pacer {c |} 
    {c |} AMC Spirit         AMC Spirit {c |}
    {c |} Buick Century   Buick Century {c |}
    {c |} Buick Opel         Buick Opel {c |}
    {c BLC}{hline 31}{c BRC}


    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse census10}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/8}

{pstd}Left-align the {cmd:state} variable{p_end}
{phang2}{cmd:. format state %-14s}

{pstd}List the result{p_end}
{phang2}{cmd:. list in 1/8}

{pstd}Left-align {cmd:region}, a numeric variable with attached value
label{p_end}
{phang2}{cmd:. format region %-8.0g}

{pstd}List the result{p_end}
{phang2}{cmd:. list in 1/8}

{pstd}Insert commas in the variable {cmd:pop}{p_end}
{phang2}{cmd:. format pop %12.0gc}

{pstd}List the result{p_end}
{phang2}{cmd:. list in 1/8}

{pstd}Vertically align the decimal points in {cmd:medage}{p_end}
{phang2}{cmd:. format medage %8.1f}

{pstd}List the result{p_end}
{phang2}{cmd:. list in 1/8}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fmtxmpl}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list empid in 83/87}

{pstd}Attach leading zeros to {cmd:empid} values{p_end}
{phang2}{cmd:. format empid %05.0f}

{pstd}List the result{p_end}
{phang2}{cmd:. list empid in 83/87}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fmtxmpl2}

{pstd}Display the formats of the three date variables{p_end}
{phang2}{cmd:. format hiredate login logout}

{pstd}Attach a date format to {cmd:login} and {cmd:logout}{p_end}
{phang2}{cmd:. format login logout %tcDDmonCCYY_HH:MM:SS.ss}

{pstd}List the result{p_end}
{phang2}{cmd:. list login logout in 1/5}

{pstd}Attach a date format to the {cmd:hiredate} variable{p_end}
{phang2}{cmd:. format hiredate %td}

{pstd}List the result{p_end}
{phang2}{cmd:. list hiredate in 1/5}

{pstd}Attach a different date format to the {cmd:hiredate} variable{p_end}
{phang2}{cmd:. format hiredate %tdDD/NN/CCYY}

{pstd}List the result{p_end}
{phang2}{cmd:. list hiredate in 1/5}

{pstd}Display the current formats for all variables using
{cmd:describe}{p_end}
{phang2}{cmd:. describe}

{pstd}Display the formats for the variables whose display format is too long
to show in the {cmd:describe} output{p_end}
{phang2}{cmd:. format}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse census10}

{pstd}Attach a European format to the variables {cmd:pop} and
{cmd:medage}{p_end}
{phang2}{cmd:. format pop %12,0gc}{space 5}(note the comma){p_end}
{phang2}{cmd:. format medage %9,2gc}

{pstd}List the result{p_end}
{phang2}{cmd:. list in 1/8}

{pstd}Remove the European format from variables {cmd:pop} and
{cmd:medage}{p_end}
{phang2}{cmd:. format pop %12.0gc}{space 5}
               (back to period for the decimal point){p_end}
{phang2}{cmd:. format medage %9.2gc}

{pstd}Change the setting for the decimal point to comma{p_end}
{phang2}{cmd:. set dp comma}

{pstd}Perform a one-way tabulation{p_end}
{phang2}{cmd:. tabulate region [fw=pop]}

{pstd}Restore period as the setting for the decimal point{p_end}
{phang2}{cmd:. set dp period}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=cF_pJtXWf3Y":How to change the display format of a variable}
{p_end}
