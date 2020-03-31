{smcl}
{* *! version 1.0.8  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime" "help datetime"}{...}
{viewerjumpto "Syntax" "_confirm_date##syntax"}{...}
{viewerjumpto "Description" "_confirm_date##description"}{...}
{viewerjumpto "Example" "_confirm_date##example"}{...}
{title:Title}

{p 4 27 2}
{hi:[P] _confirm_date} {hline 2} Tool for confirming that a date string is given
in a valid format


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_confirm_date} {it:time_format} {it:date_string}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_confirm_date} is a programmer's tool used for verifying
that a given date string is valid, given the time format specified.


{marker example}{...}
{title:Example}

{pstd}{cmd:. _confirm_date %tq 1995q3}{p_end}
