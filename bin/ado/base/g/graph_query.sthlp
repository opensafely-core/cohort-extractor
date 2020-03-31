{smcl}
{* *! version 1.1.8  15may2018}{...}
{viewerdialog "graph query" "dialog graph_query"}{...}
{vieweralsosee "[G-2] graph query" "mansection G-2 graphquery"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Schemes intro" "help schemes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] palette" "help palette"}{...}
{viewerjumpto "Syntax" "graph query##syntax"}{...}
{viewerjumpto "Menu" "graph query##menu"}{...}
{viewerjumpto "Description" "graph query##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_query##linkspdf"}{...}
{viewerjumpto "Remarks" "graph query##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-2] graph query} {hline 2}}List available schemes and styles{p_end}
{p2col:}({mansection G-2 graphquery:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:gr:aph}
{cmdab:q:uery},
{cmdab:sch:emes}

{p 8 16 2}
{cmdab:gr:aph}
{cmdab:q:uery}

{p 8 16 2}
{cmdab:gr:aph}
{cmdab:q:uery}
{it:stylename}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Manage graphs > Query styles and schemes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:query,} {cmd:schemes} lists the available schemes.

{pstd}
{cmd:graph} {cmd:query} without options lists the available styles.

{pstd}
{cmd:graph} {cmd:query} {it:stylename} lists the styles available within
{it:stylename}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphqueryQuickstart:Quick start}

        {mansection G-2 graphqueryRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
This manual may not be -- probably is not -- complete.  Schemes and
styles can be added by StataCorp via updates (see {manhelp update R}), by other
users and traded over the Internet (see {manhelp net R} and {manhelp ssc R}),
and by you.

{pstd}
Schemes define how graphs look (see {manhelp schemes G-4:Schemes intro}), and
styles define the features that are available to you (see
{manhelpi symbolstyle G-4} or {manhelpi linestyle G-4}).

{pstd}
To find out which schemes are installed on your computer, type

	{cmd:. graph query, schemes}

{pstd}
See {manhelp schemes G-4:Schemes intro} for information on schemes and how to
use them.

{pstd}
To find out which styles are installed on your computer, type

	{cmd:. graph query}

{pstd}
Many styles will be listed.  How you use those styles is described in this
manual.  For instance, one of the styles that will be listed is
{it:symbolstyle}.  See {manhelpi symbolstyle G-4} for more information on
symbol styles.  To find out which symbol styles are available to you, type

	{cmd:. graph query symbolstyle}

{pstd}
All styles end in "{it:style}", and you may omit typing that part:{p_end}

	{cmd:. graph query symbol}
