{smcl}
{* *! version 1.0.6  11may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Data types" "help data_types"}{...}
{vieweralsosee "[D] format" "help format"}{...}
{viewerjumpto "Syntax" "inten##syntax"}{...}
{viewerjumpto "Description" "inten##description"}{...}
{viewerjumpto "Examples" "inten##examples"}{...}
{viewerjumpto "Stored results" "inten##results"}{...}
{viewerjumpto "Bugs" "inten##bugs"}{...}
{title:Title}

{p 4 20 2}
{hi:[P] inbase} {hline 2} Base conversion


{marker syntax}{...}
{title:Syntax}

	{cmd:inbase} {it:#1} {it:#2}

	{cmd:inten}  {it:#1} {it:#2}

{phang}
where{break}
{it:#1} is the base integer and {it:#2} is the integer to be converted.{break}
{it:#1} must be between 2 and 62, inclusive.


{marker description}{...}
{title:Description}

{pstd}
{cmd:inbase} converts decimal integers to the specified base.

{pstd}
{cmd:inten} converts integers of the specified base into decimal integers.


{marker examples}{...}
{title:Examples}

	{cmd:. inbase 16 29}
	1d

	{cmd:. inbase 2 29}
	11101

	{cmd:. inten 16 1d}
	29

	{cmd:. inten 2 11101}
	29


{marker results}{...}
{title:Stored results}

    {cmd:inten} returns

	scalar {cmd:r(ten)}    containing integer in base 10

    {cmd:inbase} returns

	local  {cmd:r(base)}   containing integer in specified base


{marker bugs}{...}
{title:Bugs}

{pstd}
{cmd:inten} does not verify that you do not use digits beyond the base.
For instance, you can type {cmd:inten 16 1g}.
{p_end}
