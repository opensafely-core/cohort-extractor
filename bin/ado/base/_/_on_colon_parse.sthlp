{smcl}
{* *! version 1.0.6  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] gettoken" "help gettoken"}{...}
{vieweralsosee "[P] _prefix" "help _prefix"}{...}
{viewerjumpto "Syntax" "_on_colon_parse##syntax"}{...}
{viewerjumpto "Description" "_on_colon_parse##description"}{...}
{viewerjumpto "Examples" "_on_colon_parse##examples"}{...}
{viewerjumpto "Stored results" "_on_colon_parse##results"}{...}
{title:Title}

{p 4 25 2}
{hi:[P] _on_colon_parse} {hline 2} Splitting text on the colon character


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_on_colon_parse} [{it:text_before}] {cmd::} [{it:text_after}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_on_colon_parse} is a programmer's tool, written for the purpose of parsing
prefix commands, see {helpb _prefix}.


{marker examples}{...}
{title:Examples}

{pstd}{cmd:. _on_colon_parse :}{p_end}
{pstd}{cmd:. sreturn list}{p_end}

{pstd}{cmd:. _on_colon_parse stuff before : stuff after}{p_end}
{pstd}{cmd:. sreturn list}{p_end}

    {txt}macros:
                 s(after) : "{res} stuff after{txt}"
                s(before) : "{res}stuff before {txt}"


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_on_colon_parse} stores the following in {cmd:s()}:

{phang}
Macros:{p_end}
{col 8}{cmd:s(before)}{col 20}{it:text_before}
{col 8}{cmd:s(after)}{col 20}{it:text_after}
