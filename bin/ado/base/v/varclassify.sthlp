{smcl}
{* *! version 1.0.0  15jun2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee vl "help vl"}{...}
{viewerjumpto "Syntax" "varclassify##syntax"}{...}
{viewerjumpto "Description" "varclassify##description"}{...}
{viewerjumpto "Options" "varclassify##options"}{...}
{viewerjumpto "Remarks" "varclassify##remarks"}{...}
{viewerjumpto "Stored results" "varclassify##results"}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col:{hi:[P] varclassify} {hline 2}}Classify a single variable as categorical or not{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:varclassify} {varname} {ifin} [{cmd:,} 
{opt cat:egorical(#)}
{opt uncer:tain(#)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:varclassify} classifies a numeric variable.  The command displays no
output; the classification is obtained from
{helpb varclassify##results:r(class)}. 


{marker options}{...}
{title:Options}

{phang}
{opt categorical(#)} specifies the maximum number of categories of a variable 
classified as {cmd:categorical}.  If the nonmissing values of a variable are
all nonnegative integers and the number of distinct values is less than or
equal to {it:#}, the variable is classified as {cmd:categorical}.  The default
is {cmd:categorical(10)}.

{phang}
{opt uncertain(#)} specifies the maximum number of categories of a variable 
classified as {cmd:uncertain}.  If the nonmissing values of a variable are all 
nonnegative integers and the number of distinct values are less than or equal
to {it:#} and greater than {opt categorical(#)}, the variable is classified as
{cmd:uncertain}.  The default is {cmd:uncertain(100)}.  Specifying
{cmd:uncertain(0)} or {opt uncertain(#)} where {it:#} is equal to
{opt categorical(#)} results in no variables being classified as
{cmd:uncertain}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:varclassify} classifies a numeric variable shown in {cmd:r(class)}
as {cmd:categorical}, {cmd:uncertain}, {cmd:continuous integer},
{cmd:noninteger}, {cmd:negative}, {cmd:big} (one or more values greater than
2,147,483,647, the maximum value of a factor variable), {cmd:constant}, or
{cmd:all missing}.  To be classified as {cmd:categorical}, {cmd:uncertain}, or
{cmd:continuous integer}, values must be nonnegative integers with cutoffs for
the classifications defined by the options {opt categorical(#)} and
{opt uncertain(#)}.  The classification {cmd:categorical} is intended to mean
that the user has deemed this variable suitable for use as a factor variable
for a particular analysis.  The classification {cmd:uncertain} is for a
variable that may or may not be suitable for use as a factor variable.

{pstd}
Classifications are made in the order shown in {it:Stored results} below.
For example, a variable with both noninteger values and negative values is
classified as {cmd:noninteger}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:varclassify} stores the following in {cmd:r()}:

{synoptset 12 tabbed}{...}
{p2col 5 12 14 2: Scalar}{p_end}
{synopt:{cmd:r(N)}}number of nonmissing observations{p_end}
{synopt:{cmd:r(r)}}number of categories when {ul:<} {opt uncertain(#)};
otherwise, {cmd:r(r)} is not computed{p_end}
{synopt:{cmd:r(bound)}}number of categories > {cmd:r(bound)}
when {cmd:r(class)} is {cmd:continuous integer}; otherwise, not set{p_end}
{synopt:{cmd:r(min)}}minimum{p_end}
{synopt:{cmd:r(max)}}maximum{p_end}
{synopt:{cmd:r(mean)}}mean{p_end}
{synopt:{cmd:r(sum)}}sum{p_end}
{p2colreset}{...}

{synoptset 12 tabbed}{...}
{p2col 5 12 14 2: Macros}{p_end}
{synopt:{cmd:r(class)}}{cmd:all missing} when all values are missing{p_end}
{synopt:}{cmd:constant} when all nonmissing values are the same{p_end}
{synopt:}{cmd:noninteger} when there are one or more noninteger values{p_end}
{synopt:}{cmd:negative} when there are one or more negative values{p_end}
{synopt:}{cmd:big} when one or more values are > 2,147,483,647 
(2^32 - 1){p_end}
{synopt:}{cmd:categorical} when nonnegative, integer, and number of distinct 
values are {ul:<} {opt categorical(#)}{p_end}
{synopt:}{cmd:uncertain} when nonnegative, integer, and number of distinct 
values are > {opt categorical(#)} and {ul:<} {opt uncertain(#)}{p_end}
{synopt:}{cmd:continuous integer} when nonnegative, integer, and number of 
distinct values are > {opt uncertain(#)}{p_end}
{p2colreset}{...}
