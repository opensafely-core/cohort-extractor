{smcl}
{* *! version 1.3.8  15oct2018}{...}
{viewerdialog search "search_d"}{...}
{vieweralsosee "[R] search" "mansection R search"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{vieweralsosee "[R] net search" "help net"}{...}
{viewerjumpto "Syntax" "search##syntax"}{...}
{viewerjumpto "Menu" "search##menu"}{...}
{viewerjumpto "Description" "search##description"}{...}
{viewerjumpto "Links to PDF documentation" "search##linkspdf"}{...}
{viewerjumpto "Options for search" "search##options"}{...}
{viewerjumpto "Option for set searchdefault" "search##options_searchdefault"}{...}
{viewerjumpto "Examples" "search##examples"}{...}
{viewerjumpto "Advice on using search" "search##advice"}{...}
{viewerjumpto "Looking up error messages" "search##error_msgs"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] search} {hline 2}}Search Stata documentation and other resources{p_end}
{p2col:}({mansection R search:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:search}
{it:word}
[{it:word} {it:...}]
[{cmd:,}
{it:search_options}]

{p 8 11 2}
{cmd:set searchdefault}
{c -(}{opt all}|{opt local}|{opt net}{c )-}
[{cmd:,} {opt perm:anently}]

{synoptset 14}
{synopthdr:search_options}
{synoptline}
{synopt:{opt all}}search across both the local keyword database and the
{opt net} material; the default{p_end}
{synopt:{opt local}}search using Stata's keyword database{p_end}
{synopt:{opt net}}search across materials available via Stata's {opt net}
command{p_end}

{synopt:{opt a:uthor}}search by author's name{p_end}
{synopt:{opt ent:ry}}search by entry ID{p_end}
{synopt:{opt ex:act}}search across both the local keyword database and the
{opt net} materials; prevents matching on abbreviations{p_end}
{synopt:{opt faq}}search the FAQs posted to the Stata website{p_end}
{synopt:{opt h:istorical}}search entries that are of historical interest
only{p_end}
{synopt:{opt or}}list an entry if any of the words typed after {opt search}
are associated with the entry{p_end}
{synopt:{opt man:ual}}search the entries in the Stata Documentation{p_end}
{synopt:{opt sj}}search the entries in the Stata Journal and the
STB{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Help > Search...} 


{marker description}{...}
{title:Description}

{pstd}
{opt search} searches a keyword database and the Internet for Stata
materials related to your query.

{pstd}
Capitalization of words following {opt search} is irrelevant, as is the
inclusion or exclusion of special characters such as commas and hyphens.

{pstd}
{opt set searchdefault} affects the default behavior of the {opt search}
command.  {opt all} is the default.

{pstd}
{opt search, all} is the best way to search for information on a topic across
all sources, including the system help, the FAQs at the Stata website,
the {bf:Stata Journal}, and all Stata-related Internet sources
including community-contributed additions.  From the results, you can click to
go to a source or to install additions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R searchQuickstart:Quick start}

        {mansection R searchRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options for search}

{phang}
{opt all}, the default (unless changed by {opt set searchdefault}),
specifies that the search be performed across both the local keyword
database and the {opt net} materials.
The results of a search performed with {opt all} and no other
options will be displayed in the {help view:Viewer}.

{phang}
{opt local} specifies that the search be performed using only Stata's keyword
database.  The results of a search performed with {opt local} and no other
options will be displayed in the {help view:Viewer}.

{phang}
{opt net} specifies that the search be performed across the materials
available via Stata's {opt net} command.  Using
{opt search} {it:word} [{it:word} {it:...}]{opt , net} is equivalent to typing
{opt net search} {it:word} [{it:word} {it:...}] (without options); see 
{manhelp net R}.  The results of a search performed with {opt net} and
no other options will be displayed in the {help view:Viewer}.

{phang}
{opt author} specifies that the search be performed on the basis of the
author's name rather than keywords.  A search with the {opt author} option is
performed on the local keyword database only, and the results are displayed
in the Results window.

{phang}
{opt entry} specifies that the search be performed on the basis of entry
IDs rather than keywords.  A search with the {opt entry} option is performed
on the local keyword database only, and the results are displayed
in the Results window.

{phang}
{opt exact} prevents matching on abbreviations.  A search with the {opt exact}
option is performed across both the local keyword database and the {opt net}
materials, and the results are displayed in the Results window.

{phang}
{opt faq} limits the search to the FAQs posted on the Stata website:
{browse "https://www.stata.com"}.  A search with the {opt faq} option is
performed on the local keyword database only, and the results are displayed
in the Results window.

{phang}
{opt historical} adds to the search entries that are of historical
interest only.  By default, such entries are not listed.  Past entries are
classified as historical if they discuss a feature that later became an
official part of Stata.  Updates to historical entries will always be found,
even if {opt historical} is not specified.  A search with the {opt historical}
option is performed on the local keyword database only, and the results are
displayed in the Results window.

{phang}
{opt or} specifies that an entry be listed if any of the words typed
after {opt search} are associated with the entry.  The default is to list the
entry only if all the words specified are associated with the entry.  A search
with the {opt or} option is performed on the local keyword database only, and
the results are displayed in the Results window.

{phang}
{opt manual} limits the search to entries in the Stata Documentation;
that is, the search is limited to the {it:User's Guide} and all the
reference manuals.  A search with the {opt manual} option is performed on the
local keyword database only, and the results are displayed in the Results
window.

{phang}
{opt sj} limits the search to entries in the {it:Stata Journal} and its
predecessor, the {it:Stata Technical Bulletin}; see {manhelp sj R}.  A search
with the {opt sj} option is performed on the local keyword database only,
and the results are displayed in the Results window.


{marker options_searchdefault}{...}
{title:Option for set searchdefault}

{phang}
{opt permanently} specifies that, in addition to making the change right now,
the {opt searchdefault} setting be remembered and become the default setting
when you invoke Stata.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. search kolmogorov-smirnov equality of distribution test}{p_end}
{phang}{cmd:. search normal distribution}{p_end}
{phang}{cmd:. search linear regression}{p_end}
{phang}{cmd:. search regression}{p_end}
{phang}{cmd:. search [R], entry}{p_end}
{phang}{cmd:. search STB-16, entry historical}{p_end}
{phang}{cmd:. search Salgado-Ugarte, author}


{marker advice}{...}
{title:Advice on using search}

{pstd}
See {help searchadvice} for details.


{marker error_msgs}{...}
{title:Looking up error messages}

{pstd}
In addition to serving as an index, {cmd:search} knows Stata's return codes
and can offer longer explanations than the commands issuing the errors do
themselves.  For instance, say that you use {cmd:test} and,

	{cmd:. test} {it:...}
	{err:not possible with test}
	{search r(131):r(131);}

{pstd}
131 is called the return code.  To obtain more information on 131, type

	{cmd:. search rc 131}
