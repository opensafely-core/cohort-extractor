{smcl}
{* *! version 1.0.9  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] textstyle" "help textstyle"}{...}
{vieweralsosee "[G-4] clockposstyle" "help clockposstyle"}{...}
{vieweralsosee "[G-4] textsizestyle" "help textsizestyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] markerlabelstyle" "help markerlabelstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{viewerjumpto "Syntax" "labelstyle##syntax"}{...}
{viewerjumpto "Description" "labelstyle##description"}{...}
{viewerjumpto "Remarks" "labelstyle##remarks"}{...}
{title:Title}

{p2colset 5 25 27 2}{...}
{p2col :{hi:[G-4]} {it:labelstyle} {hline 2}}Choices for overall look of marker labels (scheme files version){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:labelstyle}{col 34}Description
	{hline 69}
	{cmd:p1}{hline 1}{cmd:p15}{...}
{col 34}used by first{hline 1}fifteenth twoway plot
	{cmd:p1box}{hline 1}{cmd:p15box}{...}
{col 34}used by first{hline 1}fifteenth "box" plot
	{hline 69}

{pin}
Other {it:labelstyles} may be available. Type

	    {cmd:.} {bf:{stata graph query labelstyle}}

{pin}
to obtain the complete list of {it:labelstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
{it:labelstyle} is a synonym for {it:{help markerlabelstyle}}, and sets
the {it:{help textstyle}} and {help clockposstyle:position} for a marker
label.  This entry provides a more formal definition than what is found in
{it:{help markerlabelstyle}} and is better suited for those creating 
{help scheme files}.



{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help labelstyle##remarks1:What is a labelstyle?}
	{help labelstyle##remarks1:What are numbered styles?}


{marker remarks1}{...}
{title:What is a labelstyle?}

{pstd}
The look of marker labels is defined by three attributes:

{phang2}
    1.  {it:textstyle} -- the look of the label text, including size,
    color, etc.;{break} see {manhelpi textstyle G-4}.

{phang2}
    2.  {it:clockposstyle} -- the position of the label relative
    	to the marker; {break}
	see {manhelpi clockposstyle G-4}.

{phang2}
    3.  {it:textsizestyle} -- the gap between the marker and the 
    	label; {break}
	see {manhelpi textsizestyle G-4}.

{pstd}
The {it:labelstyle} specifies all of these attributes.  


{marker remarks2}{...}
{title:What are numbered styles?}

{phang}
     {cmd:p1}{hline 1}{cmd:p15} are the default styles used for labeling the
     markers on {helpb graph twoway:twoway graphs}.  {cmd:p1} is used for the
     first set of marker labels, {cmd:p2} for the second, and so on.

{phang}
     {cmd:p1box}{hline 1}{cmd:p15box} are the default styles used for labeling
     the outside values on {help graph_box:box charts}.  {cmd:p1box} is used
     for the first set of outside values, {cmd:p2box} for the second, and so
     on.

{pstd}
        The "look" defined by a numbered style, such as {cmd:p1},
        {cmd:p2}, {cmd:p1box}, etc, is determined by the
        {help schemes:scheme} selected. By "look" we mean
        {help textstyle}, {help clockposstyle}, and {help textsizestyle}.
{p_end}
