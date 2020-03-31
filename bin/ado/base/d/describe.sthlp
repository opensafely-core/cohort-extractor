{smcl}
{* *! version 1.5.4  05feb2019}{...}
{viewerdialog "describe" "dialog describe"}{...}
{vieweralsosee "[D] describe" "mansection D describe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] ds" "help ds"}{...}
{vieweralsosee "[D] varmanage" "help varmanage"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cf" "help cf"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] compare" "help compare"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{vieweralsosee "[D] format" "help format"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[D] lookfor" "help lookfor"}{...}
{vieweralsosee "[D] notes" "help notes"}{...}
{vieweralsosee "[D] order" "help order"}{...}
{vieweralsosee "[D] rename" "help rename"}{...}
{vieweralsosee "[D] sysdescribe" "help sysdescribe"}{...}
{viewerjumpto "Syntax" "describe##syntax"}{...}
{viewerjumpto "Menu" "describe##menu"}{...}
{viewerjumpto "Description" "describe##description"}{...}
{viewerjumpto "Links to PDF documentation" "describe##linkspdf"}{...}
{viewerjumpto "Options to describe data in memory" "describe##options_memory"}{...}
{viewerjumpto "Options to describe data in file" "describe##options_file"}{...}
{viewerjumpto "Remarks" "describe##remarks"}{...}
{viewerjumpto "Examples" "describe##examples"}{...}
{viewerjumpto "Stored results" "describe##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] describe} {hline 2}}Describe data in memory or in file{p_end}
{p2col:}({mansection D describe:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Describe data in memory

{p 8 17 2}
{cmdab:d:escribe} [{varlist}] [{cmd:,}
 {it:{help describe##memory_options:memory_options}}]


{phang}
Describe data in file

{p 8 17 2}
{cmdab:d:escribe} [{varlist}] {cmd:using} {it:{help filename}}
 [{cmd:,} {it:{help describe##file_options:file_options}}]


{synoptset 20}{...}
{marker memory_options}{...}
{synopthdr :memory_options}
{synoptline}
{synopt :{opt si:mple}}display only variable names{p_end}
{synopt :{opt s:hort}}display only general information{p_end}
{synopt :{opt f:ullnames}}do not abbreviate variable names{p_end}
{synopt :{opt n:umbers}}display variable number along with name{p_end}
{synopt :{opt replace}}make dataset, not written report, of description{p_end}
{synopt :{opt clear}}for use with {cmd:replace}{p_end}

{synopt :{opt varl:ist}}store {cmd:r(varlist)} and {cmd:r(sortlist)} in addition to usual stored results; programmer's option{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:varlist} does not appear in the dialog box.

{synoptset 20}{...}
{marker file_options}{...}
{synopthdr :file_options}
{synoptline}
{synopt :{opt s:hort}}display only general information{p_end}
{synopt :{opt si:mple}}display only variable names{p_end}

{synopt :{opt varl:ist}}store {cmd:r(varlist)} and {cmd:r(sortlist)} in addition to usual stored results; programmer's option{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:varlist} does not appear in the dialog box.


{marker menu}{...}
{title:Menu}

{phang2}
{bf:Data > Describe data > Describe data in memory or in a file}


{marker description}{...}
{title:Description}

{pstd}
{cmd:describe} produces a summary of the dataset in memory or of the data
stored in a Stata-format dataset.

{pstd}
For a compact listing of variable names, use {cmd:describe, simple}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D describeQuickstart:Quick start}

        {mansection D describeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_memory}{...}
{title:Options to describe data in memory}

{phang}
{opt simple} displays only the variable names in a compact format.  
{opt simple} may not be combined with other options.

{phang}
{opt short} suppresses the specific information for each variable.  Only the
general information (number of observations, number of variables, size, and
sort order) is displayed.

{phang}
{opt fullnames} specifies that {cmd:describe} display the full
names of the variables.  The default is to present an abbreviation when the
variable name is longer than 15 characters.  {cmd:describe using} always shows
the full names of the variables, so {opt fullnames} may not be specified with
{cmd:describe using}.

{phang}
{opt numbers} specifies that {cmd:describe} present the variable number with
the variable name.  If {opt numbers} is specified, variable names are
abbreviated when the name is longer than eight characters.  The 
{opt numbers} and {opt fullnames} options may not be specified together.
{opt numbers} may not be specified with {cmd:describe} {cmd:using}.

{phang}
{opt replace} and {opt clear} are alternatives to the options above.
{cmd:describe} usually produces a written report, and the options above 
specify what the report is to contain.  If you specify {opt replace}, 
however, no report is produced; the data in memory are instead
replaced with data containing the information that the report would have
presented.  Each observation of the new data describes a variable 
in the original data; see {it:{help describe##replace:describe, replace}}
below.

{pmore}
{opt clear} may be specified only when {opt replace} is specified.  
{opt clear} specifies that the data in memory be cleared and replaced with
the description information, even if the original data have not been saved to
disk.

{pstd}
The following option is available with {cmd:describe} but is not shown 
in the dialog box:

{phang} 
{opt varlist}, an option for programmers, specifies that, in addition to the
usual stored results, {cmd:r(varlist)} and {cmd:r(sortlist)} be stored, too.
{cmd:r(varlist)} will contain the names of the variables in the dataset.
{cmd:r(sortlist)} will contain the names of the variables by which the data
are sorted.


{marker options_file}{...}
{title:Options to describe data in file}

{phang}
{opt short} suppresses the specific information for each variable.  Only the 
general information (number of observations, number of variables, size, and
sort order) is displayed.

{phang}
{opt simple} displays only the variable names in a compact format.  
{opt simple} may not be combined with other options.

{pstd}
The following option is available with {cmd:describe} but is not shown 
in the dialog box:

{phang} 
{opt varlist}, an option for programmers, specifies that, in addition to the
usual stored results, {cmd:r(varlist)} and {cmd:r(sortlist)} be stored, too.
{cmd:r(varlist)} will contain the names of the variables in the dataset.
{cmd:r(sortlist)} will contain the names of the variables by which the data
are sorted.

{pmore} 
Because {help statamp:Stata/MP} and {help specialedition:Stata/SE} can create
truly large datasets, there might be too many variables
in a dataset for their names to be stored in {cmd:r(varlist)}, given the
current maximum length of macros, as determined by {helpb maxvar:set maxvar}.
Should that occur, {cmd:describe using} will issue the error message
"too many variables", r(103).


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help describe##noreplace:describe}
	{help describe##replace:describe, replace}


{marker noreplace}{...}
{title:describe}

{pstd}
If {cmd:describe} is typed with no operands, the contents of the dataset
currently in memory are described.

{pstd}
The {it:varlist} in the {cmd:describe using} syntax differs from standard
Stata {help varlist:varlists} in two ways.
First, you cannot abbreviate variable 
names; that is, you have to type {cmd:displacement} rather than {cmd:displ}.
However, you can use the wildcard character ({cmd:~}) to indicate
abbreviations, for example, {cmd:displ~}.  Second, you may not refer to a range
of variables; specifying {cmd:age-income} is considered an error.


{marker replace}{...}
{title:describe, replace}

{pstd}
{cmd:describe} with the {cmd:replace} option is rarely used, although 
you may sometimes find it convenient.

{pstd}
Think of {cmd:describe,} {cmd:replace} as separate from but related to 
{cmd:describe} without the {cmd:replace} option.  Rather than producing 
a written report, {cmd:describe,} {cmd:replace} produces a new dataset 
that contains the same information a written report would.  For instance, try
the following:

	. {cmd:sysuse auto, clear}

	. {cmd:describe}
	{it:(report appears; data in memory unchanged)}

	. {cmd:list}
	{it:(visual proof that data are unchanged)}

	. {cmd:describe, replace}
	{it:(no report appears, but the data in memory are changed!)}

	. {cmd:list}
	{it:(visual proof that data are changed)}

{pstd}
{cmd:describe,} {cmd:replace} changes the original data in memory into 
a dataset containing an observation for each variable in the 
original data.  Each observation in the new data describes a variable in 
the original data.  The new variables are

{p 8 12 2}
1.  {cmd:position}, a variable containing the numeric position of the original
    variable (1, 2, 3, ...).

{p 8 12 2}
2.  {cmd:name}, a variable containing the name of the original variable, 
    such as {cmd:"make"}, {cmd:"price"}, {cmd:"mpg"}, ....

{p 8 12 2}
3.  {cmd:type}, a variable containing the storage type of the original 
    variable, such as {cmd:"str18"}, {cmd:"int"}, {cmd:"float"}, ....

{p 8 12 2}
4.  {cmd:isnumeric}, a variable equal to 1 if the original variable was 
    numeric and equal to 0 if it was string. 

{p 8 12 2}
5.  {cmd:format}, a variable containing the display format of the original 
    variable, such as {cmd:"%-18s"}, {cmd:"%8.0gc"}, ....

{p 8 12 2}
6.  {cmd:vallab}, a variable containing the name of the value label 
    associated with the original variable, if any.

{p 8 12 2}
7.  {cmd:varlab}, a variable containing the variable label of the 
    original variable, such as {cmd:"Make and Model"}, 
    {cmd:"Price"}, {cmd:"Mileage (mpg)"}, ....

{pstd}
In addition, the data contain the following characteristics:

{p 12 12 2}
{cmd:_dta[d_filename]}, the name of the file containing the original data.

{p 12 12 2}
{cmd:_dta[d_filedate]}, the date and time the file was written.

{p 12 12 2}
{cmd:_dta[d_N]}, the number of observations in the original data.

{p 12 12 2}
{cmd:_dta[d_sortedby]}, the variables on which the original data were
sorted, if any.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse states}

{pstd}Describe dataset in memory{p_end}
{phang2}{cmd:. describe}

{pstd}Describe dataset in memory, displaying full variable names{p_end}
{phang2}{cmd:. describe, fullnames}

{pstd}Describe dataset in memory, suppressing specific information about each
variable{p_end}
{phang2}{cmd:. describe, short}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse census}

{pstd}Describe all variables whose names begin with {cmd:pop*} for the dataset
in memory{p_end}
{phang2}{cmd:. describe pop*}

{pstd}Describe the variables {cmd:state}, {cmd:region}, and {cmd:pop18p} for
the dataset in memory{p_end}
{phang2}{cmd:. describe state region pop18p}

{pstd}Describe the {cmd:states} dataset located at the
https://www.stata-press.com website{p_end}
{phang2}{cmd:. describe using https://www.stata-press.com/data/r16/states}
{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:describe} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(k)}}number of variables{p_end}
{synopt:{cmd:r(width)}}width of dataset{p_end}
{synopt:{cmd:r(changed)}}flag indicating data have changed since last saved{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(datalabel)}}dataset label{p_end}
{synopt:{cmd:r(varlist)}}variables in dataset (if {cmd:varlist} specified)
{p_end}
{synopt:{cmd:r(sortlist)}}variables by which data are sorted
   (if {cmd:varlist} specified){p_end}
{p2colreset}{...}

{pstd}
{cmd:describe,} {cmd:replace} stores nothing in {cmd:r()}.
{p_end}
