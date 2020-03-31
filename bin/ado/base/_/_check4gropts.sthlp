{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] _get_gropts" "help _get_gropts"}{...}
{viewerjumpto "Syntax" "_check4gropts##syntax"}{...}
{viewerjumpto "Description" "_check4gropts##description"}{...}
{viewerjumpto "Option" "_check4gropts##option"}{...}
{viewerjumpto "Examples" "_check4gropts##examples"}{...}
{title:Title}

{p 4 23 2}
{hi:[G] _check4gropts} {hline 2} Parsing tool for graph commands


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:_check4gropts} {it:opt_name} [, {cmdab:opt:s:(}{it:options}{cmd:)} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_check4gropts} displays an error message when certain options are
supplied in {cmd:opts()}.  The purpose of this tool is to provide a way for
graph producing commands to quit early when supplied with options that are not
allowed.

{pstd}
The current list of options that {cmd:_check4gropts} checks for is

{pin2}
	{cmd:by()}
	{cmd:name()}
	{cmd:saving()}


{marker option}{...}
{title:Option}

{phang}
{cmd:opts(}{it:options}{cmd:)} contains the options to be parsed.


{marker examples}{...}
{title:Examples}

    {cmd}. cap noi _check4gropts ciopts, opts(by(for, total))
    {err}option ciopts() does not allow the by() option
    {txt}{search r(191):r(191);}

    {cmd}. cap noi _check4gropts ciopts, opts(name(stuff))
    {err}option ciopts() does not allow the name() option
    {txt}{search r(198):r(198);}
