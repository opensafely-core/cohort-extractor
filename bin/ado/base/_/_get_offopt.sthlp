{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "_get_offopt##syntax"}{...}
{viewerjumpto "Description" "_get_offopt##description"}{...}
{viewerjumpto "Option" "_get_offopt##option"}{...}
{viewerjumpto "Examples" "_get_offopt##examples"}{...}
{title:Title}

{pstd}
{hi:[P] _get_offopt} {hline 2}
Parsing tool for getting offset option specification


{marker syntax}{...}
{title:Syntax}

{pstd}
Standard offset variable syntax:

{phang2}
{cmd:_get_offopt} [{it:varname}] [{cmd:,} {opt noconfirm}]


{pstd}
Exposure variable syntax (also known as log offset):

{phang2}
{cmd:_get_offopt} [{opt ln(varname)}] [{cmd:,} {opt noconfirm}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_get_offopt} is a programming tool that helps identify which option was
used to specify an offset in an estimation command, based on what is typically
put in {cmd:e(offset)}.  Basically, {cmd:_get_offopt} looks at the supplied
argument and returns the associated option in {cmd:s(offopt)}.
{it:varname} is returned in {cmd:s(offvar)}.


{marker option}{...}
{title:Option}

{phang}
{opt noconfirm} prevents {cmd:_get_offopt} from confirming that {it:varname}
exists.


{marker examples}{...}
{title:Examples}

    {cmd}. sysuse auto, clear
    {txt}(1978 Automobile Data)

    {cmd}. quietly poisson mpg turn trunk, exposure(gear)
    {txt}
    {cmd}. di "`e(offset)'"
    {res}ln(gear_ratio)
    {txt}
    {cmd}. _get_offopt `e(offset)'
    {txt}
    {cmd}. sreturn list

    {txt}macros:
                s(offvar) : "{res}gear_ratio{txt}"
                s(offopt) : "{res}exposure(gear_ratio){txt}"
