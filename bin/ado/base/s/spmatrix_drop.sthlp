{smcl}
{* *! version 1.1.5  23jun2019}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix drop" "mansection SP spmatrixdrop"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix summarize" "help spmatrix summarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] clear" "help clear"}{...}
{vieweralsosee "[M] mata" "mansection M-0 Mata"}{...}
{viewerjumpto "Syntax" "spmatrix_drop##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_drop##menu"}{...}
{viewerjumpto "Description" "spmatrix_drop##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_drop##linkspdf"}{...}
{viewerjumpto "Example" "spmatrix_drop##example"}{...}
{viewerjumpto "Stored results" "spmatrix_drop##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[SP] spmatrix drop} {hline 2}}List and delete weighting
matrices stored in memory{p_end}
{p2col:}({mansection SP spmatrixdrop:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax} 

{phang}
List the Sp weighting matrices stored in memory

{p 8 14 2}
{cmd:spmatrix dir}


{phang}
Drop an Sp matrix from memory

{p 8 14 2}
{cmd:spmatrix drop} {it:spmatname}


{phang}
Drop all weighting matrices from memory

{p 8 14 2}
{cmd:spmatrix clear}


{phang}
{it:spmatname} is the name of an Sp weighting matrix stored in memory.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:dir} lists the Sp weighting matrices stored in memory.  

{pstd}
{cmd:spmatrix} {cmd:drop} deletes a single Sp matrix from memory.

{pstd}
{cmd:spmatrix} {cmd:clear} deletes all Sp matrices from memory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixdropQuickstart:Quick start}

        {mansection SP spmatrixdropRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge_shp.dta .}
{p_end}
{phang2}{cmd:. use texas_merge}
{p_end}
{phang2}{cmd:. spmatrix create contiguity W}
{p_end}
{phang2}{cmd:. spmatrix create contiguity M, normalize(row) second(0.5)}
{p_end}
{phang2}{cmd:. spmatrix create idistance W, replace}

{pstd}List all weighting matrices stored in memory{p_end}
{phang2}{cmd:. spmatrix dir}

{pstd}Drop weighting matrix {cmd:M}{p_end}
{phang2}{cmd:. spmatrix drop M}

{pstd}Drop all weighting matrices{p_end}
{phang2}{cmd:. spmatrix clear}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spmatrix} {cmd:dir} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt :{cmd:r(names)}}space-separated list of matrix names{p_end}
{p2colreset}{...}
