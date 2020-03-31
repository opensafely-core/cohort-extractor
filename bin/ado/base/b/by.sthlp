{smcl}
{* *! version 1.2.3  19oct2017}{...}
{vieweralsosee "[D] by" "mansection D by"}{...}
{findalias asfrsyntax}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] byable" "help byprog"}{...}
{vieweralsosee "[P] foreach" "help foreach"}{...}
{vieweralsosee "[P] forvalues" "help forvalues"}{...}
{vieweralsosee "[D] sort" "help sort"}{...}
{vieweralsosee "[D] statsby" "help statsby"}{...}
{vieweralsosee "[P] while" "help while"}{...}
{viewerjumpto "Syntax" "by##syntax"}{...}
{viewerjumpto "Description" "by##description"}{...}
{viewerjumpto "Links to PDF documentation" "by##linkspdf"}{...}
{viewerjumpto "Options" "by##options"}{...}
{viewerjumpto "Examples" "by##examples"}{...}
{viewerjumpto "Technical note" "by##technote"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[D] by} {hline 2}}Repeat Stata command on subsets of the data{p_end}
{p2col:}({mansection D by:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:by} {varlist}{cmd::} {it:stata_cmd}

{p 8 16 2}
{opt bys:ort} {varlist}{cmd::} {it:stata_cmd}

{pstd}
The above diagrams show {cmd:by} and {cmd:bysort} as they are typically
used.  The full syntax of the commands is

{p 8 12 2}
{cmd:by} {it:{help varlist}1} [{cmd:(}{it:{help varlist}2}{cmd:)}]
[{cmd:,} {opt s:ort} {cmd:rc0}]{cmd::}  {it:stata_cmd}

{p 8 16 2}
{opt bys:ort} {it:{help varlist}1} [{cmd:(}{it:{help varlist}2}{cmd:)}]
[{cmd:,} {cmd:rc0}]{cmd::}  {it:stata_cmd}


{marker description}{...}
{title:Description}

{pstd}
Most Stata commands allow the {cmd:by} prefix, which repeats the command for
each group of observations for which the values of the variables in
{varlist} are the same.  {cmd:by} without the {cmd:sort} option requires
that the data be sorted by {it:varlist}; see {manhelp sort D}.

{pstd}
Stata commands that work with the {cmd:by} prefix indicate this immediately
following their syntax diagram by reporting, for example,
"{cmd:by} is allowed; see {manhelp by D}" or "{cmd:bootstrap}, 
{cmd:by}, etc., are allowed; see {help prefix}".

{pstd}
{cmd:by} and {cmd:bysort} are really the same command; {cmd:bysort} is just
{cmd:by} with the {cmd:sort} option.

{pstd}
The {it:varlist1} {cmd:(}{it:varlist2}{cmd:)} syntax is of special use to
programmers.  It verifies that the data are sorted by 
{bind:{it:varlist1 varlist2}} and then performs a {cmd:by} as if only
{it:varlist1} were specified.  For instance,

{phang2}
{cmd:by pid (time): generate growth = (bp - bp[_n-1])/bp}

{pstd}
performs the {cmd:generate} by values of {hi:pid} but first verifies that
the data are sorted by {hi:pid} and {hi:time} within {hi:pid}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D byQuickstart:Quick start}

        {mansection D byRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt sort} specifies that if the data are not already sorted by {varlist},
{cmd:by} should sort them.

{phang}
{opt rc0} specifies that even if the {it:stata_cmd} produces an error in one
of the by-groups, then {cmd:by} is still to run the {it:stata_cmd} on the
remaining by-groups.  The default action is to stop when an error occurs.
{opt rc0} is especially useful when {it:stata_cmd} is an estimation command
and some by-groups have insufficient observations.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}For each category of {cmd:foreign}, display summary statistics for
{cmd:rep78}{p_end}
{phang2}{cmd:. by foreign:  summarize rep78}

{pstd}Same as above command, but check that the data are sorted by
{cmd:foreign} and {cmd:make} within {cmd:foreign}{p_end}
{phang2}{cmd:. by foreign (make):  summarize rep78}{p_end}
{phang2}{err:not sorted}{p_end}
{phang2}{search r(5)};{p_end}
{phang2}{cmd:. sort foreign make}{p_end}
{phang2}{cmd:. by foreign (make): summarize rep78}{p_end}

{pstd}For each category of {cmd:rep78}, display frequency counts of
{cmd:foreign}{p_end}
{phang2}{cmd:. by rep78: tabulate foreign}{p_end}
{phang2}{err:not sorted}{p_end}
{phang2}{search r(5)};{p_end}
{phang2}{cmd:. sort rep78}{p_end}
{phang2}{cmd:. by rep78: tabulate foreign}{p_end}

{pstd}Equivalent to above two commands{p_end}
{phang2}{cmd:. by rep78, sort:  tabulate foreign}

{pstd}Equivalent to above command{p_end}
{phang2}{cmd:. bysort rep78: tabulate foreign}

{pstd}For each category of {cmd:rep78} within categories of {cmd:foreign},
display summary statistics for {cmd:price}{p_end}
{phang2}{cmd:. by foreign rep78, sort: summarize price}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse autornd}{p_end}
{phang2}{cmd:. keep in 1/20}{p_end}

{pstd}Store in new variable {cmd:mean_w} the mean value of {cmd:weight} for
each category of {cmd:mpg}{p_end}
{phang2}{cmd:. by mpg, sort: egen mean_w = mean(weight)}{p_end}
    {hline}


{marker technote}{...}
{title:Technical note}

{pstd}
{cmd:by} repeats the {it:stata_cmd} for each group defined by {it:varlist}.
If {it:stata_cmd} {help stored_results:stores results}, only the results from
the last group on which {it:stata_cmd} executes will be stored.
{p_end}
