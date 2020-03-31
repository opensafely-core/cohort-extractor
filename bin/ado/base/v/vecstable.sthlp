{smcl}
{* *! version 1.1.15  19oct2017}{...}
{viewerdialog vecstable "dialog vecstable"}{...}
{vieweralsosee "[TS] vecstable" "mansection TS vecstable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] vec" "help vec"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "vecstable##syntax"}{...}
{viewerjumpto "Menu" "vecstable##menu"}{...}
{viewerjumpto "Description" "vecstable##description"}{...}
{viewerjumpto "Links to PDF documentation" "vecstable##linkspdf"}{...}
{viewerjumpto "Options" "vecstable##options"}{...}
{viewerjumpto "Examples" "vecstable##examples"}{...}
{viewerjumpto "Stored results" "vecstable##results"}{...}
{viewerjumpto "Reference" "vecstable##reference"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TS] vecstable} {hline 2}}Check the stability condition of VECM estimates{p_end}
{p2col:}({mansection TS vecstable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}
{cmd:vecstable} [{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt est:imates(estname)}}use previously stored results {it:estname};
  default is to use active results{p_end}
{synopt :{opt a:mat(matrix_name)}}save the companion matrix as
  {it:matrix_name}{p_end}
{synopt :{opt gra:ph}}graph eigenvalues of the companion matrix{p_end}
{synopt :{opt d:label}}label eigenvalues with the distance from the unit
  circle{p_end}
{synopt :{opt mod:label}}label eigenvalues with the modulus{p_end}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of reference unit
  circle{p_end}
{synopt :{opt nogri:d}}suppress polar grid circles{p_end}
{synopt :{opt pgrid}{cmd:(}[...]{cmd:)}}specify radii and appearance of
  polar grid circles; see {it:{help vecstable##pgrid:Options}} for details
  {p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in 
   {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:vecstable} can be used only after {cmd:vec}; see
{helpb vec:[TS] vec}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > VEC diagnostics and tests >}
     {bf:Check stability condition of VEC estimates}


{marker description}{...}
{title:Description}

{pstd}
{cmd:vecstable} checks the eigenvalue stability condition in a vector
error-correction model (VECM) fit using {cmd:vec}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS vecstableQuickstart:Quick start}

        {mansection TS vecstableRemarksandexamples:Remarks and examples}

        {mansection TS vecstableMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt estimates(estname)} requests that {cmd:vecstable} use the previously
obtained set of {cmd:vec} estimates stored as {it:estname}.  By default, 
{cmd:vecstable} uses the active results.  See {manhelp estimates R} for
information on manipulating estimation results.

{phang}
{opt amat(matrix_name)} specifies a valid Stata matrix name by which the
companion matrix can be saved.  The companion matrix is referred to as the
{bf:A} matrix in {help vecstable##L2005:L{c u:}tkepohl (2005)} and
{helpb varstable:[TS] varstable}.
The default is not to save the companion matrix.

{phang}
{opt graph} causes {cmd:vecstable} to draw a graph of the eigenvalues of the
companion matrix.

{phang}
{opt dlabel} labels the eigenvalues with their distances from the unit
circle.  {opt dlabel} cannot be specified with {opt modlabel}.

{phang}
{opt modlabel} labels the eigenvalues with their moduli.  {opt modlabel}
cannot be specified with {opt dlabel}.

{phang}
{it:marker_options}
    specify the look of markers.  This
    look includes the marker symbol, the marker size, and its color and outline;
    see {manhelpi marker_options G-3}.

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference
unit circle; see {manhelpi cline_options G-3}.

{phang}
{opt nogrid} suppresses the polar grid circles. 

{phang}
{marker pgrid}{...}
{cmd:pgrid(}[{it:{help numlist}}][{cmd:,} {it:line_options}]{cmd:)}
[{cmd:pgrid(}[{it:numlist}][{cmd:,} {it:line_options}]{cmd:)...}{break}
{cmd:pgrid(}[{it:numlist}][{cmd:,} {it:line_options}]{cmd:)} determines the
radii and appearance of the polar grid circles.  By default, the graph
includes nine polar grid circles with radii 0.1, 0.2, ..., 0.9 that have the 
{opt grid} linestyle.  The {it:numlist} specifies the radii for the
polar grid circles.  The {it:line_options} determine the
appearance of the polar grid circles; see {manhelpi line_options G-3}.  Because
the {opt pgrid()} option can be repeated, circles with different radii can have
distinct appearances. 

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} adds specified plots to the generated graph; see 
{manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and saving the graph to
disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rdinc}{p_end}

{pstd}Fit vector error-correction model (VECM){p_end}
{phang2}{cmd:. vec ln_ne ln_se}{p_end}

{pstd}Check stability of the VECM estimates{p_end}
{phang2}{cmd:. vecstable}{p_end}

{pstd}Same as above, but graph eigenvalues of the companion matrix{p_end}
{phang2}{cmd:. vecstable, graph}{p_end}

{pstd}Same as above, but suppress polar grid circles{p_end}
{phang2}{cmd:. vecstable, graph nogrid}{p_end}

{pstd}Check stability of the VECM estimates and save the companion matrix as 
{cmd:A}{p_end}
{phang2}{cmd:. vecstable, amat(A)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:vecstable} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(unitmod)}}number of unit moduli imposed on the companion
matrix{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Re)}}real part of the eigenvalues of A{p_end}
{synopt:{cmd:r(Im)}}imaginary part of the eigenvalues of A{p_end}
{synopt:{cmd:r(Modulus)}}moduli of the eigenvalues of A{p_end}

{pstd}
where A is the companion matrix of the VAR that corresponds to the VECM.
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker L2005}{...}
{phang}
L{c u:}tkepohl, H. 2005.
{browse "http://www.stata.com/bookstore/imtsa.html":{it:New Introduction to Multiple Time Series Analysis}.}
New York: Springer.
{p_end}
