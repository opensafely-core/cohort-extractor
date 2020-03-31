{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog separate "dialog separate"}{...}
{vieweralsosee "[D] separate" "mansection D separate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{vieweralsosee "[R] tabulate, summarize()" "help tabulate_summarize"}{...}
{viewerjumpto "Syntax" "separate##syntax"}{...}
{viewerjumpto "Menu" "separate##menu"}{...}
{viewerjumpto "Description" "separate##description"}{...}
{viewerjumpto "Links to PDF documentation" "separate##linkspdf"}{...}
{viewerjumpto "Options" "separate##options"}{...}
{viewerjumpto "Examples" "separate##examples"}{...}
{viewerjumpto "Stored results" "separate##results"}{...}
{p2colset 1 17 18 2}{...}
{p2col:{bf:[D] separate} {hline 2}}Create separate variables{p_end}
{p2col:}({mansection D separate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}
{cmd:separate}
{varname}
{ifin}
{cmd:,} {cmd:by(}{it:{help varlist:groupvar}} {c |} {it:{help exp}}{cmd:)}
[{it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent :* {opth by:(varlist:groupvar)}}
categorize observations into groups defined by {it:groupvar}{p_end}
{p2coldent :* {opth by(exp)}}
categorize observations into two groups defined by {it:exp}{p_end}

{syntab :Options}
{synopt :{opt g:enerate(stubname)}}name new variables by suffixing values to
{it:stubname}; default is to use {varname} as prefix{p_end}
{synopt :{opt seq:uential}}use as name suffix categories numbered sequentially
from 1{p_end}
{synopt :{opt miss:ing}}create variables for the missing values{p_end}
{synopt :{opt short:label}}create shorter variable labels{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Either {opt by(groupvar)} or {opt by(exp)} must be specified.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
   {bf:> Create separate variables}


{marker description}{...}
{title:Description}

{pstd}
{opt separate} creates new variables containing values from {varname}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D separateQuickstart:Quick start}

        {mansection D separateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:by(}{it:{help varlist:groupvar}} | {it:{help exp}}{cmd:)}
specifies one variable defining the categories or a logical expression
that categorizes the observations into two groups.

{pmore}
If {opt by(groupvar)} is specified, {it:groupvar} may be a numeric
or string variable taking on any values.

{pmore}
If {opt by(exp)} is specified, the expression must evaluate
to true (1), false (0), or missing.

{pmore}
{opt by()} is required.

{dlgtab:Options}

{phang}
{opt generate(stubname)} specifies how the new variables are to be named. If
    {opt generate()} is not specified, {opt separate} uses the name of the
    original variable, shortening it if necessary.  If {opt generate()} is
    specified, {opt separate} uses {it:stubname}.  If any of the resulting
    names is too long when the values are suffixed, it is not shortened and an
    error message is issued.

{phang}
{opt sequential} specifies that categories be numbered sequentially from 1.
    By default, {opt separate} uses the actual values recorded in the original
    variable, if possible, and sequential numbers otherwise.  {opt separate}
    can use the original values if they are all nonnegative integers smaller
    than 10,000.

{phang}
{opt missing} also creates a variable for the category missing
    if missing occurs ({it:groupvar} takes on the value missing or {it:exp}
    evaluates to missing).  The resulting variable is named in the usual
    manner but with an appended underscore; for example, {cmd:bp_}.  By
    default, {opt separate} creates no such variable.  The contents of other
    variables are unaffected by whether {opt missing} is specified.

{phang}
{opt shortlabel} creates a variable label that is shorter than the default.
By default, when {cmd:separate} generates the new variable labels, it includes
the name of the variable being separated.  {cmd:shortlabel} specifies that the
variable name be omitted from the new variable labels.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create variable {cmd:mpg0} containing values of {cmd:mpg} when
{cmd:foreign} is 0 ({cmd:Domestic}) and create variable {cmd:mpg1} containing
values of {cmd:mpg} when {cmd:foreign} is 1 ({cmd:Foreign}){p_end}
{phang2}{cmd:. separate mpg, by(foreign)}{p_end}

{pstd}Plot quantiles of {cmd:mpg0} against the quantiles of {cmd:mpg1}{p_end}
{phang2}{cmd:. qqplot mpg0 mpg1}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Create variable {cmd:mpg0} containing values of {cmd:mpg} when
{cmd:price} is not greater than 6000 and create variable {cmd:mpg1} containing
values of {cmd:mpg} when {cmd:price} is greater than 6000{p_end}
{phang2}{cmd:. separate mpg, by(price>6000)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Same as above, but call variables {cmd:mpgpr0} and {cmd:mpgpr1}{p_end}
{phang2}{cmd:. separate mpg, by(price>6000) gen(mpgpr)}{p_end}

{pstd}Plot quantiles of {cmd:mpgpr0} against the quantiles of {cmd:mpgpr1}{p_end}
{phang2}{cmd:. qqplot mpgpr0 mpgpr1}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:separate} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}names of the newly created variables{p_end}
{p2colreset}{...}
