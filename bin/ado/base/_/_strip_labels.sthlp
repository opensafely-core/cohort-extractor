{smcl}
{* *! version 1.0.6  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[P] _restore_labels" "help _restore_labels"}{...}
{viewerjumpto "Syntax" "_strip_labels##syntax"}{...}
{viewerjumpto "Description" "_strip_labels##description"}{...}
{viewerjumpto "Examples" "_strip_labels##examples"}{...}
{viewerjumpto "Stored results" "_strip_labels##results"}{...}
{title:Title}

{p 4 27 2}
{hi:[P] _strip_labels} {hline 2} remove value labels from variables


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_strip_labels} {varlist}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_strip_labels} is a programmer's tool that strips the value labels off the
variables in {it:varlist}.  


{marker examples}{...}
{title:Examples}

    {cmd}. sysuse auto, clear

    {cmd}. _strip_labels rep78 foreign 

    {cmd}. sreturn list

    {txt}macros:
               s(varlist) : "{res}foreign{txt}"
             s(labellist) : "{res}origin{txt}"

    {cmd}. d foreign

                  {txt}storage  display     value
    variable name   type   format      label      variable label
    {hline 60}
    foreign        {txt} byte   %8.0g                  Car type
    {reset}{...}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_strip_labels} stores the following in {cmd:s()}:

{p2colset 9 25 32 2}{...}
{pstd}Macros:{p_end}
{p2col :{cmd:s(varlist)}}list
	of variables whose value labels were removed{p_end}
{p2col :{cmd:s(labellist)}}the associated value label identifiers{p_end}
{p2colreset}{...}
