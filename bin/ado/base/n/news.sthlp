{smcl}
{* *! version 1.2.8  28may2019}{...}
{viewerdialog news news}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{viewerjumpto "Syntax" "help news##syntax"}{...}
{viewerjumpto "Menu" "help news##menu"}{...}
{viewerjumpto "Description" "help news##description"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] news} {hline 2}}Report Stata news{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rnews.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}


{pstd}
{cmd:news}, as of Stata 16, is no longer an official part of Stata.  The
content feed for the old {cmd:news} command will not be kept current.  To see
the latest Stata news, visit {browse "https://www.stata.com/news/"}.

{pstd}
This is the original help file, which we will no longer update, so some links
may no longer work.


{marker syntax}{...}
{title:Syntax}

	{cmd:news}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Help > News}


{marker description}{...}
{title:Description}

{pstd}
{cmd:news} displays a brief listing of recent Stata news and information,
which it obtains from Stata's website.
{cmd:news} requires that your computer be connected to the
Internet.
{p_end}
