{smcl}
{* *! version 1.0.0  19jun2019}{...}
{vieweralsosee "[D] vl set" "mansection D vlset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] vl" "help vl"}{...}
{vieweralsosee "[D] vl create" "help vl create"}{...}
{vieweralsosee "[D] vl drop" "help vl drop"}{...}
{vieweralsosee "[D] vl list" "help vl list"}{...}
{vieweralsosee "[D] vl rebuild" "help vl rebuild"}{...}
{viewerjumpto "Syntax" "vl set##syntax"}{...}
{viewerjumpto "Description" "vl set##description"}{...}
{viewerjumpto "Links to PDF documentation" "vl set##linkspdf"}{...}
{viewerjumpto "Options" "vl set##options"}{...}
{viewerjumpto "Examples" "vl set##examples"}{...}
{viewerjumpto "Stored results" "vl set##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] vl set} {hline 2}}Set system-defined variable lists{p_end}
{p2col:}({mansection D vlset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Create system-defined variable lists

{p 8 16 2}
{cmd:vl} {cmd:set} [{varlist}]
[{cmd:,} {it:options}]


{pstd}
Move variables from their current system-defined variable list to 
another

{p 8 16 2}
{cmd:vl} {cmd:move} {cmd:(}{varlist}{cmd:)} {it:vlsysname}


{pstd}
Move all variables in one system-defined variable list to another

{p 8 16 2}
{cmd:vl} {cmd:move}  {it:vlsysname1} {it:vlsysname2}


{phang}
{it:varlist} contains only numeric variables.  If not specified, then all
numeric variables in the dataset are classified.

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opt cat:egorical(#)}}upper limit for the number of categories in
{cmd:vlcategorical}{p_end}
{synopt :{opt uncer:tain(#)}}upper limit for the number of categories in {cmd:vluncertain}{p_end}
{synopt :{opt dum:my}}create variable list {cmd:vldummy} containing 0/1
variables{p_end}
{synopt :{opt list}[{cmd:(}{help vl_set##listopts:{it:list_options}}{cmd:)}]}list variables as they
are classified{p_end}
{synopt :{opt clear}}discard all existing classifications and make new
classifications{p_end}
{synopt :{opt redo}}redo classifications for variables in {varlist}{p_end}
{synopt :{opt update}}update stored statistics for variables in {varlist},
but do not change their classification{p_end}
{synopt :{opt nonotes}}suppress the notes below the summary table{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:vl} {cmd:set} is designed to identify variables that are to be treated as
factor variables in Stata's estimation commands.

{pstd}
{cmd:vl} {cmd:set} creates the system-defined variable lists
{cmd:vlcategorical}, {cmd:vlcontinuous}, {cmd:vluncertain}, and {cmd:vlother}.
Variables are placed in them based on their values (integer or noninteger, all
nonnegative, etc.) and default or user-specified cutoffs for the number of
levels in a variable.

{pstd}
{cmd:vl} {cmd:move} moves variables from one classification to another.

{pstd}
Variable lists are actually {help macro:global macros}, and they are saved
with the dataset.  See {manhelp vl_rebuild D:vl rebuild}.

{pstd}
For an introduction to the {cmd:vl} commands, see {manhelp vl D}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D vlsetQuickstart:Quick start}

        {mansection D vlsetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}


{marker options}{...}
{title:Options}

{phang}
{opt categorical(#)} specifies that variables containing nonnegative integers
be put into the {cmd:vlcategorical} variable list when the number of levels is
between 2 and {it:#} inclusive.  Variables with only one level (that is,
constants) are put into the {cmd:vlother} variable list.  The default is
{cmd:categorical(10)}.

{pmore}
{cmd:categorical(.)} can be specified to set the upper limit effectively to
infinity.  That is, all variables containing nonnegative integers (whose values
are less than 2^{31} = 2,147,483,648) are put into {cmd:vlcategorical}.
Setting {it:#} to {cmd:.} or a large value can slow computation time
considerably when the number of observations is extremely large.

{phang}
{opt uncertain(#)} specifies that variables containing nonnegative integers be
put into the {cmd:vluncertain} variable list when the number of levels are
between {opt categorical(#)} + 1 and {it:#} inclusive.  The default is
{cmd:uncertain(100)}.

{pmore}
{it:#} must be {ul:>} {opt categorical(#)}.
To omit the {cmd:vluncertain} classification, set 
{it:#} = {opt categorical(#)} or specify
{cmd:uncertain(0)}.

{pmore}
{cmd:uncertain(.)} can be specified to set the upper limit effectively to
infinity.  That is, all variables containing nonnegative integers (whose
values are less than 2^{31} = 2,147,483,648) with more than
{opt categorical(#)} levels are put into {cmd:vluncertain}.  Setting {it:#} to
{cmd:.} or a large value can slow computation time considerably when the
number of observations is extremely large.

{phang}
{cmd:dummy} specifies that a {cmd:vldummy} variable list be created containing
0/1 variables.  By default, 0/1 variables are put into {cmd:vlcategorical}.

{marker listopts}{...}
{phang}
{opt list}[{cmd:(}{it:list_options}{cmd:)}] lists variables as they are
classified.  The classification is shown as well as the number of levels for
variables in {cmd:vlcategorical} and {cmd:vluncertain}.  {it:list_options} are
as follows:

{phang2}
{opt min:imum} shows the minimum value of each variable;

{phang2}
{opt max:imum} shows the maximum value of each variable; and

{phang2}
{opt obs:ervations} shows the number of nonmissing values of each variable.

{pmore}
The same listing can be obtained using {helpb vl list} after running
{cmd:vl set}.

{phang}
{opt clear} specifies that all the system-defined variable lists (if any) be
dropped and the classifications redone.  It is equivalent to running {cmd:vl}
{cmd:clear,} {cmd:system} and then running {cmd:vl} {cmd:set}.

{phang}
{cmd:redo} specifies that the classifications be redone for the variables in
{varlist}.  It is equivalent to running {cmd:vl}
{opt drop (varlist)}{cmd:,} {cmd:system} and then running {cmd:vl} {cmd:set}
{it:varlist}.

{phang}
{cmd:update} specifies that all statistics (number of levels, minimum value,
maximum value, and number of nonmissing observations) that are saved for the
variables in {varlist} be updated but the classifications of the variables
not be changed.  {cmd:update} is intended for use when observations are added
to or dropped from the data and you want the classifications to remain
unchanged.

{phang}
{cmd:nonotes} specifies that the notes at the bottom of the summary table not
be displayed.  By default, the notes are shown.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create the system-defined variable lists{p_end}
{phang2}{cmd:. vl set}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Create a {cmd:vldummy} variable list containing 0/1 variables{p_end}
{phang2}{cmd:. vl set, dummy}{p_end}

{pstd}Drop the system-defined variable lists and rerun {cmd:vl set}{p_end}
{phang2}{cmd:. vl set, clear}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:vl set} stores the following in {cmd:r()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 27 2: Scalars}{p_end}
{synopt:{cmd:r(k_system)}}number of variables in system-defined variable
lists{p_end}
{synopt:{cmd:r(k_vlcategorical)}}number of variables in {cmd:vlcategorical}{p_end}
{synopt:{cmd:r(k_vlcontinuous)}}number of variables in {cmd:vlcontinuous}{p_end}
{synopt:{cmd:r(k_vluncertain)}}number of variables in {cmd:vluncertain}{p_end}
{synopt:{cmd:r(k_vlother)}}number of variables in {cmd:vlother}{p_end}
{synopt:{cmd:r(k_vldummy)}}number of variables in {cmd:vldummy} when
defined{p_end}

{p2col 5 23 27 2: Macros}{p_end}
{synopt:{cmd:r(vlsysnames)}}names of system-defined variable lists{p_end}
{p2colreset}{...}
