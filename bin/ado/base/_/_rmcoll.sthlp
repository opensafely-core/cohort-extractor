{smcl}
{* *! version 1.2.12  19oct2017}{...}
{vieweralsosee "[P] _rmcoll" "mansection P _rmcoll"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _rmcollright" "help _rmcollright"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Syntax" "_rmcoll##syntax"}{...}
{viewerjumpto "Description" "_rmcoll##description"}{...}
{viewerjumpto "Links to PDF documentation" "_rmcoll##linkspdf"}{...}
{viewerjumpto "Options" "_rmcoll##options"}{...}
{viewerjumpto "Remarks" "_rmcoll##remarks"}{...}
{viewerjumpto "Examples" "_rmcoll##examples"}{...}
{viewerjumpto "Stored results" "_rmcoll##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] _rmcoll} {hline 2}}Remove collinear variables{p_end}
{p2col:}({mansection P _rmcoll:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}Identify variables to be omitted because of collinearity

{p 8 16 2}{cmd:_rmcoll} {varlist} {ifin}
       [{it:{help _rmcoll##weight:weight}}]
       [{cmd:,} {cmdab:nocons:tant} {opt coll:inear}
        {cmdab:exp:and} {cmdab:force:drop}]


{pstd}Identify independent variables to be omitted because of collinearity

{p 8 17 2}{cmd:_rmdcoll} {depvar} {indepvars} {ifin}
       [{it:{help _rmcoll##weight:weight}}]
       [{cmd:,} {cmdab:nocons:tant} {opt coll:inear}
         {cmdab:exp:and} {opt normcoll}]

{p 4 6 2}
{it:varlist} and {it:indepvars} may contain factor variables; see
{help fvvarlist}.
{p_end}
{p 4 6 2}
{it:varlist}, {it:depvar}, and {it:indepvars} may contain time-series
operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:aweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_rmcoll} returns in {cmd:r(varlist)}  an updated version of {varlist}
that is specific to the sample identified by {cmd:if}, {cmd:in}, and any
missing values in {it:varlist}.  {cmd:_rmcoll} flags variables that are to
be omitted because of collinearity.  If {it:varlist} contains
{help fvvarlist:factor variables}, then {cmd:_rmcoll} also enumerates the
levels of factor variables, identifies the base levels of factor variables, and
identifies empty cells in interactions.

{pstd}
The following message is displayed for each variable that {cmd:_rmcoll} flags
as omitted because of collinearity:

{pin}note:{space 2} ______ omitted because of collinearity

{pstd}
The following message is displayed for each empty cell of an interaction that
{cmd:_rmcoll} encounters:

{pin}
note:{space 2} ______ identifies no observations in the sample

{pstd}
{helpb ml} users:  it is not necessary to call {cmd:_rmcoll} because {cmd:ml}
flags collinear variables for you, assuming that you do not specify {cmd:ml}
{cmd:model}'s {cmd:collinear} option.  Even so, {cmd:ml} programmers sometimes
use {cmd:_rmcoll} because they need the sample-specific set of variables, and
in such cases, they specify {cmd:ml} {cmd:model}'s {cmd:collinear} option so
that {cmd:ml} does not waste time looking for collinearity again.

{pstd}
{cmd:_rmdcoll} performs the same task as {cmd:_rmcoll}
and checks that {depvar} is not collinear with the variables in
{indepvars}.  If {it:depvar} is collinear with any of the variables in
{it:indepvars}, then {cmd:_rmdcoll} reports the following message with the 459
error code:

{pin}______ collinear with ______


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P _rmcollRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:noconstant} specifies that, in looking for collinearity, an
intercept not be included.  That is, a variable that contains the same
nonzero value in every observation should not be considered collinear.

{phang}
{cmd:collinear} specifies that collinear variables not be flagged.

{phang}
{cmd:expand} specifies that the expanded, level-specific variables be posted to
{cmd:r(varlist)}.  This option will have an effect only if there are factor
variables in the variable list.

{phang}
{cmd:forcedrop} specifies that collinear variables be dropped from the
variable list instead of being flagged.  This option is not allowed when the
variable list already contains flagged variables, factor variables, or
interactions.

{phang}
{cmd:normcoll} specifies that collinear variables have already been flagged
in {indepvars}.  Otherwise, {cmd:_rmcoll} is called first to flag any
such collinearity.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:_rmcoll} and {cmd:_rmdcoll} are typically used when writing estimation
commands.

{pstd}
{cmd:_rmcoll} is used if the programmer wants to flag the collinear variables
from the independent variables.

{pstd}
{cmd:_rmdcoll} is used if the programmer wants to detect collinearity
of the dependent variable with the independent variables.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse auto}{p_end}
{phang2}
{cmd:. generate tt = turn + trunk}{p_end}

{pstd}
Use {cmd:_rmcoll} to identify that we have a collinearity and flag a variable
    because of it{p_end}
{phang2}
{cmd:. _rmcoll turn trunk tt}{p_end}
{phang2}
{cmd:. display r(varlist)}{p_end}

{pstd}
Pass a factor variable to {cmd:_rmcoll}{p_end}
{phang2}
{cmd:. _rmcoll i.rep78}{p_end}
{phang2}
{cmd:. display r(varlist)}{p_end}

{pstd}
Add the {cmd:expand} option to loop over the level-specific, individual
variables in {cmd:r(varlist)}{p_end}
{phang2}
{cmd:. _rmcoll i.rep78, expand}{p_end}
{phang2}
{cmd:. display r(varlist)}{p_end}

    {hline}

{pstd}
A code fragment for a program that uses {cmd:_rmcoll} might read

	{it:...}
	{cmd:syntax varlist [fweight iweight]} {it:...} {cmd:[, noCONStant} {it:...} {cmd:]}
	{cmd:marksample touse}
	{cmd:if "`weight'" != "" {c -(}}
		{cmd:tempvar w}
		{cmd:quietly gen double `w' = `exp' if `touse'}
		{cmd:local wgt [`weight'=`w']}
	{cmd:{c )-}}
	{cmd:else   local wgt} {it:/* is nothing */}
	{cmd:gettoken depvar xvars : varlist}
	{cmd:_rmcoll `xvars' `wgt' if `touse', `constant'}
	{cmd:local xvars `r(varlist)'}
	{it:...}

{pstd}
In this code fragment, {cmd:varlist} contains one dependent variable
and zero or more independent variables.  The dependent variable is split off
and stored in the local macro {cmd:depvar}.  Then the remaining variables are
passed through {cmd:_rmcoll}, and the resulting updated independent variable
list is stored in the local macro {cmd:xvars}.

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_rmcoll} and {cmd:_rmdcoll} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(k_omitted)}}number of omitted variables in {cmd:r(varlist)}{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(varlist)}}the flagged and expanded variable list{p_end}
{p2colreset}{...}
