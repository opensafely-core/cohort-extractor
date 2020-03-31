{smcl}
{* *! version 1.0.5  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] findfile" "help findfile"}{...}
{vieweralsosee "[M-1] Source" "help m1_source"}{...}
{vieweralsosee "[P] viewsource" "help viewsource"}{...}
{viewerjumpto "Syntax" "copysource##syntax"}{...}
{viewerjumpto "Description" "copysource##description"}{...}
{viewerjumpto "Remarks" "copysource##remarks"}{...}
{title:Title}

{p 4 20 2}
{hi:[P] copysource} {hline 2} Copy source code to current directory


{marker syntax}{...}
{title:Syntax}

{phang}
{cmd:copysource} 
{it:filename}


{marker description}{...}
{title:Description}

{pstd}
{cmd:copysource} searches for {it:filename} along the {help sysdir:adopath}
and, if it is found, copies it to the current (working) directory.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:copysource} is much like {helpb viewsource}, but rather than displaying
the file in the Viewer, {cmd:copysource} copies the file to the current
directory.
{p_end}
