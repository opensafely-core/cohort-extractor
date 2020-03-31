{smcl}
{* *! version 1.3.3  15oct2018}{...}
{viewerdialog append "dialog append"}{...}
{vieweralsosee "[D] append" "mansection D append"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cross" "help cross"}{...}
{vieweralsosee "[D] joinby" "help joinby"}{...}
{vieweralsosee "[D] merge" "help merge"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{vieweralsosee "[D] use" "help use"}{...}
{viewerjumpto "Syntax" "append##syntax"}{...}
{viewerjumpto "Menu" "append##menu"}{...}
{viewerjumpto "Description" "append##description"}{...}
{viewerjumpto "Links to PDF documentation" "append##linkspdf"}{...}
{viewerjumpto "Options" "append##options"}{...}
{viewerjumpto "Examples" "append##examples"}{...}
{viewerjumpto "Video example" "append##video"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] append} {hline 2}}Append datasets{p_end}
{p2col:}({mansection D append:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:ap:pend} {cmd:using} {it:{help filename}}
[{it:{help filename}} {cmd:...}]
[{cmd:,} {it:options}]

{pstd}
You may enclose {it:filename} in double quotes and must do so if
{it:filename} contains blanks or other special characters.

{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt :{opth gen:erate(newvar)}}{it:newvar} marks source of resulting
observations{p_end}
{synopt :{opth keep(varlist)}}keep specified variables from appending
dataset(s){p_end}
{synopt :{opt nol:abel}}do not copy value-label definitions from dataset(s) on
disk{p_end}
{synopt :{opt nonote:s}}do not copy notes from dataset(s) on disk{p_end}
{synopt :{opt force}}append string to numeric or numeric to string without error{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Combine datasets > Append datasets}


{marker description}{...}
{title:Description}

{pstd}
{cmd:append} appends Stata-format datasets stored on disk to the end of the
dataset in memory.  If any {it:{help filename}} is specified without an
extension, {cmd:.dta} is assumed.

{pstd}
Stata can also join observations from two datasets into one; see
{manhelp merge D}.  See {findalias frcombine} for a comparison
of {cmd:append}, {cmd:merge}, and {cmd:joinby}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D appendQuickstart:Quick start}

        {mansection D appendRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth generate(newvar)} specifies the name of a variable to be created that
will mark the source of observations.  Observations from the master dataset
(the data in memory before the {cmd:append} command) will contain {cmd:0}
for this variable.  Observations from the first using dataset will
contain {cmd:1} for this variable; observations from the second using
dataset will contain {cmd:2} for this variable; and so on.

{phang}
{opth keep(varlist)} specifies the variables to be kept from the
using dataset.  If {opt keep()} is not specified, all variables are kept.

{pmore}
The {it:varlist} in {opt keep(varlist)} differs from standard Stata varlists in
two ways: variable names in {it:varlist} may not be abbreviated, except
by the use of wildcard characters, and you may not refer to a range of
variables, such as {opt price-weight}.

{phang}
{opt nolabel} prevents Stata from copying the value-label definitions from the
disk dataset into the dataset in memory.  Even if you do not specify this option, label
definitions from the disk dataset never replace definitions already in memory.

{phang}
{opt nonotes} prevents {opt notes} in the using dataset from being incorporated
into the result.  The default is to incorporate notes from the using dataset
that do not already appear in the master data.

{phang}
{opt force} allows string variables to be appended to numeric variables and
vice versa, resulting in missing values from the using dataset.  If omitted,
{cmd:append} issues an error message; if specified, {cmd:append} issues a
warning message.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse even}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{cmd:. webuse odd}{p_end}
{phang2}{cmd:. list}

{pstd}Append even data to the end of the odd data{p_end}
{phang2}{cmd:. append using https://www.stata-press.com/data/r16/even}{p_end}

{pstd}List the results{p_end}
{phang2}{cmd:. list}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. keep if foreign == 0}{p_end}
{phang2}{cmd:. save domestic}{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. keep if foreign == 1}{p_end}
{phang2}{cmd:. keep make price mpg rep78 foreign}{p_end}

{pstd}Append domestic car data to the end of the foreign car data and only
keep variables {cmd:make}, {cmd:price}, {cmd:mpg}, {cmd:rep78}, and 
{cmd:foreign} from domestic car data{p_end}
{phang2}{cmd:. append using domestic, keep(make price mpg rep78 foreign)}{p_end}

{pstd}List the results{p_end}
{phang2}{cmd:. list}{p_end}

    {hline}
    Setup
{phang2}{cmd:. sysuse citytemp, clear}{p_end}
{phang2}{cmd:. keep if region == 4}{p_end}
{phang2}{cmd:. save west}{p_end}
{phang2}{cmd:. sysuse citytemp, clear}{p_end}
{phang2}{cmd:. keep if region == 3}{p_end}
{phang2}{cmd:. save south}{p_end}
{phang2}{cmd:. sysuse citytemp, clear}{p_end}
{phang2}{cmd:. keep if region == 1}{p_end}

{pstd}Append temperature data for the West region ({cmd:region==4}) and
the South region ({cmd:region==3}) to the end of the data for the New
England region ({cmd:region==1}), and generate new variable {cmd:filenum}
to indicate from which file each observation came.  Do not 
load value-label definitions from {cmd:west.dta} or {cmd:south.dta}.{p_end}
{phang2}{cmd:. append using west south, generate(filenum) nolabel}{p_end}

{pstd}List the results{p_end}
{phang2}{cmd:. list}{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=AZGW8tohiqw":How to append files into a single dataset}
{p_end}
