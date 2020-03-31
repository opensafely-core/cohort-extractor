{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix summarize" "mansection SP spmatrixsummarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{viewerjumpto "Syntax" "spmatrix_summarize##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_summarize##menu"}{...}
{viewerjumpto "Description" "spmatrix_summarize##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_summarize##linkspdf"}{...}
{viewerjumpto "Option" "spmatrix_summarize##option"}{...}
{viewerjumpto "Examples" "spmatrix_summarize##examples"}{...}
{viewerjumpto "Stored results" "spmatrix_summarize##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[SP] spmatrix summarize} {hline 2}}Summarize weighting matrix
stored in memory{p_end}
{p2col:}({mansection SP spmatrixsummarize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:summarize}
{it:spmatname} 
[{cmd:,} {opth gen:erate(newvar)}]

{phang}
{it:spmatname} is the name of a weighting matrix.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:summarize} reports the summary values of the
elements of a weighting matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixsummarizeQuickstart:Quick start}

        {mansection SP spmatrixsummarizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opth generate(newvar)} adds new variable {it:newvar} to the data.
It contains the number of neighbors for each observation.  {cmd:generate()}
may be specified only when {cmd:spmatrix} {cmd:summarize} or {cmd:spmatrix}
{cmd:dir} report that the matrix is a contiguity matrix.  See
{manhelp sp_glossary SP:Glossary} for a definition of
{help sp_glossary##contiguity_matrix:ex post contiguity matrices}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge_shp.dta .}
{p_end}
{phang2}{cmd:. use texas_merge}

{pstd}Create spectral-normalized contiguity weighting matrix{p_end}
{phang2}{cmd:. spmatrix create contiguity W}

{pstd}Create spectral-normalized inverse-distance weighting matrix{p_end}
{phang2}{cmd:. spmatrix create idistance Wd}

{pstd}Display summary statistics for spectral-normalized contiguity weighting
matrix{p_end}
{phang2}{cmd:. spmatrix summarize W}

{pstd}Display summary statistics for inverse-distance weighting matrix{p_end}
{phang2}{cmd:. spmatrix summarize Wd}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spmatrix} {cmd:summarize} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt :{cmd:r(n)}}number of rows (columns){p_end}
{synopt :{cmd:r(min)}}elements: minimum value{p_end}
{synopt :{cmd:r(mean)}}elements: mean value{p_end}
{synopt :{cmd:r(min0)}}elements: minimum of elements > 0{p_end}
{synopt :{cmd:r(max)}}elements: maximum value{p_end}

{p2col 5 18 22 2: Macros}{p_end}
{synopt :{cmd:r(type)}}type of matrix: {cmd:contiguity}, {cmd:idistance}, or
{cmd:custom}{p_end}
{synopt :{cmd:r(normalization)}}type of normalization{p_end}

{pstd}
If {cmd:r(type)} = {cmd:contiguity}, also stored are 

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(n_min)}}neighbors: minimum value{p_end}
{synopt :{cmd:r(n_mean)}}neighbors: mean value{p_end}
{synopt :{cmd:r(n_max)}}neighbors: maximum values{p_end}
{p2colreset}{...}
