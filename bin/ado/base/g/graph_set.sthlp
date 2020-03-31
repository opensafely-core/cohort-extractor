{smcl}
{* *! version 1.4.3  19oct2017}{...}
{vieweralsosee "[G-2] graph set" "mansection G-2 graphset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph print" "help graph_print"}{...}
{vieweralsosee "[G-3] eps_options" "help eps_options"}{...}
{vieweralsosee "[G-3] pr_options" "help pr_options"}{...}
{vieweralsosee "[G-3] ps_options" "help ps_options"}{...}
{vieweralsosee "[G-3] svg_options" "help svg_options"}{...}
{vieweralsosee "[G-4] text" "help graph_text"}{...}
{viewerjumpto "Syntax" "graph set##syntax"}{...}
{viewerjumpto "Description" "graph set##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_set##linkspdf"}{...}
{viewerjumpto "Remarks" "graph set##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-2] graph set} {hline 2}}Set graphics options{p_end}
{p2col:}({mansection G-2 graphset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Manage graph print settings

{p 8 16 2}
{cmdab:gr:aph} {cmd:set} {cmd:print} [{it:setopt} {it:setval}]


{phang}Manage graph export settings

{p 8 16 2}
{cmdab:gr:aph} {cmd:set} [{it:exporttype}] [{it:setopt} {it:setval}]

    where {it:exporttype} is the export file type and may be one of 

{p 8 16 2}
{cmd:ps} | {cmd:eps} | {cmd:svg}

    and {it:setopt} is the option to set with the setting {it:setval}.


{phang}Manage Graph window font settings

        {cmdab:gr:aph} {cmd:set} {cmd:window} {cmd:fontface}       {c -(} {it:fontname} | {cmd:default} {c )-}
        {cmdab:gr:aph} {cmd:set} {cmd:window} {cmd:fontfacemono}   {c -(} {it:fontname} | {cmd:default} {c )-}
        {cmdab:gr:aph} {cmd:set} {cmd:window} {cmd:fontfacesans}   {c -(} {it:fontname} | {cmd:default} {c )-}
        {cmdab:gr:aph} {cmd:set} {cmd:window} {cmd:fontfaceserif}  {c -(} {it:fontname} | {cmd:default} {c )-}
        {cmdab:gr:aph} {cmd:set} {cmd:window} {cmd:fontfacesymbol} {c -(} {it:fontname} | {cmd:default} {c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:set} without options lists the current graphics font,
print, and export settings for all {it:exporttype}s. {cmd:graph set} with
{cmd:window}, {cmd:print}, or {it:exporttype} lists the current
settings for the Graph window, for printing, or for the specified
{it:exporttype}, respectively.

{pstd}
{cmd:graph} {cmd:set} {cmd:print} allows you to change the print
settings for graphics.

{pstd}
{cmd:graph} {cmd:set} {it:exporttype} allows you to change the graphics export
settings for export file type {it:exporttype}.

{pstd}
{cmd:graph} {cmd:set} {cmd:window} {cmd:fontface}{it:*} allows you to change the
Graph window font settings.  (To change font settings for graphs
exported to PostScript, Encapsulated PostScript, or Scalable Vector
Graphic files, use
{cmd:graph} {cmd:set} {c -(}{cmd:ps}|{cmd:eps}|{cmd:svg}{c )-}
{cmd:fontface}{it:*}; see
{manhelpi ps_options G-3}, {manhelpi eps_options G-3}, or
{manhelpi svg_options G-3}.)  If {it:fontname}
contains spaces, enclose it in double quotes.  If you specify {cmd:default}
for any of the {cmd:fontface}{it:*} settings, the default setting will
be restored.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphsetQuickstart:Quick start}

        {mansection G-2 graphsetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

            {help graph_set##remarks1:Overview}
            {help graph_set##remarks2:Setting defaults}


{marker remarks1}{...}
{title:Overview}

{pstd}
{cmd:graph set} allows you to permanently set the primary font face used in
the Graph window as well as the font faces to be used for the four Stata
"font faces" supported by the graph SMCL tags {cmd:{c -(}stMono{c )-}},
{cmd:{c -(}stSans{c )-}}, {cmd:{c -(}stSerif{c )-}}, and
{cmd:{c -(}stSymbol{c )-}}.  See {manhelpi graph_text G-4:text} for more details
on these SMCL tags.

{pstd}
{cmd:graph set} also allows you to permanently set any of the options supported
by {cmd:graph print} (see {manhelp graph_print G-2:graph print}) or by the
specific export file types provided by {cmd:graph export} (see
{manhelp graph_export G-2:graph export}).

{pstd}
To find out more about the {cmd:graph} {cmd:set} {cmd:print} {it:setopt}
options and their associated values ({it:setval}), see
{manhelpi pr_options G-3}.

{pstd}
Some graphics file types supported by {helpb graph export} have
options that can be set.  The file types that allow option settings and their
associated {it:exporttype}s are

	{it:exporttype}{col 21}Description{col 50}Available settings
	{hline 60}
	{cmd:ps}{...}
{col 21}PostScript{col 50}{manhelpi ps_options G-3}
	{cmd:eps}{...}
{col 21}Encapsulated PostScript{col 50}{manhelpi eps_options G-3}
	{cmd:svg}{...}
{col 21}Scalable Vector Graphics{col 50}{manhelpi svg_options G-3}
	{hline 60}


{marker remarks2}{...}
{title:Setting defaults}

{pstd}
If you always want the Graph window to use Times New Roman as its
default font, you could type

{phang2}
{cmd:. graph set window fontface "Times New Roman"}

{pstd}
Later, you could type

{phang2}
{cmd:. graph set window fontface default}

{pstd}
to restore the factory setting. 

{pstd}
To change the font used by {cmd:{stMono}} in the Graph window, you
could type

{phang2}
{cmd:. graph set window fontfacemono "Lucida Console"}

{pstd}
and to reset it, you could type

{phang2}
{cmd:. graph set window fontfacemono default}

{pstd}
You can list the current graph settings by typing

{phang2}
{cmd:. graph set}{p_end}
