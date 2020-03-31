{smcl}
{* *! version 1.1.2  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cf" "help cf"}{...}
{viewerjumpto "Syntax" "dta_equal##syntax"}{...}
{viewerjumpto "Description" "dta_equal##description"}{...}
{viewerjumpto "Options" "dta_equal##options"}{...}
{viewerjumpto "Stored results" "dta_equal##results"}{...}
{title:Title}

{p 4 22 2}
{hi:[P] dta_equal} {hline 2} Assert datasets equal


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmd:dta_equal}
{it:filename1}
{it:filename2}
[{cmd:,} {it:options}]

{p 8 24 2}
{cmd:dta_equal}{bind:      }{cmd:.}{bind:    }{it:filename2}
[{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{opth ex:clude(varname:varnames)}}exclude {it:varnames} from comparison
{p_end}
{synopt:{cmd:uniq1}}exclude variables unique to {it:filename1} from comparison
{p_end}
{synopt:{cmd:uniq2}}exclude variables unique to {it:filename2} from comparison
{p_end}
{synopt:{opt none:ok}}it is okay if no variables in common after exclusions
{p_end}
{synoptline}
{p2colreset}{...}
	

{marker description}{...}
{title:Description}

{p 4 4 2}
The {cmd:dta_equal} certification command slowly but surely compares
{it:filename1}{cmd:.dta} with {it:filename2}{cmd:.dta}, variable by variable,
and aborts with error r(9) if they differ.  If {it:filename1} is specified as
period ({cmd:.}), {it:filename1} is taken to be the data in memory.

{p 4 4 2}
Displayed are 
variables unique to {it:filename1}, 
in alphabetical order;
variables unique to {it:filename2}, in alphabetical order;
and
variables in common, in alphabetical order.

{p 4 4 2}
{cmd:dta_equal} returns only {cmd:r(0)} if all variables, after exclusions, 
contain equal values in the two datasets.

{p 4 4 2}
If filenames are specified without a suffix, {cmd:.dta} is assumed.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:exclude(}{it:varnames}{cmd:)}
    excludes the listed variable names from the comparison.
    Names must be entered one after the other in unabbreviated form.

{p 4 8 2}
{cmd:uniq1}
    excludes variables unique to {it:filename1} from the comparison.  If this
    option is not specified, unique variables cause error r(9).

{p 4 8 2}
{cmd:uniq2}
    excludes variables unique to {it:filename2} from the comparison.  If this
    option is not specified, unique variables cause error r(9).

{p 4 8 2}
{cmd:noneok} 
    specifies that it is okay if all variables are excluded. 
    If this option is not specified, the presence of no common 
    variables results in error r(9).


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:dta_equal} stores the following in {cmd:r()}:

{synoptset 12 tabbed}{...}
{p2col 5 12 16 2:Macros}{p_end}
{synopt:{cmd:r(common)}}common variables, in alphabetical order{p_end}
{synopt:{cmd:r(uniq1)}}variables unique to {it:filename1}, in alphabetical order
{p_end}
{synopt:{cmd:r(uniq2)}}variables unique to {it:filename2}, in alphabetical order
{p_end}
{p2colreset}{...}
