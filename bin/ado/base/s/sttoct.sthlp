{smcl}
{* *! version 1.1.5  19sep2018}{...}
{vieweralsosee "[ST] sttoct" "mansection ST sttoct"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] ct" "help ct"}{...}
{vieweralsosee "[ST] st_is" "help st_is"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] sttocc" "help sttocc"}{...}
{viewerjumpto "Syntax" "sttoct##syntax"}{...}
{viewerjumpto "Description" "sttoct##description"}{...}
{viewerjumpto "Links to PDF documentation" "sttoct##linkspdf"}{...}
{viewerjumpto "Options" "sttoct##options"}{...}
{viewerjumpto "Example" "sttoct##example"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[ST] sttoct} {hline 2}}Convert survival-time data to count-time data{p_end}
{p2col:}({mansection ST sttoct:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:sttoct} {it:newfailvar} {it:newcensvar} [{it:newentvar}]
	[{cmd:,} {it:options}]


{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt :{opth by(varlist)}}reflect counts by group, where groups are defined by observations with equal values of {it:varlist}{p_end}
{synopt :{opt replace}}proceed with transformation, even if current data are not saved{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:sttoct}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified
using {cmd:stset}; see {manhelp stset ST}.{p_end}
{p 4 6 2}
There is no dialog-box interface for {cmd:sttoct}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:sttoct} converts survival-time (st) data to count-time (ct) data; see
{manhelp ct ST}.

{pstd}
At present, there is absolutely no reason that you would want to do this. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST sttoctQuickstart:Quick start}

        {mansection ST sttoctRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth by(varlist)} specifies that counts reflect counts by group where the
groups are defined by observations with equal values of {it:varlist}.

{phang}
{opt replace} specifies that it is okay to proceed with the transformation, even
though the current dataset has not been saved on disk.

{phang}
{opt noshow} prevents {cmd:sttoct} from showing the key st variables.  This
option is seldom used because most people type {cmd:stset, show} or
{cmd:stset, noshow} to set whether they want to see these variables mentioned
at the top of every st command; see {manhelp stset ST}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sttoct}

{pstd}Show st settings{p_end}
{phang2}{cmd:. st}

{pstd}Convert survival-time data to count-time data{p_end}
{phang2}{cmd:. sttoct ndead2 ncens2}{p_end}
