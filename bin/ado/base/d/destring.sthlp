{smcl}
{* *! version 1.1.19  11may2018}{...}
{viewerdialog destring "dialog destring"}{...}
{viewerdialog tostring "dialog tostring"}{...}
{vieweralsosee "[D] destring" "mansection D destring"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{vieweralsosee "[D] encode" "help encode"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[D] split" "help split"}{...}
{vieweralsosee "[FN] String functions" "help string functions"}{...}
{viewerjumpto "Syntax" "destring##syntax"}{...}
{viewerjumpto "Menu" "destring##menu"}{...}
{viewerjumpto "Description" "destring##description"}{...}
{viewerjumpto "Links to PDF documentation" "destring##linkspdf"}{...}
{viewerjumpto "Options for destring" "destring##options_destring"}{...}
{viewerjumpto "Options for tostring" "destring##options_tostring"}{...}
{viewerjumpto "Examples" "destring##examples"}{...}
{viewerjumpto "Video example" "destring##video"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] destring} {hline 2}}Convert string variables to numeric variables and vice versa{p_end}
{p2col:}({mansection D destring:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Convert string variables to numeric variables

{p 8 29 2}
{cmd:destring}
[{varlist}]
{cmd:,}
{c -(}{opth g:enerate(newvarlist)}{c |}{opt replace}{c )-}
[{it:{help destring##destring_options:destring_options}}]


{phang}
Convert numeric variables to string variables

{p 8 27 2}
{cmd:tostring}
{varlist}
{cmd:,}
{c -(}{opth g:enerate(newvarlist)}{c |}{opt replace}{c )-}
[{it:{help destring##tostring_options:tostring_options}}]


{synoptset 32 tabbed}{...}
{marker destring_options}{...}
{synopthdr :destring_options}
{synoptline}
{p2coldent :* {opth g:enerate(newvarlist)}}generate {it:newvar_1}, ..., {it:newvar_k} for each variable in {varlist}{p_end}
{p2coldent :* {opt replace}}replace string variables in {varlist} with numeric variables{p_end}
{synopt :{cmdab:i:gnore("}{it:chars}{cmd:"} [{cmd:,} {help destring##ignoreopts:{it:ignoreopts}}]{cmd:)}}remove specified nonnumeric characters, as characters or as bytes, and illegal Unicode characters{p_end}
{synopt :{opt force}}convert nonnumeric strings to missing values{p_end}
{synopt :{opt float}}generate numeric variables as type {opt float}{p_end}
{synopt :{opt percent}}convert percent variables to fractional form{p_end}
{synopt :{opt dpcomma}}convert variables with commas as decimals to 
period-decimal format{p_end}
{synoptline}
{pstd}* Either {opt generate(newvarlist)} or {opt replace} is required.
{p2colreset}{...}

{synoptset 32 tabbed}{...}
{marker tostring_options}{...}
{synopthdr :tostring_options}
{synoptline}
{p2coldent :* {opth g:enerate(newvarlist)}}generate {it:newvar_1}, ..., {it:newvar_k} for each variable in {varlist}{p_end}
{p2coldent :* {opt replace}}replace numeric variables in {it:varlist} with string variables{p_end}
{synopt :{opt force}}force conversion ignoring information loss{p_end}
{synopt :{opth format(format)}}convert using specified format{p_end}
{synopt :{opt u:sedisplayformat}}convert using display format{p_end}
{synoptline}
{pstd}* Either {opt generate(newvarlist)} or {opt replace} is required.
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:destring}

{phang2}
{bf:Data > Create or change data > Other variable-transformation commands}
      {bf:> Convert variables from string to numeric}

    {title:tostring}

{phang2}
{bf:Data > Create or change data > Other variable-transformation commands}
      {bf:> Convert variables from numeric to string}


{marker description}{...}
{title:Description}

{pstd}
{cmd:destring} converts variables in {varlist} from string to numeric.
If {it:varlist} is not specified, {cmd:destring} will attempt to convert all
variables in the dataset from string to numeric.  Characters listed in 
{opt ignore()} are removed.  Variables in {it:varlist} that are already numeric
will not be changed.  {cmd:destring} treats both empty strings "" and "." as
indicating sysmiss ({cmd:.}) and interprets the strings ".a", ".b", ...,
".z" as the extended missing values {cmd:.a}, {cmd:.b}, ..., {cmd:.z}; see
{manhelp missing U:12.2.1 Missing values}.  {cmd:destring} also ignores any
leading or trailing spaces so that, for example, " " is equivalent to "" and "
. " is equivalent to ".".

{pstd}
{cmd:tostring} converts variables in {it:varlist} from numeric to string.  The
most compact string format possible is used.  Variables in {it:varlist} that
are already string will not be converted.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D destringQuickstart:Quick start}

        {mansection D destringRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_destring}{...}
{title:Options for destring}

{pstd}
Either {opt generate()} or {opt replace} must be specified.  With either
option, if any string variable contains nonnumeric characters not specified
with {opt ignore()}, then no corresponding variable will be generated, nor
will that variable be replaced (unless {opt force} is specified).

{phang}
{opth generate(newvarlist)} specifies that a new variable be created for each
variable in {varlist}.  {it:newvarlist} must contain the same number of new
variable names as there are variables in {it:varlist}.  If {it:varlist} is not
specified, {opt destring} attempts to generate a numeric variable for each
variable in the dataset; {it:newvarlist} must then contain the same number of
new variable names as there are variables in the dataset.  Any variable labels
or characteristics will be copied to the new variables created.

{phang}
{opt replace} specifies that the variables in {varlist} be converted to
numeric variables.  If {it:varlist} is not specified, {cmd:destring} attempts
to convert all variables from string to numeric.  Any variable labels or
characteristics will be retained.

{marker ignoreopts}{...}
{phang}
{cmd:ignore("}{it:chars}{cmd:"} [{cmd:,} {it:ignoreopts}]{cmd:)} specifies
nonnumeric characters be removed.  {it:ignoreopts} may be {cmd:aschars},
{cmd:asbytes}, or {cmd:illegal}.  The default behavior is to remove characters
as characters, which is the same as specifying {cmd:aschars}.
{cmd:asbytes} specifies removal of all bytes included in all characters in the
ignore string, regardless of whether these bytes form complete Unicode
characters.  {cmd:illegal} specifies removal of all illegal Unicode
characters, which is useful for removing high-ASCII characters.  {cmd:illegal}
may not be specified with {cmd:asbytes}.  If any string variable still
contains any nonnumeric or illegal Unicode characters after the ignore string
has been removed, no action will take place for that variable unless
{opt force} is also specified.  Note that to Stata the comma is a nonnumeric
character; see also the {helpb destring##dpcomma:dpcomma} option below.

{phang}
{opt force} specifies that any string values containing nonnumeric
characters, in addition to any specified with {opt ignore()}, be treated as
indicating missing numeric values.

{phang}
{opt float} specifies that any new numeric variables be created initially as
type {opt float}.  The default is type {opt double}; see
{manhelp data_types D:Data types}.
{cmd:destring} attempts automatically to compress each new numeric variable
after creation.

{phang}
{opt percent} removes any percent signs found in the values of a variable, and
all values of that variable are divided by 100 to convert the values to
fractional form.  {opt percent} by itself implies that the percent sign,
"{cmd:%}", is an argument to {opt ignore()}, but the converse is not true.

{marker dpcomma}{...}
{phang}
{opt dpcomma} specifies that variables with commas as decimal values
should be converted to have periods as decimal values.


{marker options_tostring}{...}
{title:Options for tostring}

{pstd}
Either {opt generate()} or {opt replace} must be specified.  If converting any
numeric variable to string would result in loss of information, no variable
will be produced unless {opt force} is specified.  For more details, see
{helpb destring##force:force} below.

{phang}
{opth generate(newvarlist)} specifies that a new variable be created for each
variable in {varlist}.  {it:newvarlist} must contain the same number of new
variable names as there are variables in {it:varlist}.  Any variable labels
or characteristics will be copied to the new variables created.

{phang}
{opt replace} specifies that the variables in {varlist} be converted to
string variables.  Any variable labels or characteristics will be retained.

{marker force}{...}
{phang}
{opt force} specifies that conversions be forced even if they entail loss of
information.  Loss of information means one of two
circumstances:  1) The result of 
{cmd:real(string(}{varname}{cmd:, "}{it:{help format}}{cmd:"))} is not equal to
{it:varname}; that is, the conversion is not reversible without loss of
information; 2) {opt replace} was specified, but a variable has associated
value labels.  In circumstance 1, it is usually best to specify 
{opt usedisplayformat} or {opt format()}.  In circumstance 2, value labels
will be ignored in a forced conversion.  {cmd:decode} (see 
{manhelp encode D}) is the standard way to generate a string variable based on
value labels.

{phang}
{opth format(format)} specifies that a numeric format be used as an argument to
the {opt string()} function, which controls the conversion of the numeric
variable to string.  For example, a format of {opt %7.2f} specifies that
numbers are to be rounded to two decimal places before conversion to string.
See {manhelp string_functions FN:String functions} and {manhelp format D}.
{opt format()} cannot be specified with {opt usedisplayformat}.

{phang}
{opt usedisplayformat} specifies that the current display format be used for
each variable.  For example, this option could be useful when using
U.S. Social Security numbers or daily or other dates with some {cmd:%d}
or {cmd:%t} format assigned.  {opt usedisplayformat} cannot be specified with
{opt format()}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse destring1}{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. list}

{pstd}Generate numeric variables from the string variables{p_end}
{phang2}{cmd:. destring, generate(id2 num2 code2 total2 income2)}

{pstd}Describe the result{p_end}
{phang2}{cmd:. describe}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse destring1, clear}{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. list}

{pstd}Convert string variables to numeric variables, replacing the original
string variables{p_end}
{phang2}{cmd:. destring, replace}

{pstd}Describe the result{p_end}
{phang2}{cmd:. describe}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse destring2, clear}{p_end}
{phang2}{cmd:. describe date}{p_end}
{phang2}{cmd:. list date}

{pstd}Remove the spaces in {cmd:date} and convert it to a numeric variable,
replacing the original string variable{p_end}
{phang2}{cmd:. destring date, ignore(" ") replace}

{pstd}Describe the result{p_end}
{phang2}{cmd:. describe}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tostring, clear}{p_end}
{phang2}{cmd:. describe}{p_end}
{phang2}{cmd:. list}

{pstd}Convert the numeric variables {cmd:year} and {cmd:day} to string
variables, replacing the original string variables{p_end}
{phang2}{cmd:. tostring year day, replace}

{pstd}Describe the result{p_end}
{phang2}{cmd:. describe}

{pstd}List the result{p_end}
{phang2}{cmd:. list}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=Js_i3wI2-jY":How to convert a string variable to a numeric variable}
{p_end}
