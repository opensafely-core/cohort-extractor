{smcl}
{* *! version 1.1.8  15oct2018}{...}
{vieweralsosee "[G-4] Scheme economist" "mansection G-4 Schemeeconomist"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Schemes intro" "help schemes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] set scheme" "help set_scheme"}{...}
{vieweralsosee "[G-3] scheme_option" "help scheme_option"}{...}
{viewerjumpto "Syntax" "scheme_economist##syntax"}{...}
{viewerjumpto "Description" "scheme_economist##description"}{...}
{viewerjumpto "Links to PDF documentation" "scheme_economist##linkspdf"}{...}
{viewerjumpto "Remarks" "scheme_economist##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[G-4] Scheme economist} {hline 2}}Scheme description:  economist{p_end}
{p2col:}({mansection G-4 Schemeeconomist:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:schemename}{col 22}Foreground{col 36}Background{col 48}Description
	{hline 70}
	{cmd:economist}{...}
{col 22}color{...}
{col 36}white{...}
{col 48}{it:The Economist} magazine
	{hline 70}

{pstd}
For instance, you might type

{p 8 16 2}
{cmd:. graph}
...{cmd:,}
...
{cmd:scheme(economist)}

{p 8 16 2}
{cmd:. set}
{cmd:scheme}
{cmd:economist}
[{cmd:,}
{cmdab:perm:anently}]

{pstd}
See {manhelpi scheme_option G-3} and {manhelp set_scheme G-2:set scheme}.


{marker description}{...}
{title:Description}

{pstd}
Schemes determine the overall look of a graph; see
{manhelp schemes G-4:Schemes intro}.

{pstd}
Scheme {cmd:economist} specifies a look similar to that used by
{it:The Economist} magazine.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 SchemeeconomistRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:The Economist} magazine ({browse "https://www.economist.com"}) uses a
unique and clean graphics style that is both worthy of emulation and
different enough from the usual to provide an excellent example of just how
much difference the scheme can make.

{pstd}
Among other things, {it:The Economist} puts the {it:y} axis on the right
rather than on the left of scatterplots.
{p_end}

{pstd}
For an example, see
{mansection G-4 SchemesintroRemarksandexamplesExamplesofschemes:{it:Examples of schemes}} 
in {it:Remarks and examples} of {bf:[G-4] Schemes intro}.
{p_end}
