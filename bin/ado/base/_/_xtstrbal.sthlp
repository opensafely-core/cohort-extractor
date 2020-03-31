{smcl}
{* *! version 1.0.2  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_xtstrbal##syntax"}{...}
{viewerjumpto "Description" "_xtstrbal##description"}{...}
{viewerjumpto "Remarks" "_xtstrbal##remarks"}{...}
{title:Title}

{p2colset 5 23 25 2}{...}
{p2col:{hi:[XT] _xtstrbal} {hline 2}}Programmer's command to verify that data are strongly balanced{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:_xtstrbal} {it:panelvar} {it:timevar} {it:tousevar}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_xtstrbal} is used by panel-data commands to verify that data 
are strongly balanced.  Unlike {cmd:xtset} and {cmd:tsset}, here you 
include a {cmd:touse} variable that can restrict the sample.  
{cmd:_xtstrbal} returns {cmd:r(strbal)}, containing {cmd:yes} or 
{cmd:no} depending on the case.


{marker remarks}{...}
{title:Remarks}

{pstd}
A dataset is strongly balanced if each panel has the same number of 
observations and each distinct time period in the dataset has the same 
number of observations.  In other words, a dataset is strongly balanced 
if each panel has the same number of observations and the panels' 
observations refer to the same set of time periods.
{p_end}
