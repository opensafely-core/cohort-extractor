{smcl}
{* *! version 1.0.5  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_sep_varsylags##syntax"}{...}
{viewerjumpto "Description" "_sep_varsylags##description"}{...}
{viewerjumpto "Stored results" "_sep_varsylags##results"}{...}
{title:Title}

{p 4 21 2}
{hi:[TS] _sep_varsylags} {hline 2} Return the lag structure of varlist


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:_sep_varsylags} {varlist}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_sep_varsylags} parses out and saves off the lag structure of a
varlist.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_sep_varsylags} stores the following in {cmd:r()}:

{pstd}
Macros{p_end}
{phang2}
{cmd:r(vars)} contains the varlist of base variables.  Base variables may
contain time-series operators.  The lag structure for each base variable is
stored in {cmd:r(lags)}.

{phang2}
{cmd:r(lags)} contains a colon-separated list of the lags for each base
variable.

{phang2}
{cmd:r(newlist)} contains an equivalent version of the original varlist.
The {cmd:newlist} has the structure broken out for each base variable.

{pstd}
Matrices{p_end}
{phang2}
{cmd:r(lagsm)} contains the lag structure of the base variables.  For each
base variable, there is a row in {cmd:r(lagsm)}.  There are {cmd:mlag}
columns in {cmd:r(lagsm)}, where {cmd:mlag} is the longest lag over all the
base variables.  If element {cmd:i,j} in {cmd:r(lagsm)} is 0, then the
coefficient on lag {cmd:j} of the {cmd:i}th variable was not estimated.  If
element {cmd:i,j} in {cmd:r(lagsm)} is 1, then the coefficient on lag {cmd:j}
of the {cmd:i}th variable was estimated.
{p_end}
