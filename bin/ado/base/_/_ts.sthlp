{smcl}
{* *! version 1.0.2  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_ts##syntax"}{...}
{viewerjumpto "Description" "_ts##description"}{...}
{viewerjumpto "Options" "_ts##options"}{...}
{viewerjumpto "Remarks" "_ts##remarks"}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col:{hi:[TS] _ts} {hline 2}}Programmer's command to verify that data are
tsset properly{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:_ts} {ifin} [{cmd:,} {it:options}]

{synoptset 13}{...}
{synopthdr}
{synoptline}
{synopt: {opt s:ort}}caller requires that time variable be set{p_end}
{synopt: {opt p:anel}}panel variable{p_end}
{synopt: {opt o:nepanel}}time variable{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ts} is used by time-series commands to verify that the data have 
previously been {cmd:tsset}.  {cmd:_ts} does not check that the time 
variable is still consistent with the value of delta last recorded by 
{cmd:tsset}, nor does it perform any other consistency checks.  If 
the data have not been {cmd:tsset}, {cmd:_ts} exits with an error message.  If you 
specify the {opt onepanel} or {opt panel} option, the return code is 
459; otherwise, the return code is 111.


{marker options}{...}
{title:Options}

{phang}
{opt sort} requests that {cmd:_ts} re-sort the data by the panel 
variable (if previously declared) and the time variable.

{phang}
{opt panel} indicates that the command calling {cmd:_ts} can be used 
with panel data.  Here {cmd:_ts} verifies that both panel and time 
variables have been declared.  For panel-data applications, we 
recommend using {helpb _xt} instead, because it offers more flexibility and 
more sanity checking.

{phang}
{opt onepanel} indicates that the command calling {cmd:_ts} can be used 
with panel data if the {cmd:if} and {cmd:in} conditions restrict the 
estimation sample to a single panel of the panel dataset.


{marker remarks}{...}
{title:Remarks}

{pstd}
Suppose you are writing a new time-series command that requires the data 
be {cmd:tsset}.  {cmd:_ts} verifies that is the case.  Using {cmd:_ts} 
is much faster than having your command call {cmd:tsset}, because 
{cmd:_ts} does not perform any calculations on the data; it only checks 
that {bf:_dta[_TStvar]} is filled in.  When you specify the 
{opt onepanel} or {opt panel} option, it also checks 
{bf:_dta[_TSpanel]}.
{p_end}
