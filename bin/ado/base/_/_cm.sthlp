{smcl}
{* *! version 1.0.2  29oct2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_cm##syntax"}{...}
{viewerjumpto "Description" "_cm##description"}{...}
{viewerjumpto "Options" "_cm##options"}{...}
{viewerjumpto "Remarks" "_cm##remarks"}{...}
{viewerjumpto "Stored results" "_cm##results"}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col:{hi:[CM] _cm} {hline 2}}Programmer's command to verify that data are
cmset{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:_cm} [{cmd:,} {it:options}]

{synoptset 13}{...}
{synopthdr}
{synoptline}
{synopt: {opt altrequired}}caller requires that an alternatives variable
be set{p_end}
{synopt: {opt panel}}give appropriate error messages for panel data{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_cm} is used by {cmd:cm} commands to verify that the data have
been {cmd:cmset}.


{marker options}{...}
{title:Options}

{phang}
{opt altrequired} specifies that an error message is to be issued if an
alternatives variable has not been {cmd:cmset}.  By default, an alternatives
variable in the {cmd:cmset} settings is optional.

{phang}
{opt panel} indicates that the caller is a {cmd:cm} command for panel data.
If an error message is found in the {cmd:cmset} settings, this option
specifies that an error message worded appropriately for panel data be issued.
By default, error messages are worded appropriately for cross-sectional data.
This option only affects the wording of error messages.  It does not require
the {cmd:cmset} settings to be for panel data.


{marker remarks}{...}
{title:Remarks}

{pstd}
The {cmd:_cm} command is used by {cmd:cm} commands to verify that the
data have been {cmd:cmset}.

{pstd}
{cmd:_cm} verifies whether the data have been {cmd:cmset} by
checking the characteristics {cmd:_dta[_cm_*]}.  These characteristics
contain variable names, and {cmd:_cm} checks whether these
variables exist in the data.  These are the only checks {cmd:_cm}
performs.

{pstd}
Behavior depends on the options specified.

{phang2}1.  Coding

{pin3}
{cmd:_cm}

{pmore2}
by itself tells {cmd:_cm} to verify that the data have been {cmd:cmset}
with or without an alternatives variable.
Error messages (if any) are worded appropriately
for cross-sectional data.

{phang2}2.  Coding

{pin3}
{cmd:_cm, altrequired}

{pmore2}
tells {cmd:_cm} to verify that the data have been {cmd:cmset}
with an alternatives variable.

{phang2}3.  Coding

{pin3}
{cmd:_cm, panel}

{pmore2}
tells {cmd:_cm} to issue error messages (if any) worded appropriately
for panel data.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_cm} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(caseid)}}name of case ID variable{p_end}
{synopt:{cmd:r(altvar)}}name of alternatives variable, if any{p_end}
{synopt:{cmd:r(panelvar)}}name of panel variable constructed by {cmd:cmset},
if any{p_end}
{synopt:{cmd:r(origpanelvar)}}name of original panel variable passed as an
argument to {cmd:cmset}, if any{p_end}
{synopt:{cmd:r(timevar)}}name of time variable, if any{p_end}
{p2colreset}{...}
