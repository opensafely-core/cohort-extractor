{smcl}
{* *! version 1.1.14  19oct2017}{...}
{vieweralsosee "[P] mark" "mansection P mark"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] byable (byprog)" "help byprog"}{...}
{vieweralsosee "[SVY] svymarkout" "help svymarkout"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "mark##syntax"}{...}
{viewerjumpto "Description" "mark##description"}{...}
{viewerjumpto "Links to PDF documentation" "mark##linkspdf"}{...}
{viewerjumpto "Options" "mark##options"}{...}
{viewerjumpto "Remarks" "mark##remarks"}{...}
{viewerjumpto "Example" "mark##example"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[P] mark} {hline 2}}Mark observations for inclusion{p_end}
{p2col:}({mansection P mark:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Create marker variable after syntax

{p 8 19 2}{cmd:marksample} {it:lmacname} [{cmd:,} {cmdab:nov:arlist}
{cmdab:s:trok} {cmdab:zero:weight} {cmd:noby}]


    Create marker variable

{p 8 19 2}{cmd:mark} {it:newmarkvar}
{ifin} 
[{it:{help mark##weight:weight}}]
[{cmd:,} {cmdab:zero:weight} {cmd:noby}]


    Modify marker variable

{p 8 19 2}{cmd:markout} {it:markvar} [{varlist}] [{cmd:,}
{cmdab:s:trok}
{cmdab:sysmis:sok}]


    Find range containing selected observations

{p 8 19 2}{cmd:markin} {ifin}
[{cmd:,}
	{cmdab:n:ame}{cmd:(}{it:lclname}{cmd:)}
	{cmd:noby}]


    Modify marker variable based on survey-characteristic variables

{p 8 19 2}{cmd:svymarkout} {it:markvar}


{marker weight}{...}
{pstd}
{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.{p_end}
{pstd}
{it:varlist} may contain time-series operators; see {help tsvarlist}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:marksample}, {cmd:mark}, and {cmd:markout} are for use in Stata programs.
{cmd:marksample} and {cmd:mark} are alternatives; {cmd:marksample} links to
information left behind by {cmd:syntax}, and {cmd:mark} is seldom used.
Both create a 0/1 to-use variable that records which observations are to be used
in subsequent code.  {cmd:markout} sets the to-use variable to 0 if any
variables in {varlist} contain missing and is used to further restrict
observations.

{pstd}
{cmd:markin} is for use after {cmd:marksample}, {cmd:mark}, and {cmd:markout}
and, sometimes, provides a more efficient encoding of the observations to
be used in subsequent code.  {cmd:markin} is rarely used.

{pstd}
{cmd:svymarkout} sets the to-use variable to 0 wherever any of the
survey-characteristic variables contain missing values; it is discussed in
{manhelp svymarkout SVY} and is not further discussed here.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P markRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang} 
{cmd:novarlist} is for use with {cmd:marksample}.  It specifies that missing
    values among variables in {varlist} not cause the marker
    variable to be set to 0.  Specify {cmd:novarlist} if you previously
    specified

            {cmd:syntax newvarlist} ...

{pmore}or

            {cmd:syntax newvarname} ...

{pmore}
    You should also specify {cmd:novarlist} when missing
    values are not to cause observations to be excluded (perhaps you are
    analyzing the pattern of missing values).

{marker strok}{...}
{phang}
{cmd:strok} is used with {cmd:marksample} or {cmd:markout}.  Specify this
    option if string variables in {varlist} are to be allowed.  {cmd:strok}
    changes {help mark##rule6:rule 6} in {it:Remarks} below to read 

{pmore}
    "The marker variable is set to 0 in observations for which any of 
      the string variables in {it:varlist} contain {cmd:""}."

{marker zeroweight}{...}
{phang}
{cmd:zeroweight} is for use with {cmd:marksample} or {cmd:mark}.  It deletes
    {help mark##rule1:rule 1} in {it:Remarks} below, meaning that observations
    will not be excluded because the weight is zero.

{phang}{cmd:noby} is used rarely and only in {cmd:byable(recall)} programs.
It specifies that, in identifying the sample, the restriction to the by-group
be ignored.  {cmd:mark} and {cmd:marksample} are to create the marker variable
as they would had the user not specified the {cmd:by} prefix.  If the user
did not specify the {cmd:by} prefix, specifying {cmd:noby} has no effect.
{cmd:noby} provides a way for {cmd:byable(recall)} programs to identify the
overall sample.  For instance, if the program needed to calculate the
percentage of observations in the by-group, the program would need to know
both the sample to be used on this call and the overall sample.  The program
might be coded as

	    {cmd:program} {it:...}{cmd:, byable(recall)}
		    {it:...}
		    {cmd:marksample touse}
		    {cmd:marksample alluse, noby}

		    {it:...}
		    {cmd:quietly count if `touse'}
		    {cmd:local curN = r(N)}
		    {cmd:quietly count if `alluse'}
		    {cmd:local totN = r(N)}

		    {cmd:local frac = `curN'/`totN'}
		    {it:...}
	    {cmd:end}

{pmore}
See {manhelp byprog P:byable}.

{phang}
{cmd:sysmissok} is used with {cmd:markout}.  Specify this option
    if numeric variables in {varlist} equal to system missing ({cmd:.})
    are to be allowed and only numeric variables equal to extended missing
    ({cmd:.a}, {cmd:.b}, ...) are to be excluded.
    The default is that all missing values ({cmd:.}, {cmd:.a}, {cmd:.b}, ...)
    are excluded.

{phang}
{opt name(lclname)} is for use with {cmd:markin}.  It specifies the name
of the macro to be created.  If {cmd:name()} is not specified, the name
{cmd:in} is used.


{marker remarks}{...}
{title:Remarks}

{pstd}
Regardless of whether you use {cmd:mark} or {cmd:marksample}, followed or not
by {cmd:markout}, the following rules apply:

{marker rule1}{...}
{phang}
 1.  The marker variable is set to 0 in observations for which {it:weight}
    is 0 (but see option {helpb mark##zeroweight:zeroweight}).

{phang}
2.  The appropriate error message is issued, and everything stops if
    {it:weight} is invalid (such as being less than 0 in some observation or
    being a noninteger for frequency weights).

{phang}
3.  The marker variable is set to 0 in observations for which the {cmd:if}
    {it:exp} is not satisfied.

{phang}
4.
    The marker variable is set to 0 in observations outside the {cmd:in}
    {it:range}.

{phang}
5.  The marker variable is set to 0 in observations for which any of the
    numeric variables in {it:varlist} contain a numeric missing value.

{marker rule6}{...}
{phang}
6.  The marker variable is set to 0 in all observations if any of the
    variables in {it:varlist} are strings; see option {helpb mark##strok:strok}
    for an exception.

{phang}
7.  The marker variable is set to 1 in the remaining observations.

{pstd}
Using the name {cmd:touse} is a convention, not a rule, but it is
recommended for consistency between programs.


{marker example}{...}
{title:Example}

    {cmd:program} {it:...}
	    {cmd:syntax} {it:...}
	    {cmd:marksample touse}
	    {it:...}
	    {it:...} {cmd:if `touse'} {it:...}
	    {it:...}
    {cmd:end}
