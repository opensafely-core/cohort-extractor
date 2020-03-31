{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_xt##syntax"}{...}
{viewerjumpto "Description" "_xt##description"}{...}
{viewerjumpto "Options" "_xt##options"}{...}
{viewerjumpto "Remarks" "_xt##remarks"}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col:{hi:[XT] _xt} {hline 2}}Programmer's command to verify that data are
xtset properly{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:_xt} [{cmd:,} {it:options}]

{synoptset 13}{...}
{synopthdr}
{synoptline}
{synopt: {opt treq:uired}}caller requires that time variable be set{p_end}
{synopt: {opt i(panelvar)}}panel variable{p_end}
{synopt: {opt t(timevar)}}time variable{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_xt} is used by panel-data commands to verify that the data have
been {cmd:xtset}.  If a time variable has been set, {cmd:_xt} verifies
that it is consistent with the value of delta last recorded by
{cmd:xtset}, and the data are sorted by the panel and time variables.  
If only a panel variable has been set, the data are not sorted.


{marker options}{...}
{title:Options}

{phang}
{opt trequired} indicates that the caller needs to know the time 
variable.  By default, {cmd:_xt} assumes that only the panel variable need 
be known.

{phang}
{opt i(panelvar)} is included for backward compatibility with 
previous versions of Stata and indicates the panel variable.  

{phang}
{opt t(timevar)} is included for backward compatibility with 
previous versions of Stata and indicates the time variable.  


{marker remarks}{...}
{title:Remarks}

{pstd}
The {cmd:_xt} command is for use by panel-data commands to verify that the 
data have been {cmd:xtset}.  

{pstd}
The {opt i()} and {opt t()} options are provided for backward compatibility
with existing {cmd:xt} commands that accept the {opt i()} and {opt t()}
options.  Authors of new {cmd:xt} commands should instead require the 
user to use {cmd:xtset} beforehand, using {cmd:_xt} without those 
options to verify the integrity of the panel data.

{pstd} 
The panel variable is returned in {cmd:r(ivar)}, which will be nonempty. 
The time variable is returned in {cmd:r(tvar)}; it will be nonempty if
{opt trequired} is specified, if {opt t(varname)} was specified,
or if characteristic {cmd:_dta[_TStvar]} is nonempty.  Delta is returned 
in {cmd:r(tdelta)} if {cmd:trequired} was specified.

{pstd}
Behavior depends on the options specified.

{phang2}1.  Coding

{pin3}
{cmd:_xt}

{pmore2}
by itself tells {cmd:_xt} to verify that the data have been {cmd:xtset} 
by checking whether characteristic {cmd:_dta[_TSpanel]} is nonempty.

{phang2}2.  Coding

{pin3}
{cmd:_xt, trequired}

{pmore2}
tells {cmd:_xt} to verify that the data have been
{cmd:xtset} by checking whether both characteristics {cmd:_dta[_TSpanel]} and 
{cmd:_dta[_TStvar]} are nonempty.

{pmore2}
Also, {cmd:_xt} verifies that the time variable is consistent, 
meaning that for each panel, consecutive periods differ by delta 
units or an integer multiple of delta units.  The value of delta is 
obtained from characteristic {cmd: _dta[_TSdelta]}.  

{pmore2} 
After {cmd:_xt} is called, the data will be sorted by the panel and time
variables.

{phang2}3.  Coding

{pin3}
{cmd:_xt, i(}{it:panelvar}{cmd:)}

{pmore2}
or

{pin3}
{cmd:_xt, i(}{it:panelvar}{cmd:) t(}{it:timevar}{cmd:)}

{pmore2}
tells {cmd:_xt} to {cmd:xtset} the data with {it:panelvar} or
{it:panelvar} and {it:timevar}, assuming a delta of one.  If the data
have already been {cmd:xtset} by using different panel or time variables,
{cmd:_xt} issues a warning message before re-{cmd:xtset}ting the data.
If {opt i()} or {opt t()} is empty, {cmd:_xt} will examine the dataset 
characteristics to find the panel or time variable.

{pstd}
Some old panel-data commands looked at characteristics {cmd:_dta[iis]}
and {cmd:_dta[tis]} to obtain information about the dataset.  If the
characteristic {cmd:_dta[_TSpanel]} is empty, {cmd:_xt} checks for the
panel variable in {cmd:_dta[iis]} and, if not empty, copies
it to {cmd:_dta[_TSpanel]}, and similarly for the time 
variable.  However, the use of {cmd:_dta[iis]} and {cmd:_dta[tis]} is
considered deprecated and should not be relied upon in new code.
{p_end}
