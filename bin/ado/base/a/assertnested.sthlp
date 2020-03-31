{smcl}
{* *! version 1.0.0  12jun2019}{...}
{vieweralsosee "[D] assertnested" "mansection D assertnested"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{vieweralsosee "[CM] Intro 2" "mansection CM Intro2"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{vieweralsosee "[SVY] Survey" "help survey"}{...}
{vieweralsosee "[XT] xt" "help xt"}{...}
{findalias asfrdofiles}{...}
{viewerjumpto "Syntax" "assertnested##syntax"}{...}
{viewerjumpto "Description" "assertnested##description"}{...}
{viewerjumpto "Links to PDF documentation" "assertnested##linkspdf"}{...}
{viewerjumpto "Options" "assertnested##options"}{...}
{viewerjumpto "Examples" "assertnested##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] assertnested} {hline 2}}Verify variables nested{p_end}
{p2col:}({mansection D assertnested:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:assertnested}
{varlist}
{ifin} 
[{cmd:,}
{opt within(withinvars)}
{opt miss:ing}]


{phang}
The variables in {it:varlist} are given in the order of biggest 
grouping to smallest grouping.

{phang}
{cmd:by} is allowed; see {manhelp by D}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:assertnested} verifies that the values of variables are nested within the
values of other variables.  If they are nested, the command produces no
output.  If they are not nested, {cmd:assertnested} informs you that they are
not and issues an error return code of 459; see {findalias frrc}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D assertnestedQuickstart:Quick start}

        {mansection D assertnestedRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt within(withinvars)} asserts that the values of {varlist}
are nested within each of the variables in {it:withinvars}. That is,
{cmd:assertnested} {it:varlist}{cmd:,} 
{opt within(w1 w2 ...)}   
will issue an error if any of 
{cmd:assertnested} {it:w1} {it:varlist},
{cmd:assertnested} {it:w2} {it:varlist}, ...
issue an error.
  
{phang}
{cmd:missing} specifies that missing values in {varlist} and 
{it:withinvars} are to be treated the same as nonmissing values.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}

{pstd}Assert that {cmd:consumerid} is nested within {cmd:gender}{p_end}
{phang2}{cmd:. assertnested gender consumerid}

{pstd}Assert that {cmd:consumerid} is nested within {cmd:income}{p_end}
{phang2}{cmd:. assertnested income consumerid}

{pstd}Same as the above two commands, but use the {cmd:within()} option to do
this in one command{p_end}
{phang2}{cmd:. assertnested consumerid, within(gender income)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse schools}{p_end}

{pstd}Assert that {cmd:student} is nested within {cmd:school}
and that {cmd:school} is nested within {cmd:district}{p_end}
{phang2}{cmd:. assertnested district school student}

{pstd}Schools are not nested within district; thus, the error
message 

    {hline}
